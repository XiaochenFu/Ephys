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

% number of channels in the experiment
num_chan = 4;


%% read the raw data from the binary file

% Open the file for reading
fileID = fopen(Intan_output_bin_file, 'r');
% Read the data from the file
tetrode_int16 = fread(fileID, 'int16');
% Close the file
fclose(fileID);
% Convert the data back to double (for filtering)
tetrode = double(tetrode_int16);
tetrode = reshape(tetrode, num_chan,[]);