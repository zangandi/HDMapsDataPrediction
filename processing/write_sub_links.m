%% This function writes sub-links and visualizes them
%
%
clear all
%
addpath('.\satelliteImgRetriever\')
%
load xian.mat
%
sublink_list_dir = '.\sublinks\';
%
for i = 1:13%size(road_map,1)
    %
    link = road_map{i};
    %
    % initialize bbox
    lat_min = 90;
    lat_max = -90;
    lon_min = 180;
    lon_max = -180;
    %
    if ~isempty(link)
        %
        for j = 1:size(link.links,1)
            %
            nodes = link.links{j};
            %
            sublink_name = strcat(num2str(link.id),'.',num2str(j),'.nodes');
            %
            fid = fopen(strcat(sublink_list_dir, sublink_name), 'w+');
            %
            for k = 1:size(nodes,1)
                fprintf(fid, '%.6f %.6f\n', nodes(k,2), nodes(k,1));
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
            fclose(fid);
        end%endfor j
        % add buffer zone
        lat_min = lat_min - 0.0001;
        lat_max = lat_max + 0.0001;
        lon_min = lon_min - 0.0001;
        lon_max = lon_max + 0.0001;
        %
        bbox = [lat_max, lon_min, lat_min, lon_max];
        %
        [mask, canvas] = drawLinks(bbox, link.links, 16);
        %
        imwrite(canvas, strcat(sublink_list_dir, num2str(link.id), '.png'));
    end%endif
end%endfor i