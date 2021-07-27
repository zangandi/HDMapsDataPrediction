%%
% hd_maps
% bbox
% trace: [time_stamp, lat, lon, link_id]
% link_id_list
% links
% adjacency_matrix
% intersection_matrix
% shift


function [total_mdc, trip_start_time_stamp, trip_end_time_stamp, mdc_level_1, mdc_level_2, mdc_level_3] = newMDC4SingleTrip(hd_maps, trace, bbox, osm_adjacency, osm_node_list, osm_intersection, link_id_list)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all
% %
% addpath('.\satelliteImgRetriever\')
% load xian_hd_maps_0602.mat
% % load masks
% load osm_1013_link.mat
% load osm_1013_adjacency.mat
% % load sample traces
% trip = csvread('G:\datasets\didi\data\mm\gps_20161001\000f16030d7df2b0ec860b5c1dcf89fc.csv',1,0);
% osm_node_list = csvread('.\data\xian_osm_1009\nodes.csv');
zoomlevel = 13;
% bbox = [34.279936, 108.92185, 34.207309, 109.009348];
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
% shift = [osm_to_didi_mis_lat, osm_to_didi_mis_lon];
% trace = trip;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
number_of_poses = size(trace, 1);
trace_only = trace(:,4:5);
mm_link_id =  trace(:,6);
%
trip_start_time_stamp = trace(1,1);
trip_end_time_stamp = trace(end,1);
%
level_1_mask = drawLinksFast(bbox, {}, zoomlevel);
level_2_mask = drawLinksFast(bbox, {}, zoomlevel);
level_3_mask = drawLinksFast(bbox, {}, zoomlevel);
%
for i = 1:number_of_poses - 1
    %
    segment = trace_only(i:i+1, :);
    %
    start_point_mm_link_id = mm_link_id(i);
    end_point_mm_link_id = mm_link_id(i+1);
    %
    this_lla = [trace(i,3), trace(i,2), 0];
    next_lla = [trace(i+1,3), trace(i+1,2), 0];
    time_diff = trace(i+1,1) - trace(i,1);
    %
    this_ecef = lla2ecef(this_lla);
    next_ecef = lla2ecef(next_lla);
    %
    this_speed = norm(this_ecef - next_ecef)/time_diff;
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
            a = 0;
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
            segment = cat(1, segment(1,:), intersection_location, segment(2,:));
        end%fi

    end
    % get mask
    segment_mask = drawLinksFast(bbox, {segment}, zoomlevel);
    % overlay the mask with the HD maps
    %
    if this_speed <=5
%         se = strel('disk',1);
%         segment_mask = imdilate(segment_mask,se);
        level_1_mask = level_1_mask + segment_mask;
    elseif this_speed <=10
        se = strel('disk',1);
        segment_mask = imdilate(segment_mask,se);
        level_2_mask = level_2_mask + segment_mask;
    else
        se = strel('disk',2);
        segment_mask = imdilate(segment_mask,se);
        level_3_mask = level_3_mask + segment_mask;
    end
end%endfor i

%
mdc_level_1 = sum(sum(double(level_1_mask>0).*hd_maps(:,:,1)));
mdc_level_2 = sum(sum(double(level_2_mask>0).*hd_maps(:,:,2)));
mdc_level_3 = sum(sum(double(level_3_mask>0).*hd_maps(:,:,3)));
%
total_mdc = mdc_level_1 + mdc_level_2 + mdc_level_3;

% visualization_image = (cat(3, level_1_mask, level_2_mask, level_3_mask));
% imshow(visualization_image)
% 
% figure;
% hold on;
% % im = imread('xian_hd_maps_0602.png');
% image('CData',flipdim(visualization_image,1),'XData',[108.92185 109.009348],'YData',[34.207309 34.279936])
% bbox = [34.279936, 108.92185, 34.207309, 109.009348];
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