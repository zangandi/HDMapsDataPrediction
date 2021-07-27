%% This function returns internal factors
%   Input:
%       trace: [n by 1+2+2]: n trajectory points, timestamp + raw lat lon + mm
%       lat lon.
%   Output:
%
%
%
function [feature] = getInternalFeatures(trace)
    %
    n_poses = size(trace,1);
    %
    time_stamp = trace(:,1);
    mm_lla = cat(2, trace(:,4), trace(:,5), zeros(n_poses,1));
    raw_lla = cat(2, trace(:,3), trace(:,2), zeros(n_poses,1));
    % convert lla to ecef
    mm_ecef = lla2ecef(mm_lla);
    raw_ecef = lla2ecef(raw_lla);
    %
%     feature = zeros(n_poses,1+1+3+3);
    %
    raw_speed = zeros(n_poses,1);
    mm_speed = zeros(n_poses,1);
    raw_heading = zeros(n_poses,3);
    mm_heading = zeros(n_poses,3);
    time_stamp_diff = zeros(n_poses,1);
    %
    for i = 1:n_poses - 1
        raw_speed(i) = norm(raw_ecef(i,:) - raw_ecef(i+1,:))/(time_stamp(i+1)-time_stamp(i));
        mm_speed(i) = norm(mm_ecef(i,:) - mm_ecef(i+1,:))/(time_stamp(i+1)-time_stamp(i));
        if norm(raw_ecef(i,:) - raw_ecef(i+1,:)) ~= 0
            raw_heading(i,:) = (raw_ecef(i+1,:) - raw_ecef(i,:))/norm(raw_ecef(i,:) - raw_ecef(i+1,:));
        else
            raw_heading(i,:) = [0 0 0];
        end
        if norm(mm_ecef(i,:) - mm_ecef(i+1,:)) ~= 0
            mm_heading(i,:) = (mm_ecef(i+1,:) - mm_ecef(i,:))/norm(mm_ecef(i,:) - mm_ecef(i+1,:));
        else
            mm_heading(i,:) = [0 0 0];
        end
        %
        time_stamp_diff(i+1) = time_stamp(i+1) - time_stamp(i); 
    end
    %
    feature = cat(2, time_stamp_diff, raw_speed, mm_speed, raw_heading, mm_heading);
end%endfunction
% visualize the stats

[a,b] = hist(all_traces(:,2),[0:1:25]);
all_points = sum(a);
all_points_no_zero = sum(a)-a(1);
a_no_zero = a;
a_no_zero(1) = 0;

a_no_zero = a_no_zero./all_points_no_zero.*100;
a = a./all_points.*100;

c = cat(1,a,a_no_zero);
figure
bar(c')
legend({'w 0s', 'w/ 0s'})
xlabel('Speed ^{m}/_{s}')
ylabel('100%')