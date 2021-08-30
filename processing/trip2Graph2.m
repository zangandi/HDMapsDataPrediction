%% This function converts link to given graph
%  This is the newer version, which consists of 
%   start point -> intersetion -> intersection -> ... -> end point
%
%
%

function [whole_trip] = trip2Graph2(trip, osm, link_id_list)
% end
%
% clear all
% load all_nodes_adjacency_0618.mat
%
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
bbox = [34.279936, 108.92185, 34.207309, 109.009348];

% load a sample trip
trip = csvread('.\data\gps_20161001\000f16030d7df2b0ec860b5c1dcf89fc.csv',1,0);

% filter trip
[new_trip_filtered] = trip_mm_filter(trip, osm, link_id_list);
%
if ~isempty(new_trip_filtered)
    trip = new_trip_filtered;
    %
    portions = zeros(size(trip,1), 4);
    %
    for i = 1:size(trip,1)
        %
        this_raw_loc = trip(i,3:-1:2);
        this_mm_loc = trip(i,4:5);
        this_mm_link_id = trip(i,6);
        % find the index of this traj
        link_index = find(link_id_list == this_mm_link_id);
        % reference link
        reference_link = osm{link_index};
        % find its nearest line segment
        [min_dist, segment_id, segment_portion] = point2LineSegmentsDistLLA(this_mm_loc,...
                                                  reference_link(:,2:3)+...
                                                  repmat([osm_to_didi_mis_lat, osm_to_didi_mis_lon], size(reference_link,1),1));
        %
        start_node_id_of_this_segment = reference_link(segment_id,4);
        end_node_id_of_this_segment = reference_link(segment_id,5);
        %
        portions(i,:) = [start_node_id_of_this_segment, end_node_id_of_this_segment, segment_portion];
        %
%         if segment_portion(1) > 1 || segment_portion(2) > 1
%             disp(i)
%         end
        %
    end
    whole_trip = cat(2, trip, portions);
else
    whole_trip = [];
end

%
trip_in_graph = [];
for i = 2:size(whole_trip,1)
    if whole_trip(i,6)~= whole_trip(i-1,6)
        if whole_trip(i,8) == whole_trip(i-1,8)
            trip_in_graph = cat(1, trip_in_graph, whole_trip(i,8));
        elseif whole_trip(i,7) == whole_trip(i-1,7)
            trip_in_graph = cat(1, trip_in_graph, whole_trip(i,7));
        elseif whole_trip(i,7) == whole_trip(i-1,8)
            trip_in_graph = cat(1, trip_in_graph, whole_trip(i,7));
        elseif whole_trip(i,8) == whole_trip(i-1,7)
            trip_in_graph = cat(1, trip_in_graph, whole_trip(i,8));
        end
    end
end

figure
hold on
plot(reference_link(:,3)+osm_to_didi_mis_lon, reference_link(:,2)+osm_to_didi_mis_lat, 'r-');
plot(this_mm_loc(2), this_mm_loc(1), 'ro');
plot(this_raw_loc(2), this_raw_loc(1), 'bo');
% 
% %
figure;
hold on;
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat = -0.0016;
for i = 1:size(osm)
    link = osm{i};
    plot(link(:,3) + osm_to_didi_mis_lon, link(:,2) + osm_to_didi_mis_lat,'k--', 'linewidth', 1);
end

for i = 1:size(end_point_ids_list,1)
    idx = find(osm_node_list(:,1) == end_point_ids_list(i));
    plot(osm_node_list(idx,3) + osm_to_didi_mis_lon, osm_node_list(idx,2) + osm_to_didi_mis_lat,'go', 'linewidth', 1);
end

% %
plot(new_trip_filtered(:,5), new_trip_filtered(:,4),'b-', 'linewidth', 2);
plot(trip(:,2), trip(:,3),'r-', 'linewidth', 2);

for i = 1:size(new_trip_filtered,1)
    plot(new_trip_filtered(:,5), new_trip_filtered(:,4),'bo', 'linewidth', 2);
end