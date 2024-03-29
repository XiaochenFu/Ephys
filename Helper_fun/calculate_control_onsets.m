function control_onsets = calculate_control_onsets(controlCycles, LatencyFromCalculatedSniffOnset_ms)
% find control with same latency

% Reshape controlCycles to a column vector (just in case it's not)
controlCycles = controlCycles(:);

% Use broadcasting to add each element of controlCycles to every element of LatencyFromCalculatedSniffOnset_ms
control_onsets = bsxfun(@plus, controlCycles, LatencyFromCalculatedSniffOnset_ms/1000);
control_onsets = control_onsets(:);
n = length(control_onsets);

% Ensure there are at least 100 elements in A
if n < 100
    error('Array has fewer than 100 elements.');
end

% Generate 100 unique random indices
rng(233)
randomIndices = randperm(n, 100);

% Extract the random elements
control_onsets = control_onsets(randomIndices);
end
