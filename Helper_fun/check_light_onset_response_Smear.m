function [response, pVals] = check_light_onset_response_Smear(spikes, lightStimuliTimes, controlCycles)
% Notes:
% This function assumes that spikes is an array containing the spike times,
% and lightStimuliTimes contains the onset times of the light stimuli.
% controlCycles are the times of the control cycles without light
% stimulation. The function fitGaussianToDifference is a placeholder.
% Depending on the specifics of your data and the way you want to fit the
% Gaussian, you'd need to implement this. The MATLAB Curve Fitting Toolbox
% would be especially helpful for this. The function uses the mafdr
% function from the Bioinformatics Toolbox for the Benjamini-Hochberg
% adjustment. Ensure that you have the required toolbox.

% Parameters
N_TRIALS = length(lightStimuliTimes);
N_TIME_WINDOWS = 100; % 1, 2, ... 100 ms
ALPHA1= 0.003; % Threshold for p-value
ALPHA2 = 0.05; % Threshold for p-value
CONTROL_SAMPLE_SIZE = length(controlCycles);


response = false;
% fittedGaussian = struct('A', [], 'tau', [], 'sigma', []);

pVals = nan(N_TIME_WINDOWS, 1);
for tw = 1:N_TIME_WINDOWS
    % Spike count for stimulated trials
    stimulatedCounts = countSpikesInWindow(spikes, lightStimuliTimes, tw);

    % Spike count for control cycles
    controlCounts = countSpikesInWindow(spikes, controlCycles, tw);
%     controlCounts = NaN(CONTROL_SAMPLE_SIZE, 1);
%     for i = 1:CONTROL_SAMPLE_SIZE
%         controlCounts(i) = countSpikesInWindow(spikes, controlCycles(i), tw);
%     end
    % get the mean for stimulatedCounts
    stimulated_mean = median( stimulatedCounts  ) ;
    if stimulated_mean
        pVals(tw) = sum(controlCounts>stimulated_mean)/length(controlCounts);
    else
        pVals(tw) = nan;
    end
    %         pVals = zeros(size(stimulatedCounts));
    %     for i = 1:length(stimulatedCounts)
    %         pVals(tw) = sum((stimulatedCounts) >(sum(controlCounts)/ length(controlCounts)))*length(stimulatedCounts);
    %     end

    % Multiply by 2 to account for the two-sidedness of the test


    %     % Check if p-value is below threshold
    %     if pVals(tw) < ALPHA
    %         response = true;
    %         break
    %     end
end
    pVals = 2 * pVals;
% if length(unique(rmmissing(pVals(pVals~=0)))) ==1
%     response = false;
% else
%     if any(pVals < ALPHA1)
%         % Benjamini-Hochberg procedure
%         [adjustedP, ~] = mafdr(pVals);
%         if any(adjustedP < ALPHA2) && any(pVals < ALPHA1)
%             response = true;
%         else
%             response = false;
%         end
%
%     else
%         response = false;
%
%     end
% end


try
    [adjustedP, ~] = mafdr(pVals);
    if any(adjustedP < ALPHA2)
        response = true;
    else
        response = false;
    end
catch
%     disp('Error encountered while running mafdr.');
    if any(pVals < ALPHA1)
        response = true;
    else
        response = false;
    end
end




% If there's a response, fit the Gaussian to the difference
% if response
%     %         difference = histcounts(spikes(lightStimuliTimes)) - histcounts(spikes(controlCycles));
%     binEdges = [min([lightStimuliTimes'; controlCycles]), max([lightStimuliTimes'; controlCycles])];
%     stimulatedHist = histcounts(spikes, binEdges);
%     controlHist = histcounts(spikes, binEdges);
%     difference = stimulatedHist - controlHist;
%
%     fittedGaussian = fitGaussianToDifference(difference);
% end


end

function count = countSpikesInWindow(spikes, onsets, window)
count = zeros(length(onsets), 1); % Initialize the count array

for i = 1:length(onsets)
    onsetTime = onsets(i);

    % Ensure spikes are within a valid range
    validSpikes = spikes(spikes >= 0 & spikes <= max(onsets) + window/1000);

    % Count spikes within the current window
    spikesInRange = validSpikes(validSpikes >= onsetTime & validSpikes < (onsetTime + window/1000));

    count(i) = numel(spikesInRange);
end
end


