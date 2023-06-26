function [evoked_psth] = light_evoked_psth(spiketime,stim_grouped_j, varargin)
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
evoked_psth{1} = bins_base;
evoked_psth{2} = fr_base;
end
