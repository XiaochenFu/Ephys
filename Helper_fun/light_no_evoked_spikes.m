function [evoked_spk,spk_latency_ms,jitter_ms,prob_spk] = light_no_evoked_spikes(spiketime,stim_grouped_j, varargin)

% light_onsets = get_stimuli_onsets_s(stim_grouped_j);


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
fr_threhold =getOr(option, 'fr_threhold', 200);
jitter_window = getOr(option,'jitter_window',1);
% for j = 4%:length(stim_grouped)
stimuli_colour = getOr(option,'stimuli_colour','cyan');
%     stim_grouped_j = stim_grouped(j);
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
    hold on
    plot_light_stimuli(stim_grouped_j)
    xlabel('Time from trail onset (s)')
    ylabel ('Instant FR (Hz)')
    title("")
end
%% 
% 
% [pks,locs] = findpeaks(fr_base,bins_base,'MinPeakHeight',fr_threhold); % seems to work for now
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
    plot_light_stimuli(stim_grouped_j,stimuli_colour)
    xlabel('Time from trail onset (s)')
    ylabel ('Trial number')
    title('Light evoked spikes')
end

for lo = 1:length(light_onsets)

    evoked_spk_lo = [];
    spk_latency_lo_ms = nan;
    jitter_lo_ms = nan;
    prob_spk_lo = 0;
    evoked_spk{lo} = evoked_spk_lo;
    spk_latency_ms{lo} = spk_latency_lo_ms;
    jitter_ms{lo} = jitter_lo_ms;
    prob_spk{lo} = prob_spk_lo;
end
