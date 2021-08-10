clear all
addpath('.\satelliteImgRetriever\')
%
load xian_hd_maps_0602.mat
load traffic_1029.mat
%
load all_nodes_adjacency_0618.mat
%
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
zoomlevel = 13;
%
number_of_intersections = size(adjacency_matrix,1);
% sparse representation
tti_value_list = [];
speed_value_list = [];
tti_location_list = [];
%
canvas1 = zeros(513,510);
%
for i = 1:number_of_intersections
    for j = 1:number_of_intersections
        if ~isempty(node_to_node_links{i,j})
            for k = 1:size(node_to_node_links(i,j),1)
                this_link = node_to_node_links{i,j}{k};
                this_link = cat(2, this_link(:,1) + osm_to_didi_mis_lat,...
                                   this_link(:,2) + osm_to_didi_mis_lon);

                segment_mask = drawLinksFast(bbox, {this_link}, zoomlevel);
                canvas1 = canvas1 + segment_mask;
            end
        end
    end
end
canvas1 = double(canvas1 > 0);
%
canvas2 = zeros(513,510);
%
for i = 1:1%size(osm,1)
    this_link = osm{i};
    this_link = cat(2, this_link(:,2) + osm_to_didi_mis_lat,...
                       this_link(:,3) + osm_to_didi_mis_lon);
    segment_mask = drawLinksFast(bbox, {this_link}, zoomlevel);
    canvas2 = canvas2 + segment_mask;
end
canvas2 = double(canvas2 > 0);




imshow(cat(3, canvas1,canvas2,zeros(513,510)));