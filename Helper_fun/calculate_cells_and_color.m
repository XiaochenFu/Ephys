function [depth, total_mt, color] = calculate_cells_and_color(data_struct, color_m, color_t)
    n_depth = length(data_struct);
    total_mt = zeros(n_depth, 1);
    color = zeros(n_depth, 3); % assuming RGB colors

    for i = 1:n_depth
        depth(i) = data_struct(i).RecordingDepth;

        % calculate total 'm' and 't' cells
        total_mt(i) = data_struct(i).m + data_struct(i).t;

        % calculate proportions
        prop_m = data_struct(i).m / total_mt(i);
        prop_t = data_struct(i).t / total_mt(i);

        % blend colors
        color(i, :) = prop_m * color_m + prop_t * color_t;
    end
end
