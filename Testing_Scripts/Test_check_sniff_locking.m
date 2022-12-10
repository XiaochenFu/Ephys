close all
global isplot saveplot
isplot = 0;
saveplot = 0;

options.num_shuffle = 100;
sniff_onsets = odour_unit_processing.Spontaneous_SniffOnset;
spiketime = odour_unit_processing.st;

% check_sniff_locking
sniff_coupled = check_sniff_locking(spiketime, sniff_onsets, options)