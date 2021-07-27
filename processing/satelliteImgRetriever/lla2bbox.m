%% Points locations (in LLA) to local locations (in pixel)
%  This function returns point locations in LLA to local gridded
%  locations in pixel, with given bounding box and resolution.
%  Andi Zang
%  02/26/2018
%
%  Input:
%       points: N by 2/3, point locations in LLA coordinate
%       bbox: 1 by 4, [top_left_lat, top_left_lon, bottom_right_lat, bottom_right_lon] in degree
%       bboxsize: 1 by 2, [image height, image width]
%   Output:
%       xy: N by 2, point locations local coordinate
%
function [xy] = lla2bbox(points, bbox, bboxsize)
% check bounding box
if bbox(1) <= bbox(3) || bbox(2)>= bbox(4)
    error('Please check the bounding box.');
end
% check points
if size(points,2) == 2
    points = points;
elseif size(points,2) == 3
    points = points(:,1:2);
else
    error('Please check points size.');
end%endif
%
h = bboxsize(1);
w = bboxsize(2);
% initialize xy
xy = zeros(size(points,1),2);
% assign location to each point
for i = 1:size(points,1)
    %
    x_ratio = (points(i,1) - bbox(1))/(bbox(3) - bbox(1));
    y_ratio = (points(i,2) - bbox(2))/(bbox(4) - bbox(2));
    %
    x = round(x_ratio*h);
    y = round(y_ratio*w);
    %
    if x > 0 && x <= h
        x= x;
    else
        %warning('x out of bound.');
    end
    %
    if y > 0 && y <= w
        y= y;
    else
        %warning('y out of bound.');
    end
    %
    xy(i,:) = [x, y];
end%endfor
end%endfunction