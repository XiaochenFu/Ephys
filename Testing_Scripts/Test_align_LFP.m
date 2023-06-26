cc
cd('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Tbx211')
run('Tbx_211_Path.m')
mouse_path = 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Tbx211';
Intan_folder_path = fullfile(mouse_path,'Intan_Data_binary');
% Intan_Session_name = 'Xiaochen_Preliminary__220603_163651';
Intan_Session_name = 'Xiaochen_Preliminary__220603_162820';
% Intan_Session_name = 'Xiaochen_Preliminary__220603_160445';
Intan_clip_type = 'All';

%% load the stmiuli file and the raw recording
myKsDir0 = Intan_folder_path;
myKsDir = fullfile(myKsDir0,Intan_Session_name,Intan_clip_type);
cd(myKsDir)
matfile_name = strcat(Intan_Session_name,'.mat');
load(matfile_name)
%% load the stimuli file
load('Stimuli_Info.mat')
stim_grouped = sort_light_stimuli(Stimuli_Info);

%% load the corresponding sniff onsets
preprocess_path = fullfile(mouse_path,'Before_loading_spikesorting');
matfile_name = strcat(Intan_Session_name,'.mat');
load(fullfile(preprocess_path,matfile_name),'sniff_onset_spike2_aligned')
%%
cd 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\LFP_fun'
option = [];
option.isplot = 1;
fslow = 100;
fshigh = 4;
fs = 20000;
channel = tetrode(1,:)* 0.195; % convert to microvolt
[b1, a1] = butter(3, [fshigh/fs,fslow/fs]*2, 'bandpass'); % butterworth filter with only 3 nodes (otherwise it's unstable for float32)
channel_filtered = filtfilt(b1,a1,channel);
data = channel_filtered;
tetrode_time = t;
SNF_OST = sniff_onset_spike2_aligned;
clc
for j = 1:length(stim_grouped)

    stim_grouped_j = stim_grouped(j);
    [zscored_data, ~, ~] = align_LFP(data,tetrode_time,stim_grouped_j,SNF_OST,option);
    k = max(zscored_data{1})-min(zscored_data{1})
    figure(999)
    plot(j,k,'rx'); hold on 
%     figure(666)
    l = max(zscored_data{1})
    plot(j,l,'gx'); hold on 
%     figure(7)
    m = min(zscored_data{1})
    plot(j,m,'bx'); hold on 

end

p1 = plot(NaN, "DisplayName", "max-min", "Color", 'r')
p2 = plot(NaN, "DisplayName", "max", "Color", 'g')
p3 = plot(NaN, "DisplayName", "min", "Color", 'b')
legend([p1 p2 p3 ],'Location', 'Best','NumColumns',3);
title('parameters to characterize evoked LFP')
ylabel({'Response from',' Zscored data'})
xticks([1 2 3 4 5 ])
xticklabels({'167', '333', '500', '667', '833'})
xlabel('Driving Current(mA)')
saveimg(999,'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Test_Figure','LFP_threshold',Intan_Session_name,111)
%%
figure(5)
subplot 311
set(gca,'xticklabel',{[]})
xlabel([])
subplot 312
set(gca,'xticklabel',{[]})
xlabel([])
saveimg(5,'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Test_Figure','LFP_threshold','sample_zscore',111)