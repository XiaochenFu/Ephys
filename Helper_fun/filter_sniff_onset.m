function filtered_sniff_onset = filter_sniff_onset(FV_opening_time, Sniff_onset, time_after_FV)
% FILTERSNIFFONSET Finds sniff_onset times that occur after each FV_opening_time but before the elapsed time_after_FV
% Input:
% FV_opening_time - array of times when the FV opens
% Sniff_onset - array of times when sniffs begin
% time_after_FV - the time duration after each FV_opening_time during which to look for Sniff_onset
%
% Output:
% filtered_sniff_onset - array of Sniff_onset times that occurred within time_after_FV after each FV_opening_time

% Initialize empty array for filtered sniff onset times
filtered_sniff_onset = [];

% Loop over all FV opening times
for i = 1:length(FV_opening_time)
    % For each FV opening time, find the sniff onset times that occur within the specified window
    valid_sniff_indices = find(Sniff_onset > FV_opening_time(i) & Sniff_onset <= (FV_opening_time(i) + time_after_FV));
    valid_sniff_onsets = Sniff_onset(valid_sniff_indices);

    % Add the valid sniff onset times to the filtered array
    filtered_sniff_onset = [filtered_sniff_onset, valid_sniff_onsets];
end
end
