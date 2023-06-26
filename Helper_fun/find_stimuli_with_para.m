function [stimuli_grouped_j,idx] = find_stimuli_with_para(stimuli_grouped,drivingcurrent,frequency,pulsewidth_ms,pulse_num)
DrivingCurrent = extractfield(stimuli_grouped,'DrivingCurrent');
Frequency = extractfield(stimuli_grouped,'Frequency');
PulseWidth_ms = extractfield(stimuli_grouped,'PulseWidth_ms');
PulseNumber = extractfield(stimuli_grouped,'PulseNumber');
dc_match = (DrivingCurrent==drivingcurrent);
f_match = (Frequency == frequency);
pw_match = (PulseWidth_ms == pulsewidth_ms);
pn_match = (PulseNumber == pulse_num);
idx = dc_match & f_match & pw_match & pn_match;
stimuli_grouped_j = stimuli_grouped(idx);
end
