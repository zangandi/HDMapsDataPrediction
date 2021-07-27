%% Filer out maps
%
clear all
%
load('xian.mat');
%
max_lat = 34.279936;
min_lat = 34.207309;
max_lon = 109.009348;
min_lon = 108.92185;
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
%
filtered_road_map_links = {};
filtered_road_map_ids = [];
%
for i = 1:size(road_map,1)
    if ~isempty(road_map{i})
        %
        id = road_map{i}.id;
        link = road_map{i}.links;
        %
        all_nodes = [];
        %
        for j = 1:size(link,1)
            nodes = link{j};
            all_nodes = cat(1, all_nodes, nodes);
        end%endfor j
        %
        for j = 1:size(all_nodes,1)
            if all_nodes(j,1)>= min_lon && all_nodes(j,1)<= max_lon &&...
               all_nodes(j,2)>= min_lat && all_nodes(j,2)<= max_lat
                filtered_road_map_ids = cat(1, filtered_road_map_ids, id);
                %
                new_link = merge_segments(link);
                filtered_road_map_links = cat(1, filtered_road_map_links, {new_link});
                break;
            end%endif
        end%endfor j
    end
end%endfor i
save('xian_filtered.mat', 'filtered_road_map_links', 'filtered_road_map_ids')