function plot_light_stimuli(stim_grouped_j,varargin)
if length(varargin)>2
    error("check")
end
switch length(varargin)
    case 0
        stimuli_colour = 'cyan';
        yl = ylim;
    case 1
        stimuli_colour = varargin{1};
        yl = ylim;
    case 2
        stimuli_colour = varargin{1};
        yl = varargin{2};
end
pulse_num = stim_grouped_j.PulseNumber;
pulse_frequency = stim_grouped_j.Frequency;
pulse_width = stim_grouped_j.PulseWidth_ms;

for k = 1:pulse_num
    x1 = 1000/pulse_frequency*(k-1); %compute the pulse onset in ms
    x2 = x1+pulse_width;
    %     y1 = 0;
    %     y2 = max(rasterY)+1;
    y1 = yl(1);
    y2 = yl(2)+1;
    ylim([y1 y2])
    hold on
    fill([x1 x1 x2 x2]/1000,[y1 y2 y2 y1],stimuli_colour,'FaceAlpha',.3)
end