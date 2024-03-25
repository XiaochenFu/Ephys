function [evoked_spk,spk_latency_ms,jitter_ms,prob_spk] = light_evoked_spikes(spiketime,stim_grouped_j, varargin)
% find the antidromic spikes that follow the light pulses. Calculate the
% PSTH of the unit. For each pulse, find the first peak of the PSTH after
% that, which is likely to be light evoked. Then, find the corresponding
% spikes that belongs to the PSTH peak.


% INPUT
%   spiketime: spike time of the unit. In second
%
%   stim_grouped_j: a tructure about the light pulses. Should be with
%       the field of DrivingCurrent(mA), Frequency(Hz), PulseWidth_ms(ms),
%       PulseNumber(int), TrailOnset (s,1xn array),
%       LatencyFromCalculatedSniffOnset_ms (ms,1xn array),
%       PhaseFromCalculatedSniffOnset (rad,1xn array)
%
%   option:
%       fs: sampleing rate. default 20000.

%       calcWindow:  time window (s) from the pulse OFFSET that we check.
%           something like [0 0.02]. If the calcWindow is not defined,
%           calcWindow is [0 calcWindow_latency]

%       calcWindow_latency: by default 0.02

%       binSize: time bin used to calculate the PSTH. default is 1% of the
%           calcWindow width.

%       fr_threhold: threshold for PSTH peak. default 50Hz.

%       jitter_window: the range of time we use to look for the 'spikes
%           belongs to the PSTH peak'

%       count_before_light: when finding the spikes contributing the PSTH
%           peak, take the spikes happen before the current light onset into
%           accrount. default 0

%       latency_est: ?????

%       one_spk_only: ignore the 2nd and the 3rd spikes evoked by the light
%           pusle. default 1.

%       isplot: show plot or not. default 0

%       stimuli_colour: default color for ploting the light pulse. default cyan.

%       saveplot: save figure or not. defacult 0.


% OUTPUT
%   evoked_spk: Cell array containing spike times considered light-evoked
%       for each pulse. Each cell corresponds to a pulse.

%   spk_latency_ms: Cell array holding average latency of evoked spikes for
%       each pulse in milliseconds.

%   jitter_ms: Cell array containing jitter (standard deviation of latency)
%       of evoked spikes for each pulse in milliseconds.

%   prob_spk: Cell array holding the probability of observing an evoked
%       spike per pulse. Calculated as number of evoked spikes divided by
%       total number of trials (light pulses).

%
if length(varargin)>1
    error("check the input number")
end
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end
fs = getOr(option, 'fs', 20000);
calcWindow = getOr(option, 'calcWindow', []);
calcWindow_latency = getOr(option, 'calcWindow_latency', 0.020); % by default, we only check the spikes happen within 20ms after the light pulse

if isempty(calcWindow) % the time window after the pulse that we used to check the spikes
    pulse_num = stim_grouped_j.PulseNumber;
    pulse_frequency = stim_grouped_j.Frequency;
    pulse_width = stim_grouped_j.PulseWidth_ms;
    k = pulse_num;
    x1 = 1000/pulse_frequency*(k-1); %compute the pulse onset in ms
    x2 = x1+pulse_width;
    calcWindow = [0, x2/1000+calcWindow_latency];

else
end
binSize = getOr(option, 'binSize', 0.01*(calcWindow(2)-calcWindow(1))); %getOr(option, 'binSize', 1/20000);
fr_threhold =getOr(option, 'fr_threhold', 50);
jitter_window = getOr(option,'jitter_window',1);
count_before_light = getOr(option,'count_before_light',0);
latency_est = getOr(option,'latency_est',2/1000);
% seting for ploting.
isplot = getOr(option, 'isplot', 0);
stimuli_colour = getOr(option,'stimuli_colour','cyan');
saveplot = getOr(option, 'saveplot', 0);



one_spk_only = getOr(option,'one_spk_only',1);
try
    eventtime = stim_grouped_j.TrialOnset; % onset of the each trial (the onset of the first pulse in the pulse train)
catch
    eventtime = stim_grouped_j.TrailOnset; % onset of the each trial (the onset of the first pulse in the pulse train)
end



%% when light present
[psth_base, bins_base, ~, ~, ~, ~] = psthAndBA(spiketime, eventtime, calcWindow, binSize);
psth_base = psth_base*binSize;
fr_base = psth_base/binSize;
if isplot
    figure
    plot(bins_base,fr_base)
    xlim([min(bins_base) max(bins_base)])
    hold on
    plot_light_stimuli(stim_grouped_j,stimuli_colour)
    xlabel('Time from trail onset (s)')
    ylabel ('Instant FR (Hz)')
    title("")
end
%%

