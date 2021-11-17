mat_dir = 'D:\Dropbox\results\';

label_idx = csvread('..\embeddings\embedtrain_test_label.csv');
load('raw_training_trips.mat')
dist = [];
test_idx = [];
for i = 1:size(label_idx,1)
    if label_idx(i) == 1
        test_idx = cat(1, test_idx, i);
    end
end

for i = 1:size(test_idx,1)
    dist = cat(1, dist, training_data{test_idx(i)}.length);
end

dist_r = [];

for i = 1:size(dist,1)
    dist_r = cat(1, dist_r, dist(i)/sum(dist));
end

for i = 1:13
    load(strcat(mat_dir, num2str(i),'.mat'));
    i
    mae(YPred*10^7-YTest*10^7)
    this_MAPE = mape2(YPred*10^7, YTest*10^7)
    this_wMAPE = wmape(YPred*10^7, YTest*10^7, dist_r)
end