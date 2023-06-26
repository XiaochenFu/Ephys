cc
addpath('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\Unit_Def')
addpath('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\Helper_fun')
addpath(genpath("C:\Users\yycxx\OneDrive - OIST\Ephys_Code\spikes-master"))
preprocess_path = "C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Tbx327\Before_loading_spikesorting";

load('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Tbx327\Good_Units\Tbx_327_Tract1_Depth1393_Intensity_unit30.mat')
% load the stimuli info
Intan_Session_name = light_unit_processing.Intan_File;
load(fullfile("C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Tbx327\Intan_Data_binary\",Intan_Session_name,"All","Stimuli_Info.mat"))
stim_grouped = sort_light_stimuli(Stimuli_Info);
matfile_name = strcat(Intan_Session_name,'.mat');
% load(fullfile(preprocess_path,matfile_name))
cd(preprocess_path)
load '25Jan2023__230125_150519.mat' -regexp ^(?!tetrode$).
option = [];
option.update = 1;
option.plotevoked = 1

% option.isplot = 1; % plot all 
% plot light evoked

spiketime = light_unit_processing.st;
sniff_spon = light_unit_processing.Spontaneous_SniffOnset;
stim_group = stim_grouped(1);
LatencyFromCalculatedSniffOnset_ms = stim_group.LatencyFromCalculatedSniffOnset_ms;
sniff_onset_spike2_aligned;
% check_light_response
light_evoked = check_light_response_ttest(spiketime,stim_grouped(4),sniff_onset_spike2_aligned,option)
% close all
%%
% if the ttest indicate that there might be some difference, for each light
% pulse, find the evoked spike 
% light_evoked_spikes(spiketime,stim_grouped,sniff_onset, varargin)
stim_grouped_j = stim_grouped(4);
clc
option.isplot = 1;
[evoked_spk,spk_latency_ms,jitter_ms,prob_spk] = light_evoked_spikes(spiketime,stim_grouped_j,option);
% 
saveimg(1,'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\Sample_Plots','25Jan2023__230125_150519','Demo_psth','111')
saveimg(1,'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\Sample_Plots','25Jan2023__230125_150519','Demo_Liht_evoked_spike','111')

% close all
%%