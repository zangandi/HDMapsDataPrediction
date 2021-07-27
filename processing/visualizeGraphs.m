%% visualize graph
%
%

figure 
hold on
%
osm_to_didi_mis_lon = 0;
osm_to_didi_mis_lat = 0;
% draw osm
for i = 1:length(osm)
    link = osm{i};
    plot(link(:,3) + osm_to_didi_mis_lon, link(:,2) + osm_to_didi_mis_lat,'k--', 'linewidth', 1);
end
% draw nodes
for i = 1:size(end_point_ids_list,1)
    node_idx = find(osm_node_list(:,1)==end_point_ids_list(i));
    plot(osm_node_list(node_idx,3) + osm_to_didi_mis_lon, osm_node_list(node_idx,2) + osm_to_didi_mis_lat,'ro', 'linewidth', 1);
end
% draw links
for i = 1:size(adjacency_matrix,1)
    for j = 1:size(adjacency_matrix,2)
        if adjacency_matrix(i,j) ~= 0
            start_node_idx = find(osm_node_list(:,1)==end_point_ids_list(i));
            end_node_idx = find(osm_node_list(:,1)==end_point_ids_list(j));
            plot([osm_node_list(start_node_idx,3) + osm_to_didi_mis_lon, osm_node_list(end_node_idx,3) + osm_to_didi_mis_lon],...
                 [osm_node_list(start_node_idx,2) + osm_to_didi_mis_lat, osm_node_list(end_node_idx,2) + osm_to_didi_mis_lat],...
                 'r-', 'linewidth', 1);
        end
    end
end