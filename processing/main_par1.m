%
clear all
%
addpath('.\satelliteImgRetriever\')
%
load xian_hd_maps_1111.mat
load osm_1013_link.mat
load osm_1013_adjacency.mat
load osm_1111_intersectionmap.mat
% load traffic
load traffic_1029.mat
osm_node_list = csvread('.\data\xian_osm_1009\nodes.csv');
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
%%%%%%%%%%%%%%%%%%%%%%%%%%
save_dir = 'G:\datasets\ready_1207\06\';
trace_dir = 'G:\datasets\didi\data\mm\gps_20161006\';
all_trace_dir = dir(strcat(trace_dir,'*.csv'));
%
next_n = 20;
%
[local_hd_maps_min, local_hd_maps_max] = localMinMax(hd_maps(:,:,1));
% write meta data
fid = fopen(strcat(save_dir,'run.meta'), 'w+');
fprintf(fid, 'next n: %d\n', next_n);
fprintf(fid, 'Maps: osm_1013_link, osm_1013_adjacency, xian_hd_maps_1111, osm_1111_intersectionmap\n');
fprintf(fid, 'Traffic: traffic_1029\n');
fprintf(fid, 'OSM node list: xian_osm_1009\n');
fprintf(fid, 'Trace dir: %s\n', trace_dir);
fprintf(fid, 'Bounding Box: %.8f, %.8f, %.8f, %.8f\n', bbox);

%
tic;
fid2 = fopen(strcat(save_dir,'trace_uuid.list'), 'w+');
%
for i = 1:length(all_trace_dir)-1
    %
    trace_uuid = all_trace_dir(i).name;
    trace_uuid = trace_uuid(1:end-4);
    % load trace
    trace = csvread(strcat(trace_dir,all_trace_dir(i).name),1,0);
    %
    all_feature = [];
    % validate trace
    if ValidateTrace(trace, 6, 100, bbox, 100)
        % get mdc
        mdc_of_poses = mdc(hd_maps, trace, bbox, osm_adjacency, osm_node_list, osm_intersection, link_id_list);
        % get internal features
        internal_feature = getInternalFeatures(trace);
        % get maps
%         next_n_maps = getMaps(hd_maps, trace, bbox, osm_adjacency, osm_node_list, osm_intersection, link_id_list, 10);
        try
            [next_n_maps, next_n_traffic_tti, next_n_traffic_speed, next_n_poi] = ...
                getMapsAndTraffic(hd_maps, trace, bbox, osm_adjacency, osm_node_list, osm_intersection, osm_intersection_maps,...
                                  link_id_list, speed_sequence, tti_sequence, next_n);
                              
%             ppp
            %
            % write data
            % [index, mdc, internal features .... , external features...]
            % 
            % normalization and non-linear transformation
%             mdc_of_poses_in_log = data2Log(mdc_of_poses);
             
            mdc_of_poses_normalized = normailzeData(mdc_of_poses, local_hd_maps_min, local_hd_maps_max);
            next_n_maps_normalized = normailzeData(next_n_maps, local_hd_maps_min, local_hd_maps_max);
            
            %
            %
            basic_feature = cat(2, mdc_of_poses_normalized, internal_feature,...
                                 next_n_maps_normalized);
            all_feature = cat(2, mdc_of_poses_normalized, internal_feature,...
                                 next_n_maps_normalized,...
                                 next_n_traffic_tti, next_n_traffic_speed, next_n_poi);
            csvwrite(strcat(save_dir, '\basic\', trace_uuid, '.csv'), basic_feature);
            csvwrite(strcat(save_dir, '\advanced\', trace_uuid, '.csv'), all_feature);
            % write to uuid list and stats
            trip_length = 0;
            speed = [];
            for j = 1:size(trace,1)-1
                current_distance = distanceLLA(trace(j,2:3), trace(j+1,2:3), 1);
                current_speed = current_distance/(trace(j+1,1) - trace(j,1));        
                speed = cat(1, speed, current_speed);
                trip_length = trip_length + current_distance;
            end%
            fprintf(fid2, '%s, %d, %d, %f, %f\n', trace_uuid, size(trace,1), trace(end,1) - trace(1,1), mean(speed), trip_length);
        catch
            disp(strcat(trace_uuid, [' error.']));
        end
    else
        disp(strcat(trace_uuid, [' pass.']));
    end
end%endfor i
fclose(fid2);
fprintf(fid, 'Run time:%d', toc);
