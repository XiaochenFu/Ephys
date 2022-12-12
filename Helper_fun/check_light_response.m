function light_evoked_grouped = check_light_response(spiketime,stim_grouped,sniff_onset, varargin)
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end
for j = 1:length(stim_grouped)
    eventtime = stim_grouped(j).TrailOnset;
    trial_latency = stim_grouped(j).LatencyFromCalculatedSniffOnset_ms; 
    calcWindow = getOr(option, 'calcWindow', [0, 0.1]);
    binSize = getOr(option, 'binSize', 0.01*(calcWindow(2)-calcWindow(1)));
    isplot = getOr(option, 'isplot', 0);
    saveplot = getOr(option, 'saveplot', 0);

    [psth_base, bins_base, ~, ~, ~, ~] = psthAndBA(spiketime, eventtime, calcWindow, binSize);
    psth_base = psth_base*binSize;
    fr_base = psth_base/binSize;
    % plot(bins_base,fr_base)
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
        if(ttest(fr_base,fr_base0)) ==1
            light_evoked_group(j) = 1;
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
