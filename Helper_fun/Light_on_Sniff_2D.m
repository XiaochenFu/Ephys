%% plot sniff phase, add pusle onset the sniff phase if necessary 
% input:
% sniff signal
% sniff time
% pulse onset
% pulse signal
% output
% figure
% function Light_on_Sniff_2D(sniff,t,fs, )
%% resmple sniff signal if necessary
isresample = 1;
fs0 = 1000;
if isresample
    sniff0 = resample(sniff,fs0,fs);
    t0 = resample(t,fs0,fs);
else
    sniff0 = sniff;
    t0 = t;
end
%%
CalculatedSniffOnset = extractfield_blank2nan(Stimuli_Info,'CalculatedSniffOnset');
LatencyFromCalculatedSniffOnset_ms = extractfield_blank2nan(Stimuli_Info,'LatencyFromCalculatedSniffOnset_ms');
plt_window = [0 0.5];
close all
[B,I] = sort(LatencyFromCalculatedSniffOnset_ms);
[x1_all,x1_onsetused,x1_time] = segment_with_onset_time2(sniff0', t0, CalculatedSniffOnset(I), plt_window);
cmp =  colormap(cbrewer2('RdYlGn'));

x = (1:size(x1_all,2));
% y = (1:size(x1_all,1))/fs;
y = x1_time;

% heatmap(y,x,x1_all');
imagesc(y,x,x1_all')
%
% Ax = gca;
% Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
% Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
% colorbar off
ax = axes;
% plot(ax,magic(4),'LineWidth',2)
% ax.Color = 'none'
plot(ax,LatencyFromCalculatedSniffOnset_ms(I)/1000,x,'r|','MarkerSize',3)
xlim(plt_window )
%         axis off
hold on
ax.Color = 'none';
set(ax, 'YDir','reverse')
ylim([min(x)-0.5 max(x)+0.5])