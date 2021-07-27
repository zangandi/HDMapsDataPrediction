%%


function [min_dist, segment_id, segment_portion] = point2LineSegmentsDistLLA(point, points)
%
% point = this_mm_loc;
% points = reference_link(:,2:3)+...
%          repmat([osm_to_didi_mis_lat, osm_to_didi_mis_lon], size(reference_link,1),1);
% covert LLA to ECEF
if size(point,2) == 2
    point = [point 0];
end

if size(points,2) == 2
    points = cat(2, points, zeros(size(points,1),1));
end

point_ecef = lla2ecef(point);
points_ecef = lla2ecef(points);
%
num_of_segments = size(points,1)-1;
dist_to_each_segment = zeros(num_of_segments,1);
dist_to_each_segment_penalty = zeros(num_of_segments,1);
portion_on_each_segment = zeros(num_of_segments,2);
% check each segment
for i = 1:num_of_segments
    [dist,d] = point2LineDist(point_ecef, points_ecef(i,:), points_ecef(i+1,:));
    dist_to_each_segment(i) = dist;
    portion_on_each_segment(i,1) = norm(d-points_ecef(i,:))/norm(points_ecef(i,:)-points_ecef(i+1,:));
    portion_on_each_segment(i,2) = norm(d-points_ecef(i+1,:))/norm(points_ecef(i,:)-points_ecef(i+1,:));
    if portion_on_each_segment(i,1)> 1.00 || portion_on_each_segment(i,2) > 1.00
        dist_to_each_segment_penalty(i) = Inf;
    else
        dist_to_each_segment_penalty(i) = dist;
    end
end
% find the nearest one
[min_dist, segment_id] = min(dist_to_each_segment_penalty);
segment_portion = portion_on_each_segment(segment_id,:);

end%endfunction