function sniff_coupled = check_sniff_locking(spiketime, baseline_sniff_onset, option)
% check the sniff locking of the unit 
% method: for each unit, calculate 100 resultant vector from random alignment
% If the resultant vector is longer than 90 of the vector from random alignment, it will be labelled as sniff coupled
num_shuffle = getOr(option,"num_shuffle",100);
couple_threshold = getOr(option,"couple_threshold",90);
isplot = getOr(option,"isplot",0);
% baseline
[bins_base, fr_base] = baseline_sniff_phase_uniform(baseline_sniff_onset,spiketime,option);
v_base = calculate_resultant_vector_norm(bins_base,fr_base,option);
v_shuffle = nan(2,num_shuffle);
[shuffled_onsets, ~] = shuffle_sniff_duration(baseline_sniff_onset,option);
for i = 1:num_shuffle
    shuffled_onset = shuffled_onsets(:,i);
    [bins_base, fr_base] = baseline_sniff_phase_uniform(shuffled_onset,spiketime,option);
    
    v_shuffle(:,i) = calculate_resultant_vector_norm(bins_base,fr_base);
    % the resultant vector resultant_vector = [r_phy,r_r];
end
r_base = v_base(2,:);
r_shuffle = v_shuffle(2,:);
if isplot
    figure 
    plot(sort(r_shuffle),1:num_shuffle,'k.')
    yline(90,'--')
    xlabel('normalized resultant vector lenth')
    ylabel('% randomly aligned')
% figure
% for i = 1:num_shuffle
% compass()
% end
end

r_longer_than_base = r_base> r_shuffle;
if sum(r_longer_than_base)>couple_threshold
    sniff_coupled = 1;
else
    sniff_coupled = 0;
end

end