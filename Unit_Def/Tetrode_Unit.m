classdef Tetrode_Unit<dynamicprops  % works well for handle. use dynamicprops because it will be easy to add properties 

    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Mouse_ID % ID of the mouse, strain_number
        Exp_Date % Date of experiment, something like'29-Oct-2022';
        Tract % which tract, 1, 2, or 3
        Recording_Depth % depth in um, integer
        Cannula_Position % endup postion of the cannula, structure with 3 fields, AP, ML, DV
        Distance_to_L1 % distance to layer1 piriform, um
        Baseline_ms
        Baseling_Phase_Uniform
        Baseling_Phase_Wrap
        Resultant_Vector_Uniform
        Resultant_Vector_Wrap
        st %Spike_Time
        Unit_Quality
        Unit_Identity
        cid % unit id in Phy
        %         Light_Evoked
        Unit_Name_Long
        Intan_File
        Spike_File
        Intan_Clip
        Spontaneous_SniffOnset = [];
    end

    methods
        function tet_unit = Tetrode_Unit()
            addpath 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions'
%             tet_unit.Unit_Name_Long = sprintf('%s_Tract%d_Depth%d_%s_unit%d',obj.Mouse_ID,obj.Tract,Recording_Depth,Stimuli_Type,j_cid);
        end
        function [bins_base, fr_base] = baseline_sniff_ms(obj,varargin)
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
        function [bins_base, fr_base] = baseline_sniff_phase(obj,varargin)
            if ~isempty(varargin)
                option = varargin{1}; % parameters supplied by user
            else
                option = [];
            end
            cluster_id = obj.cid;

            binSize = getOr(option, 'binSize', 0.01*2*pi);
            isplot = getOr(option, 'isplot', 0);
            saveplot = getOr(option, 'saveplot', 0);
            baseline_sniff_onset = obj.Spontaneous_SniffOnset;
            spiketime = obj.st;
            plotWindow_phase = getOr(option, 'plotWindow_phase', [0, 2*pi]);
            calcWindow_each_cycle = diff(baseline_sniff_onset);
            % █ █▀▄▀█ █▀█ █▀█ █▀█ ▀█▀ ▄▀█ █▄░█ ▀█▀
            % █ █░▀░█ █▀▀ █▄█ █▀▄ ░█░ █▀█ █░▀█ ░█░
            % the window will be an array of sniff durations
%             [psth_base, bins_base, rasterX_SP, rasterY_SP, spikeCounts_SP, ba_SP] = psthAndBA(spiketime, baseline_sniff_onset, calcWindow, binSize);

            [psth_base, bins_base, rasterX_SP, rasterY_SP, spikeCounts_SP, ba_SP] = phase_normed_psthAndBA(spiketime, baseline_sniff_onset, calcWindow_each_cycle, binSize);
            psth_base = psth_base*binSize;
            fr_base = psth_base/(binSize/2/pi);
            obj = obj.update("Baseling_Phase_Uniform",bins_base,fr_base);
            if isplot
                figure
                
                plot(bins_base,fr_base,'k')
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
        function obj = update(obj,ppt ,varargin)
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