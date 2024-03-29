classdef Tet_Light_Unit_Dual < Tet_Light_Unit
    properties %
        Distance_to_L1_Medial
        Cannula_Position_Medial  % endup postion of the medial cannula, structure with 3 fields, AP, ML, DV
        Light_Onsets_Medial
        Stimuli_Info_Medial % stimuli for medial core only, unsorted
        Stimuli_Grouped_Medial % a sructure of odour stimuli.
        Light_Response_Medial % a structure with grouped stimuli and response.
        % -1 for inhibitatory response, 0 for not responding and 1 for
        % excitatory response. By default, the odour need to be presented
        % for more than once
        Light_Evoked_Medial = []; % binary value, 1 if the unit show any excitatory
        % respnse to at least one odour By default, the odour need to be
        % presented for more than once
        Current_to_Power_Medial %
    end
    methods
        % Method to get light response
        function light_response = get_light_response_Medial(obj, stim_grouped, varargin) % old version: light_response = get_light_response(obj, stim_grouped, sniffonsets, varargin)
            % Handle error for too many inputs
            if length(varargin)>1
                error("Too many inputs. Please check.")
            end

            % Check for optional parameters
            if ~isempty(varargin)
                option = varargin{1}; % Parameters supplied by user
            else
                option = [];
            end

            % Obtain spike times and spontaneous sniff onset
            spiketime = obj.st;
            %             sniff_spon = obj.Spontaneous_SniffOnset;
            sniffonsets = obj.SniffOnset;

            % Check light response using dedicated function. not used
            % anymore
            %             light_response = check_light_response_ttest(spiketime, stim_grouped, sniffonsets, option);

            % check with the method in Smear 2011
            lightStimuliTimes = obj.Light_Onsets_Medial;
            controlCycles = calculate_control_cycles(sniffonsets, lightStimuliTimes);
            light_response = check_light_stim_response_Smear(spiketime, stim_grouped, controlCycles, option);
            % Update object properties
            obj.update("Light_Response_Medial", light_response, stim_grouped);

            % Check if the light response is evoked
            obj.is_light_evoked_Medial;
        end

        % Method to check if light is evoked
        function light_evoked = is_light_evoked_Medial(obj)
            if isempty(obj.Light_Response_Medial{1})
                fprintf("Please calculate with get_light_response")
            else
                light_response = obj.Light_Response_Medial{1};
                if any(light_response)
                    light_evoked = 1;
                else
                    light_evoked = 0;
                end
            end

            % Update object property
            obj.Light_Evoked_Medial = light_evoked;
        end
        
        function obj = AddIntensity_Stimuli_Grouped_Medial(obj)
            Stim_Grouped_Medial = obj.Stimuli_Grouped_Medial;
            if isfield(Stim_Grouped_Medial,'Power')
                error('why the power is there')
            else
                Current2Power = obj.Current_to_Power_Medial;
                for stm = 1:length(Stim_Grouped_Medial)
                    DrivingCurrent = Stim_Grouped_Medial(stm).DrivingCurrent;
                    Intensity = DrivingCurrent_2_Intensity(DrivingCurrent, Current2Power);
                    Stim_Grouped_Medial(stm).Intensity = Intensity;
                end
                obj.Stimuli_Grouped_Medial = Stim_Grouped_Medial;
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