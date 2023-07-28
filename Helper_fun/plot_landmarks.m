function plot_landmarks(filepath, depth, sheetname)
% Read table from excel
T = readtable(filepath, 'Sheet', sheetname);

% Get section and landmark data
section = T.section;
landmark0 = T.landMark;

% Set the colors for different landmarks
colors = containers.Map({'GL', 'EPL', 'MCl', 'GCL'}, ...
    {'r', 'g', 'b', 'm'}); % Adjust these color codes to your liking

% Create a figure
 hold on;

landmark = landmark0(~cellfun('isempty', landmark0))

% Calculate the step size for each section
step = max(depth)/length(landmark);

% Initialize previous landmark
prev_landmark = landmark{1};
prev_y = 0;

% Loop over sections
for i = 2:length(landmark)
    if ~isempty(landmark{i})
        % Compute the y-coordinate for this landmark
        y = i * step;

        % If the landmark changed, draw a line segment for the previous landmark
        if ~isempty(prev_landmark) && ~strcmp(landmark{i}, prev_landmark) && y ~= prev_y
            if isKey(colors, prev_landmark)
                color = colors(prev_landmark);
            else
                color = 'k'; % Default color if landmark type is unknown
            end
            line([0, 0], [prev_y, y], 'Color', color, 'LineWidth', 10);
            hold on
            prev_landmark = landmark{i};
            prev_y = y;
        end
    end
end

% Draw the last line segment
if ~isempty(prev_landmark) & isKey(colors, prev_landmark) & depth ~= prev_y
    color = colors(prev_landmark);
else
    color = 'k'; % Default color if landmark type is unknown
end
line([0, 0], [prev_y, max(depth)], 'Color', color, 'LineWidth', 10);

% Configure the plot
ylim([0 max(depth)]);
set(gca, 'YDir', 'reverse'); % Reverse y-axis direction to plot depth correctly
ylabel('Depth');
set(gca, 'XTick', []); % Remove x-axis
hold off;
end
