%
clear all
%
addpath('.\satelliteImgRetriever\')
%
load xian_hd_maps_0602.mat
load osm_1013_link.mat
load osm_1013_adjacency.mat
load osm_1111_intersectionmap.mat
% load traffic
load traffic_1029.mat
osm_node_list = csvread('.\data\xian_osm_1009\nodes.csv');
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
%%%%%%%%%%%%%%%%%%%%%%%%%%
for m = 1:6


    save_dir = 'G:\datasets\ready_0610\';
    trace_dir = 'G:\datasets\didi\data\mm\gps_201610';
    %
    save_dir = strcat(save_dir, num2str(m), '\');
    if ~exist(save_dir, 'dir')
        mkdir(save_dir)
    end
    if m <10
        trace_dir = strcat(trace_dir, '0', num2str(m), '\');
    else
        trace_dir = strcat(trace_dir, num2str(m), '\');
    end
    %
    all_trace_dir = dir(strcat(trace_dir,'*.csv'));
    %
    [local_hd_maps_min, local_hd_maps_max] = localMinMax(hd_maps(:,:,1));
    % % write meta data
    fid = fopen(strcat(save_dir,'run.meta'), 'w+');
    fprintf(fid, 'next n: %d\n', next_n);
    fprintf(fid, 'Maps: osm_1013_link, osm_1013_adjacency, xian_hd_maps_0602, osm_1111_intersectionmap\n');
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
        basic_feature = [];
        % validate trace
        if ValidateTrace(trace, 6, 100, bbox, 100)
            % get mdc
            [total_mdc, trip_start_time_stamp, trip_end_time_stamp, mdc_level_1, mdc_level_2, mdc_level_3] =...
                           newMDC4SingleTrip(hd_maps, trace, bbox, osm_adjacency, osm_node_list, osm_intersection, link_id_list);
            %
            [trip_start_time_day, trip_start_time_time, trip_start_time_idx] = unixtime2weekdate(trip_start_time_stamp, '2018-01-01 00:00:00', 1, 8);
            [trip_end_time_day, trip_end_time_time, trip_end_time_idx] = unixtime2weekdate(trip_end_time_stamp, '2018-01-01 00:00:00', 1, 8);
            %
%             trace_uuid: string
%             trip_start_time_stamp: int
%             trip_start_time_day: int
%             trip_start_time_time: int
%             trip_start_time_idx: int
%             trip_end_time_stampX4
%             mdc_level_1: int
%             mdc_level_2: int
%             mdc_level_3: int
%             total_mdc: int
            %
            fprintf(fid2, '%s, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n', trace_uuid,...
                                                                              trip_start_time_stamp,trip_start_time_day, trip_start_time_time, trip_start_time_idx,...
                                                                              trip_end_time_stamp, trip_end_time_day, trip_end_time_time, trip_end_time_idx,...
                                                                              mdc_level_1, mdc_level_2, mdc_level_3, total_mdc);
        else
            disp(strcat(trace_uuid, [' pass.']));
        end
    end%endfor i
    fclose(fid2);
    fprintf(fid, 'Run time:%d', toc);
    fclose(fid);
end