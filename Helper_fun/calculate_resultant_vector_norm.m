function resultant_vector = calculate_resultant_vector_norm(phase,spike_per_cycle, varargin)
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end
isplot = getOr(option, 'isplot', 0);
saveplot = getOr(option, 'saveplot', 0 );
%% noramlize the spike_per_cycle
spike_per_cycle_norm = spike_per_cycle/sum(spike_per_cycle);
%%
% convert to polar axis
x = spike_per_cycle_norm.*cos(phase);
y = spike_per_cycle_norm.*sin(phase);
rx = mean(x);
ry = mean(y);
[r_phy,r_r] = cart2pol(rx,ry);
resultant_vector = [r_phy;r_r];

if isplot
    figure
    compass(max(abs(spike_per_cycle_norm)),max(abs(spike_per_cycle_norm)),'w:')
    hold on
    compass(rx,ry)
    hold on
    plot(x,y);
    if saveplot
        saveimg(gcf,"C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\Sample_Plots","Demo","resultant_vector",111);
    end
end
end