classdef    Tet_Odour_Unit < Tetrode_Unit
    properties
        Stimuli_Info % stimuli, unsorted
        Stimuli_Grouped % a sructure of odour stimuli.
        Odour_Response % a structure with grouped stimuli and response.
        % -1 for inhibitatory response, 0 for not responding and 1 for
        % excitatory response. By default, the odour need to be presented
        % for more than once
        Odour_Evoked = [];% binary value, 1 if the unit show any excitatory
        % respnse to at least one odour By default, the odour need to be
        % presented for more than once

%         Odour_ms = struct('OdourName', { 'Acetophenone', 'EythylButyrate', 'EythylTiglate', 'MethylValerate'}, 'Phase_Uniforms', { {}, {}, {}, {} }); % to calculate the resulatant vector for odour
        Odour_Phase_Uniform = struct('OdourName', { 'Acetophenone', 'EythylButyrate', 'EythylTiglate', 'MethylValerate'}, 'Phase_Uniforms', { {}, {}, {}, {} }); % to calculate the resulatant vector for odour
        Odour_Resultant_Vector_Uniform = struct('OdourName', { 'Acetophenone', 'EythylButyrate', 'EythylTiglate', 'MethylValerate'}, 'Phase_Uniforms', { [], [], [], [] }); % resultant vector for odour response, [r_phy;r_r], normalized
    



    end
    methods

        function odour_response = get_odour_response(obj, stim_grouped,varargin)
            % Check for optional parameters
            if ~isempty(varargin)
                option = varargin{1}; % Parameters supplied by user
            else
                option = [];
            end

            % Obtain spike times
            spiketime = obj.st;

            % Check odour response using dedicated function
            odour_response = check_odour_response(spiketime,stim_grouped,option);

            % Update object properties
            obj.update("Odour_Response",odour_response,stim_grouped);

            % Check if the odour response is evoked
            obj.is_odour_evoked;
        end

        % Method to check if odour is evoked
        function odour_evoked = is_odour_evoked(obj)

            if isempty(obj.Odour_Response{1})
                fprintf("Please calculate with get_odour_response")
            else
                odour_response = obj.Odour_Response{1};
                if any(odour_response)
                    odour_evoked = 1;
                else
                    odour_evoked = 0;
                end
            end

            % Update object property
            obj.Odour_Evoked = odour_evoked;
        end

        function [bins_base, fr_base] = get_odour_sniff_phase_uniform(obj,stim_grouped,sniff_onset,varargin) 
            % calculate the sniff coupling in phase after the odour onset
            if length(varargin)>1
                error("check input number")
            end
            if ~isempty(varargin)
                option = varargin{1}; % parameters supplied by user
            else
                option = [];
            end
            isplot = getOr(option, 'isplot', 0);
            saveplot = getOr(option, 'saveplot', 0);
            update = getOr(option, 'update', 1);
            spiketime = obj.st;
            plotWindow_phase = getOr(option, 'plotWindow_phase', [0, 2*pi]);
            odour_check_time = getOr(option, 'odour_check_time', 1.5); % by default, check the sniff onset 1.5s after the FV opening

            for odour_i = 1:length(stim_grouped)
                OdourName = stim_grouped(odour_i).OdourName;
                FV_opening_time = stim_grouped(odour_i).TrailOnset;
                sniff_onset_odour = filter_sniff_onset(FV_opening_time, sniff_onset, odour_check_time);
                if ~update
                    bins_base = obj.Baseling_Phase_Uniform{1};
                    fr_base = obj.Baseling_Phase_Uniform{2};
                else
                    [bins_base, fr_base] = baseline_sniff_phase_uniform(sniff_onset_odour,spiketime,varargin);
                    % calculate the resultant vector
                    resultant_vector = calculate_resultant_vector_norm(bins_base,fr_base,option);%[r_phy;r_r];
                    % update the result (the method update is not goo d)
                    odour_phase_struct = struct('OdourName',OdourName, 'Phase_Uniforms', { resultant_vector });
                    odour_resultant_vector_uniform_struct = struct('OdourName',OdourName, 'Phase_Uniforms', { resultant_vector });
                    obj.Odour_Phase_Uniform = updateStructure(obj.Odour_Phase_Uniform,odour_phase_struct);
                    obj.Odour_Resultant_Vector_Uniform = updateStructure(obj.Odour_Resultant_Vector_Uniform,odour_resultant_vector_uniform_struct);
                end
            end
            
            

            function obj = untitled15(inputArg1,inputArg2)
                %UNTITLED15 Construct an instance of this class
                %   Detailed explanation goes here
                obj.Property1 = inputArg1 + inputArg2;
            end

            function outputArg = method1(obj,inputArg)
                %METHOD1 Summary of this method goes here
                %   Detailed explanation goes here
                outputArg = obj.Property1 + inputArg;
            end
        end
    end
end