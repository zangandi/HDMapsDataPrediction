function [dist,d,tof] = point2LineDist(c, a, b)
%% this function is used to calculate normal vector to line a-b 
% from point c
AB = b - a;
AC = c - a;
AD = dot(AC, AB/norm(AB))*AB/norm(AB);
d = AD + a;
cd = d - c;
dist = norm(cd);
ab = norm(AB);
ad = norm(AD);
bd = norm(b - d);
if bd + ad <= ab
    tof = 1;
else
    tof = 0;
end
end