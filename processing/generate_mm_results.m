clear all
addpath('..\jsonlab-2.0\')
addpath('.\satelliteImgRetriever\')

addpath('.\satelliteImgRetriever\')
load xian_hd_maps_0602.mat


counter = 1;
training_data = [];
%
for i = 1:30
    % load trips
    A = loadjson(strcat('G:\didi\data\',num2str(i),'.json'));
    % load raw and ts
    B = load(strcat('G:\didi\data\',num2str(i),'_w_ts.mat'));
    all_trips_w_ts = B.all_trips_w_ts;
    %
    
    c = 0;
    %
    if size(A,2) == size(all_trips_w_ts,2)
        for j = 1:size(A,2)
            this_trip_cpath = A{j}.Cpath;
            this_trip_opath = A{j}.Opath;
%             [raw_lon, raw_lat] = linestring2xy(raw_str);
            %
            this_trip_raw_locs = all_trips_w_ts{j}.locs;
            this_trip_raw_ts = all_trips_w_ts{j}.ts;
            
            this_locs = all_trips_w_ts{j}.locs;
            ts = all_trips_w_ts{j}.ts;
            if size(this_locs,1) >= 100 && size(this_trip_opath,2) == size(this_locs,1)
                this_trip_node = [];
                this_trip_node(1,1) = this_trip_raw_ts(1,1);
                [a,b,c] = unixtime2weekdate(this_trip_raw_ts(1,1), '2018-01-01 00:00:00', 1, 8);
                this_trip_node(1,2:4) = [a,b,c];
                for k = 1:size(this_trip_opath,2)-1
                    if this_trip_opath(k) ~= this_trip_opath(k+1);
                        this_ts = (this_trip_raw_ts(k,1)+this_trip_raw_ts(k+1,1))/2;
                        this_trip_node_temp(1,1) =  this_ts;
                        [a,b,c] = unixtime2weekdate(this_ts, '2018-01-01 00:00:00', 1, 8);
                        this_trip_node_temp(1,2:4) = [a,b,c];
                        %
                        this_trip_node = cat(1, this_trip_node, this_trip_node_temp);
                        %
                        %disp(this_trip_opath(k));
                    end
                end
                %
                this_trip_node_last = [];
                this_trip_node_last(1,1) = this_trip_raw_ts(end,1);
                [a,b,c] = unixtime2weekdate(this_trip_raw_ts(end,1), '2018-01-01 00:00:00', 1, 8);
                this_trip_node_last(1,2:4) = [a,b,c];
                %
                this_trip_node = cat(1, this_trip_node, this_trip_node_last);
                %%
                if size(this_trip_node,1) == size(this_trip_cpath,2) + 1
                    [total_mdc, trip_start_time_stamp, trip_end_time_stamp, mdc_level_1, mdc_level_2, mdc_level_3] =...
                                                                                newMDC4SingleTrip2(hd_maps, this_locs, ts);
                    %                                                      
                    training_data{counter}.mdc = total_mdc;
                    training_data{counter}.duration = ts(end) - ts(1);
                    training_data{counter}.timestamp = ts;
                    training_data{counter}.locs = this_locs;
                    
                    training_data{counter}.cpath = this_trip_cpath;
                    training_data{counter}.cpath_timestamp = this_trip_node;
                    training_data{counter}.length = tripLength(this_locs);
                    
                    counter = counter + 1
                end
            end
        end
    end
end

save('raw_training_trips.mat', 'training_data');