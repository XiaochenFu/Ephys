function pulse_onset = get_pulse_latency_from_stimuli(stim_grouped_j, i)
    if i > stim_grouped_j.PulseNumber
        error('i exceeds the PulseNumber in stim_grouped_j.');
    end

    % Calculate the onset
    pulse_onset = stim_grouped_j.LatencyFromCalculatedSniffOnset_ms + (1/stim_grouped_j.Frequency) * (i - 1);
end
