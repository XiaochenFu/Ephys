function stim_grouped = sort_light_stimuli(Stimuli_Info)
% put same stimuli into the same group
% first, use intensity
min_num_trial = 3;
DrivingCurrent = extractfield(Stimuli_Info,"DrivingCurrent");
[n_current,~, uni_current] = unique(DrivingCurrent);
% then, use frequency
Frequency = extractfield(Stimuli_Info,"Frequency");
[n_frequency,~, uni_frequency]  = unique(Frequency);
% then PulseWidth_ms
PulseWidth_ms = extractfield(Stimuli_Info,"PulseWidth_ms");
[n_width,~, uni_width] = unique(PulseWidth_ms);
% then PulseNumber
PulseNumber = extractfield(Stimuli_Info,"PulseNumber");
[n_number,~, uni_number]  = unique(PulseNumber);



out=sprintf('%02d%02d%02d%02d ',[uni_current,uni_frequency,uni_width,uni_number].');
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
LatencyFromCalculatedSniffOnset_ms = extractfield(Stimuli_Info,"LatencyFromCalculatedSniffOnset_ms");
PhaseFromCalculatedSniffOnset = extractfield(Stimuli_Info,"PhaseFromCalculatedSniffOnset");
if isfield(Stimuli_Info,'LatencyFromSniffTrigger_ms')
    LatencyFromSniffTrigger_ms = extractfield(Stimuli_Info,"LatencyFromSniffTrigger_ms");
    PhaseFromSniffTrigger = extractfield(Stimuli_Info,"PhaseFromSniffTrigger");
end
%
for i = 1:length(n_stimuli_type)
    %     sum(n_stimuli_type(i) == out3);
    if sum(strcmp(n_stimuli_type(i),out2))>=min_num_trial
        %         if sum(n_stimuli_type(i) == out3)>=min_num_trial
        %         stimuli_type = num2str(n_stimuli_type(i));
        stimuli_type = num2str(n_stimuli_type{i});
        stim_grouped(count_i).DrivingCurrent = n_current(str2num(stimuli_type(1:2)));
        stim_grouped(count_i).Frequency = n_frequency(str2num(stimuli_type(3:4)));
        stim_grouped(count_i).PulseWidth_ms = n_width(str2num(stimuli_type(5:6)));
        stim_grouped(count_i).PulseNumber = n_number(str2num(stimuli_type(7:8)));
        stim_grouped(count_i).TrialOnset = TrialOnset(strcmp(n_stimuli_type(i),out2));
        stim_grouped(count_i).LatencyFromCalculatedSniffOnset_ms = LatencyFromCalculatedSniffOnset_ms(strcmp(n_stimuli_type(i),out2));
        stim_grouped(count_i).PhaseFromCalculatedSniffOnset = PhaseFromCalculatedSniffOnset(strcmp(n_stimuli_type(i),out2));
        if isfield(Stimuli_Info,'LatencyFromSniffTrigger_ms')
            stim_grouped(count_i).LatencyFromSniffTrigger_ms = LatencyFromSniffTrigger_ms(strcmp(n_stimuli_type(i),out2));
            stim_grouped(count_i).PhaseFromSniffTrigger = PhaseFromSniffTrigger(strcmp(n_stimuli_type(i),out2));

        end
        %         stim_grouped(count_i).DrivingCurrent = n_current(str2num(stimuli_type(1)));
        %         stim_grouped(count_i).Frequency = n_frequency(str2num(stimuli_type(2)));
        %         stim_grouped(count_i).PulseWidth_ms = n_width(str2num(stimuli_type(3)));
        %         stim_grouped(count_i).PulseNumber = n_number(str2num(stimuli_type(4)));
        %         stim_grouped(count_i).TrailOnset = TrailOnset(n_stimuli_type(i) == out3);
        %         stim_grouped(count_i).LatencyFromCalculatedSniffOnset_ms = LatencyFromCalculatedSniffOnset_ms(n_stimuli_type(i) == out3);
        %         stim_grouped(count_i).PhaseFromCalculatedSniffOnset = PhaseFromCalculatedSniffOnset(n_stimuli_type(i) == out3);
        count_i = count_i+1;
    end


end