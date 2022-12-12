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
    end
    methods
        function odour_response = get_odour_response(obj, stim_grouped,varargin)
            if ~isempty(varargin)
                option = varargin{1}; % parameters supplied by user
            else
                option = [];
            end
            spiketime = obj.st;
            odour_response = check_odour_response(spiketime,stim_grouped,option);
            obj.update("Odour_Response",odour_response,stim_grouped);
            obj.is_odour_evoked;
         end
        function odour_evoked = is_odour_evoked(obj)
            % calculated and update Odour_Evoked
                if isempty( obj.Odour_Response{1})
                    fprintf("please calculate with get_light_response")
                else
                    odour_response = obj.Odour_Response{1};
                    if any(odour_response)
                        odour_evoked = 1;
                    else
                        odour_evoked = 0;
                    end
                end
                obj.Odour_Evoked = odour_evoked;
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