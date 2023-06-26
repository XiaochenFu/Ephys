cc
addpath('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\Unit_Def')
addpath('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\Helper_fun')
addpath(genpath("C:\Users\yycxx\OneDrive - OIST\Ephys_Code\spikes-master"))
preprocess_path = "C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Tbx284\Before_loading_spikesorting";

load('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Tbx284\Good_Units\Tbx_284_Tract1_Depth999_IntensityTrigger_unit16.mat')
% load the stimuli info
Intan_Session_name = light_unit_processing.Intan_File;
load(fullfile("C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Tbx284\Intan_Data_binary\",Intan_Session_name,"All","Stimuli_Info.mat"))
stim_grouped = sort_light_stimuli(Stimuli_Info);
matfile_name = strcat(Intan_Session_name,'.mat');
load(fullfile(preprocess_path,matfile_name))
option = [];
option.update = 1;
option.plotevoked = 1;

% option.isplot = 1; % plot all 
% plot light evoked

spiketime = light_unit_processing.st;
sniff_spon = light_unit_processing.Spontaneous_SniffOnset;
stim_group = stim_grouped(1);
LatencyFromCalculatedSniffOnset_ms = stim_group.LatencyFromCalculatedSniffOnset_ms;
sniff_onset_spike2_aligned;
% check_light_response
light_evoked = check_light_response_zscore(spiketime,stim_group,sniff_onset_spike2_aligned,option);
light_evoked = check_light_response_zscore(spiketime,stim_grouped,sniff_onset_spike2_aligned,option)