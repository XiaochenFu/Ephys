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
        Unit_Quality % after sorting by phy
        Unit_Identity
        cid % unit id in Phy

        % unit quality from kilosort2, including cluster_id	Amplitude
        % ContamPct KSLabel	amp	ch	depth	fr	group	n_spikes sh. saved
        % in file cluster_info.tsv
        KS_info


        Baseline_ms
        Baseling_Phase_Uniform
        Baseling_Phase_Wrap
        Resultant_Vector_Uniform % resultant vector, [r_phy;r_r], normalized
        Resultant_Vector_Wrap

        Sniff_Locked = nan;
        %         Light_Evoked

        Intan_File
        Spike_File
        Intan_Clip
        Spontaneous_SniffOnset = [];
        SniffOnset = []; % all the sniff onset.
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
            baseline_sniff_onset = getOr(option, 'baseline_sniff_onset', obj.Spontaneous_SniffOnset);
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
                figure
                plot(rasterX_SP,rasterY_SP,'.')
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
            baseline_sniff_onset = getOr(option, 'baseline_sniff_onset', obj.Spontaneous_SniffOnset);
            spiketime = obj.st;
            plotWindow_phase = getOr(option, 'plotWindow_phase', [0, 2*pi]);
            if ~update
                bins_base = obj.Baseling_Phase_Uniform{1};
                fr_base = obj.Baseling_Phase_Uniform{2};
            else
                [bins_base, fr_base] = baseline_sniff_phase_uniform(baseline_sniff_onset,spiketime,varargin);
                % calculate the resultant vector
                resultant_vector = calculate_resultant_vector_norm(bins_base,fr_base,option);%[r_phy;r_r];
                obj.Resultant_Vector_Uniform = resultant_vector;
            end
            obj = obj.update("Baseling_Phase_Uniform",bins_base,fr_base);

            if isplot
                figure
                plot(bins_base,fr_base,'k')
                cluster_id = obj.cid;
                title(sprintf("Baseline Sniff Coupling of Unit%d",cluster_id))
                xlabel("Phase in sniff cycle")
                ylabel(["Firing Rate (spike/cycle)"])%,sprintf("bin = %3g*2pi",binSize/2/pi)])
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
            update = getOr(option, 'update', 1);

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
                    neurontype = "o";
                end
            end

        end

        %         function h = plot_traces_overlay(obj,tetrode,varargin)
        %             Colours
        %             if length(varargin)>1
        %                 error("check")
        %             end
        %             if ~isempty(varargin)
        %                 option = varargin{1}; % parameters supplied by user
        %             else
        %                 option = [];
        %             end
        %             fs = getOr(option, 'fs', 20000);
        %             fslow = getOr(option, 'fslow', 3000);
        %             fshigh = getOr(option, 'fshigh', 300);
        %             window = getOr(option, 'window', [-0.001 0.002]);
        %             fhandle = getOr(option, 'fhandle', 233);
        %             evtTimes = getOr(option, 'evtTimes', obj.st);
        %             trace_max_number = getOr(option, 'trace_max_number', 100); % [] for plot all
        %             if ~isempty(trace_max_number)
        %                 if length(evtTimes)>trace_max_number
        %                     eventTimes_index = randperm(length(evtTimes),trace_max_number);
        %                     evtTimes = evtTimes(eventTimes_index);
        %                 end
        %             end
        %             n_channel = size(tetrode,1);
        %             ch_extract = getOr(option, 'ch_extract', [1:n_channel]);
        %
        %             t = (1:size(tetrode,2))/fs;
        %
        %             % randomly poll 100 traces so it will not take forever to plot
        %             rng(233)
        %
        %             yLimit_all = [];
        %             for ch_i = 1:length(ch_extract)
        %                 Channel_num = ch_extract(ch_i);
        %                 channel = tetrode(Channel_num,:);
        %                 [b1, a1] = butter(3, [fshigh/fs,fslow/fs]*2, 'bandpass'); % butterworth filter with only 3 nodes (otherwise it's unstable for float32)
        %                 channel_filtered = filtfilt(b1,a1,channel);
        %                 h = figure(fhandle);
        %                 subplot(n_channel/4,4, Channel_num)
        %                 [x1_all,~] = segment_with_onset_time(channel_filtered', t,  evtTimes, window);
        %                 x1 = mean(x1_all,2);
        %                 x1_std = std(x1_all,0,2);
        %                 itv = 1/fs;
        %                 tshow = 1000*(((1:length(x1))-1)*itv+window(1));% convert to ms
        %                 pl = plot(x1_all, 'Color',[c_Black 0.05]);
        %                 box off
        %                 axis off
        %                 eval(sprintf('yLimit%d = get(gca,"YLim");',Channel_num))
        %                 eval(sprintf('yLimit_all = [yLimit_all yLimit%d];',Channel_num))
        %                 hold on
        %             end
        %             ylim_min = min([yLimit_all]);
        %             ylim_max = max([yLimit_all]);
        %             for Channel_num = 1:n_channel
        %                 h = figure(fhandle);
        %                 subplot(n_channel/4,4, Channel_num)
        %                 ylim([ylim_min ylim_max])
        %             end
        %         end

        function waveforms = calculate_waveforms(obj, tetrode, varargin)
            if length(varargin) > 1
                error("check")
            end
            if ~isempty(varargin)
                option = varargin{1}; % parameters supplied by user
            else
                option = [];
            end
            fs = getOr(option, 'fs', 20000);

            window = getOr(option, 'window', [-0.001 0.002]);
            evtTimes = getOr(option, 'evtTimes', obj.st);
            trace_max_number = getOr(option, 'trace_max_number', 100); % [] for plot all
            isFiltered = getOr(option, 'filtered', false);
            fullChannel = getOr(option, 'fullChannel', true);


            if fullChannel
                n_channel = size(tetrode, 1);
                ch_extract = getOr(option, 'ch_extract', [1:n_channel]);
                data_to_filter = tetrode(ch_extract, :);
            else
                defaultChNum = getOr(option, 'defaultChNum', 16);
                n_channel = defaultChNum;
                ch_extract = getOr(option, 'ch_extract', []);
                if isempty(ch_extract)
                    error('Please tell me which channel you picked.')
                end
                data_to_filter = tetrode;
            end

            if ~isFiltered
                fslow = getOr(option, 'fslow', 3000);
                fshigh = getOr(option, 'fshigh', 300);
                [b1, a1] = butter(3, [fshigh/fs, fslow/fs] * 2, 'bandpass');
            end

            if ~isempty(trace_max_number)
                if length(evtTimes) > trace_max_number
                    rng(233) % Set seed for reproducibility
                    eventTimes_index = randperm(length(evtTimes), trace_max_number);
                    evtTimes = evtTimes(eventTimes_index);
                end
            end

            t = (1:size(tetrode, 2)) / fs;

            waveforms = cell(1, length(ch_extract));



            % Determine channels that need to be filtered
            if ~isFiltered
                filtered_data = filtfilt(b1, a1, data_to_filter')';  % Filter all necessary channels at once
            else
                filtered_data = data_to_filter;
            end

            % Now, loop over the channels just for the segmentation
            for ch_i = 1:length(ch_extract)
                waveforms{ch_i} = segment_with_onset_time(filtered_data(ch_i, :)', t, evtTimes, window);
            end

            %             for ch_i = 1:length(ch_extract)
            %                 Channel_num = ch_extract(ch_i);
            %                 channel = tetrode(Channel_num, :);
            %
            %                 if ~isFiltered
            %                     channel_filtered = filtfilt(b1, a1, channel);
            %                 else
            %                     channel_filtered = channel;
            %                 end
            %
            %                 waveforms{ch_i} = segment_with_onset_time(channel_filtered', t, evtTimes, window);
            %             end
        end

        %
        %     n_channel = size(tetrode, 1);
        %     ch_extract = getOr(option, 'ch_extract', [1:n_channel]);
        %     t = (1:size(tetrode, 2)) / fs;
        %
        %     rng(233) % Set seed for reproducibility
        %
        %     waveforms = cell(1, length(ch_extract));
        %     [b1, a1] = butter(3, [fshigh/fs, fslow/fs] * 2, 'bandpass');
        %     for ch_i = 1:length(ch_extract)
        %         Channel_num = ch_extract(ch_i);
        %         channel = tetrode(Channel_num, :);
        %
        %         channel_filtered = filtfilt(b1, a1, channel);
        %         waveforms{ch_i} = segment_with_onset_time(channel_filtered', t, evtTimes, window);
        %     end
        % end

        %
        %         function h = plot_traces_overlay(obj, tetrode, varargin)
        %             % Fetching the needed parameters
        %             if ~isempty(varargin)
        %                 option = varargin{1};
        %             else
        %                 option = [];
        %             end
        %             waveforms = calculate_waveforms(obj, tetrode, option);
        %
        %             % Assuming the 'Colours' function is defined elsewhere in your code
        %             Colours
        %
        %
        %             fhandle = getOr(option, 'fhandle', 233);
        %             n_channel = size(tetrode, 1);
        %             ch_extract = getOr(option, 'ch_extract', [1:n_channel]);
        %
        %             % Preallocate yLimit_all
        %             yLimit_all = zeros(1, length(ch_extract));
        %
        %             for ch_i = 1:length(ch_extract)
        %                 Channel_num = ch_extract(ch_i);
        %                 h = figure(fhandle);
        %                 subplot(n_channel/4, 4, Channel_num)
        %                 x1_all = waveforms{ch_i};
        %                 plot(x1_all, 'Color', [c_Black 0.05]);
        %                 box off
        %                 axis off
        %                 yLimit_all(ch_i) = max(get(gca, "YLim"));
        %                 hold on
        %             end
        %             ylim_min = min(yLimit_all);
        %             ylim_max = max(yLimit_all);
        %             for Channel_num = 1:n_channel
        %                 h = figure(fhandle);
        %                 subplot(n_channel/4, 4, Channel_num)
        %                 ylim([ylim_min ylim_max])
        %             end
        %         end

        function h = plot_traces_overlay(obj, tetrode, varargin)
            % Fetching the needed parameters
            if ~isempty(varargin)
                option = varargin{1};
            else
                option = [];
            end

            waveforms = calculate_waveforms(obj, tetrode, option);

            % Assuming the 'Colours' function is defined elsewhere in your code
            Colours

            fhandle = getOr(option, 'fhandle', 233);
            plot_all = getOr(option, 'plot_all', true);
            ch_extract = getOr(option, 'ch_extract', 1:16);
            fullChannel = getOr(option, 'fullChannel', true);
            if fullChannel
                n_channel = size(tetrode, 1);
                ch_extract = getOr(option, 'ch_extract', [1:n_channel]);
                data_to_filter = tetrode(ch_extract, :);
            else
                defaultChNum = getOr(option, 'defaultChNum', 16);
                n_channel = defaultChNum;
                ch_extract = getOr(option, 'ch_extract', []);
                if isempty(ch_extract)
                    error('Please tell me which channel you picked.')
                end
                data_to_filter = tetrode;
            end
            % Preallocate yLimit_all
            yLimit_all = nan(2, ch_extract);

            if plot_all
                n_channel = 16;
                for ch_i = 1:length(ch_extract)
                    Channel_num = ch_extract(ch_i);
                    h = figure(fhandle);
                    subplot(n_channel/4, 4, Channel_num)
                    x1_all = waveforms{ch_i};
                    plot(x1_all, 'Color', [c_Black 0.05]);
                    box off
                    axis off
                    yLimit_all(:,ch_i) = get(gca, "YLim");
                    hold on
                end
            else
                for ch_i = 1:length(ch_extract)
                    h = figure(fhandle);
                    subplot(1, length(ch_extract), ch_i)
                    x1_all = waveforms{ch_i};
                    plot(x1_all, 'Color', [c_Black 0.05]);
                    box off
                    axis off
                    yLimit_all(:,ch_i) = max(get(gca, "YLim"));
                    hold on
                end
            end

            ylim_min = min(yLimit_all,[], 'all','omitnan');
            ylim_max = max(yLimit_all,[], 'all','omitnan');

            if plot_all
                for ch_i = 1:length(ch_extract)
                    h = figure(fhandle);
                    subplot(n_channel/4, 4, ch_extract(ch_i))
                    ylim([ylim_min ylim_max])
                end
            else
                for ch_i = 1:length(ch_extract)
                    h = figure(fhandle);
                    subplot(1, length(ch_extract), ch_i)
                    ylim([ylim_min ylim_max])
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