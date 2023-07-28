function plotCellDistribution(depth, total_mt, color)
% convert depth to negative for plotting downwards
%     depth = -1*total_mt.RecordingDepth;


% create a new figure
figure;

% plot circles at each depth
for i = 1:length(depth)
    scatter(1, depth(i), total_mt(i)*100, 'filled', 'MarkerFaceColor', color(i, :));
    hold on;
end

% adjust y axis direction
set(gca, 'YDir', 'reverse');

% add labels
%     xlabel('Cell Type');
set(gca, 'XTickLabel', []);
set(gca, 'XTick', []);

ylabel('Recording Depth');

% show grid
grid on;
end
