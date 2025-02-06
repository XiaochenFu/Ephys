function power = computePower(recording, samplerate, t1, t2, f1, f2, t1_full, t2_full)
%% based on what is used in Lewis 2024. Will use this to calculate the LFP power and then find the MCL
% computePower calculates the power of a specific frequency band within a
% specified time window of a neural recording using continuous wavelet transform.
%
% Inputs:
%   recording - An N*1 array representing the neural recording.
%   samplerate - The sampling rate of the recording (in Hz), e.g., 30000 for 30 kHz.
%   t1, t2 - The start and end of the time window (in seconds) for which the power
%            is calculated within the recording.
%   f1, f2 - The lower and upper bounds of the frequency band (in Hz) for which
%            the power is calculated.
%   t1_full, t2_full - The start and end of the larger time window (in seconds)
%                      used for CWT to reduce edge effects.
%
% Output:
%   power - The calculated power of the specified frequency band within the
%           specified time window of the recording.

% Validate input parameters
if t1 >= t2 || f1 >= f2 || t1_full >= t2_full || t1 < t1_full || t2 > t2_full
    error('Invalid time window or frequency band');
end

% Downsample the signal from 30 kHz to 1 kHz
downsampleRate = 1000; % Target sampling rate for CWT
downsampleFactor = samplerate / downsampleRate;
downsampledRecording = downsample(recording, downsampleFactor);

% Define the time vector after downsampling
dt = 1 / downsampleRate;
timeVector = (0:length(downsampledRecording)-1) * dt;

% Select the signal within the full time window for CWT analysis
idx_full = timeVector >= t1_full & timeVector <= t2_full;
selectedSignal_full = downsampledRecording(idx_full);

% Apply the continuous wavelet transform (CWT) on the full time window
[cfs, frequencies] = cwt(selectedSignal_full, downsampleRate);

% Identify the frequency range of interest within the CWT result
freqIdx = frequencies >= f1 & frequencies <= f2;

% Extract the time window of interest from the full CWT result
idx_analysis = timeVector(idx_full) >= t1 & timeVector(idx_full) <= t2;
cfs_analysis = cfs(freqIdx, idx_analysis);

% Inverse CWT to get the signal in the specified frequency band
bandSignal = icwt(cfs_analysis, frequencies(freqIdx));

% Calculate the power as the square of the RMS of the band signal
power = rms(bandSignal)^2;
end
