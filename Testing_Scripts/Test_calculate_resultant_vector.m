option.isplot = 1;
phase = odour_unit_processing.Baseling_Phase_Uniform{1};
spike_per_cycle = odour_unit_processing.Baseling_Phase_Uniform{2};
resultant_vector = calculate_resultant_vector_norm(phase,spike_per_cycle,option)
option.isplot = 0;