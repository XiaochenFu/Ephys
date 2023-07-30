function [bins_base, fr_base] = evoked_sniff_phase_uniform(selected_sniff_onset, all_sniff_onset, spiketime,varargin)
if length(varargin)>1
    error("check input number")
end
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end

binSize = getOr(option, 'binSize', 0.01*2*pi);

% Calculate difference between all sniff onset times
calcWindow_all_cycle = diff(all_sniff_onset);

% Find indices of selected sniff onset times in all sniff onset times
[~, indices] = ismember(selected_sniff_onset, all_sniff_onset);

% Filter calcWindow_all_cycle to only include elements corresponding to selected sniff onset
calcWindow_each_cycle = calcWindow_all_cycle(indices);

[psth_base, bins_base, rasterX_SP, rasterY_SP, spikeCounts_SP, ba_SP] = phase_normed_psthAndBA(spiketime, selected_sniff_onset, calcWindow_each_cycle, binSize);

% Convert psth_base to frequency
psth_base = psth_base*binSize;

% Convert frequency to rate
fr_base = psth_base/(binSize/2/pi);
end
