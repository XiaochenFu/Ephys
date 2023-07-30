function plot_mean_16channel(matrix)
    % Input: 
    % matrix - a 16*A matrix

    % check if the input matrix has 16 rows
    if size(matrix, 1) ~= 16
        error('Input matrix must have 16 rows');
    end

    figure; % Create new figure
    for i = 1:16
        subplot(16, 1, i); % Create subplot for each row
        plot(matrix(i, :)); % Plot each row
    end
end
