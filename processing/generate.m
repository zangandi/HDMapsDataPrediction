clear all
addpath('..\jsonlab-2.0\')




for i = 1:30
    % load trips
    A = loadjson(strcat('G:\didi\data\',num2str(i),'.json'));
    % load raw and ts
    B = load(strcat('G:\didi\data\',num2str(i),'_w_ts.mat'));
    all_trips_w_ts = B.all_trips_w_ts;
    %
    mm_results_in_graph = cell(0);
    counter = 1;
    %
    if size(A,2) == size(all_trips_w_ts,2)
        %
        for j = 1:size(A,2)
            this_trip_cpath = A{j}.Cpath;
            this_trip_opath = A{j}.Opath;
            this_trip_id = A{j}.traj_id;
            if ~isempty(this_trip_opath)
                this_trip_raw_locs = all_trips_w_ts{j}.locs;
                this_trip_raw_ts = all_trips_w_ts{j}.ts;
                %
%                 this_trip_node = zeros(size(this_trip_cpath,2)+1,4);
                %
                %
                if size(this_trip_raw_ts,1) ~= size(this_trip_opath,2)
                    disp('==========')
                    disp(i)
                    disp(j)
                else
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
                    %
                    if size(this_trip_node,1) == size(this_trip_cpath,2) + 1
                        mm_results_in_graph{counter}.Cpath = this_trip_cpath;
                        mm_results_in_graph{counter}.id = this_trip_id;
                        mm_results_in_graph{counter}.timestamp = this_trip_node;
                        counter = counter + 1;
                    else
%                         disp('==========')
%                         disp(i)
%                         disp(j)
                    end
                    %
                end
                
            end
        end
        %
        savejson([],mm_results_in_graph,strcat('G:\didi\data\mm_results_in_graph_w_ts\',num2str(i),'.json'));
        
        %
    else
        disp(i)
    end
end
