% plot number LFP response sides v.s. distance to target
Colours
FibreTips = readtable('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Thesis_Daft\Ephys\Fibre_Tips.csv');

FibreTips.number_responding_LFP_site = zeros(9,1);

% 220304, tbx203 1 site
FibreTips.number_responding_LFP_site(2) = 1;
% 220406 Tbx215 1 site
FibreTips.number_responding_LFP_site(3) = 1;
% 220603 Tbx 211 1 site
FibreTips.number_responding_LFP_site(6) = 1;
% 221029 Tbx 284 1 site
FibreTips.number_responding_LFP_site(9) = 1;
% remove the one with glass pipet
FibreTips.number_responding_LFP_site(4) = NaN;
% remove the WT
FibreTips.number_responding_LFP_site(5) = NaN;

figure
plot(FibreTips.Var5,FibreTips.number_responding_LFP_site,'x')
hold on 
% plot the WT in red
p1 = plot(FibreTips.Var5(5),0,'rx');
xlabel('Distance to target (um)')
ylabel({'Number of recording sites','with LFP evoked'})
ylim([0 2])
legend({'ChETA mice','WT'})
saveimg(gcf,'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Test_Figure\LFP_test','LFP','vsDistance2L1','111')