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
    end
    methods
        function light_response = get_light_response(obj, stim_grouped, sniffonsets,varargin)
            if ~isempty(varargin)
                option = varargin{1}; % parameters supplied by user
            else
                option = [];
            end
            spiketime = obj.st;
            sniff_spon = obj.Spontaneous_SniffOnset;
            light_response = check_light_response(spiketime,stim_grouped,sniffonsets,option);
            obj.update("Light_Response",light_response,stim_grouped);
            obj.is_light_evoked;
            %             obj.Light_Evoked = light_evoked;
            %             if light_evoked
            %                 obj.Unit_Name_Long
            %             end
        end
        function light_evoked = is_light_evoked(obj)
            % calculated and update Light_Evoked
%             if isempty(obj.Light_Evoked)
                if isempty( obj.Light_Response{1})
                    fprintf("please calculate with get_light_response")
                else
                    light_response = obj.Light_Response{1};
                    if any(light_response)
                        light_evoked = 1;
                    else
                        light_evoked = 0;
                    end
                end
                obj.Light_Evoked = light_evoked;
%             else
%                 light_evoked = obj.Light_Evoked;
%             end
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