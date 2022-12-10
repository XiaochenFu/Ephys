function [bins_base, fr_base] = baseline_sniff_phase_uniform(baseline_sniff_onset,spiketime,varargin)
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end

binSize = getOr(option, 'binSize', 0.01*2*pi);


calcWindow_each_cycle = diff(baseline_sniff_onset);
% █ █▀▄▀█ █▀█ █▀█ █▀█ ▀█▀ ▄▀█ █▄░█ ▀█▀
% █ █░▀░█ █▀▀ █▄█ █▀▄ ░█░ █▀█ █░▀█ ░█░
% the window will be an array of sniff durations
%             [psth_base, bins_base, rasterX_SP, rasterY_SP, spikeCounts_SP, ba_SP] = psthAndBA(spiketime, baseline_sniff_onset, calcWindow, binSize);

[psth_base, bins_base, rasterX_SP, rasterY_SP, spikeCounts_SP, ba_SP] = phase_normed_psthAndBA(spiketime, baseline_sniff_onset, calcWindow_each_cycle, binSize);
psth_base = psth_base*binSize;
fr_base = psth_base/(binSize/2/pi);
end