[pks,locs] = findpeaks(fr_base,bins_base,'MinPeakHeight',fr_threhold); % seems to work for now
light_onsets = get_stimuli_onsets_s(stim_grouped_j);
%% this is the raster to find the light evoked spikes, binned so not accurate
% [binnedArray, bins] = timestampsToBinned(spiketime, eventtime, binSize, calcWindow);
% [tr,b] = find(binnedArray);
% [rasterX,yy] = rasterize(bins(b) - 0.5*binSize);
% % rasterY = yy+reshape([zeros(size(tr'));tr';zeros(size(tr'))],1,length(tr)*3);
% % rasterX(rasterY==0) = [];
% % rasterY(rasterY==0) = [];% remove zeros
% rasterY = reshape([nan(size(tr'));tr';zeros(size(tr'))],1,length(tr)*3);
% mask = ~isnan(rasterY);
% rasterX = rasterX(mask);
% rasterY = rasterY(mask);% Remove NaNs

%% this is the raster to calculate the latency, so accurate
[binnedArray, bins] = timestampsToBinned(spiketime, eventtime, 1/fs, calcWindow);
[tr,b] = find(binnedArray);
[raw_rasterX,~] = rasterize(bins(b) - 0.5*binSize);
raw_rasterY = reshape([nan(size(tr'));tr';nan(size(tr'))],1,length(tr)*3);
raw_mask = ~isnan(raw_rasterY);
rasterX = raw_rasterX(raw_mask);
rasterY = raw_rasterY(raw_mask);% Remove NaNs
if isplot
    figure
    pl1 = plot(rasterX, rasterY,'.'); hold on
end

%%     find the peak after the onset for the light evoked stimuli
% by default, get one or zero evoked spike with one light pulse (to calculate the spike probability)
if one_spk_only
    if jitter_window<0
        for lo = 1:length(light_onsets)
            fprintf('jitter_window will be ignored')
            light_onset = light_onsets(lo);
            firstpeakafter_t = @(locs,t) min(locs(locs>t)-t)+t;
            %             closest_peak_time = firstpeakafter_t(locs,light_onset+latency_est); %
            evoked_spk_lo = nan(size(eventtime));
            spk_latency_lo_ms = nan;
            jitter_lo_ms = nan;
            prob_spk_lo = 0;
            closest_peak_window = calcWindow;
            %                             check_window = jitter_window*[-1 1]/1000;
            %                 closest_peak_window = closest_peak_time+check_window;
            if ~count_before_light % if we only count the pulse after light onset (default)
                if closest_peak_window(1)<light_onset
                    closest_peak_window(1) = light_onset;
                end
            end
            %         if the pulse is after the second light, then it doesn't belong to
            %         the first one
            if lo<length(light_onsets)
                light_onset_oneafter = light_onsets(lo+1);
                if closest_peak_window(2)>light_onset_oneafter
                    closest_peak_window(2) = light_onset_oneafter;
                end
            end

            % filter those spike that might fall into the window
            spk_idx = rasterX>closest_peak_window(1) & rasterX<closest_peak_window(2);
            rasterX0 = rasterX(spk_idx);
            rasterY0 = rasterY(spk_idx);

            %%
            closestXValues = NaN(size(eventtime));  % Initialize a result array
            uniqueRasterY = NaN(size(eventtime));  % Initialize a result array

            for idx = 1:size(eventtime,2)

                currentY = idx;

                % Get all the rasterX values corresponding to the current rasterY value
                correspondingX = rasterX0(rasterY0 == currentY);
                if ~isempty(correspondingX)
                    % Find the rasterX value closest to onset
                    [~, minIdx] = min(abs(correspondingX - light_onset));
                    closestXValues(idx) = correspondingX(minIdx);
                    uniqueRasterY(idx) = currentY;
                end
            end
            % Now, closestXValues will hold the rasterX values closest to closest_peak_time for each unique rasterY value.
            rasterX0 = closestXValues;
            rasterY0 = uniqueRasterY;

            if isplot
                %             plot(rasterX0, rasterY0,'ro');
                nonNanIdx = ~isnan(rasterX0) & ~isnan(rasterY0); % Get indices where neither of the arrays is NaN
                filtered_rasterX0 = rasterX0(nonNanIdx); % Filter NaN values from rasterX0
                filtered_rasterY0 = rasterY0(nonNanIdx); % Filter NaN values from rasterY0

                plot(filtered_rasterX0, filtered_rasterY0, 'ro');
            end
            evoked_spk_lo = rasterX0;
            spk_latency_lo_ms = (mean(evoked_spk_lo,"omitnan")-light_onset)*1000;
            jitter_lo_ms = std(evoked_spk_lo,"omitnan")*1000;
            prob_spk_lo = sum(~isnan(evoked_spk_lo))/length(eventtime);

            evoked_spk{lo} = evoked_spk_lo;
            spk_latency_ms{lo} = spk_latency_lo_ms;
            jitter_ms{lo} = jitter_lo_ms;
            prob_spk{lo} = prob_spk_lo;

        end
    else
        for lo = 1:length(light_onsets) % loop for each pulse of the pulse train
            light_onset = light_onsets(lo);
            firstpeakafter_t = @(locs,t) min(locs(locs>t)-t)+t;
            closest_peak_time = firstpeakafter_t(locs,light_onset+latency_est); %
            evoked_spk_lo = nan(size(eventtime));
            spk_latency_lo_ms = nan;
            jitter_lo_ms = nan;
            prob_spk_lo = 0;

            if (closest_peak_time-light_onset)<(calcWindow_latency) % if jitter is considered
                check_window = jitter_window*[-1 1]/1000;
                closest_peak_window = closest_peak_time+check_window;
                if ~count_before_light % if we only count the pulse after light onset (default)
                    if closest_peak_window(1)<light_onset
                        closest_peak_window(1) = light_onset;
                    end
                end
                %         if the pulse is after the second light, then it doesn't belong to
                %         the first one
                if lo<length(light_onsets)
                    light_onset_oneafter = light_onsets(lo+1);
                    if closest_peak_window(2)>light_onset_oneafter
                        closest_peak_window(2) = light_onset_oneafter;
                    end
                end
                % filter those spike that might fall into the window
                spk_idx = rasterX>closest_peak_window(1) & rasterX<closest_peak_window(2);
                rasterX0 = rasterX(spk_idx);
                rasterY0 = rasterY(spk_idx);

                %%
                closestXValues = NaN(size(eventtime));  % Initialize a result array
                uniqueRasterY = NaN(size(eventtime));  % Initialize a result array

                for idx = 1:size(eventtime,2)

                    currentY = idx;

                    % Get all the rasterX values corresponding to the current rasterY value
                    correspondingX = rasterX0(rasterY0 == currentY);
                    if ~isempty(correspondingX)
                        % Find the rasterX value closest to closest_peak_time
                        [~, minIdx] = min(abs(correspondingX - closest_peak_time));
                        closestXValues(idx) = correspondingX(minIdx);
                        uniqueRasterY(idx) = currentY;
                    end
                end
                % Now, closestXValues will hold the rasterX values closest to closest_peak_time for each unique rasterY value.
                rasterX0 = closestXValues;
                rasterY0 = uniqueRasterY;

                if isplot
                    %             plot(rasterX0, rasterY0,'ro');
                    nonNanIdx = ~isnan(rasterX0) & ~isnan(rasterY0); % Get indices where neither of the arrays is NaN
                    filtered_rasterX0 = rasterX0(nonNanIdx); % Filter NaN values from rasterX0
                    filtered_rasterY0 = rasterY0(nonNanIdx); % Filter NaN values from rasterY0

                    plot(filtered_rasterX0, filtered_rasterY0, 'ro');
                end
                evoked_spk_lo = rasterX0;
                spk_latency_lo_ms = (mean(evoked_spk_lo,"omitnan")-light_onset)*1000;
                jitter_lo_ms = std(evoked_spk_lo,"omitnan")*1000;
                prob_spk_lo = sum(~isnan(evoked_spk_lo))/length(eventtime);

            end
            evoked_spk{lo} = evoked_spk_lo;
            spk_latency_ms{lo} = spk_latency_lo_ms;
            jitter_ms{lo} = jitter_lo_ms;
            prob_spk{lo} = prob_spk_lo;
        end
    end
    if isplot

        plot_light_stimuli(stim_grouped_j,stimuli_colour)
        xlim([min(bins_base) max(bins_base)])
        xlabel('Time from trail onset (s)')
        ylabel ('Trial number')
        %     legend([pl1 pl2], {"Spikes","Light evoked Spikes"},'Location','southoutside')
        title('Light evoked spikes')
    end
    %========================================================================


else %plot all the evoked spikes. Ignore the jitter window.
    if jitter_window<0
        fprintf('jitter_window will be ignored')
    end

    light_onset = light_onsets(1);

    rasterX0 = rasterX;
    rasterY0 = rasterY;

    if isplot
        %             plot(rasterX0, rasterY0,'ro');
        nonNanIdx = ~isnan(rasterX0) & ~isnan(rasterY0); % Get indices where neither of the arrays is NaN
        filtered_rasterX0 = rasterX0(nonNanIdx); % Filter NaN values from rasterX0
        filtered_rasterY0 = rasterY0(nonNanIdx); % Filter NaN values from rasterY0

        plot(filtered_rasterX0, filtered_rasterY0, 'ro');
    end
    evoked_spk_lo = rasterX0;
    spk_latency_lo_ms = (mean(evoked_spk_lo,"omitnan")-light_onset)*1000;
    jitter_lo_ms = std(evoked_spk_lo,"omitnan")*1000;
    prob_spk_lo = sum(~isnan(evoked_spk_lo))/length(eventtime);

    %
    evoked_spk{1} = evoked_spk_lo;
    spk_latency_ms{1} = spk_latency_lo_ms;
    jitter_ms{1} = jitter_lo_ms;
    prob_spk{1} = prob_spk_lo;

    if isplot

        plot_light_stimuli(stim_grouped_j,stimuli_colour)
        xlim([min(bins_base) max(bins_base)])
        xlabel('Time from trail onset (s)')
        ylabel ('Trial number')
        %     legend([pl1 pl2], {"Spikes","Light evoked Spikes"},'Location','southoutside')
        title('Light evoked spikes')
    end
end
end