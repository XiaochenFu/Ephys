function [stimuli_grouped_j_subset,phase_subset] = pick_stimuli_with_phase(stimuli_grouped_j,phase_min,phase_max)
PhaseFromCalculatedSniffOnset = extractfield(stimuli_grouped_j,'PhaseFromCalculatedSniffOnset');
TrailOnset = extractfield(stimuli_grouped_j,'TrailOnset');
LatencyFromCalculatedSniffOnset_ms = extractfield(stimuli_grouped_j,'LatencyFromCalculatedSniffOnset_ms');
idx = (PhaseFromCalculatedSniffOnset>=phase_min) & (PhaseFromCalculatedSniffOnset<phase_max);
phase_subset = PhaseFromCalculatedSniffOnset(idx);
latency_subset  = 0;
stimuli_grouped_j_subset = stimuli_grouped_j;
TrailOnset_subset = TrailOnset(idx);
stimuli_grouped_j_subset.TrailOnset =TrailOnset_subset;
stimuli_grouped_j_subset.PhaseFromCalculatedSniffOnset =phase_subset;
onset_subset = LatencyFromCalculatedSniffOnset_ms(idx);
stimuli_grouped_j_subset.LatencyFromCalculatedSniffOnset_ms =onset_subset;
end
