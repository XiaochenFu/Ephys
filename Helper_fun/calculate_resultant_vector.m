function resultant_vector = calculate_resultant_vector(phase,spike_per_cycle)
% convert to polar axis
x = spike.*cos(phase);
y = spike.*sin(phase);
resultant_vector = [sum(x);sum(y)];


end