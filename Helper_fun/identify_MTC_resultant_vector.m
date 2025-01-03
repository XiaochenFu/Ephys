function neurontype = identify_MTC_resultant_vector(resultant_vector,varargin)
% get neurontype from the resultant vector calculated from baseline snif
% coupling. According to Ackels et al., 2020, MTC can be classified into MC
% and TC according to the angle of the resultant vector (in radian).
% 2.75–5.63 radians for TCs
% 0.83–2.66 radians for MCs
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end
isplot = getOr(option, 'isplot', 0);
saveplot = getOr(option, 'saveplot', 0);
TC_range = getOr(option, 'TC_range', [2.75 5.63]);
MC_range = getOr(option, 'MC_range', [0.83 2.66]);
MTCClassifier = getOr(option,'MTCClassifier','nearestBoundClassifierCircular');% minMaxClassifierCircular, centroidClassifierCircular, nearestBoundClassifierCircular


resultant_vector_r = resultant_vector(1);
switch MTCClassifier
    % if isinwindow(resultant_vector_r,TC_range)
    %     neurontype = 't';
    % elseif isinwindow(resultant_vector_r,MC_range)
    %     neurontype = 'm';
    % else
    %     neurontype = 'o';
    % end
    case('nearestBoundClassifierCircular')
        neurontype = nearestBoundClassifierCircular(resultant_vector_r, TC_range, MC_range);
    case('centroidClassifierCircular')
        neurontype = centroidClassifierCircular(resultant_vector_r, TC_range, MC_range);
    case('minMaxClassifierCircular')
        neurontype = minMaxClassifierCircular(resultant_vector_r, TC_range, MC_range);
end
if isplot
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot 121
    bar(timesteps,APs)
    hold on
    bar(timesteps_new,AP_new)
    title(sprintf("APs in %d ms bins",binsize_new*1000))
    xlabel('time from inhal onset (s)')
    ylabel('number of spikes')
    subplot 122
    bar(timesteps_new,AP_new_norm)
    hold on
    xline(window_check(1))
    xline(window_check(2))
    title(sprintf("Noramlized APs, cell type = %s",neurontype))
    ylabel("proportion of APs")
    xlabel('time from inhal onset (s)')
    if saveplot
        saveimg(gcf,"C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\Sample_Plots","Demo","MTC_auto_identify",111);
    end

end
end
function tf = isinwindow(v,window)
w1 = window(1);
w2 = window(2);
if v>w1 && v<w2
    tf = 1;
else
    tf = 0;
end
end

function label = minMaxClassifierCircular(angle, TC_range, MC_range)
angle = mod(angle, 2*pi);  % Normalize to [0, 2*pi)
if (angle >= TC_range(1) && angle <= TC_range(2)) || (angle >= TC_range(1) - 2*pi && angle <= TC_range(2) - 2*pi)
    label = 't';
elseif (angle >= MC_range(1) && angle <= MC_range(2)) || (angle >= MC_range(1) + 2*pi && angle <= MC_range(2) + 2*pi)
    label = 'm';
else
    label = 'o';
end
end

function label = centroidClassifierCircular(angle, TC_range, MC_range)
angle = mod(angle, 2*pi);  % Normalize to [0, 2*pi)
centroidT = mod((TC_range(1) + TC_range(2)) / 2, 2*pi);
centroidM = mod((MC_range(1) + MC_range(2)) / 2, 2*pi);

distanceT = min(abs(angle - centroidT), 2*pi - abs(angle - centroidT));
distanceM = min(abs(angle - centroidM), 2*pi - abs(angle - centroidM));

if distanceT < distanceM
    label = 't';
elseif distanceM < distanceT
    label = 'm';
else
    label = 'o';
end
end

function label = nearestBoundClassifierCircular(angle, TC_range, MC_range)
angle = mod(angle, 2*pi);  % Normalize to [0, 2*pi)
boundsT = [mod(TC_range(1), 2*pi), mod(TC_range(2), 2*pi)];
boundsM = [mod(MC_range(1), 2*pi), mod(MC_range(2), 2*pi)];

nearestBoundT = min(min(abs(boundsT - angle), 2*pi - abs(boundsT - angle)));
nearestBoundM = min(min(abs(boundsM - angle), 2*pi - abs(boundsM - angle)));

if nearestBoundT < nearestBoundM
    label = 't';
elseif nearestBoundM < nearestBoundT
    label = 'm';
else
    label = 'o';
end
end