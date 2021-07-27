%% This function generates traffic information for each link
%
%
clear all
%
load xian_hd_maps_0602.mat
load traffic_1029.mat
%
load all_nodes_adjacency_0618.mat
%
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
%
number_of_intersections = size(adjacency_matrix,1);
% sparse representation
tti_value_list = [];
speed_value_list = [];
tti_location_list = [];
%
for i = 1:number_of_intersections
    for j = 1:number_of_intersections
        if ~isempty(node_to_node_links{i,j})
            aaa
            canvas = zeros(513,510);
            for k = 1:size(node_to_node_links{i,j},1)
                this_link = node_to_node_links{i,j}{k};
                this_link = cat(2, this_link(:,1) + osm_to_didi_mis_lat,...
                                   this_link(:,2) + osm_to_didi_mis_lon);

                segment_mask = drawLinksFast(bbox, {this_link}, zoomlevel);
                canvas = canvas + segment_mask;
            end
            %
            canvas = double(canvas > 0);
            %
            speed_canvas = double(sum(tti_sequence,3)>0);
            
            imshow(cat(3, canvas, canvas, speed_canvas))
            
            %
            [x,y] = find(canvas>0);
            %
            this_ttis = zeros(size(x,1),1008);
            this_speed = zeros(size(x,1),1008);
            %
            for l = 1:size(x,1)
                this_ttis(l,:) = tti_sequence(x(l),y(l),:);
                this_speed(l,:) = speed_sequence(x(l),y(l),:);
            end
            %
            median_ttis = median(this_ttis,1);
            median_speed = median(this_speed,1);
            %
            tti_location_list = cat(1, tti_location_list, [i,j]);
            tti_value_list = cat(1, tti_value_list, median_ttis);
            speed_value_list = cat(1, speed_value_list, median_speed);
        end
    end
end

save('traffic_for_graph.mat', 'adjacency_matrix', 'end_point_ids_list',...
    'speed_value_list','tti_value_list','tti_location_list');