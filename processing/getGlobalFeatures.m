%% This function returns internal factors
%   Input:
%       trace: [n by 1+2+2]: n trajectory points, timestamp + raw lat lon + mm
%       lat lon.
%   Output:
%
%
%
function [feature] = getGlobalFeatures(trace)
    %
    n_poses = size(trace,1);
    %
    time_stamp = trace(:,1);
    %
    trip_total_time = time_stamp(end) - time_stamp(1);
    trip_total_distance = 0;
    %
    for i = 1:n_poses - 1
        % distance
        current_distance = distanceLLA(trace(i,2:3), trace(i+1,2:3), 1);
        trip_total_distance = trip_total_distance + current_distance;
    end
    %
    mm_distance_ratio_travelled = zeros(n_poses,1);
    mm_distance_ratio_togo = zeros(n_poses,1);
    mm_time_ratio_travelled = zeros(n_poses,1);
    mm_time_ratio_togo = zeros(n_poses,1);
    %
    distance_travelled = 0;
    time_travelled = 0;
    %
    for i = 1:n_poses
        if i == 1
            mm_distance_ratio_travelled(i) = 0;
            mm_distance_ratio_togo(i) = 1;
            mm_time_ratio_travelled(i) = 0;
            mm_time_ratio_togo(i) = 1;
        else
            % distance
            current_distance = distanceLLA(trace(i-1,2:3), trace(i,2:3), 1);
            %
            distance_travelled = distance_travelled + current_distance;
            time_travelled = time_travelled + time_stamp(i) - time_stamp(i-1);
            %
            mm_distance_ratio_travelled(i) = distance_travelled/trip_total_distance;
            mm_distance_ratio_togo(i) = 1 - distance_travelled/trip_total_distance;
            mm_time_ratio_travelled(i) = time_travelled/trip_total_time;
            mm_time_ratio_togo(i) = 1 - time_travelled/trip_total_time;
        end
    end
    %
    feature = cat(2, mm_distance_ratio_travelled, mm_distance_ratio_togo,...
                     mm_time_ratio_travelled, mm_time_ratio_togo);
end%endfunction