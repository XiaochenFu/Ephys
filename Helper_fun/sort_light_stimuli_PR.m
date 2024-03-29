function stim_grouped = sort_light_stimuli_PR(Stimuli_Info)
% put same stimuli into the same group
% first, use intensity
min_num_trial = 3;
DrivingCurrent_Med = extractfield(Stimuli_Info,"DrivingCurrent_Med");
[n_current,~, uni_current] = unique(DrivingCurrent_Med);
DrivingCurrent_Lat = extractfield(Stimuli_Info,"DrivingCurrent_Lat");
[n_current,~, uni_current] = unique(DrivingCurrent_Lat);
% then, use frequency
Frequency = extractfield(Stimuli_Info,"Frequency");
[n_frequency,~, uni_frequency]  = unique(Frequency);
% then PulseWidth_ms
PulseWidth_ms = extractfield(Stimuli_Info,"PulseWidth_ms");
[n_width,~, uni_width] = unique(PulseWidth_ms);
% then PulseNumber
PulseNumber = extractfield(Stimuli_Info,"PulseNumber");
[n_number,~, uni_number]  = unique(PulseNumber);
TrialType = extractfield(Stimuli_Info, "TrialType");
[n_type,~, uni_type]  = unique(TrialType');

% Assuming uni_current, uni_frequency, uni_width, and uni_number are scalars:
formattedNumbers = sprintf('%02d%02d%02d%02d', uni_current, uni_frequency, uni_width, uni_number);

% Concatenate the numbers with the TrialType string.
% If TrialType is a single string:
out = [formattedNumbers, TrialType];

% If TrialType is a cell array of strings and you want to concatenate each element with the numbers:
out = cellfun(@(t) [formattedNumbers, t], TrialType, 'UniformOutput', false);

% 'out' will be a cell array if TrialType is a cell array, or a string if TrialType is a single string.
out2 = split(out," ");
if length(out2)>length(uni_number)
    out2 = out2(1:end-1);
end
% out3 = cellfun(@str2num,out2);
% out3 = str2num(cell2mat(out2));
% [n_stimuli_type,~, uni_stimuli_type] = unique(out3);
[n_stimuli_type,~, uni_stimuli_type] = unique(out2);
count_i = 1;
clear stim_grouped
%
try
    TrialOnset = extractfield(Stimuli_Info,"TrialOnset");
catch
    TrialOnset = extractfield(Stimuli_Info,"TrailOnset");
end
LatencyFromCalculatedSniffOnset_ms_Med = extractfield(Stimuli_Info,"LatencyFromCalculatedSniffOnset_ms_Med");
LatencyFromCalculatedSniffOnset_ms_Lat = extractfield(Stimuli_Info,"LatencyFromCalculatedSniffOnset_ms_Lat");
PhaseFromCalculatedSniffOnset_Med = extractfield(Stimuli_Info,"PhaseFromCalculatedSniffOnset_Med");
PhaseFromCalculatedSniffOnset_Lat = extractfield(Stimuli_Info,"PhaseFromCalculatedSniffOnset_Lat");
TrialOnset_Med = extractfield(Stimuli_Info,"TrialOnset_Med");
TrialOnset_Lat = extractfield(Stimuli_Info,"TrialOnset_Lat");


% Assuming n_stimuli_type is a cell array of strings:
for i = 1:length(n_stimuli_type)
    currentStimType = n_stimuli_type{i};
    matchingIndices = strcmp(currentStimType, out2);
    
    if sum(matchingIndices) >= min_num_trial
        % Parse out each part of the stimuli_type string
        % This assumes the Trial_Type is the last part of the string
        stimuli_type = currentStimType(1:end-length(TrialType{1}));
        trial_type = currentStimType(end-length(TrialType{1})+1:end);
        
        stim_grouped(count_i).DrivingCurrent = n_current(str2num(stimuli_type(1:2)));
        stim_grouped(count_i).Frequency = n_frequency(str2num(stimuli_type(3:4)));
        stim_grouped(count_i).PulseWidth_ms = n_width(str2num(stimuli_type(5:6)));
        stim_grouped(count_i).PulseNumber = n_number(str2num(stimuli_type(7:8)));
        stim_grouped(count_i).Trial_Type = trial_type;
        stim_grouped(count_i).TrialOnset = TrialOnset(matchingIndices);
        stim_grouped(count_i).TrialOnset_Lat = TrialOnset_Lat(matchingIndices);
        stim_grouped(count_i).TrialOnset_Med = TrialOnset_Med(matchingIndices);
        stim_grouped(count_i).LatencyFromCalculatedSniffOnset_ms_Med = LatencyFromCalculatedSniffOnset_ms_Med(strcmp(n_stimuli_type(i),out2));
        stim_grouped(count_i).LatencyFromCalculatedSniffOnset_ms_Lat = LatencyFromCalculatedSniffOnset_ms_Lat(strcmp(n_stimuli_type(i),out2));
        stim_grouped(count_i).PhaseFromCalculatedSniffOnset_Med = PhaseFromCalculatedSniffOnset_Med(strcmp(n_stimuli_type(i),out2));
        stim_grouped(count_i).PhaseFromCalculatedSniffOnset_Lat = PhaseFromCalculatedSniffOnset_Lat(strcmp(n_stimuli_type(i),out2));
        
        count_i = count_i + 1;
    end
end