%% This function is used to interpolate points.
%   Andi Zang
%   09/10
function [cp_spline, total_distance] = llaPolylineInterpolation(cps, dens)
%
if size(cps,2) < 2
    warning('Check input')
    return
end
if size(cps,2) == 2
    cps = cat(2, cps, zeros(size(cps,1),1));
end
%   convert control points to ecef
cps_ecef = lla2ecef(cps);
%
%
total_distance = 0;
cp_spline = [];
if size(cps_ecef,1)>1
    for i = 1:1:size(cps_ecef,1)-1
        dist = norm((cps_ecef(i+1,:) - cps_ecef(i,:)));
        total_distance = total_distance + dist;
        if dist > dens
            for k = 0:dens:dist
                new_pose = k/dist*(cps_ecef(i+1,:) - cps_ecef(i,:)) + cps_ecef(i,:);
                cp_spline = cat(1, cp_spline, new_pose);
            end%endfor k
        else
            cp_spline = cat(1, cp_spline, cps_ecef(i,:), cps_ecef(i+1,:));
        end
    end
    if isempty(cp_spline)
        cp_spline = cps;
    else
        cp_spline = ecef2lla(cp_spline);
    end%endif
    
else
    cp_spline = cps;
    total_distance = 0;
end%endif
end%endfunction