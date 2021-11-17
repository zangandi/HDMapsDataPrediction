%% Configuration of LSTM
clear all
save_dir = 'C:\Users\zanga\Dropbox\results\' ;
mat_dir = 'G:\mats\experiment_';
%
for f = 2:13
    load(strcat(mat_dir,num2str(f),'.mat'));
    %
    sample = experiment{1};
    numFeatures = size(sample.x,2)/sample.number_of_edges;
    %
    numHiddenUnits = 125;
    numResponses = 1;
    %
    test_idx = csvread('..\embeddings\embedtrain_test_label.csv');
    test_idx = test_idx==1;
    train_idx = ~test_idx;
    %
    X = cell(size(experiment,1),1);
    Y = zeros(size(experiment,1),1);
    %
    for i = 1:size(experiment,1)
        X{i} = reshape(experiment{i}.x, numFeatures, experiment{i}.number_of_edges);
        Y(i) = experiment{i}.y;
    end
    %
    XTrain = X(train_idx);
    YTrain = Y(train_idx)/10000000;
    XTest = X(test_idx);
    YTest = Y(test_idx)/10000000;
    %
    layers = [ ...
        sequenceInputLayer(numFeatures)
        lstmLayer(numHiddenUnits,'OutputMode','last')
        fullyConnectedLayer(numResponses)
        regressionLayer];

    maxEpochs = 10;
    miniBatchSize = 27;

    options = trainingOptions('adam', ...
        'ExecutionEnvironment','cpu', ...
        'GradientThreshold',1, ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest', ...
        'Shuffle','never', ...
        'Verbose',0, ...
        'Plots','training-progress');

    %% 
    net = trainNetwork(XTrain,YTrain,layers,options);
    %
    YPred = predict(net,XTest, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest');
    save(strcat(save_dir,num2str(f),'.mat'), 'YPred', 'YTest');
end