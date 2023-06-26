function [evoked_spk,spk_latency_ms,jitter_ms,prob_spk] = light_evoked_spikes(spiketime,stim_grouped_j, varargin)
if length(varargin)>1
    error("check")
end
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end
calcWindow = getOr(option, 'calcWindow', []);
if isempty(calcWindow)
    calcWindow_latency = getOr(option, 'calcWindow_latency', 0.020);
    pulse_num = stim_grouped_j.PulseNumber;
    pulse_frequency = stim_grouped_j.Frequency;
    pulse_width = stim_grouped_j.PulseWidth_ms;
    k = pulse_num;
    x1 = 1000/pulse_frequency*(k-1); %compute the pulse onset in ms
    x2 = x1+pulse_width;
    calcWindow = [0, x2/1000+calcWindow_latency];
else

end
binSize = getOr(option, 'binSize', 0.01*(calcWindow(2)-calcWindow(1)));
isplot = getOr(option, 'isplot', 0);
saveplot = getOr(option, 'saveplot', 0);
fr_threhold =getOr(option, 'fr_threhold', 50);
jitter_window = getOr(option,'jitter_window',1);
stimuli_colour = getOr(option,'stimuli_colour','cyan');
count_before_light = getOr(option,'count_before_light',0);
latency_est = getOr(option,'latency_est',2/1000);
eventtime = stim_grouped_j.TrailOnset;
trial_latency = stim_grouped_j.LatencyFromCalculatedSniffOnset_ms;
% calculate window will be automatically decided based on the last
% pulse.since the latency might change with the light intensity etc.,
% but less than 20ms, I'll use 20 ms after the last pulse
%     calcWindow = getOr(option, 'calcWindow', [0, 0.1]);




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
[binnedArray, bins] = timestampsToBinned(spiketime, eventtime, binSize, calcWindow);
% lick raster for only s plus trials
[tr,b] = find(binnedArray);
[rasterX,yy] = rasterize(bins(b));
rasterY = yy+reshape([zeros(size(tr'));tr';zeros(size(tr'))],1,length(tr)*3); % note from XFu. The original code duplicate the dots to make the ticks longer, which I believe is cheating.
rasterX(rasterY==0) = [];rasterY(rasterY==0) = [];% remove zeros
if isplot
    figure
    pl1 = plot(rasterX, rasterY,'.'); hold on
end
%                   !  scatter(rasterX, rasterY,15,1:length(rasterY)) % sanity check. No duplicated dots
%     find the fist peak after the onset for the light evoked stimuli
for lo = 1:length(light_onsets)
    light_onset = light_onsets(lo);
    firstpeakafter_t = @(locs,t) min(locs(locs>t)-t)+t;
%     secondpeakafter_t = @(locs,t) min(locs(locs>firstpeakafter_t(t))-firstpeakafter_t(t))+firstpeakafter_t(t);
    %     firstpeakafter_t = @(locs,t) find(locs==interp1(locs,locs,t,'next'),1);
    closest_peak_time = firstpeakafter_t(locs,light_onset+latency_est); %
%     close_peak_time = secondpeakafter_t(locs,light_onset); %
%     if secondpeakafter_t<(20/1000)
%         higest_peak_time
%     end
    if (closest_peak_time-light_onset)<(20/1000)
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
        spk_idx = rasterX>closest_peak_window(1) & rasterX<closest_peak_window(2);
        if isplot

            pl2 = plot(rasterX(spk_idx), rasterY(spk_idx),'ro');
        end
        evoked_spk_lo = rasterX(spk_idx);
        spk_latency_lo_ms = (mean(evoked_spk_lo)-light_onset)*1000;
        jitter_lo_ms = std(evoked_spk_lo)*1000;
        prob_spk_lo = length(evoked_spk_lo)/length(eventtime);
    else
        evoked_spk_lo = nan;
        spk_latency_lo_ms = nan;
        jitter_lo_ms = nan;
        prob_spk_lo = 0;
    end
    evoked_spk{lo} = evoked_spk_lo;
    spk_latency_ms{lo} = spk_latency_lo_ms;
    jitter_ms{lo} = jitter_lo_ms;
    prob_spk{lo} = prob_spk_lo;
end
if isplot

    plot_light_stimuli(stim_grouped_j,stimuli_colour)
    xlim([min(bins_base) max(bins_base)])
    xlabel('Time from trail onset (s)')
    ylabel ('Trial number')
    legend([pl1 pl2], {"Spikes","Light evoked Spikes"},'Location','southoutside')
    title('Light evoked spikes')
end
