function odour_evoked_grouped = check_odour_response(spiketime,stim_grouped, varargin)
% FV opened for 1.5s
% Calculate the mean firing rate of each unit with (defalut 500 ms) bins
% For 1.5s before FV opening and during the 1.5s of the FV opening,
% Paired ttest (Matlab ttest)

if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end
for j = 1:length(stim_grouped)
    eventtime = stim_grouped(j).TrailOnset;

    %     calcWindow = getOr(option, 'calcWindow', [0, 0.1]);
    calcWindow_FVon = getOr(option, 'calcWindow', [0, 1.5]);
    calcWindow_beforeFV = getOr(option, 'calcWindow', [-1.5 0]);
    binSize = getOr(option, 'binSize', 0.5);
    isplot = getOr(option, 'isplot', 0);
    saveplot = getOr(option, 'saveplot', 0);
    % get the spikes during the FV opening
    [psth_base, bins_base, ~, ~, ~, ~] = psthAndBA(spiketime, eventtime, calcWindow_FVon, binSize);
    psth_base = psth_base*binSize;
    fr_base = psth_base/binSize;
    % as comperation, get the psth usinglast sniff. same onset latency

    eventtime0 = nan(size(eventtime));
    [psth_base0, bins_base0, rasterX_SP, rasterY_SP, spikeCounts_SP, ba_SP] = psthAndBA(spiketime, eventtime, calcWindow_beforeFV, binSize);
    psth_base0 = psth_base0*binSize;
    fr_base0 = psth_base0/binSize;

    if ~isnan(ttest(fr_base,fr_base0))
        if(ttest(fr_base,fr_base0)) ==1
            if mean(fr_base0)<mean(fr_base) %excitatory response
                odour_evoked_group(j) = 1;
            else
                odour_evoked_group(j) = -1; % inhibitatory response
            end
        else
            odour_evoked_group(j) = 0;
        end
    else
        odour_evoked_group(j) = 0;
    end
    if isplot
        figure
        plot(bins_base,fr_base)
        hold on
        plot(bins_base0,fr_base0)
        switch odour_evoked_group(j)
            case 1
                tt = "excitatory";
            case 0
                tt = "no";
            case -1
                tt = "inhibitory";
        end
        title(tt)

    end
end

odour_evoked_grouped = odour_evoked_group;

