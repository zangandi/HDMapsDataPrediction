%% This function checkes alignment results
%
%
%
clear all
%
addpath('.\satelliteImgRetriever\')
%
load data\tracemats\1_clean.mat
% load 
load xian_filtered.mat
% load mask
load didi_maps_13.mat

trips = alltrips_clean;

bbox = [34.279936, 108.92185, 34.207309, 109.009348];


for i = 1:size(trips,1)
    % 
    trip_mm_link_ids = removeDuplicatedListMat(trips{i,5});
    %
    link_map = [];
    %
    for j = 1:size(trip_mm_link_ids,1)
        link_layer_idx = find(filtered_road_map_ids == trip_mm_link_ids(j));
        link_map  = cat(1, link_map,...
                    {[filtered_road_map_links{link_layer_idx}(:,2) filtered_road_map_links{link_layer_idx}(:,1)]});
    end%endfor j
    %
    bbox = [max(trips{i,4}(:,1))+0.001...
            min(trips{i,4}(:,2))-0.001...
            min(trips{i,4}(:,1))-0.001...
            max(trips{i,4}(:,2))+0.001];
    %
    [mask_raw, ~, ~] = drawLinks(bbox, trips(i,4), 17);
    [mask_mm, ~, ~] = drawLinks(bbox, trips(i,6), 17);
    [mask_map, ~, ~] = drawLinks(bbox, link_map, 17);
    short_mm = trips{i,6};
    short_mm = short_mm(11:40,:);
    [mask_mm, ~, ~] = drawLinks(bbox, {short_mm}, 17);
   
    %
    imshow(cat(3,mask_map, mask_raw, mask_mm))
    
    imwrite(cat(3,mask_map, mask_raw, mask_mm), strcat('visualization\',trips{i,1},'.png'));
    %
end