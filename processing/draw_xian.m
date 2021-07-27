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
% initialize bbox
lat_min = 90;
lat_max = -90;
lon_min = 180;
lon_max = -180;
%
allnodes = [];
%
for i = 1:size(road_map,1)
    %
    link = road_map{i};
    %
    % 

    %
    if ~isempty(link)
        %
        for j = 1:size(link.links,1)
            %
            nodes = link.links{j};
            %
            for k = 1:size(nodes,1)
                %
                lat = nodes(k,2);
                lon = nodes(k,1);
                % update bbox
                if lat < lat_min
                    lat_min = lat;
                end
                if lat > lat_max
                    lat_max = lat;
                end
                if lon < lon_min
                    lon_min = lon;
                end
                if lon > lon_max
                    lon_max = lon;
                end
            end%endfor k
            %
        end%endfor j
        allnodes = cat(1, allnodes, link.links);
    end%endif
    disp(i)
end%endfor i
% add buffer zone
lat_min = lat_min - 0.0001;
lat_max = lat_max + 0.0001;
lon_min = lon_min - 0.0001;
lon_max = lon_max + 0.0001;

bbox = [lat_max, lon_min, lat_min, lon_max];
%
[mask, canvas, satellite] = drawLinks(bbox, allnodes, 11);
mask = double(mask);
%
% canvas = canvas(2000:end, 2000:end);
% mask = mask(2000:end, 2000:end);
% satellite = satellite(2000:end, 2000:end,:);
%
save('xian_visualization_11.mat', 'canvas', 'mask')
%
imwrite(canvas, 'xian_10of10_road_11.png');
imwrite(satellite, 'xian_10of10_satellite_11.png');
imwrite(cat(3, satellite(:,:,1).*~mask + canvas(:,:,1),...
               satellite(:,:,2).*~mask + canvas(:,:,2),...
               satellite(:,:,3).*~mask + canvas(:,:,3)),... 
               'xian_10of10_fusion_11.png');