function stim_grouped = sort_odour_stimuli(Stimuli_Info,varargin)
if length(varargin)>1
    error("check")
end
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end
%% based on sort_light_stimuli()
% put same stimuli into the same group
% first, use intensity
min_num_trial = getOr(option, 'min_num_trial', 2);
TrailType = extractfield(Stimuli_Info,"TrailType");
[n_stimuli_type,~, uni_stimuli_type]  = unique(string(TrailType));
count_i = 1;
clear stim_grouped
% 
TrailOnset = extractfield(Stimuli_Info,"TrailOnset");
LatencyFromCalculatedSniffOnset_ms = extractfield(Stimuli_Info,"LatencyFromCalculatedSniffOnset_ms");
%
for i = 1:length(n_stimuli_type)
%     sum(n_stimuli_type(i) == out3);
    if sum(n_stimuli_type(i) == string(TrailType))>=min_num_trial
        stimuli_type = num2str(n_stimuli_type(i));
        stim_grouped(count_i).OdourName = stimuli_type;
        stim_grouped(count_i).TrailOnset = TrailOnset(n_stimuli_type(i) == string(TrailType));
        count_i = count_i+1;
    end


end