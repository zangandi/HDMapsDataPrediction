%%
clear all

trace_dir = 'G:\datasets\didi\data\mm\gps_201610';
%

%
% speed = [];
trip_length = [];
trip_duration = [];
timewindow_count = zeros(6*24, 7);
%
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
%
for m = 1:30
    if m <10
        day_trace_dir = strcat(trace_dir, '0', num2str(m), '\');
    else
        day_trace_dir = strcat(trace_dir, num2str(m), '\');
    end
    %
    all_trace_dir = dir(strcat(day_trace_dir,'*.csv'));

    for i = 1:length(all_trace_dir)
        % load trace
        trace = csvread(strcat(day_trace_dir,all_trace_dir(i).name),1,0);
        
        if ValidateTrace(trace, 6, 100, bbox, 100)
            %
            [time_d, time_t, time_idx] = unixtime2weekdate(trace(1,1), '2018-01-01 00:00:00', 1, 8);
            %
            timewindow_count(time_t, time_d) = timewindow_count(time_t, time_d) + 1;   
            %
            current_length = 0;
            current_duration = trace(end,1) - trace(1,1);
            %
            for j = 1:size(trace,1)-1
                current_distance = distanceLLA(trace(j,4:5), trace(j+1,4:5), 0);
    %             current_speed = current_distance/(trace(j+1,1) - trace(j,1));        
    %             speed = cat(1, speed, current_speed);
                current_length = current_length + current_distance;
            end%
            %
            trip_length = cat(1, trip_length, current_length);
            trip_duration = cat(1, trip_duration, current_duration);
        end
        %
        if mod(i,1000) == 0
            disp(i)
        end
        %
    end%endfor i
    %
    disp(m)
end
%
save('mdc_trip_stats.mat', 'trip_length', 'trip_duration', 'timewindow_count');


%