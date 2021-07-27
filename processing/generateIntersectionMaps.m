%% This function generate interseciont maps
%
%
%
clear all
% load links
load osm_1013_link.mat
load osm_1013_adjacency.mat
% load 
zoomlevel = 13;
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
addpath('.\satelliteImgRetriever\')
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
%
osm_node_list = csvread('.\data\xian_osm_1009\nodes.csv');
%
[canvas, w, h, resolution] = bbox2canvas(bbox, zoomlevel);
for i = 1:size(osm_intersection,1)
    for j = 1:size(osm_intersection,2)
        intersections = osm_intersection{i,j};
        if ~isempty(intersections)
            for k = 1:size(intersections,1)
                %
                idx = findidx(osm_node_list(:,1), intersections(k));
                %
                lat = osm_node_list(idx,2);
                lon = osm_node_list(idx,3);
                %
                [mask] = drawLinksFast(bbox, {[lat+osm_to_didi_mis_lat lon+osm_to_didi_mis_lon;...
                                               lat+osm_to_didi_mis_lat lon+osm_to_didi_mis_lon]}, zoomlevel);
                canvas = canvas + mask;
            end
        end
    end
end
canvas = double(canvas>0);
se = strel('square',2);
canvas2 = imdilate(canvas,se);
imshow(cat(3,canvas,canvas2,zeros(513,510)));
% imwrite(cat(3,canvas,canvas2,zeros(513,510)), 'osm_intersecion_visualization.png');
osm_intersection_maps = canvas2;
save('osm_1111_intersectionmap.mat', 'osm_intersection_maps');
