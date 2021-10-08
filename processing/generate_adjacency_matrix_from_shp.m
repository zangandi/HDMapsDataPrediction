%% This function converts shp files (edge and node) into adjacency matrix
%
%
clear all

edge_shp = shaperead('..\mapmatching\network\edges.shp');
node_shp = shaperead('..\mapmatching\network\nodes.shp');
%
A = loadjson('..\mapmatching\mm_test.json');
a_trip = A{6};
%
number_of_links = length(edge_shp);
%
adjacency_mat = zeros(number_of_links, number_of_links);
% search all links
for i = 1:size(edge_shp)
    ui = edge_shp(i).u;
    vi = edge_shp(i).v;
    for j = 1:size(edge_shp)
        if adjacency_mat(i,j) ~= 0
            aaa
        end
        if i ~= j
            uj = edge_shp(j).u;
            vj = edge_shp(j).v;
            %
            if vi == vj || vi == uj
                adjacency_mat(i,j) = vi;
            elseif ui == uj || ui == vj
                adjacency_mat(i,j) = ui;
            end
        end
    end
end

save('links_adj_matrix.mat', 'edge_shp', 'node_shp', 'adjacency_mat');
%

node_list = a_trip.Cpath

node_locations = [];

for i = 1:size(node_list,2)-1
    this_link_id = node_list(i);
    next_link_id = node_list(i+1);
    node_id = adjacency_mat(next_link_id, this_link_id)
end
