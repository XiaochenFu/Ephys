function Odour_Phase_Uniforms = updateStructure(Odour_Phase_Uniforms, newStruct)
    % Function to update Odour_Phase_Uniforms based on newStruct
    
    for i = 1:length(newStruct) % Iterate over each OdourName in newStruct
        % Extract OdourName fields into a cell array
        existingOdourNames = {Odour_Phase_Uniforms.OdourName};
        
        % Find the index of the OdourName in Odour_Phase_Uniforms that matches the current OdourName in newStruct
        idx = find(strcmp(existingOdourNames, newStruct(i).OdourName));
        
        if ~isempty(idx) % If a match is found
            % Update the Phase_Uniforms of the matching OdourName in Odour_Phase_Uniforms with the Phase_Uniforms of the current OdourName in newStruct
            Odour_Phase_Uniforms(idx).Phase_Uniforms = newStruct(i).Phase_Uniforms;
        else % If a match is not found
            % Add a new entry to Odour_Phase_Uniforms with the OdourName and Phase_Uniforms from newStruct
            Odour_Phase_Uniforms(end+1) = struct('OdourName', newStruct(i).OdourName, 'Phase_Uniforms', newStruct.Phase_Uniforms{i});
        end
    end
end
