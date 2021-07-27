%% This function writes sub-links and visualizes them
%
%
clear all
%
addpath('.\satelliteImgRetriever\')
%
load xian.mat
%
sublink_list_dir = '.\links\';
%
allnodes = [];
%
for i = 1:size(road_map,1)
    %
    link = road_map{i};
    if ~isempty(link)
        allnodes = cat(1, allnodes, link.links);
    end%endif
    disp(i)
end%endfor i
%
% bbox = [lat_max, lon_min, lat_min, lon_max];
bbox = [34.3108 108.8783 34.2314 109.0073];
% [image, ~, ~, ~] = satelliteImageRetrieverBoundingBox(bbox, 14, []);
%
[mask, canvas, satellite] = drawLinks(bbox, allnodes, 14);
mask = double(mask);
%
% canvas = canvas(2000:end, 2000:end);
% mask = mask(2000:end, 2000:end);
% satellite = satellite(2000:end, 2000:end,:);
%
save('xian_didi_bbox.mat', 'canvas', 'mask')
%
% imwrite(canvas, 'xian_10of10_road_11.png');
% imwrite(satellite, 'xian_10of10_satellite_11.png');
% imwrite(cat(3, satellite(:,:,1).*~mask + canvas(:,:,1),...
%                satellite(:,:,2).*~mask + canvas(:,:,2),...
%                satellite(:,:,3).*~mask + canvas(:,:,3)),... 
%                'xian_10of10_fusion_11.png');
[mask, canvas, satellite] = drawLinks(bbox, osm, 14);
mask = double(mask);
save('xian_osm_bbox.mat', 'canvas', 'mask')