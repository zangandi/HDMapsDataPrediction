%%


function [next_n_maps, next_n_traffic_tti, next_n_traffic_speed, next_n_poi] = getMapsAndTraffic(hd_maps, trace, bbox, osm_adjacency, osm_node_list, osm_intersection, osm_intersection_maps, link_id_list, speed_sequence, tti_sequence, next_n)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all
% %
% load xian_hd_maps_1022.mat
% % load mask
% load osm_1013_link.mat
% % load 
% load osm_1013_adjacency.mat
% % load sample traces
% trip = csvread('.\data\mm\trip_50\32f86d6026f8d5dcbc0156aab67f37e3.csv',1,0);
% osm_node_list = csvread('.\data\xian_osm_1009\nodes.csv');
zoomlevel = 13;
% bbox = [34.279936, 108.92185, 34.207309, 109.009348];
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
% % shift = [osm_to_didi_mis_lat, osm_to_didi_mis_lon];
% trace = trip;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
blank_image = bbox2canvas(bbox, zoomlevel);
%
time_stamp = trace(:,1);
%
number_of_poses = size(trace, 1);
next_n_maps = zeros(number_of_poses, next_n);
next_n_traffic_tti = zeros(number_of_poses, next_n);
next_n_traffic_speed = zeros(number_of_poses, next_n);
next_n_poi = zeros(number_of_poses, next_n);
trace_only = trace(:,4:5);
mm_link_id =  trace(:,6);
%
new_trace = [];
%
for i = 1:number_of_poses - 1
    %
    segment = trace_only(i:i+1, :);
    %
    start_point_mm_link_id = mm_link_id(i);
    end_point_mm_link_id = mm_link_id(i+1);%
    %
    if start_point_mm_link_id ~= end_point_mm_link_id
        %
%         start_mask = drawLinksFast(bbox, {[segment(1,:);segment(1,:)]}, zoomlevel);
%         end_mask = drawLinksFast(bbox, {[segment(2,:);segment(2,:)]}, zoomlevel);
        % check if exists the start point and end point
%         [start_x, start_y] = find(start_mask == 1);
%         [end_x, end_y] = find(end_mask == 1);
        %
        start_link_index = find(link_id_list == start_point_mm_link_id);
        end_link_index = find(link_id_list == end_point_mm_link_id);
        % find the intersection
        intersection_index = osm_adjacency(min(start_link_index, end_link_index),...
                                           max(start_link_index, end_link_index));
        if intersection_index == 0
%             disp(['start link id:' num2str(start_link_index)]);
%             disp(['end link id:' num2str(end_link_index)]);
%             disp(['Trace id:' num2str(i)]);
            new_trace = cat(1, new_trace, {trace_only(i,:)});
        else
            point_to_intersection_dist = zeros(intersection_index,1);
            %
            intersection_ids = osm_intersection{min(start_link_index, end_link_index),...
                                                 max(start_link_index, end_link_index)};
            % pick a point
            p1 = trace_only(i,:);
            %
            for j = 1:intersection_index
                intersection_idx = find(osm_node_list(:,1) == intersection_ids(j));
                %
                intersection_location = osm_node_list(intersection_idx,2:3)+...
                                        [osm_to_didi_mis_lat, osm_to_didi_mis_lon];
                point_to_intersection_dist(j) = distanceLLA(p1,...
                                                            intersection_location,...
                                                            0);
            end%endfor j
            [~, min_idx] = min(point_to_intersection_dist);
            intersection_idx = find(osm_node_list(:,1) == intersection_ids(min_idx));
            intersection_location = osm_node_list(intersection_idx,2:3)+...
                                    [osm_to_didi_mis_lat, osm_to_didi_mis_lon];
            new_trace = cat(1, new_trace, {[segment(1,:); intersection_location]});
        end%fi
        
    else
            new_trace = cat(1, new_trace, {trace_only(i,:)});
    end
    % 
end%endfor i
%
new_trace = cat(1, new_trace, {trace_only(end,:)});
%
% new_trace = cat(2, new_trace, zeros(size(new_trace,1),1));
% new_trace = llaPolylineInterpolation(new_trace, 5);
% % %
% xy = lla2bbox(new_trace, bbox, [size(blank_image,1), size(blank_image,2)]);
% %
% xy = removeDuplicatedListMat(xy);
%
for i = 1:number_of_poses
    %
    rest_trace = [];
    for j = i:number_of_poses
        rest_trace = cat(1, rest_trace, new_trace{j});
    end
    %
    current_time_stamp = time_stamp(i);
    [~,~,current_time_stamp_idx] = unixtime2weekdate(current_time_stamp, '2018-01-01 00:00:00', 1, 8);
    %
    rest_trace = cat(2, rest_trace, zeros(size(rest_trace,1),1));
    rest_trace = llaPolylineInterpolation(rest_trace, 5);
    %
    rest_xy = lla2bbox(rest_trace, bbox, [size(blank_image,1), size(blank_image,2)]);
    rest_xy = removeDuplicatedListMat(rest_xy);
    %
    for j = 1:min(size(rest_xy,1), next_n)
%         try
            next_n_maps(i,j) = hd_maps(rest_xy(j,1), rest_xy(j,2), 1);
            next_n_traffic_tti(i,j) = tti_sequence(rest_xy(j,1), rest_xy(j,2), current_time_stamp_idx);
            next_n_traffic_speed(i,j) = speed_sequence(rest_xy(j,1), rest_xy(j,2), current_time_stamp_idx);
            next_n_poi(i,j) = osm_intersection_maps(rest_xy(j,1), rest_xy(j,2));
%         catch
%             disp('Out of bounds.')
%         end
    end%endfor j
end

% figure;
% hold on;
% osm_to_didi_mis_lon = 0.0047;
% osm_to_didi_mis_lat =-0.0016;
% for i = 1:size(osm,1)
%     link = osm{i};
%     plot(link(:,2) + osm_to_didi_mis_lon, link(:,1) + osm_to_didi_mis_lat,'k--', 'linewidth', 1);
% end
% %
% plot(trace_only(:,2), trace_only(:,1),'r-', 'linewidth', 2);
% plot(segment(:,2), segment(:,1),'g-', 'linewidth', 10);
% plot(segment2(:,2), segment2(:,1),'b-', 'linewidth', 2);