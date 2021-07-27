%%
%
%
%
function [dist] = distanceLLA(p1, p2, reverse_flag)
%
if size(p1,2) == 2 && size(p2,2) == 2 && reverse_flag == 0
    p1 = [p1(1:2) 0];
    p2 = [p2(1:2) 0];
elseif size(p1,2) == 2 && size(p2,2) == 2 && reverse_flag == 1
    p1 = [p1(2) p1(1) 0];
    p2 = [p2(2) p2(1) 0];
elseif size(p1,2) == 3 && size(p2,2) == 3 && reverse_flag == 0
    p1 = p1;
    p2 = p2;
elseif size(p1,2) == 3 && size(p2,2) == 3 && reverse_flag == 1
    p1 = [p1(2) p1(1) p1(3)];
    p2 = [p2(2) p2(1) p2(3)];
else
    warn('error1')
end
%
dist = norm(lla2ecef(p1) - lla2ecef(p2));
end