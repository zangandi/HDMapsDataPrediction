%%
% hd_maps
% bbox
% trace: [time_stamp, lat, lon, link_id]
% link_id_list
% links
% adjacency_matrix
% intersection_matrix
% shift


function [total_mdc, trip_start_time_stamp, trip_end_time_stamp, mdc_level_1, mdc_level_2, mdc_level_3] = newMDC4SingleTrip2(hd_maps, trace, ts)

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
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
% shift = [osm_to_didi_mis_lat, osm_to_didi_mis_lon];
% trace = this_locs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
number_of_poses = size(trace, 1);
%
trip_start_time_stamp = ts(1,1);
trip_end_time_stamp = ts(end,1);
%
level_1_mask = drawLinksFast(bbox, {}, zoomlevel);
level_2_mask = drawLinksFast(bbox, {}, zoomlevel);
level_3_mask = drawLinksFast(bbox, {}, zoomlevel);
%
trace(:,1) = trace(:,1) + osm_to_didi_mis_lat;
trace(:,2) = trace(:,2) + osm_to_didi_mis_lon;
%
for i = 1:number_of_poses - 1
    %
    segment = trace(i:i+1, :);
    %
    dist = distanceLLA(trace(i+1,:), trace(i,:), 0);
    %
    this_speed = dist/(ts(i+1)-ts(i));
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
% imshow(cat(3,level_1_mask,level_2_mask,level_3_mask))

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