function stim_latency_grouped = sort_light_stimuli_guess_latency_group(stim_grouped)
% This function groups stimuli based on the LatencyFromSniffTrigger_ms value
% Input: stim_grouped (output from sort_light_stimuli)
% Output: stim_latency_grouped (grouped based on LatencyFromSniffTrigger_ms)

min_num_trial = 3;

% Initialize the output
stim_latency_grouped = [];


% Get the unique LatencyFromSniffTrigger_ms values from all groups
if isfield(stim_grouped, 'LatencyFromSniffTrigger_ms')
    all_latencies = extractfield(stim_grouped,'LatencyFromSniffTrigger_ms');
    all_latencies = round(all_latencies/20)*20;
    %     [unique_latencies, ~, ic1] = unique(all_latencies);$$
    % Tabulate the array to get the frequency of each unique value
    tbl = tabulate(all_latencies);
    % Filter values that occur at least min_num_trial times
    unique_latencies = tbl(tbl(:,2) >= min_num_trial, 1);

    LatencyFromCalculatedSniffOnset_ms = extractfield(stim_grouped,'LatencyFromCalculatedSniffOnset_ms');
    PhaseFromSniffTrigger = extractfield(stim_grouped,'PhaseFromSniffTrigger');
    PhaseFromCalculatedSniffOnset = extractfield(stim_grouped,'PhaseFromCalculatedSniffOnset');
    TrialOnset = extractfield(stim_grouped,'TrialOnset');
    DrivingCurrent = extractfield(stim_grouped,"DrivingCurrent");
    Frequency = extractfield(stim_grouped,"Frequency");
    PulseWidth_ms = extractfield(stim_grouped,"PulseWidth_ms");
    PulseNumber = extractfield(stim_grouped,"PulseNumber");

    % Iterate over each unique latency and group the stimuli
    for i = 1:length(unique_latencies)
        latency_value = unique_latencies(i);
        %         matching_groups = stim_grouped(arrayfun(@(x) x.LatencyFromSniffTrigger_ms(1) == latency_value, stim_grouped));
        matching_groups = (all_latencies==latency_value);
        % Store the grouped stimuli by latency
        stim_latency_grouped(i).DrivingCurrent = DrivingCurrent;
        stim_latency_grouped(i).Frequency = Frequency;
        stim_latency_grouped(i).PulseWidth_ms = PulseWidth_ms;
        stim_latency_grouped(i).PulseNumber = PulseNumber;
        stim_latency_grouped(i).TrialOnset = TrialOnset(matching_groups);

        stim_latency_grouped(i).LatencyFromSniffTrigger_ms = latency_value;
        stim_latency_grouped(i).LatencyFromCalculatedSniffOnset_ms = LatencyFromCalculatedSniffOnset_ms(matching_groups);
        stim_latency_grouped(i).PhaseFromSniffTrigger = PhaseFromSniffTrigger(matching_groups);
        stim_latency_grouped(i).PhaseFromCalculatedSniffOnset = PhaseFromCalculatedSniffOnset(matching_groups);
    end
else
    error('LatencyFromSniffTrigger_ms field is missing in stim_grouped.');
end
end
