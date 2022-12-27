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

resultant_vector_r = resultant_vector(1);

if isinwindow(resultant_vector_r,TC_range)
    neurontype = 't';
elseif isinwindow(resultant_vector_r,MC_range)
    neurontype = 'm';
else
    neurontype = 'o';
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