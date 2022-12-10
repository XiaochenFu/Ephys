option = [];
spiketime = light_unit_processing.st;
sniff_spon = light_unit_processing.Spontaneous_SniffOnset;
stim_group = stim_grouped(1);
LatencyFromCalculatedSniffOnset_ms = stim_group.LatencyFromCalculatedSniffOnset_ms;
sniff_onset_spike2_aligned;
% check_light_response
light_evoked = check_light_response(spiketime,stim_group,sniff_onset_spike2_aligned, LatencyFromCalculatedSniffOnset_ms);
light_evoked = check_light_response(spiketime,stim_grouped,sniff_onset_spike2_aligned, LatencyFromCalculatedSniffOnset_ms)