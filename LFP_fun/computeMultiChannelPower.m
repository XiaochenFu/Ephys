function power = computeMultiChannelPower(recording, samplerate, t1, t2, f1, f2, t1_full, t2_full)
    % computeMultiChannelPower calculates the power of a specific frequency band
    % within a specified time window for each channel in a multi-channel neural recording.
    %
    % Inputs:
    %   recording - An N*M array representing the neural recording, where N is the
    %               number of samples and M is the number of channels.
    %   samplerate - The sampling rate of the recording (in Hz), e.g., 30000 for 30 kHz.
    %   t1, t2 - The start and end of the time window (in seconds) for which the power
    %            is calculated within the recording.
    %   f1, f2 - The lower and upper bounds of the frequency band (in Hz) for which
    %            the power is calculated.
    %   t1_full, t2_full - The start and end of the larger time window (in seconds)
    %                      used for CWT to reduce edge effects.
    %
    % Output:
    %   power - A 1*M array containing the calculated power of the specified frequency
    %           band within the specified time window for each channel.

    % Validate input parameters
    if t1 >= t2 || f1 >= f2 || t1_full >= t2_full || t1 < t1_full || t2 > t2_full
        error('Invalid time window or frequency band');
    end

    % Number of channels
    numChannels = size(recording, 2);

    % Initialize the power array
    power = zeros(1, numChannels);

    % Process each channel individually to minimize memory load
    for ch = 1:numChannels
        % Extract the current channel data
        channelData = recording(:, ch);

        % Compute the power for the current channel
        power(ch) = computePower(channelData, samplerate, t1, t2, f1, f2, t1_full, t2_full);
    end
end

% You should also adjust the original computePower function to handle a single channel of data,
% ensuring it processes the data efficiently and is suitable for being called in a loop.
