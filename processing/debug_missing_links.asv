end_point_ids_list = [];
for i = 1:size(used_nodes_list_wo_duplication,1)
    end_point_ids_list = cat(1, end_point_ids_list, osm_node_list(used_nodes_list_wo_duplication(i),:));
end
% now we have 
num_of_nodes = size(used_nodes_list_wo_duplication,1);
num_of_links = size(osm,1);
%
adjacency_matrix = zeros(num_of_nodes, num_of_nodes);
node_to_node_link_ids = cell(num_of_nodes, num_of_nodes);
node_to_node_links = cell(num_of_nodes, num_of_nodes);
%
link_to_node_list = cell(num_of_links, 1);
link_to_node_list_in_adj_matrix = zeros(num_of_links, 4);

%
for i = 1:size(osm,1)
    this_link = osm{i};
    %
    temp_node_to_node_links = cell(num_of_nodes, num_of_nodes);
    hitmap = zeros(num_of_nodes, num_of_nodes);
    %
    for j = 1:size(this_link,1)
        %
        this_node_id = this_link(j,1);
%         this_node_id_in_whole_list = find(osm_node_list(:,1) == this_node_id);
        this_node_location = this_link(j,2:3);
        %
        start_node_id = this_link(j,4);
        end_node_od = this_link(j,5);
        %
        start_id_in_node_list = find(end_point_ids_list(:,1) == start_node_id);
        end_id_in_node_list = find(end_point_ids_list(:,1) == end_node_od);
        %
        if isempty(start_id_in_node_list) || isempty(end_id_in_node_list)
            disp(i)
        end
        % corner case
        if j ~= 1 && this_link(j,4) == this_link(j-1,1)
            previous_node_location = this_link(j-1,2:3);
            temp_node_to_node_links{start_id_in_node_list, end_id_in_node_list} = ...
            cat(1, temp_node_to_node_links{start_id_in_node_list, end_id_in_node_list}, previous_node_location);
            
        end
        
        %
        temp_node_to_node_links{start_id_in_node_list, end_id_in_node_list} = ...
            cat(1, temp_node_to_node_links{start_id_in_node_list, end_id_in_node_list}, this_node_location);
        %
        hitmap(start_id_in_node_list, end_id_in_node_list) = 1;
    end
    %
    node_to_node_links = verticalMergeCell(node_to_node_links, temp_node_to_node_links, hitmap);
    %
    disp(i)
end

number_of_intersections = size(adjacency_matrix,1);
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
for i = 1:size(osm,1)
    this_link = osm{i};
    this_link = cat(2, this_link(:,2) + osm_to_didi_mis_lat,...
                       this_link(:,3) + osm_to_didi_mis_lon);

    segment_mask = drawLinksFast(bbox, {this_link}, zoomlevel);
    canvas2 = canvas2 + segment_mask;
end
canvas2 = double(canvas2 > 0);


imshow(cat(3, canvas1,canvas2,zeros(513,510)));
