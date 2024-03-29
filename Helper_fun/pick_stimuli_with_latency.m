function [stimuli_grouped_j_subset,onset_subset] = pick_stimuli_with_latency(stimuli_grouped_j,latency_min_ms,latency_max_ms)
try
    LatencyFromCalculatedSniffOnset_ms = extractfield(stimuli_grouped_j,'LatencyFromCalculatedSniffOnset_ms');
    TrialOnset = extractfield(stimuli_grouped_j,'TrialOnset');
    % Frequency = extractfield(stimuli_grouped,'Frequency');
    % PulseWidth_ms = extractfield(stimuli_grouped,'PulseWidth_ms');
    % PulseNumber = extractfield(stimuli_grouped,'PulseNumber');
    % dc_match = (DrivingCurrent==drivingcurrent);
    % f_match = (Frequency == frequency);
    % pw_match = (PulseWidth_ms == pulsewidth_ms);
    % pn_match = (PulseNumber == pulse_num);
    idx = (LatencyFromCalculatedSniffOnset_ms>latency_min_ms) & (LatencyFromCalculatedSniffOnset_ms<latency_max_ms);
    onset_subset = LatencyFromCalculatedSniffOnset_ms(idx);
    stimuli_grouped_j_subset = stimuli_grouped_j;
    TrialOnset_subset = TrialOnset(idx);
    stimuli_grouped_j_subset.TrialOnset =TrialOnset_subset;
    stimuli_grouped_j_subset.LatencyFromCalculatedSniffOnset_ms =onset_subset;
catch
    LatencyFromCalculatedSniffOnset_ms = extractfield(stimuli_grouped_j,'LatencyFromCalculatedSniffOnset_ms');
    TrailOnset = extractfield(stimuli_grouped_j,'TrailOnset');
    % Frequency = extractfield(stimuli_grouped,'Frequency');
    % PulseWidth_ms = extractfield(stimuli_grouped,'PulseWidth_ms');
    % PulseNumber = extractfield(stimuli_grouped,'PulseNumber');
    % dc_match = (DrivingCurrent==drivingcurrent);
    % f_match = (Frequency == frequency);
    % pw_match = (PulseWidth_ms == pulsewidth_ms);
    % pn_match = (PulseNumber == pulse_num);
    idx = (LatencyFromCalculatedSniffOnset_ms>latency_min_ms) & (LatencyFromCalculatedSniffOnset_ms<latency_max_ms);
    onset_subset = LatencyFromCalculatedSniffOnset_ms(idx);
    stimuli_grouped_j_subset = stimuli_grouped_j;
    TrialOnset_subset = TrailOnset(idx);
    stimuli_grouped_j_subset.TrialOnset =TrialOnset_subset;
    stimuli_grouped_j_subset.LatencyFromCalculatedSniffOnset_ms =onset_subset;
end
end
