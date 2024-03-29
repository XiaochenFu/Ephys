function controlCycles = calculate_control_cycles(sniffOnsets, lightStimuliTimes)
    % Buffer for considering next sniffs
    BUFFER_CYCLES = 5;

    % Compute the absolute differences
    diffs = abs(bsxfun(@minus, sniffOnsets(:), lightStimuliTimes(:)'));


    % Find sniffs that don't have any light stimuli close enough
    isControlImmediately = all(diffs > min(diff(sniffOnsets)), 2);

    % Ensure the next BUFFER_CYCLES sniffs also don't have closely associated light stimulus
    controlBuffer = true(size(sniffOnsets(:)));
    for offset = 1:BUFFER_CYCLES
        controlBuffer = controlBuffer & circshift(isControlImmediately, -offset);
    end

    isControlBuffered = isControlImmediately & controlBuffer;
    
    % Extract control cycle times
    controlCycles = sniffOnsets(isControlBuffered);
end
