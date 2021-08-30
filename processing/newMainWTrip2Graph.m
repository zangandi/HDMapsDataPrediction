%
clear all
%
addpath('.\satelliteImgRetriever\')
%
load xian_hd_maps_0602.mat
load osm_1013_link.mat
load osm_1013_adjacency.mat
load osm_1111_intersectionmap.mat
load all_nodes_adjacency_0810.mat
% load traffic
load traffic_1029.mat
% osm_node_list = csvread('.\data\xian_osm_1009\nodes.csv');
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
%%%%%%%%%%%%%%%%%%%%%%%%%%
for m = 1:1


    save_dir = 'F:\didi\ready_0716\';
    trace_dir = 'F:\didi\data\gps_201610';
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
    %
    all_trips = cell(0);
    %
    for i = 1:length(all_trace_dir)-1
        %
        trace_uuid = all_trace_dir(i).name;
        trace_uuid = trace_uuid(1:end-4);
        % load trace
        trace = csvread(strcat(trace_dir,all_trace_dir(i).name),1,0);
        % validate trace
        if ValidateTrace(trace, 9, 100, bbox, 100)
            % convert trip to graph
            [whole_trip] = trip2Graph(trace, osm, link_id_list);
            if ~isempty(whole_trip)
            % get mdc
                [total_mdc, trip_start_time_stamp, trip_end_time_stamp, mdc_level_1, mdc_level_2, mdc_level_3] =...
                               newMDC4SingleTrip(hd_maps, whole_trip, bbox, osm_adjacency, osm_node_list, osm_intersection, link_id_list);
                %
                [d_t_idx] = unixtime2weekdateMat(whole_trip(:,1), '2018-01-01 00:00:00', 1, 8);
%                 [trip_start_time_day, trip_start_time_time, trip_start_time_idx] = unixtime2weekdate(trip_start_time_stamp, '2018-01-01 00:00:00', 1, 8);
%                 [trip_end_time_day, trip_end_time_time, trip_end_time_idx] = unixtime2weekdate(trip_end_time_stamp, '2018-01-01 00:00:00', 1, 8);
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
                % 
                this_trip.trip = whole_trip;
                this_trip.total_mdc = total_mdc;
                this_trip.trace_uuid = trace_uuid;
                this_trip.time = d_t_idx;
                %
                all_trips = cat(1, all_trips, this_trip);      
                %
                disp(strcat(trace_uuid, [' --> '], num2str(size(whole_trip,1))));
            end
        else
%             disp(strcat(trace_uuid, [' pass.']));
            continue
        end
    end%endfor i
    %
    save(strcat(save_dir,'all_trips.mat'), 'all_trips');
end