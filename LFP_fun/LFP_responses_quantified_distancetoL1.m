% Read all the .mat files, then for each mouse, get number of spots
% evoked, mininum driving current used.
% then plot

% For voltage
% 1. absolute evoked voltage v.s. distance to target
% 2. lowest velly v.s. distance to target
% 3. highest peak v.s. distance to target

% For zscore (varience from baseline, the time point)
% 1. absolute zscore v.s. distance to target
% 2. lowest velly v.s. distance to target
% 3. highest peak v.s. distance to target

% For zscore (varience from baseline, all)
% 1. absolute zscore v.s. distance to target
% 2. lowest velly v.s. distance to target
% 3. highest peak v.s. distance to target

cc
Colours
vtg_max_min = @(x) (max(x{1})-min(x{1}));
vtg_max = @(x) max(x{1});
vtg_min = @(x) min(x{1});
zscore_all = @(x,y) (x{1}-y{1})/mean(y{2});
cd('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Result\LFP\zscores')
outputpath = 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Result\LFP\analyses_from_zscore_voltage';
d = dir('*.mat');
FibreTips = readtable('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Thesis_Daft\Ephys\Fibre_Tips.csv');
Distances = [NaN 0.0992550000000000 0.137270000000000 0.124110000000000 0.00277020000000000 0.285330000000000 0.668580000000000 0.605480000000000 0.222970000000000 0.073247];
% names = ["Monocycle" "Bicycle" "Tricycle"];
Mouse_List = [...
    "Tbx196",...
    "Tbx203",...
    "Tbx215",...
    "CCK129",...
    "TbxAi32_51_WT"...
    "Tbx211",...
    "Tbx218",...
    "LBHD147",...
    "Tbx284",...
    "Tbx327",...
    ];
distance_dic = dictionary(Mouse_List,Distances);
tempid_dic = dictionary(Mouse_List,1:10);
varables_list = {"v_minmax","v_max","v_min","z1_minmax","z1_max","z1_min","z2_minmax","z2_max","z2_min","distance","estimated_cell"};
titer_cell_dic = dictionary(Mouse_List,["tbx1","tbx1","tbx1","cck2","WT","tbx1","tbx1","lbhd1","tbx5","tbx5_3"]);
estimated_cell_dic = dictionary(["tbx1","WT","lbhd1","tbx5", "tbx5_3"],[2300 0 500 400 1200]);
estimated_cell_list = {2300 2300 2300 400 0 2300 2300 500 400 1200};
v_minmax_all = [];
v_max_all = [];
v_min_all = [];
z1_minmax_all = [];
z1_max_all = [];
z1_min_all = [];
z2_minmax_all = [];
z2_max_all = [];
z2_min_all = [];
distance_all = [];
estimated_cell_all = [];

for k = 1:length(d) % avoid using the first ones
    currD = d(k).name; % Get the current subdirectory name
    load(currD)
    distance = distance_dic(Mouse_ID);
    v_minmax =vtg_max_min(aligned_data);
    v_max = vtg_max(aligned_data);
    v_min = vtg_min(aligned_data);
    z1_minmax = vtg_max_min(zscored_data);
    z1_max = vtg_max(zscored_data);
    z1_min = vtg_min(zscored_data);

    z2_max = max(zscore_all(aligned_data,zscored_data));
    z2_min = min(zscore_all(aligned_data,zscored_data));
    z2_minmax = z2_max-z2_min;

    estimated_cell = estimated_cell_dic(titer_cell_dic(Mouse_ID));
    for v = 1:length(varables_list)
        vrb = varables_list{v};
        eval(sprintf('%s_all = [%s_all %s];',vrb,vrb,vrb));
    end




    %%

    %     cd 'C:\Users\yycxx\Documents\LOT_sections\' %先将工作目录切换到目标文件夹下
end
% save("C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\Result\LFP\analyses_from_zscore_voltage\result.mat")
ptsize = 20;
distance_all(isnan(distance_all)) = 1;% for plotting

figure_idx = 1;vtg = v_minmax_all;tt = ('Vpp (uV)');tt_save = 'Vpp';
LFP_responses_quantified_distancetoL1_genplot

figure_idx = 2;vtg = v_max_all;tt =('V max (uV)');tt_save = 'Vmax';
LFP_responses_quantified_distancetoL1_genplot

figure_idx = 3;vtg = v_min_all;tt =('V min (uV)');tt_save = 'Vmin';
LFP_responses_quantified_distancetoL1_genplot

figure_idx = 4;vtg = z1_minmax_all;tt =('Absolute Zscore');tt_save = 'ZscoreRange';
LFP_responses_quantified_distancetoL1_genplot

figure_idx = 5;vtg = z1_max_all;tt =('Max Zscore');tt_save = 'ZscoreMax';
LFP_responses_quantified_distancetoL1_genplot

figure_idx = 6;vtg = z1_min_all;tt =('Min Zscore');tt_save = 'ZscoreMin';
LFP_responses_quantified_distancetoL1_genplot

figure_idx = 7;vtg = z2_minmax_all;tt =('Absolute Zscore');tt_save = 'SmoothZscoreRange';
LFP_responses_quantified_distancetoL1_genplot

figure_idx = 8;vtg = z2_max_all;tt =('Max Zscore');tt_save = 'SmoothZscoreMax';
LFP_responses_quantified_distancetoL1_genplot

figure_idx = 9;vtg = z2_min_all;tt =('Min Zscore');tt_save = 'SmoothZscoreMin';
LFP_responses_quantified_distancetoL1_genplot
% function plot_LFP(vtg,tt,figure_idx)
% 
% 
% end