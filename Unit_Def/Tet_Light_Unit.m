classdef Tet_Light_Unit < Tetrode_Unit
    properties %
        Stimuli_Info
        Light_Evoked
%         LatencyFromCalculatedSniffOnset_ms
    end
    methods
        function light_evoked = get_lighted_response(obj, stim_grouped, sniffonsets,option)
            option = [];
            spiketime = obj.st;
            sniff_spon = obj.Spontaneous_SniffOnset;
            stim_group = stim_grouped(1);
%             sniffonsets = 
%             LatencyFromCalculatedSniffOnset_ms = obj.LatencyFromCalculatedSniffOnset_ms;
            light_evoked = check_light_response(spiketime,stim_grouped,sniffonsets, sniffonsets,option);
            obj.Light_Evoked = light_evoked;
            if light_evoked
                obj.Unit_Name_Long
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