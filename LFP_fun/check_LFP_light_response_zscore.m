% check if the LFP is evoked by light 
% if the zscore is higher than a therehold, it's evoked. 
function [light_evoked, zscored_data, aligned_data, aligned_baseline] = check_LFP_light_response_zscore(data,tetrode_time,stim_grouped_j,SNF_OST,varargin)
% based on
% check_light_response_ttest(spiketime,stim_grouped,sniffonsets,option)
% and 
% but the comperation part will be in other file

if length(varargin)>1
    error("check")
end
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end

eventtime = stim_grouped_j.TrailOnset;
trial_latency = stim_grouped_j.LatencyFromCalculatedSniffOnset_ms;
% calculate window will be automatically decided based on the last
% pulse.since the latency might change with the light intensity etc.,
% but less than 20ms, I'll use 20 ms after the last pulse
calcWindow = getOr(option, 'calcWindow', []);
if isempty(calcWindow)
    calcWindow_latency = getOr(option, 'calcWindow_latency', 0.020);
    pulse_num = stim_grouped_j.PulseNumber;
    pulse_frequency = stim_grouped_j.Frequency;
    pulse_width = stim_grouped_j.PulseWidth_ms;
    k = pulse_num;
    x1 = 1000/pulse_frequency*(k-1); %compute the pulse onset in ms
    x2 = x1+pulse_width;
    calcWindow = [0, x2/1000+calcWindow_latency];
else

end

binSize = getOr(option, 'binSize', 0.01*(calcWindow(2)-calcWindow(1)));
isplot = getOr(option, 'isplot', 0);
plotevoked = getOr(option, 'plotevoked', 0);
saveplot = getOr(option, 'saveplot', 0);
zscore_threshold = getOr(option,'zscore_threshold',2);
%% Filtered, when light present
[x5_all,~] = segment_with_onset_time(data', tetrode_time,  eventtime, calcWindow);
x5 = mean(x5_all,2);
x5_std = std(x5_all,0,2);



%% before light
eventtime0 = nan(size(eventtime));
% as comperation, get the psth using last sniff. same onset latency
for i = 1:length(eventtime)
    % find the last sniff, so two onsets before
    sniff_onset1 = SNF_OST(SNF_OST<eventtime(i));
    sniff_onset2 = sniff_onset1(end-1);
    eventtime0(i) = sniff_onset2+ trial_latency(i)/1000;
end
[x6_all,~] = segment_with_onset_time(data', tetrode_time,  eventtime0, calcWindow);
x6 = mean(x6_all,2);
x6_std = std(x6_all,0,2);
% itv = tetrode_time(2)-tetrode_time(1);
% plot_t = ((1:length(x6))-1)*itv+calcWindow(1);

%%
aligned_data{1} = x5;
aligned_data{2} = x5_std;
aligned_baseline{1} = x6;
aligned_baseline{2} = x6_std;
zscored_data{1} = (x5-x6)./x6_std;
zscored_data{2} = (x5_std)./x6_std;
if (max(zscored_data{1})-min(zscored_data{1}))>zscore_threshold
    light_evoked = 1;
else 
    light_evoked = 0;
end
%%
if isplot || (plotevoked&&light_evoked)
    figure
    subplot 311
    itv = tetrode_time(2)-tetrode_time(1);
    plot_t = ((1:length(x5))-1)*itv+calcWindow(1);
    plot_mean_std(plot_t, x5, x5_std,'k');
    ylabel({"Evoked";"(µV)"})
    xlabel('Time from onset(s)')
    yLimit3 = get(gca,'YLim');hold on
    subplot 312
    plot_mean_std(plot_t, x6, x6_std,'k');
    ylabel({"Baseline";"(µV)"})
    xlabel('Time from onset(s)')
    yLimit3 = get(gca,'YLim');hold on
    subplot 313
    plot_mean_std(plot_t, (x5-x6)./x6_std, (x5_std-x6)./x6_std,'k');
    ylabel({"Zscored LFP";"(µV)"})
    xlabel('Time from onset(s)')
    yLimit3 = get(gca,'YLim');hold on
    if saveplot
        xlabel('Driving Current (mA)')
        saveimg(gcf,'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Test_Figure\LFP_test','LFPtest','eachStim','111')
    end
end


% %% sanity check, passed
% if isplot
%     figure
%     plot_mean_std(plot_t, (x6-x6)./x6_std, (x6_std-x6)./x6_std,'k');
% end
%%
% end

% light_evoked_grouped = any(light_evoked_group);

% light_evoked_grouped = light_evoked_group;
%% 
