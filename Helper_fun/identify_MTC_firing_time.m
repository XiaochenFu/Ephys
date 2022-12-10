function neurontype = identify_MTC_firing_time(timesteps,APs,varargin)
% get neurontype from the baseline snif coupling. 
% If proportion of 150-250ms after inhalation onset > 50%, assign it to TC. 
% Else, MC
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end
isplot = getOr(option, 'isplot', 0);
saveplot = getOr(option, 'saveplot', 0);
binsize_new = 50/1000;
window_check = [0.15 0.25];
threshold = 0.5;
binsize_old = timesteps(2)-timesteps(1);
num_new_bin = binsize_new/binsize_old;
AP_new = reshape(APs,round(num_new_bin),[]);
AP_new = sum(AP_new);
% timesteps_new = resample(timesteps,1,round(num_new_bin));
timesteps_new = reshape(timesteps,round(num_new_bin),[]);
timesteps_new = mean(timesteps_new);

idx = (timesteps_new'>=window_check(1))&(timesteps_new' <=window_check(2));
AP_new_norm = AP_new./sum(AP_new);
if sum(AP_new_norm(idx))>threshold
    neurontype = 't';
else
    neurontype = 'm';
end
if exist("isplot","var")
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
end
