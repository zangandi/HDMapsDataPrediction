clear all
% load trips
load('raw_training_trips.mat');
% load edge information
load('hd_maps_and_traffic_for_each_link_11_03.mat')
% load road network embedding
load('..\embeddings\edge_embedding_np.mat')
% load HD maps embedding
load('..\embeddings\hd_maps_embeddings.mat');

x = zeros(size(training_data,2),1);
% duration, distance, mdc1, mdc2, mdc3, edge distance
y = zeros(size(training_data,2),1);
for i = 1:size(training_data,2)
    this_trip = training_data{i};
    %
    y(i) = this_trip.mdc*(1+rand(1)/2);
    % 
    x(i,1) = rand(1);%this_trip.duration;
%     x(i,1) = this_trip.length;
    %
    all_mdcs = [0 0 0];
    all_length = 0;
    %
    edge_list = this_trip.cpath;
    for j = 1:size(edge_list,2)
        this_segment = edge_list(j);
        all_mdcs = all_mdcs + all_links{this_segment}.total_mdc;
        all_length = all_length + all_links{this_segment}.dist;
    end
%     x(i,3:5) = all_mdcs;
%     x(i,2) = all_length;
end

test = csvread('..\embeddings\embedtrain_test_label.csv');
test = logical(test);
train = ~test;
x_train = x(train,:);
x_test = x(test,:);
y_train = y(train,:);
YTest = y(test,:);
M = fitlm(x_train,y_train);
YPred = predict(M, x_test);
this_MAPE = mape2(YPred, YTest)

save('D:\Dropbox\results\clean\lr.mat','YPred', 'YTest');

mae(YPred-YTest)
    
for i = 1:10
    test = (indices == i); 
    train = ~test;
    x_train = x(train,:);
    x_test = x(test,:);
    y_train = y(train,:);
    y_test = y(test,:);
    M = fitlm(x_train,y_train);
    
    y_predict = predict(M, x_test);
    
end

[pdf1] = getPFD(y_predict, y_test, 20);