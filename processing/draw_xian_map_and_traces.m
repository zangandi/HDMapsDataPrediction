%%


clear all;
%
addpath('.\satelliteImgRetriever\')
%
load xian_filtered.mat
load data/tracemats/1.mat

% 34.279936,108.92309,
% 34.278608, 109.008833,
% 34.207309,109.009348,
% 34.204946,108.92185
%
bbox = [34.279936, 108.92185, 34.207309, 109.009348];


[mask1, canvas1, satellite1] = drawLinks(bbox, alltrip_traces(1:1000), 13);
%
filtered_road_map_links2 = [];
for i = 1:size(filtered_road_map_links,1)
    link = filtered_road_map_links{i};
    filtered_road_map_links2 = cat(1, filtered_road_map_links2, {[link(:,2) link(:,1)]});
end
%
[mask2, canvas2, ~] = drawLinks(bbox, filtered_road_map_links2, 13);


mask1 = double(mask1);
mask2 = double(mask2);
mask0 = zeros(size(mask1));

mask = cat(3, mask1, mask2, mask0);
imshow(mask);
%