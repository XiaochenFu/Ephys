function sniff_coupled = check_sniff_locking(spiketime, baseline_sniff_onset, options)
% check the sniff locking of the unit 
% method: for each unit, calculate 100 resultant vector from random alignment
% If the resultant vector is longer than 90 of the vector from random alignment, it will be labelled as sniff coupled
num_shuffle = getOr(options,"num_shuffle",100);
couple_threshold = getOr(options,"couple_threshold",90);
% baseline
[bins_base, fr_base] = baseline_sniff_phase_uniform(baseline_sniff_onset,spiketime,options);
v_base = calculate_resultant_vector(bins_base,fr_base);
v_shuffle = nan(2,num_shuffle);
[shuffled_onsets, ~] = shuffle_sniff_duration(baseline_sniff_onset,options);
for i = 1:num_shuffle
    shuffled_onset = shuffled_onsets(:,i);
    [bins_base, fr_base] = baseline_sniff_phase_uniform(shuffled_onset,spiketime,options);
    
    v_shuffle(:,i) = calculate_resultant_vector(bins_base,fr_base);
    % the resultant vector resultant_vector = [r_phy,r_r];
end
r_base = v_base(2,:);
r_shuffle = v_shuffle(2,:);
r_longer_than_base = r_base> r_shuffle;
if sum(r_longer_than_base)>couple_threshold
    sniff_coupled = 1;
else
    sniff_coupled = 0;
end

end