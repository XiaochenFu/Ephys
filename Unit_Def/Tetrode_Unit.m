classdef Tetrode_Unit<dynamicprops  % works well for handle. use dynamicprops because it will be easy to add properties

    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Mouse_ID % ID of the mouse, strain_number
        Exp_Date % Date of experiment, something like'29-Oct-2022';
        Tract % which tract, 1, 2, or 3
        Recording_Depth % depth in um, integer
        Unit_Name_Long % Name of the unit, used for plotting, files, etc

        Cannula_Position % endup postion of the cannula, structure with 3 fields, AP, ML, DV
        Distance_to_L1 % distance to layer1 piriform, um

        st %Spike_Time
        Unit_Quality
        Unit_Identity
        cid % unit id in Phy

        Baseline_ms
        Baseling_Phase_Uniform
        Baseling_Phase_Wrap
        Resultant_Vector_Uniform
        Resultant_Vector_Wrap

        Sniff_Locked = nan;
        %         Light_Evoked

        Intan_File
        Spike_File
        Intan_Clip
        Spontaneous_SniffOnset = [];
    end

    methods
        % tet_unit = Tetrode_Unit() % create a new unit object
        % [bins_base, fr_base] = baseline_sniff_ms(obj,varargin) % calculate the baseline sniff coupling in ms
        % [bins_base, fr_base] = get_baseline_sniff_phase_uniform(obj,varargin) % calculate the baseline sniff coupling in phase
        % iscoupled = get_sniff_lock(obj,varargin) % check if unit is sniff coupled
        % neurontype = get_neurontype(obj,varargin) % check if unit is MC or TC or others
        % obj = update(obj,ppt ,varargin) % update the property of a unit

        function tet_unit = Tetrode_Unit() % create a new unit object
            addpath 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions'
            %             tet_unit.Unit_Name_Long = sprintf('%s_Tract%d_Depth%d_%s_unit%d',obj.Mouse_ID,obj.Tract,Recording_Depth,Stimuli_Type,j_cid);
        end

        function [bins_base, fr_base] = baseline_sniff_ms(obj,varargin) % calculate the baseline sniff coupling in ms
            if length(varargin)>1
                error("check")
            end
            if ~isempty(varargin)
                option = varargin{1}; % parameters supplied by user
            else
                option = [];
            end
            cluster_id = obj.cid;
            calcWindow = getOr(option, 'calcWindow', [-1, 1]);
            binSize = getOr(option, 'binSize', 0.01*(calcWindow(2)-calcWindow(1)));
            isplot = getOr(option, 'isplot', 0);
            saveplot = getOr(option, 'saveplot', 0);
            baseline_sniff_onset = obj.Spontaneous_SniffOnset;
            spiketime = obj.st;

            [psth_base, bins_base, rasterX_SP, rasterY_SP, spikeCounts_SP, ba_SP] = psthAndBA(spiketime, baseline_sniff_onset, calcWindow, binSize);
            psth_base = psth_base*binSize;
            fr_base = psth_base/binSize;
            obj = obj.update("Baseline_ms",bins_base,fr_base);
            if isplot
                figure

                plot(bins_base,fr_base,'k')
                title(sprintf("Baseline Sniff Coupling of Unit%d",cluster_id))
                xlabel("Time from sniff onset(s)")
                ylabel(sprintf("Firing Rate (Hz) bin = %3gs",binSize))
                if saveplot
                    saveas(gcf,sprintf("%s_%s_%s_ms.jpg",obj.Mouse_ID,obj.Intan_File,obj.Cannula_Position))

                end
            end
        end
        function [bins_base, fr_base] = get_baseline_sniff_phase_uniform(obj,varargin) % calculate the baseline sniff coupling in phase
            if length(varargin)>1
                error("check")
            end
            if ~isempty(varargin)
                option = varargin{1}; % parameters supplied by user
            else
                option = [];
            end
            isplot = getOr(option, 'isplot', 0);
            saveplot = getOr(option, 'saveplot', 0);
            update = getOr(option, 'update', 1);
            baseline_sniff_onset = obj.Spontaneous_SniffOnset;
            spiketime = obj.st;
            plotWindow_phase = getOr(option, 'plotWindow_phase', [0, 2*pi]);
            if ~update
                bins_base = obj.Baseling_Phase_Uniform{1};
                fr_base = obj.Baseling_Phase_Uniform{2};
            else
                [bins_base, fr_base] = baseline_sniff_phase_uniform(baseline_sniff_onset,spiketime,varargin);
                % calculate the resultant vector
                resultant_vector = calculate_resultant_vector_norm(bins_base,fr_base);
                obj.Resultant_Vector_Uniform = resultant_vector;
            end
            obj = obj.update("Baseling_Phase_Uniform",bins_base,fr_base);

            if isplot
                figure
                plot(bins_base,fr_base,'k')
                cluster_id = obj.cid;
                title(sprintf("Baseline Sniff Coupling of Unit%d",cluster_id))
                xlabel("Phase in sniff cycle")
                ylabel(["Firing Rate (spike/cycle)",sprintf("bin = %3g*2pi",binSize/2/pi)])
                set(gca,'XTick',0:pi/2:2*pi)
                set(gca,'XTickLabel', {'0','\pi/2','\pi','3\pi/2','2\pi'});
                if saveplot
                    saveas(gcf,sprintf("%s_%s_%s_phase.jpg",obj.Mouse_ID,obj.Intan_File,obj.Cannula_Position))
                end
            end
        end
        function iscoupled = get_sniff_lock(obj,varargin) % check if unit is sniff coupled
            if length(varargin)>1
                error("check")
            end
            if ~isempty(varargin)
                option = varargin{1}; % parameters supplied by user
            else
                option = [];
            end
            update = getOr(option, 'update', 1);
            if ~update
                iscoupled = obj.Sniff_Locked;
            else
                sniff_onsets = obj.Spontaneous_SniffOnset;
                spiketime = obj.st;
                % check_sniff_locking
                iscoupled = check_sniff_locking(spiketime, sniff_onsets, option);
                obj.Sniff_Locked = iscoupled;
            end

        end
        function neurontype = get_neurontype(obj,varargin) % check if unit is MC or TC or others
            if length(varargin)>1
                error("check")
            end
            if ~isempty(varargin)
                option = varargin{1}; % parameters supplied by user
            else
                option = [];
            end
            update = getOr(option, 'update', 0);

            if ~update
                neurontype = obj.Unit_Identity; % return the existing value is no need to update
            else
                if obj.Sniff_Locked % if the unit is sniff coupled
                    %                     %% get neurontype from the baseline sniff coupling
                    %                     timesteps = obj.Baseline_ms{1};
                    %                     APs = obj.Baseline_ms{2};
                    %                     % identify_MTC_firing_time
                    %                     neurontype = identify_MTC_firing_time(timesteps,APs,option);
                    %                     obj.Unit_Identity = neurontype;
                    %%  get neuron type using resultant vector
                    resultant_vector = obj.Resultant_Vector_Uniform;
                    neurontype = identify_MTC_resultant_vector(resultant_vector,option);
                    obj.Unit_Identity = neurontype;
                else % neurontype "o" if the unit is not MTC.
                    obj.Unit_Identity = "o";
                end
            end

        end
        function obj = update(obj,ppt ,varargin) % update the property of a unit
            p = length(varargin);
            if p>1
                for j = 1:p
                    obj.(ppt){j} = varargin{j};
                end
            else
                obj.(ppt) = varargin;
            end
        end
        function obj = untitled3(inputArg1,inputArg2)
            %UNTITLED3 Construct an instance of this class
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