classdef Tet_Light_Unit < Tetrode_Unit
    properties %
        Stimuli_Info % stimuli, unsorted
        Stimuli_Grouped % a sructure of odour stimuli.
        Light_Response % a structure with grouped stimuli and response.
        % -1 for inhibitatory response, 0 for not responding and 1 for
        % excitatory response. By default, the odour need to be presented
        % for more than once
        Light_Evoked = []; % binary value, 1 if the unit show any excitatory
        % respnse to at least one odour By default, the odour need to be
        % presented for more than once
        Current_to_Power %
    end
    methods
        % Method to get light response
        function light_response = get_light_response(obj, stim_grouped, sniffonsets, varargin)
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
            sniff_spon = obj.Spontaneous_SniffOnset;

            % Check light response using dedicated function
            light_response = check_light_response_ttest(spiketime, stim_grouped, sniffonsets, option);

            % Update object properties
            obj.update("Light_Response", light_response, stim_grouped);

            % Check if the light response is evoked
            obj.is_light_evoked;
        end

        % Method to check if light is evoked
        function light_evoked = is_light_evoked(obj)
            if isempty(obj.Light_Response{1})
                fprintf("Please calculate with get_light_response")
            else
                light_response = obj.Light_Response{1};
                if any(light_response)
                    light_evoked = 1;
                else
                    light_evoked = 0;
                end
            end

            % Update object property
            obj.Light_Evoked = light_evoked;
        end
        
        function obj = AddIntensity_Stimuli_Grouped(obj)
            StimuliGrouped = obj.Stimuli_Grouped;
            if isfield(StimuliGrouped,'Power')
                error('why the power is there')
            else
                Current2Power = obj.Current_to_Power;
                for stm = 1:length(StimuliGrouped)
                    DrivingCurrent = StimuliGrouped(stm).DrivingCurrent;
                    Intensity = DrivingCurrent_2_Intensity(DrivingCurrent, Current2Power);
                    StimuliGrouped(stm).Intensity = Intensity;
                end
                obj.Stimuli_Grouped = StimuliGrouped;
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