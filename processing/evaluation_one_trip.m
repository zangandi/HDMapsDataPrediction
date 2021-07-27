%% 

clear all
%
trip_name = 'd8454976ca3d466d85ed81bd5a0ce3b1.csv';
result_csv_dir = 'G:\run_0113\5lstm-exp2\';
raw_trip_dir = 'G:\datasets\didi\data\mm\';

% find raw trip
all_trips = dir(strcat(raw_trip_dir,'\*\*.csv'));
%
idx = [];
for i = 1:length(all_trips)
    if strcmp(all_trips(i).name, trip_name)
        idx = cat(1, idx, i);
    end
end
%
trip_full_dir = strcat(all_trips(idx).folder, '\', all_trips(idx).name);
%
trace = csvread(trip_full_dir,1,0);

current_length = 0;
current_duration = trace(end,1) - trace(1,1);
%
for j = 1:size(trace,1)-1
    current_distance = distanceLLA(trace(j,4:5), trace(j+1,4:5), 0);
%             current_speed = current_distance/(trace(j+1,1) - trace(j,1));        
%             speed = cat(1, speed, current_speed);
    current_length = current_length + current_distance;
end%



addpath('.\satelliteImgRetriever\')
%
load osm_1013_link.mat

figure
hold on
xlabel('Longitude (degree), E')
ylabel('Latitude (degree), N');
ylim([34.207309 34.279936])
xlim([108.92185 109.009348])
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
for i = 1:size(osm,1)
    link = osm{i};
    plot(link(:,2) + osm_to_didi_mis_lon, link(:,1) + osm_to_didi_mis_lat,'k-', 'linewidth', 1);
end

for i = 1:size(trace,1)
    plot(trace(i,5), trace(i,4),'ro', 'linewidth', 2);
    %plot(trace(i,2), trace(i,3),'ro', 'linewidth', 2);
    %plot([trace(i,5) trace(i,2)], [trace(i,4) trace(i,3)], 'm-', 'linewidth', 2);
end

plot(trace(:,5), trace(:,4),'r-', 'linewidth', 2);
%



dir_list = {'1lstm-exp1','3lstm-exp4','5lstm-exp4','5normal-rnn-exp3'};
%
results = [];
for i = 1:length(dir_list)
    result = csvread(strcat('G:\run_0113\',dir_list{i},'\',trip_name));
    results = cat(2, results, result(:,1));
end
%
gt = result(:,2);

figure;
hold on;
grid on
plot([1:length(gt)], gt,'k-');
plot([1:length(gt)], results(:,1),'r-');
plot([1:length(gt)], results(:,2),'b-');
plot([1:length(gt)], results(:,3),'c-');
plot([1:length(gt)], results(:,4),'m-');
xlabel('Trajectory point#')
ylabel('Normalized MDC')
legend({'MDC','1B+srLSTM','5A+srLSTM','5B+srLSTM','5B+RNN'});






trip_time = trace(end,1) - trace(1,1);
total_distance = 0;
for i = 1:size(trace,1)-1
    total_distance = total_distance + distanceLLA(trace(i,2:3), trace(i+1,2:3), 1);
end
