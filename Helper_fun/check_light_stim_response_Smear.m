function light_evoked_grouped = check_light_stim_response_Smear(spiketime, stim_grouped, controlCycles, varargin)
if length(varargin)>1
    error("check")
end
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end

for j = 1:length(stim_grouped)
    light_evoked_group(j) = 0;
    stim_grouped_j = stim_grouped(j);

    %     trial_latency = stim_grouped_j.LatencyFromCalculatedSniffOnset_ms;
    % calculate window will be automatically decided based on the last
    % pulse.since the latency might change with the light intensity etc.,
    % but less than 20ms, I'll use 20 ms after the last pulse
    calcWindow = getOr(option, 'calcWindow', [0, 0.02]);
    %     calcWindow = getOr(option, 'calcWindow', []);
    %     if isempty(calcWindow)
    %         calcWindow_latency = getOr(option, 'calcWindow_latency', 0.020);
    %         pulse_num = stim_grouped_j.PulseNumber;
    %         pulse_frequency = stim_grouped_j.Frequency;
    %         pulse_width = stim_grouped_j.PulseWidth_ms;
    %         k = pulse_num;
    %         x1 = 1000/pulse_frequency*(k-1); %compute the pulse onset in ms
    %         x2 = x1+pulse_width;
    %         calcWindow = [0, x2/1000+calcWindow_latency];
    %     else
    %
    %     end

    binSize = getOr(option, 'binSize', 0.01*(calcWindow(2)-calcWindow(1)));
    isplot = getOr(option, 'isplot', 0);
    plotevoked = getOr(option, 'plotevoked', 0);
    plotlight = getOr(option, 'plotlight', 1);
    saveplot = getOr(option, 'saveplot', 0);
    spk_threshold = getOr(option,'spk_threshold',4);
    plotpath = getOr(option, 'plotpath', 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Test_Figure');
    saveformat = getOr(option,'saveformat','1');




    %% check if light evoked for each light pulse
    num_pulse = stim_grouped_j.PulseNumber;

    for pi = 1:num_pulse

        eventtime = get_pulse_onset_from_stimuli(stim_grouped_j, pi);
        LatencyFromCalculatedSniffOnset_ms = stim_grouped_j.LatencyFromCalculatedSniffOnset_ms;
        control_onsets = calculate_control_onsets(controlCycles, LatencyFromCalculatedSniffOnset_ms);
        response = 0;
        [response, ~] = check_light_onset_response_Smear(spiketime, eventtime, control_onsets);
        if response
            light_evoked_group(j) = 1;
            %          eventtime = stim_grouped_j.TrailOnset;
            %% when light present
            [psth_base, bins_base, ~, ~, ~, ~] = psthAndBA(spiketime, eventtime, calcWindow, binSize);
            psth_base = psth_base*binSize;
            fr_base = psth_base/binSize;

            % plot(bins_base,fr_base)
            %% before light
            %     eventtime0 = nan(size(eventtime));
            %     % as comperation, get the psth usinglast sniff. same onset latency
            %     for i = 1:length(eventtime)
            %         % find the last sniff, so two onsets before
            %         sniff_onset1 = sniff_onset(sniff_onset<eventtime(i));
            %         sniff_onset2 = sniff_onset1(end-1);
            %         eventtime0(i) = sniff_onset2+ trial_latency(i)/1000;
            %     end
            [psth_base0, bins_base0, rasterX_SP, rasterY_SP, spikeCounts_SP, ba_SP] = psthAndBA(spiketime, controlCycles, calcWindow, binSize);
            psth_base0 = psth_base0*binSize;
            fr_base0 = psth_base0/binSize;
            fittedGaussian = fit_Gaussian(bins_base, (fr_base-fr_base0));
            if isplot
                figure
                plot(bins_base,fr_base)
                hold on
                plot(bins_base0,fr_base0)
                x = bins_base;
                y = (fr_base-fr_base0);
                fitResult = fit_Gaussian(x, y);
                plot(x, y)
                hold on
                plot(fitResult, x, y);
                title('Gaussian for fitting evoked PSTH')
                %                 pi
            end
        end
    end




%     if response % light response different from the baseline
        [evoked_spk,~,~,~] = light_evoked_spikes(spiketime,stim_grouped_j,option);

        %         [evoked_spk,~,~,~] = light_evoked_spikes_Gaussian(spiketime,stim_grouped_j,fittedGaussian,option);
        %         if max(cellfun(@length,evoked_spk))>spk_threshold
        %             light_evoked_group(j) = 1;
        if plotevoked &response
            %% raster plot
            figure
            subplot 211
            % lick raster for all trials
            [binnedArray, bins] = timestampsToBinned(spiketime, eventtime, binSize, calcWindow);
            % lick raster for only s plus trials
            [tr,b] = find(binnedArray);
            [rasterX,yy] = rasterize(bins(b));
            rasterY = yy+reshape([nan(size(tr'));tr';zeros(size(tr'))],1,length(tr)*3); % note from XFu. The original code duplicate the dots to make the ticks longer, which I believe is cheating.
            rasterX(rasterY==0) = [];rasterY(rasterY==0) = [];% remove zeros
            plot(rasterX, rasterY,'.')
            hold on
            if plotlight
                % plot the light stimuli
                pulse_num = stim_grouped_j.PulseNumber;
                pulse_frequency = stim_grouped_j.Frequency;
                pulse_width = stim_grouped_j.PulseWidth_ms;
                for k = 1:pulse_num
                    x1 = 1000/pulse_frequency*(k-1); %compute the pulse onset in ms
                    x2 = x1+pulse_width;
                    y1 = 0;
                    y2 = max([0 rasterY])+1;
                    ylim([y1 y2])
                    hold on
                    fill([x1 x1 x2 x2]/1000,[y1 y2 y2 y1],'cyan','FaceAlpha',.3)
                end
            end
            xLimit1 = get(gca,"XLim");
            subplot 212
            plot(bins_base,fr_base)
            hold on
            plot(bins_base0,fr_base0)

            xLimit2 = get(gca,"XLim");
            xlim_min = min([xLimit1 xLimit2]);
            xlim_max = max([xLimit1 xLimit2]);
            subplot 211
            xlim([xlim_min xlim_max])
            subplot 212
            xlim([xlim_min xlim_max])
            if saveplot
                cd(plotpath)
                title(num2str(pulse_width))
                f = num2str(saveformat);
                for j = 1:length(f)
                    filename = strcat(datestr(datetime("now"),30));
                    switch j
                        case 1
                            if strcmp(f(end-j+1),'1')
                                extension = '.jpg';
                                %                                             filename = sprintf ('%s_%s.%s',experiment,title,extension);
                                %                                             saveas(figurehandle,fullfile(Path,filename))
                                saveas(gcf,strcat(filename,extension))
                            end
                        case 2
                            if strcmp(f(end-j+1),'1')
                                extension = '.fig';
                                %                                             filename = sprintf ('%s_%s.%s',experiment,title,extension);
                                saveas(gcf,strcat(filename,extension))
                                %                                             saveas(figurehandle,fullfile(Path,filename))
                            end
                        case 3
                            if strcmp(f(end-j+1),'1')
                                extension = '.svg';
                                %                                             filename = sprintf ('%s_%s.%s',experiment,title,extension);
                                saveas(gcf,strcat(filename,extension))
                            end

                    end
                end
                saveas(gcf,strcat(datestr(datetime("now"),30),'.jpg'))
                close all
            end
        end
%     else
%         light_evoked_group(j) = 0;
%     end

    %     else
    %         light_evoked_group(j) = 0;
    %     end



    %     if isplot
    %         figure
    %         plot(bins_base,fr_base)
    %         hold on
    %         plot(bins_base0,fr_base0)
    %     end

end

% light_evoked_grouped = any(light_evoked_group);

light_evoked_grouped = light_evoked_group;