function stimuli_onsets = get_stimuli_onsets_ms(stim_grouped_j)
pulse_num = stim_grouped_j.PulseNumber;
pulse_frequency = stim_grouped_j.Frequency;
pulse_width = stim_grouped_j.PulseWidth_ms;
stimuli_onsets = zeros(pulse_num,1);
for k = 1:pulse_num
    x1 = 1000/pulse_frequency*(k-1); %compute the pulse onset in ms
    stimuli_onsets(k) = x1;
    %     x2 = x1+pulse_width;
    %     y1 = 0;
    %     y2 = max(rasterY)+1;
    %     ylim([y1 y2])
    %     hold on
    %     fill([x1 x1 x2 x2]/1000,[y1 y2 y2 y1],'cyan','FaceAlpha',.3)
end
