%% Plot the waveform of sorted unit
% Overlay 100 traces
cc
cd('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Tbx284')
run('Tbx_284_Path.m')
Intan_folder_path = 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Tbx284\Intan_Data_binary';
Intan_Session_name = 'Xiaochen_Preliminary__221029_174916';
Intan_clip_type = 'All';
target_clu_id = 8;
Colours
figurepath = 'C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Thesis_Daft\Ephys\Figures';
myKsDir0 = Intan_folder_path;
myKsDir = fullfile(myKsDir0,Intan_Session_name,Intan_clip_type);
%% load sorted spikes
cd(myKsDir)
matfile_name = strcat(Intan_Session_name,'.mat');
load(matfile_name)
fslow = 3000;
fshigh = 300;


spikeTimes = readNPY('spike_times.npy');
spikeClusters = readNPY('spike_clusters.npy');
clusterGroup = tdfread('cluster_group.tsv','\t');
%         clusterNeurontype = tdfread('cluster_neurontype.tsv','\t');
sp = loadKSdir(myKsDir);
window = [-0.001 0.002];

unit_number = length(unique(sp.clu));
% c = [c_Vermillion; c_Orange; c_Yellow; c_Blush_Green; c_Sky_Blue];
for j = 1:unit_number

    j_cid = clusterGroup.cluster_id(j);
    if j_cid==target_clu_id





        st = sp.st;
        j_st = st(sp.clu ==  (j_cid));
        light_unit_processing.cid = j_cid;
        eventTimes1 = j_st;
        %     gg = sp.clu(g);
        %     eventTimes1 = sp.st(sp.clu == gg);
        % randomly poll 100 traces so it will not take forever to plot
        if length(eventTimes1)>100
            eventTimes_index = randperm(length(eventTimes1),100);
            eventTimes = eventTimes1(eventTimes_index);
        else
            eventTimes = eventTimes1;
        end
        for Channel_num = 1:4
            fs = 20000;
            channel = tetrode(Channel_num,:);
            [b1, a1] = butter(3, [fshigh/fs,fslow/fs]*2, 'bandpass'); % butterworth filter with only 3 nodes (otherwise it's unstable for float32)
            channel_filtered = filtfilt(b1,a1,channel);
            fff = figure(233);
            subplot(1,4, Channel_num)
            %     fff.WindowState = 'maximized';
            %     set(fff, 'Visible', 'off');
            [x1_all,~] = segment_with_onset_time(channel_filtered', t,  eventTimes, window);
            x1 = mean(x1_all,2);
            x1_std = std(x1_all,0,2);
            itv = 1/fs;
            tshow = 1000*(((1:length(x1))-1)*itv+window(1));% convert to ms
            %             plot_mean_std(tshow, x1, x1_std, c_Black);
            plot(x1_all, 'Color',c_Black);
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
        for Channel_num = 1:4
            fff = figure(233);
            subplot(1,4, Channel_num)
            ylim([ylim_min ylim_max])
        end
        %%         plot a scale bar
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
        saveimg(gcf,figurepath,sprintf('%s_%d',Intan_Session_name,j_cid),'100traces_overlay',111)
        close

    end
end