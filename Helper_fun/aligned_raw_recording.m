% function raw_recording(recording,eventTimes)
cc
load("C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Tbx284\Intan_Data_binary\Xiaochen_Preliminary__221029_163354\All\Xiaochen_Preliminary__221029_163354.mat");
load("C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Tbx284\Intan_Data_binary\Xiaochen_Preliminary__221029_163354\All\Stimuli_Info.mat");

itv = 5.0000e-05;
eventTimes = [100;200];
window = [0 0.1];
[x_all,~] = segment_with_onset_time(tetrode', t,  eventTimes, window);
x_t = ((1:length(x_all))-1)*itv+window(1);
% plot(trigger_time_remained,x3_all)
%%
num_onsets = length(eventTimes);
stim_grouped = sort_light_stimuli(Stimuli_Info);
stim_grouped_m = stim_grouped(5);
pulse_num = stim_grouped_m.PulseNumber;
pulse_frequency = stim_grouped_m.Frequency;
pulse_width = stim_grouped_m.PulseWidth_ms;

if num_onsets<=5
    figure
    tiledlayout(num_onsets,1, 'Padding', 'none', 'TileSpacing', 'compact');
    for i = 1:num_onsets
        nexttile
        %     subplot(num_onsets,1, i);
        plot(x_t,x_all(:,:,i))
        %  set(gca,'XTick',[])
        %  set(gca,'xticklabel',[])
        axis off
        hold on
        % plot the light stimuli

        for k = 1:pulse_num
            x1 = 1000/pulse_frequency*(k-1); %compute the pulse onset in ms
            x2 = x1+pulse_width;
            hold on
            %     xline(x1)
            xline(x1/1000,'black')
        end
    end
    cd('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Test_Figure')
    saveas(gcf,strcat(datestr(datetime("now"),30),'.jpg'))
    close
else
    i = 1;
    ct = 1;
    while i<num_onsets
        figure
        tiledlayout(5,1, 'Padding', 'none', 'TileSpacing', 'compact');
        while ct<=5 && i<num_onsets

            nexttile
            %     subplot(num_onsets,1, i);
            plot(x_t,x_all(:,:,i))
            %  set(gca,'XTick',[])
            %  set(gca,'xticklabel',[])
            axis off
            hold on
            % plot the light stimuli

            for k = 1:pulse_num
                x1 = 1000/pulse_frequency*(k-1); %compute the pulse onset in ms
                x2 = x1+pulse_width;
                hold on
                %     xline(x1)
                xline(x1/1000,'black')

            end
            ct=ct+1;
            i = i+1;
        end
        ct = 1;
%         if saveplot
%         cd('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Test_Figure')
%         saveas(gcf,strcat(datestr(datetime("now"),30),'.jpg'))
%         close
%         end
    end

end

% i = num_onsets;
% plot(x_t,x_all(:,:,i))
