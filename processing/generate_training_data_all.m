clear all
% load trips
load('raw_training_trips.mat');
% load edge information
load('hd_maps_and_traffic_for_each_link_11_03.mat')
% load road network embedding
load('..\embeddings\edge_embedding_np.mat')
% load HD maps embedding
load('..\embeddings\hd_maps_embeddings.mat');
% load HD maps avg embedding
load('..\embeddings\hd_maps_embeddings_avg.mat');
%
train_or_test = csvread('..\embeddings\embedtrain_test_label.csv');
%
all_links2 = all_links;
c = 0;
for i = 1:size(all_links,1)
   this_link = all_links{i};
   if size(this_link.tti,3)~=1008
       all_links{i}.tti = zeros(1,1,1008);
       all_links{i}.speed = zeros(1,1,1008);
       c = c + 1;
   end
end

%% EXP 2:
%  road 128 + hd 100
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        x = cat(2, x, road_network_embedding(this_segment,:), hd_maps_embedding(this_segment,:), all_links{this_segment}.total_mdc, all_links{this_segment}.dist);
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_2.mat', 'experiment')

%% EXP 3:
%  road 128 + hd 100 + traffic
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    ts_list = this_trip.cpath_timestamp(:,4);
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        this_ts = ts_list(j);
        this_link = all_links{this_segment};
        x = cat(2, x, road_network_embedding(this_segment,:), hd_maps_embedding(this_segment,:), this_link.total_mdc, this_link.dist, this_link.tti(this_ts), this_link.speed(this_ts));
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_3.mat', 'experiment')

%% EXP 4:
%  hd 100 + traffic
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    ts_list = this_trip.cpath_timestamp(:,4);
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        this_ts = ts_list(j);
        this_link = all_links{this_segment};
        x = cat(2, x, hd_maps_embedding(this_segment,:), this_link.total_mdc, this_link.dist, this_link.tti(this_ts), this_link.speed(this_ts));
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_4.mat', 'experiment')

%% EXP 5:
%  road 128 + hd avg 5
cdata = cell2mat(data);
cdata = reshape(cdata,4774,5);
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        x = cat(2, x, road_network_embedding(this_segment,:), cdata(this_segment,:), all_links{this_segment}.total_mdc, all_links{this_segment}.dist);
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_5.mat', 'experiment')

%% EXP 6:
%  road 128 + hd avg 5 + N
cdata = cell2mat(data);
cdata = reshape(cdata,4774,5);
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        x = cat(2, x, road_network_embedding(this_segment,:), cdata(this_segment,:));
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_6.mat', 'experiment')

%% EXP 7:
%  road 128 + hd 100 + N
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        x = cat(2, x, road_network_embedding(this_segment,:), hd_maps_embedding(this_segment,:));
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_7.mat', 'experiment')

%% EXP 8:
%  road 128 + hd 100 + traffic + N
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    ts_list = this_trip.cpath_timestamp(:,4);
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        this_ts = ts_list(j);
        this_link = all_links{this_segment};
        x = cat(2, x, road_network_embedding(this_segment,:), hd_maps_embedding(this_segment,:), this_link.tti(this_ts), this_link.speed(this_ts));
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_8.mat', 'experiment')

%% EXP 9:
%  hd 100 + traffic + N
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    ts_list = this_trip.cpath_timestamp(:,4);
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        this_ts = ts_list(j);
        this_link = all_links{this_segment};
        x = cat(2, x, hd_maps_embedding(this_segment,:), this_link.tti(this_ts), this_link.speed(this_ts));
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_9.mat', 'experiment')

%% EXP 10:
%  road 128 + N
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    ts_list = this_trip.cpath_timestamp(:,4);
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        this_ts = ts_list(j);
        this_link = all_links{this_segment};
        x = cat(2, x, road_network_embedding(this_segment,:));
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_10.mat', 'experiment')

%% EXP 11:
%  HD 100 + N
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    ts_list = this_trip.cpath_timestamp(:,4);
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        this_ts = ts_list(j);
        this_link = all_links{this_segment};
        x = cat(2, x, hd_maps_embedding(this_segment,:));
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_11.mat', 'experiment')

%% EXP 12:
%  road 128  + traffic
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    ts_list = this_trip.cpath_timestamp(:,4);
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        this_ts = ts_list(j);
        this_link = all_links{this_segment};
        x = cat(2, x, road_network_embedding(this_segment,:), this_link.total_mdc, this_link.dist, this_link.tti(this_ts), this_link.speed(this_ts));
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_12.mat', 'experiment')

%% EXP 13:
%  road 128  + traffic + N
experiment = cell(size(training_data,2),1);

for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    x = [];
    %
    edge_list = this_trip.cpath;
    ts_list = this_trip.cpath_timestamp(:,4);
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        this_ts = ts_list(j);
        this_link = all_links{this_segment};
        x = cat(2, x, road_network_embedding(this_segment,:), this_link.tti(this_ts), this_link.speed(this_ts));
    end
    %
    experiment{i}.y = this_trip.mdc;
    experiment{i}.x = x;
    experiment{i}.train_or_test = train_or_test(i);
    experiment{i}.number_of_edges = size(this_trip.cpath,2);
end

save('..\embeddings\experiment_13.mat', 'experiment')