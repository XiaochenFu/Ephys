function [shuffled_onsets, shuffled_durations] = shuffle_sniff_duration(sniff_onsets, num_shuffle)
% shuffle the sniff durations. 
rng(2); % a fixed seed for rng
% %% Test random seed with random numbers. It works
% % randperm(5)


% %% for one shuffle, it should be easy
% sniff_durations = diff([0 sniff_onsets]);
% num_cycles = length(sniff_durations);
% new_index = randperm(num_cycles);
% shuffled_durations = sniff_durations(new_index);
% shuffled_onsets = cumsum(shuffled_durations);
% length(sniff_onsets) == length(shuffled_onsets)

%% for multiple shuffle, one column is one shuffle
% https://www.mathworks.com/matlabcentral/answers/155207-matrix-with-different-randperm-rows
rng(2); % a fixed seed for rng
sniff_durations = diff([0 sniff_onsets]);
num_cycles = length(sniff_durations);
[~, new_index] = sort(rand(num_cycles,num_shuffle),1);
shuffled_durations = sniff_durations(new_index);
shuffled_onsets = cumsum(shuffled_durations,2);
% length(sniff_onsets) == length(shuffled_onsets)
end
