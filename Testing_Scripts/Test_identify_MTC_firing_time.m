global isplot saveplot
isplot = 1;
saveplot = 1;
timesteps = odour_unit_processing.Baseline_ms{1};
APs = odour_unit_processing.Baseline_ms{2};
% identify_MTC_firing_time
neurontype = identify_MTC_firing_time(timesteps,APs)
isplot = 0;