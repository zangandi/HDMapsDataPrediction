%% This function loads trace files as mat
%
%
clear all
%
trace_dir = '.\data\traces01\';
%
alltrips = [];
alltrip_traces = [];
%
tic;
for j = 1:10
    %
    trace_data = readtable(strcat(trace_dir,num2str(j)),'ReadVariableNames', false);
    %
    [~,I] = sort(trace_data{:,3});
    %
    trace_data_sorted = trace_data(I,:);
    %
    trace_data = trace_data_sorted;
    %
    %
    trips = [];
    trip_traces = [];   
    %
    for i = 1:size(trace_data,1)
        if i == 1
            trip_id = trace_data{i,2}{1};
            driver_id = trace_data{i,1}{1};
            ts = trace_data{i,3};
            poses = [trace_data{i,5} trace_data{i,4}];
        elseif i == size(trace_data,1)
            trips = cat(1, trips, {trip_id, driver_id, ts, poses});
            trip_traces = cat(1, trip_traces, {poses});
        else
            % if trips are the same one
            if strcmp(trace_data{i,2}{1}, trace_data{i-1,2}{1})
                ts = cat(1, ts, trace_data{i,3});
                poses = cat(1, poses, [trace_data{i,5} trace_data{i,4}]);
            else
                trips = cat(1, trips, {trip_id, driver_id, ts, poses});
                trip_traces = cat(1, trip_traces, {poses});
                %
                trip_id = trace_data{i,2}{1};
                driver_id = trace_data{i,1}{1};
                ts = trace_data{i,3};
                poses = [trace_data{i,5} trace_data{i,4}];
            end
        end
    end
    if mod(j,10) == 0
        disp(j);
        t = toc;
        disp(t);
        tic;
    end
    alltrips = cat(1, alltrips, trips);
    alltrip_traces = cat(1, alltrip_traces, trip_traces);
end%endfor i
t = toc;
save('.\data\tracemats\1.mat', 'alltrips', 'alltrip_traces');

%
% 34.279936,108.92309,
% 34.278608, 109.008833,
% 34.207309,109.009348,
% 34.204946,108.92185
%
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
[mask, canvas, satellite] = drawLinks(bbox, alltrip_traces(10001:12000), 14);
imshow(canvas)
mask = double(mask);
%
t2 = toc;
%
save('.\data\tracemats\1.vis.mat', 'canvas', 'mask')