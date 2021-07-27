%
clear all
%
addpath('.\satelliteImgRetriever\')
%
load xian_hd_maps_1111.mat
load osm_1013_link.mat
load osm_1013_adjacency.mat
load osm_1111_intersectionmap.mat
% load traffic
load traffic_1029.mat
osm_node_list = csvread('.\data\xian_osm_1009\nodes.csv');
bbox = [34.279936, 108.92185, 34.207309, 109.009348];

% draw OSM
mask = drawLinksFast(bbox, osm, 17);


% draw trips
%
trip_dir = 'G:\datasets\didi\data\mm\gps_20161007\';
trip_dir = dir(strcat(trip_dir,'*.csv'));
number_of_trip = length(trip_dir);

trips_mask = zeros(size(mask));
%
for i = 1:1:number_of_trip
    trip = csvread(strcat(trip_dir(i).folder,'\', trip_dir(i).name),1,0);
    trip_mask = drawLinksFast(bbox, {trip(:,4:5)}, 13);
    trips_mask = trips_mask + trip_mask;
end

trips_mask2 = trips_mask;
for i = 1:size(trips_mask,1)
    for j = 1:size(trips_mask,2)
        if trips_mask(i,j) == 0
            trips_mask2(i,j) = inf;
        end
    end
end

trips_heatmap = myheatmap(trips_mask2,1,[]);
imshow(trips_heatmap);


trips_mask2 = trips_heatmap;
for i = 1:size(trips_heatmap,1)
    for j = 1:size(trips_heatmap,2)
        if sum(trips_heatmap(i,j,:)) == 0
            trips_mask2(i,j,1) = 1;
            trips_mask2(i,j,2) = 1;
            trips_mask2(i,j,3) = 1;
        end
    end
end
imwrite(~mask, 'osm_map_level_13.png');
imwrite(trips_mask2, 'didi_trips_heatmap_level_13.png');