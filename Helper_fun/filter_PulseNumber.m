function filteredStruct = filter_PulseNumber(Stimuli_Info)
    % Initialize an array to keep track of indices to keep
    indicesToKeep = false(1, length(Stimuli_Info));
    
    % Loop through each element in the structure array
    for i = 1:length(Stimuli_Info)
        current = Stimuli_Info(i);
        hasPair = false;
        
        % Check against all other elements to find a pair
        for j = 1:length(Stimuli_Info)
            if i ~= j
                compare = Stimuli_Info(j);
                if current.DrivingCurrent == compare.DrivingCurrent && ...
                   current.PulseWidth_ms == compare.PulseWidth_ms
                    hasPair = true;
                    break;
                end
            end
        end
        
        % If a pair is found, mark this index to keep
        if hasPair
            indicesToKeep(i) = true;
        end
    end
    
    % Filter the structure to only include indices with pairs
    filteredStruct = Stimuli_Info(indicesToKeep);
end
