


function [binArray, binCenters] = phase_normed_timestampsToBinned(timeStamps, referencePoints, binSize_phase, window)
% [binArray, binCenters] = timestampsToBinned(timeStamps, referencePoints, binSize,
% window)
%
% Returns an array of binned spike counts. If you use a large enough
% binSize, it may well be possible that there is more than one spike in a
% bin, i.e. the value of some bin may be >1.



% █ █▀▄▀█ █▀█ █▀█ █▀█ ▀█▀ ▄▀█ █▄░█ ▀█▀
% █ █░▀░█ █▀▀ █▄█ █▀▄ ░█░ █▀█ █░▀█ ░█░
% the window will be an array of sniff durations


% binBorders = window(1):binSize:window(2);
% numBins = length(binBorders)-1;


binSize_ms = binSize_phase/(2*pi)*window(1);
binBorders_seconds = 0:binSize_ms:window(1);
numBins = length(binBorders_seconds)-1;

% if isempty(referencePoints)
%     binArray = [];
%     binCenters = binBorders(1:end-1)+binSize/2; % not sure if this is the same as what you get below?
%     return;
% end
% numBins = 314-1;

binArray = zeros(length(referencePoints), numBins);

% if isempty(timeStamps)
%     binCenters = binBorders(1:end-1)+binSize/2; % not sure if this is the same as what you get below?
%     return;
% end

for r = 1:length(referencePoints)-1
%     binBorders_seconds = 0:binSize_ms:window(r);
    binBorders_seconds = linspace(0,window(r),(numBins+1));
    %         binBorders = linspace(0,window(r),314);
    %     latency = referencePoints(r)-timeStamps;
    %     [n,binCenters] = hist(latency, binBorders_seconds);
    [n,binCenters] = histdiff(timeStamps, referencePoints(r), binBorders_seconds);

    binCenters = binCenters/window(r)*2*pi; % change from second to phase
    binArray(r,:) = n;
end


end
