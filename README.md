# Ephys Common Function 
## Unit_Def
Unit Definations. Named tetrode but can be used for single unit, tetrode, NN 16 and 32 channels, and NP 1.0

### 'Tetrode_Unit.m'
Untis 
### 'Tet_Odour_Unit.m'
Unit in odour sessions 
### 'Tet_Light_Unit.m'
Unit in optogenetic sessions, single core
### 'Tet_Light_Unit_Dual.m'
Unit in optogenetic sessions, dual core. Two cores used seperately
### 'Tet_Light_Unit_Dual_PR.m'
Unit in optogenetic sessions, dual core. Two cores used together


## Helper_fun
Functions for processing. See details in each file
'DrivingCurrent_2_Intensity.m'
'Light_on_Sniff_2D.m'
'Plot_100_traces_MeanSTD.m'
'Plot_100_traces_Overlay_script.m'
'aligned_raw_recording.m'
'baseline_sniff_phase_uniform.m'
'calculate_cells_and_color.m'
'calculate_control_cycles.m'
'calculate_control_onsets.m'
'calculate_resultant_vector.m'
'calculate_resultant_vector_norm.m'
'check_light_onset_response_Smear.m'
'check_light_response_ttest.m'
'check_light_response_zscore.m'
'check_light_stim_response_Smear.m'
'check_odour_response.m'
'check_sniff_locking.m'
'evoked_sniff_phase_uniform.m'
'filter_PulseNumber.m'
'filter_sniff_onset.m'
'find_evoked_spikes.m'
'find_stimuli_with_para.m'
'firing_probability.m'
'fit_Gaussian.m'
'get_pulse_latency_from_stimuli.m'
'get_pulse_onset_from_stimuli.m'
'get_stimuli_onsets_ms.m'
'get_stimuli_onsets_s.m'
'identify_MTC_firing_time.m'
'identify_MTC_resultant_vector.m'
'light_evoked_psth.m'
'light_evoked_spikes.m'
'light_evoked_spikes_Gaussian.m'
'light_no_evoked_spikes.m'
'light_psth_stacks.m'
'light_spikes_stacks.m'
'odour_name_from_voltage.m'
'phase_normed_psthAndBA.m'
'phase_normed_timestampsToBinned.m'
'pick_stimuli_with_latency.m'
'pick_stimuli_with_phase.m'
'pick_stimuli_with_trigger_latency.m'
'plotCellDistribution.m'
'plot_landmarks.m'
'plot_light_stimuli.m'
'plot_mean_16channel.m'
'plot_mean_waveform_channelmap.m'
'shuffle_sniff_duration.m'
'sort_light_stimuli.m'
'sort_light_stimuli_PR.m'
'sort_light_stimuli_guess_latency_group.m'
'sort_odour_stimuli.m'
'updateStructure.m'

## Testing_Scripts
Recodes for testing when writing each funciton

## Quality_Control
Used for remove MUAs
### 'MTCisiViolations.m'
Check if units are MTC units bases on their contaminations. 
### 'ccg.m'
crosscorrelogram
### 'Screen_Duplicated_Units.m'
Screen suspious duplicates when sorting with Phy. Not necessary for KS4

## LFP_fun
Not used. Use LFP common functions instead
