function plot_mean_waveform_channelmap(MatA, channelmap)
    % Get the number of rows and columns from MatA
    [num_rows, ~] = size(MatA);

    % Create a figure
    figure;
    hold on;

    minX = min(channelmap.xcoords);

    % Initialize minimum and maximum Y values for plot alignment
    minY = min(channelmap.ycoords);
    maxY = max(channelmap.ycoords);

    % Iterate through each row
    for i = 1:num_rows
        % Get the current channel
        current_channel = channelmap.chanMap(i);

%         % Find the index of the current channel in the channel map
%         index = find(channelmap.chanMap == current_channel)

        % Calculate the coordinates for the plot
        x = (1:length(MatA(i, :)))+ channelmap.xcoords(current_channel) - minX;
        y = MatA(i, :) + channelmap.ycoords(current_channel) - minY; % Adjust Y value based on coordinates

        % Plot the current row values at the calculated position
        plot(x, y, 'DisplayName', sprintf('Channel %d', current_channel));
    end

    % Set the axis properties
    axis tight;

    % Add legend to the plot
%     legend show;

    hold off;
end
