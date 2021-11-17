clear all
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

load(strcat(mat_dir, num2str(9),'.mat'));

pre_MAPE1 = abs((YPred-YTest)./YTest);

load(strcat(mat_dir, num2str(12),'.mat'));

pre_MAPE2 = abs((YPred-YTest)./YTest);

figure
hold on
xlabel('Trip Length (m)')
ylabel('MAPE %')
plot(dist, pre_MAPE1, 'r*');
plot(dist, pre_MAPE2, 'b*');
legend({'111','010'})