option = [];
spiketime = odour_unit_processing.st;
sniff_spon = odour_unit_processing.Spontaneous_SniffOnset;
stim_group = stim_grouped(1);
sniff_onset_spike2_aligned;
% check_light_response
odour_evoked = check_odour_response(spiketime,stim_group,option);
%%
option.isplot = 1;
odour_evoked = check_odour_response(spiketime,stim_grouped,option);
