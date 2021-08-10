clear all
load osm_0614_link.mat
load osm_1013_adjacency.mat
osm_node_list = csvread('.\data\nodes.csv');
trip = csvread('G:\datasets\didi\data\mm\gps_20161001\000f16030d7df2b0ec860b5c1dcf89fc.csv',1,0);
% check all end points
all_end_points = [];
% check all the nodes with two links
nodes_link_count = zeros(size(osm_node_list,1),1);
% go through all links
for i = 1:size(link_id_list,1)
    this_link = osm{i};
    start_node_id = this_link(1,1);
    end_node_id = this_link(end,1);
    all_end_points = cat(1, all_end_points, start_node_id, end_node_id);
    %
    for j = 1:size(this_link,1)
        this_node_id = this_link(j,1);
        % 
        idx = find(osm_node_list == this_node_id);
        if isempty(idx)
            disp(i);
            disp(j);
        end
        %
        nodes_link_count(idx) = nodes_link_count(idx) + 1;
    end
end

for i = 1:size(all_end_points,1)
    this_node_id = all_end_points(i);
    idx = find(osm_node_list == this_node_id);
    if isempty(idx)
        disp(i);
    end
        %
    nodes_link_count(idx) = nodes_link_count(idx) + 2;
end

% used nodes list
used_nodes_list_wo_duplication = [];

for i = 1:size(nodes_link_count,1)
    if nodes_link_count(i) > 1
        used_nodes_list_wo_duplication = cat(1, used_nodes_list_wo_duplication, i);
    end
end

%
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


%%
save('all_nodes_adjacency_0810.mat',...
    'adjacency_matrix', 'node_to_node_link_ids', 'node_to_node_links', 'end_point_ids_list',...
    'osm_node_list', 'osm', 'link_id_list', 'link_to_node_list');

%%
% filter trip
new_trip = trip;
for i = 3:size(trip,1)-2
    this_section = trip(i-2:i+2,6);
    this_most_freq = mode(this_section);
    %
    if trip(i,6)~=this_most_freq
        new_trip(i,6) = this_most_freq;
    end
end

%
figure;
hold on;
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat = -0.0016;
for i = 1:size(osm)
    link = osm{i};
    plot(link(:,3) + osm_to_didi_mis_lon, link(:,2) + osm_to_didi_mis_lat,'k--', 'linewidth', 1);
end
% %
for i = 1:size(trip,1)
    plot(trip(i,2), trip(i,3),'bo', 'linewidth', 2);
    plot(trip(i,5), trip(i,4),'ro', 'linewidth', 2);
    plot([trip(i,2), trip(i,5)], [trip(i,3), trip(i,4)],'g-', 'linewidth', 2);
end
plot(trip(:,2), trip(:,3),'b-', 'linewidth', 2);
plot(trip(:,5), trip(:,4),'r-', 'linewidth', 2);
%




trip = csvread('G:\datasets\didi\data\mm\gps_20161001\0a2489d980291baf4cd26ef467cc429a.csv',1,0);
%
used_link_list = [];
for i = 1:size(trip,1)
    %
    traj_point = trip(i,4:5);
    traj_point_ecef = lla2ecef([traj_point,0]);
    %
    mm_link_id = trip(i,6);
    %
    mm_link_idx = find(link_id_list==mm_link_id);
    %
    this_link = osm{mm_link_idx}
    used_link_list = cat(1, used_link_list, mm_link_idx);
end

used_link_list = removeDuplicatedListMat(used_link_list);



figure;
hold on;
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat = -0.0016;
for i = 1:size(used_link_list,1)
    link = osm{used_link_list(i)};
    plot(link(:,3) + osm_to_didi_mis_lon, link(:,2) + osm_to_didi_mis_lat,'k--', 'linewidth', 1);
end
% %
plot(trip(:,5), trip(:,4),'r-', 'linewidth', 2);
plot(trip(:,5), trip(:,4),'go', 'linewidth', 2);