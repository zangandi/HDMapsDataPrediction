%% This function converts links into graph
%
%
%
clear all
%
load xian_filtered.mat
% load mask
load didi_maps_13.mat
% load trips
% load 
% load osm
load osm_1013_link.mat
% load 
zoomlevel = 13;
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
addpath('.\satelliteImgRetriever\')
%
figure;
hold on;
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
for i = 1:size(osm,1)
    link = osm{i};
    plot(link(:,2) + osm_to_didi_mis_lon, link(:,1) + osm_to_didi_mis_lat,'k--', 'linewidth', 2);
end
%
for i = 1:size(filtered_road_map_links,1)
    link = filtered_road_map_links{i};
    plot(link(:,1), link(:,2),'r-', 'linewidth', 2);
end
%
trace_dir = 'G:\datasets\didi\data\mm\trip_50\';
all_trace_dir = dir(strcat(trace_dir,'*.csv'));
%
for i = 1:length(all_trace_dir)-1
    trace = csvread(strcat(trace_dir,all_trace_dir(i).name),1,0);
    plot(trace(:,5), trace(:,4),'color', [rand(1,3)], 'linewidth', 2);
end
%
