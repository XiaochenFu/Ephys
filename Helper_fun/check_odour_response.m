function odour_evoked_grouped = check_odour_response(spiketime, stim_grouped, varargin)
    % The function performs paired t-test (using MATLAB's ttest) to calculate
    % the mean firing rate of each unit with default bin of 500 ms.
    % It works for 1.5s before and during the opening of the field valve (FV).

    % Check if there are additional parameters passed by user
    if ~isempty(varargin)
        option = varargin{1}; 
    else
        option = [];
    end
    
    % Loop over length of grouped stimulus
    for j = 1:length(stim_grouped)
        eventtime = stim_grouped(j).TrailOnset;

        % Retrieve or set default parameters
        calcWindow_FVon = getOr(option, 'calcWindow', [0, 1.5]);
        calcWindow_beforeFV = getOr(option, 'calcWindow', [-1.5 0]);
        binSize = getOr(option, 'binSize', 0.5);
        isplot = getOr(option, 'isplot', 0);
        saveplot = getOr(option, 'saveplot', 0);
        
        % Calculate firing rate during FV opening
        [psth_base, bins_base] = psthAndBA(spiketime, eventtime, calcWindow_FVon, binSize);
        psth_base = psth_base*binSize;
        fr_base = psth_base/binSize;
        
        % Calculate firing rate before FV opening for comparison
        [psth_base0, bins_base0] = psthAndBA(spiketime, eventtime, calcWindow_beforeFV, binSize);
        psth_base0 = psth_base0*binSize;
        fr_base0 = psth_base0/binSize;

        % Perform t-test and classify responses as excitatory, inhibitory or no response
        if ~isnan(ttest(fr_base, fr_base0))
            if ttest(fr_base, fr_base0) == 1
                if mean(fr_base0) < mean(fr_base) % Excitatory response
                    odour_evoked_group(j) = 1;
                else % Inhibitory response
                    odour_evoked_group(j) = -1;
                end
            else
                odour_evoked_group(j) = 0; % No response
            end
        else
            odour_evoked_group(j) = 0; % No response due to nan values
        end
        
        % Optional plot of the results
        if isplot
            figure
            plot(bins_base, fr_base)
            hold on
            plot(bins_base0, fr_base0)
            % Get current limits
            yLimits = ylim;

            % Set minimum limit to 0, keep maximum limit same
            ylim([0, yLimits(2)]);
            switch odour_evoked_group(j)
                case 1
                    title("Excitatory Response");
                case 0
                    title("No Response");
                case -1
                    title("Inhibitory Response");
            end
        end
    end
    
    odour_evoked_grouped = odour_evoked_group;
end
