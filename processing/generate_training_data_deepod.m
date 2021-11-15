clear all
% load trips
load('..\embeddings\raw_training_trips.mat');
% load edge information
load('..\embeddings\hd_maps_and_traffic_for_each_link_11_03.mat')
% load road network embedding
load('..\embeddings\edge_embedding_np.mat')
% load HD maps embedding
load('..\embeddings\hd_maps_embeddings.mat');
%
train_or_test = csvread('..\embeddings\embedtrain_test_label.csv');
%
experiment = cell(size(training_data,2),1);
load('..\embeddings\experiment_1_deepod.mat')
for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        x = cat(2, x, road_network_embedding(this_segment,:), all_links{this_segment}.total_mdc, all_links{this_segment}.dist);
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
end

save('experiment_1_deepod.mat', 'experiment')

load('..\embeddings\experiment_1_deepod.mat')
for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
    experiment{i}.train_or_test = train_or_test(i);
end

save('..\embeddings\experiment_1_deepod.mat', 'experiment')