function light_evoked_grouped = check_light_response(spiketime,stim_grouped,sniff_onset, varargin)
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end
for j = 1:length(stim_grouped)
    stim_grouped_j = stim_grouped(j);
    eventtime = stim_grouped_j.TrailOnset;
    trial_latency = stim_grouped_j.LatencyFromCalculatedSniffOnset_ms;
    calcWindow = getOr(option, 'calcWindow', [0, 0.1]);
    binSize = getOr(option, 'binSize', 0.01*(calcWindow(2)-calcWindow(1)));
    isplot = getOr(option, 'isplot', 0);
    plotevoked = getOr(option, 'plotevoked', 0);
    saveplot = getOr(option, 'saveplot', 0);
    %% when light present
    [psth_base, bins_base, ~, ~, ~, ~] = psthAndBA(spiketime, eventtime, calcWindow, binSize);
    psth_base = psth_base*binSize;
    fr_base = psth_base/binSize;

    % plot(bins_base,fr_base)
    %% before light
    eventtime0 = nan(size(eventtime));
    % as comperation, get the psth usinglast sniff. same onset latency
    for i = 1:length(eventtime)
        % find the last sniff, so two onsets before
        sniff_onset1 = sniff_onset(sniff_onset<eventtime(i));
        sniff_onset2 = sniff_onset1(end-1);
        eventtime0(i) = sniff_onset2+ trial_latency(i)/1000;
    end
    [psth_base0, bins_base0, rasterX_SP, rasterY_SP, spikeCounts_SP, ba_SP] = psthAndBA(spiketime, eventtime0, calcWindow, binSize);
    psth_base0 = psth_base0*binSize;
    fr_base0 = psth_base0/binSize;

    if ~isnan(ttest(fr_base,fr_base0))
        if(ttest(fr_base,fr_base0)) ==1 % light response different from the baseline
            if sum(fr_base)>sum(fr_base0) % if firing rate increased
                light_evoked_group(j) = 1;
                if plotevoked
                    %% raster plot
                    figure
                    subplot 211
                    % lick raster for all trials
                    [binnedArray, bins] = timestampsToBinned(spiketime, eventtime, binSize, calcWindow);
                    % lick raster for only s plus trials
                    [tr,b] = find(binnedArray);
                    [rasterX,yy] = rasterize(bins(b));
                    rasterY = yy+reshape([zeros(size(tr'));tr';zeros(size(tr'))],1,length(tr)*3); % note from XFu. The original code duplicate the dots to make the ticks longer, which I believe is cheating.
                    rasterX(rasterY==0) = [];rasterY(rasterY==0) = [];% remove zeros
                    plot(rasterX, rasterY,'.')
                    hold on
                    % plot the light stimuli
                    pulse_num = stim_grouped_j.PulseNumber;
                    pulse_frequency = stim_grouped_j.Frequency;
                    pulse_width = stim_grouped_j.PulseWidth_ms;
                    for k = 1:pulse_num
                        x1 = 1000/pulse_frequency*(k-1); %compute the pulse onset in ms
                        x2 = x1+pulse_width;
                        y1 = 0;
                        y2 = max(rasterY)+1;
                        ylim([y1 y2])
                        hold on
                        fill([x1 x1 x2 x2]/1000,[y1 y2 y2 y1],'cyan','FaceAlpha',.3)
                    end
                    subplot 212
                    plot(bins_base,fr_base)
                    hold on
                    plot(bins_base0,fr_base0)
                    if saveplot
                        cd('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Test_Figure')
                        saveas(gcf,strcat(datestr(datetime("now"),30),'.jpg'))
                        close
                    end
                end
            else
                light_evoked_group(j) = 0;
            end

        else
            light_evoked_group(j) = 0;
        end
    else
        light_evoked_group(j) = 0;
    end
    if isplot
        figure
        plot(bins_base,fr_base)
        hold on
        plot(bins_base0,fr_base0)
    end

end

% light_evoked_grouped = any(light_evoked_group);

light_evoked_grouped = light_evoked_group;
