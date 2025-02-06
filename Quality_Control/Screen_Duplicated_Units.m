%  screen the duplicated units in a folder
%%
ephys_path = 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code';
addpath(fullfile(ephys_path,'Library\npy-matlab-master\npy-matlab'));
addpath(genpath(fullfile(ephys_path,'\Library\spikes-master')));
%%
cc
%%
myKsDir = ('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Thesis_Ephys\TbxAi32_171\Intan_Data_Binary\OB_Stim__240313_162853\All');
outputpath = '';
cd(myKsDir)
spikeTimes = readNPY('spike_times.npy');
spikeClusters = readNPY('spike_clusters.npy');
clusterGroup = tdfread('cluster_group.tsv','\t');
sp = loadKSdir(myKsDir);
st = sp.st;
%% Loop all the units unless it's labelled as noise

% Initialize matrix to store results
results = [];

% Loop through all the units, skipping noise
group = clusterGroup.group;
isnoiseunit = strcmpi(group,'noise');

for j = 1:size(group,1)
    if ~isnoiseunit(j) % if it's not noise
        j_cid = clusterGroup.cluster_id(j);
        j_st = st(sp.clu == j_cid);
        for k = (j+1):size(group,1)
            k_cid = clusterGroup.cluster_id(k);
            k_st = st(sp.clu == k_cid);
            [K, ~, ~, ~, ~] = ccg(j_st, k_st, 500, 1/1000);
            if max(K) > 10
                results = [results; [j, k, max(K)]];
            end
        end
    end
end

% Save results to a CSV file
csv_filename = fullfile(outputpath, 'results.csv');
writematrix(results, csv_filename);