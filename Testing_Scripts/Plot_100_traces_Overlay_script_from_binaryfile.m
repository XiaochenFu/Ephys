%% Plot the waveform of a sorted unit
% Overlay 100 traces
clear all
close all
clc
%% ================================= Change this part ===============================
% add library for reading the files=======================> no need if the unit spike time eventTimes is known
addpath(genpath('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Library\spikes-master'))
addpath(genpath('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Library\npy-matlab-master\npy-matlab'))

% path to the kilosort result and the binary file
myKsDir = 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Tbx284\Intan_Data_binary\Xiaochen_Preliminary__221029_174916\All';

% name of the binary file, might be continous.dat for neuropixel recordings
bin_filename = 'Xiaochen_Preliminary__221029_174916.bin';
Intan_output_bin_file = fullfile(myKsDir,bin_filename);

% just an experiment name for saving result
Intan_Session_name = 'Xiaochen_Preliminary__221029_174916';

% sampling rate, 30000? for neuropixel
fs = 20000;

% number of channels in the experiment
num_chan = 4;

% where you want to save the figure
figurepath = '';

% extract the timestamps =======================> no need if the unit spike time eventTimes is known
cd(myKsDir)
clusterGroup = tdfread('cluster_group.tsv','\t');
%         clusterNeurontype = tdfread('cluster_neurontype.tsv','\t');
sp = loadKSdir(myKsDir);
unit_number = length(unique(sp.clu));
target_clu_id = 8; %just choose a good unit
for j = 1:unit_number
    j_cid = clusterGroup.cluster_id(j);
    if j_cid==target_clu_id
        st = sp.st;
        j_st = st(sp.clu ==  (j_cid));
        light_unit_processing.cid = j_cid;
        eventTimes1 = j_st;
        % randomly poll 100 traces so it will not take forever to plot
        if length(eventTimes1)>100
            eventTimes_index = randperm(length(eventTimes1),100);
            eventTimes = eventTimes1(eventTimes_index);
        else
            eventTimes = eventTimes1;
        end
    end
end

%% read the raw data from the binary file

% Open the file for reading
fileID = fopen(Intan_output_bin_file, 'r');
% Read the data from the file
% tetrode_int16 = fread(fileID, 'int16');
%



 tetrode_int16 = fread(fileID,[4,40*fs] , 'int16');
 eventTimes = eventTimes(eventTimes<40);





 

% Close the file
fclose(fileID);
% Convert the data back to double (for filtering)
tetrode = double(tetrode_int16);
% tetrode = reshape(tetrode, num_chan,[]);



%% filter the data and plot

fslow = 3000;
fshigh = 300;
window_plot = [-0.001 0.002];
t = (1:length(tetrode))/fs;
for Channel_num = 1:num_chan

    channel = tetrode(Channel_num,:);
    [b1, a1] = butter(3, [fshigh/fs,fslow/fs]*2, 'bandpass'); % butterworth filter with only 3 nodes (otherwise it's unstable for float32)
    channel_filtered = filtfilt(b1,a1,channel);
    fff = figure(233);
    subplot(1,num_chan, Channel_num)
    %     fff.WindowState = 'maximized';
    %     set(fff, 'Visible', 'off');
    [x1_all,~] = segment_with_onset_time(channel_filtered', t,  eventTimes, window_plot);
    x1 = mean(x1_all,2);
    x1_std = std(x1_all,0,2);
    itv = 1/fs;
    tshow = 1000*(((1:length(x1))-1)*itv+window_plot(1));% convert to ms
    %             plot_mean_std(tshow, x1, x1_std, c_Black);
    plot(x1_all, 'k');
    %             ylabel("Avg Voltage(mV)")
    %             xlabel('Time from peak(ms)')
    box off
    axis off
    %             axis equal
    %             title(['unit ',num2str(j_cid)])
    eval(sprintf('yLimit%d = get(gca,"YLim")',Channel_num))
    hold on
end
ylim_min = min([yLimit1 yLimit2 yLimit3 yLimit4]);
ylim_max = max([yLimit1 yLimit2 yLimit3 yLimit4]);
for Channel_num = 1:num_chan
    fff = figure(233);
    subplot(1,num_chan, Channel_num)
    ylim([ylim_min ylim_max])
end
%%         plot a scale bar. This is for Intan data. I'm not sure about the scale for neuropixel recording. 
% for tetrode data,  tetrode * 0.195; % convert to microvolts
x_scale_position = 30;
y_scale_position  = -2500;
x_plot_scale = 0.001;% 1 ms
y_plot_scale = 150;% 150mV
%         figure
plot(x_scale_position+[0 x_plot_scale/itv],[y_scale_position y_scale_position],'k')

hold on
plot([x_scale_position x_scale_position],y_scale_position+[0 y_plot_scale/0.195],'k')
%%
% saveimg(gcf,figurepath,sprintf('%s_%d',Intan_Session_name,j_cid),'100traces_overlay',111)
% close



%% plot the unfiltered trace and the spike time


channel_ID_matlab = 2+1;
data_plot = tetrode(channel_ID_matlab,:);
[b1, a1] = butter(3, [fshigh/fs,fslow/fs]*2, 'bandpass'); % butterworth filter with only 3 nodes (otherwise it's unstable for float32)
channel_filtered = filtfilt(b1,a1,data_plot);
figure
plot(channel_filtered)
ymin = min(channel_filtered);
hold on
plot(eventTimes*fs,ymin*ones(size(eventTimes)),'r*')
zoom('xon')