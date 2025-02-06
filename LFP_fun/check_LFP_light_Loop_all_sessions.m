% Find all sessions with evoked LFP
cc
addpath('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\Helper_fun')
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions')
addpath('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\LFP_fun     ')
resultpath = 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Result\LFP\zscores';
%%
Mouse_List = {%'CCK129',...
    %     'Tbx203',...
    %     'LBHD147',...
    %     'Tbx196',...
    %     'Tbx211',...
    %     'Tbx215',...
    %     'Tbx218',...
    %     'Tbx284',...
    %     'TbxAi32_51_WT'};
    'Tbx327'};
% for each mouse, read the excel file from the excel. Then, for each light
% session, go to the intan folder, read the original data, read the stimuli
% info, then check if the LFP is evoked.
num_mouse = length(Mouse_List);
ephys_path = 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys';
num_evoked_stim_depth_pair = 1;
Light_Evoked_LFP = {};
for n_mouse = 1:num_mouse
    Mouse_ID = Mouse_List{n_mouse};
    mouse_path = fullfile(ephys_path,Mouse_ID);
    cd(mouse_path)

    %     run('Tbx_211_Path.m')
    %     mouse_path = 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Tbx211';
    % find the excel sheet in the folder
    d_sheet = dir('*.xlsx');
    [~,I] = sort([d_sheet(:).datenum],"descend");
    excel_filename = extractfield(d_sheet(I(1)),'name');
    Recording_info = readtable(excel_filename{1},'VariableNamingRule','preserve');
    num_session = height(Recording_info);
    for i  = 1:num_session
        Stimuli_Type = string(Recording_info.("Stimuli")(i));
        if ~contains(Stimuli_Type,"odour","IgnoreCase",true)
            Intan_Session_name= string(Recording_info.("Intan")(i));
            Spike2_file_name = string(Recording_info.("Spike2")(i));
            Intan_folder_path = fullfile(mouse_path,'Intan_Data_binary');
            Recording_Depth = floor(Recording_info.("Depth")(i));
            Intan_clip_type = 'All';
            %% load the raw recording
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

            % Intan_Session_name = 'Xiaochen_Preliminary__220603_163651';
            % Intan_Session_name = 'Xiaochen_Preliminary__220603_162820';
            %     Intan_Session_name = 'Xiaochen_Preliminary__220603_160445';

            %%
            cd 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\LFP_fun'

            fslow = 100;
            fshigh = 4;
            fs = 20000;
            channel = tetrode(16,:)* 0.195; % convert to microvolt
            [b1, a1] = butter(3, [fshigh/fs,fslow/fs]*2, 'bandpass'); % butterworth filter with only 3 nodes (otherwise it's unstable for float32)
            channel_filtered = filtfilt(b1,a1,channel);
            data = channel_filtered;
            tetrode_time = t;
            SNF_OST = sniff_onset_spike2_aligned;
            %     clc
            %     close all
            for j =1:length(stim_grouped)

                stim_grouped_j = stim_grouped(j);
                option = [];
                option.isplot = 0;
                option.plotevoked = 0;
                [light_evoked, zscored_data, aligned_data, aligned_baseline] = check_LFP_light_response_zscore(data,tetrode_time,stim_grouped_j,SNF_OST,option);
                %                 [zscored_data, ~, ~] = align_LFP(data,tetrode_time,stim_grouped_j,SNF_OST,option);
                zscore_minmax = max(zscored_data{1})-min(zscored_data{1});
                %                 figure(999)
                %                 plot(j,zscore_minmax,'rx'); hold on
                %     figure(666)
                zscore_max = max(zscored_data{1});
                %                 plot(j,zscore_max,'gx'); hold on
                %     figure(7)
                zscore_min = min(zscored_data{1});
                %                 plot(j,zscore_min,'bx'); hold on
                DrivingCurrent = stim_grouped_j.DrivingCurrent;
                Frequency = stim_grouped_j.Frequency;
                PulseWidth_ms = stim_grouped_j.PulseWidth_ms;
                PulseNumber = stim_grouped_j.PulseNumber;
                stim_grouped_j_summary = sprintf('%dmA%dHz%dmsx%d',DrivingCurrent,Frequency,PulseWidth_ms,PulseNumber);
                %                 if light_evoked
                %                     title(Intan_Session_name)
                %
                %                     saveimg(gcf,resultpath,Intan_Session_name,stim_grouped_j_summary,1)
                %
                %                     Light_Evoked_LFP{num_evoked_stim_depth_pair}.Intan_Session_name = Intan_Session_name;
                %                     Light_Evoked_LFP{num_evoked_stim_depth_pair}.Recording_Depth = Recording_Depth;
                %                     Light_Evoked_LFP{num_evoked_stim_depth_pair}.stim_grouped_j_summary = stim_grouped_j_summary;
                %                     num_evoked_stim_depth_pair = num_evoked_stim_depth_pair+1;
                %                     close
                %                 end
                save(fullfile(resultpath,sprintf('%s%s.mat',Intan_Session_name,stim_grouped_j_summary)),'DrivingCurrent','Frequency','PulseWidth_ms',"PulseNumber","Intan_Session_name",'light_evoked','zscored_data',"aligned_data",'aligned_baseline','Mouse_ID')

            end

            %     p1 = plot(NaN, "DisplayName", "max-min", "Color", 'r')
            %     p2 = plot(NaN, "DisplayName", "max", "Color", 'g')
            %     p3 = plot(NaN, "DisplayName", "min", "Color", 'b')
            %     legend([p1 p2 p3 ],'Location', 'Best','NumColumns',3);
            %     title('parameters to characterize evoked LFP')
            %     saveimg(999,'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Test_Figure','LFP_threshold',Intan_Session_name,1)
        end
    end




end