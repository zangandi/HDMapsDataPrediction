%% This function validates trace
%
%
%
function [tof] = ValidateTrace(trace, time_interval, distance_interval, bbox, number_of_poses)
    % a standard trace var 
    % [time stamp, lat, lon, mm_lat, mm_lon, mm_link_id]
%     trace = trip;
%     time_interval = 30;
%     distance_interval = 100;
    %
    if size(trace,1)<number_of_poses
        tof = 0;
        return
    end
    %
    time_stamp = trace(:,1);
    mm_lla = cat(2, trace(:,4), trace(:,5), zeros(size(trace,1),1));
    %
    tof = 1;
    % convert lla to ecef
    mm_ecef = lla2ecef(mm_lla);
    %
    for i = 2:size(time_stamp,1)
        % valiate time interval
        if time_stamp(i) - time_stamp(i-1) > time_interval
            tof = 0;
            break;
        end
        % valiate distance interval
        if norm(mm_ecef(i,:) - mm_ecef(i-1,:)) > distance_interval
            tof = 0;
            break;
        end
    end
    %
    if min(trace(:,3))<= bbox(3) || min(trace(:,4))<= bbox(3) ||...
       max(trace(:,3))>= bbox(1) || max(trace(:,4))>= bbox(1) ||...
       min(trace(:,2))<= bbox(2) || min(trace(:,5))<= bbox(2) ||...
       max(trace(:,2))>= bbox(4) || max(trace(:,5))>= bbox(4)
        tof = 0;
    end
    %
end%endfunction