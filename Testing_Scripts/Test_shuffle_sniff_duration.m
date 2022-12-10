close all
global isplot saveplot
isplot = 1;
saveplot = 0;

sniff_onsets = odour_unit_processing.Spontaneous_SniffOnset;
% histpgram(diff(sniff_onsets)) % the frequency seems very stable
% shuffle_sniff_duration
options.num_shuffle = 10;
[shuffled_onsets, shuffled_durations] = shuffle_sniff_duration(sniff_onsets,options);
% plot(sniff_onsets,shuffled_onsets)

%% calculate the resulatant vector of the non-shuffled 
spiketime = odour_unit_processing.st;
baseline_sniff_onset = sniff_onsets;
calcWindow_each_cycle = diff(baseline_sniff_onset);
binSize = 0.01*2*pi;
[psth_base, bins_base, rasterX_SP, rasterY_SP, spikeCounts_SP, ba_SP] = phase_normed_psthAndBA(spiketime, baseline_sniff_onset, calcWindow_each_cycle, binSize);
psth_base = psth_base*binSize;
fr_base = psth_base/(binSize/2/pi);
% figure
% plot(bins_base,fr_base,'k')
% title(sprintf("Baseline Sniff Coupling"))
% xlabel("Phase in sniff cycle")
% ylabel(["Firing Rate (spike/cycle)",sprintf("bin = %3g*2pi",binSize/2/pi)])
% set(gca,'XTick',0:pi/2:2*pi)
% set(gca,'XTickLabel', {'0','\pi/2','\pi','3\pi/2','2\pi'});

% figure
% subplot 211
calculate_resultant_vector(bins_base,fr_base)
%% calculate the resulatant vector of the shuffled 
spiketime = odour_unit_processing.st;
baseline_sniff_onset = shuffled_onsets;
calcWindow_each_cycle = diff(baseline_sniff_onset);
binSize = 0.01*2*pi;
[psth_base, bins_base, rasterX_SP, rasterY_SP, spikeCounts_SP, ba_SP] = phase_normed_psthAndBA(spiketime, baseline_sniff_onset, calcWindow_each_cycle, binSize);
psth_base = psth_base*binSize;
fr_base = psth_base/(binSize/2/pi);
% figure
% hold on
% plot(bins_base,fr_base,'k')
% title(sprintf("Shuffled Sniff Coupling"))
% xlabel("Phase in sniff cycle")
% ylabel(["Firing Rate (spike/cycle)",sprintf("bin = %3g*2pi",binSize/2/pi)])
% set(gca,'XTick',0:pi/2:2*pi)
% set(gca,'XTickLabel', {'0','\pi/2','\pi','3\pi/2','2\pi'});


% subplot 212
calculate_resultant_vector(bins_base,fr_base)