function [stimuli_grouped_j_subset,onset_subset] = pick_stimuli_with_latency(stimuli_grouped_j,latency_min,latency_max)
LatencyFromCalculatedSniffOnset_ms = extractfield(stimuli_grouped_j,'LatencyFromCalculatedSniffOnset_ms');
TrailOnset = extractfield(stimuli_grouped_j,'TrailOnset');
% Frequency = extractfield(stimuli_grouped,'Frequency');
% PulseWidth_ms = extractfield(stimuli_grouped,'PulseWidth_ms');
% PulseNumber = extractfield(stimuli_grouped,'PulseNumber');
% dc_match = (DrivingCurrent==drivingcurrent);
% f_match = (Frequency == frequency);
% pw_match = (PulseWidth_ms == pulsewidth_ms);
% pn_match = (PulseNumber == pulse_num);
idx = (LatencyFromCalculatedSniffOnset_ms>latency_min) & (LatencyFromCalculatedSniffOnset_ms<latency_max);
onset_subset = LatencyFromCalculatedSniffOnset_ms(idx);
stimuli_grouped_j_subset = stimuli_grouped_j;
TrailOnset_subset = TrailOnset(idx);
stimuli_grouped_j_subset.TrailOnset =TrailOnset_subset;
stimuli_grouped_j_subset.LatencyFromCalculatedSniffOnset_ms =onset_subset;
end
