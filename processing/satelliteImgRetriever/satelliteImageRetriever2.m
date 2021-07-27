%% Bing Satellite Imagery Retriever
%  v2.0
%  This function is used to retrieve satellite image with given center point,
%  zoomlevel, and window size.
%  Andi Zang
%  02/23/2018
%  function [satelliteimg, corners] = satelliteImageRetriever(center, zoomlevel, windowsize)
%  INPUT
%       center: [latitude longitude] in degree
%       zoomlevel: 1-22
%       windowsize: [W H] in meters
%  OUTPUT
%       satelliteimg:
%       corners:
%       resolution:
%       minimap:
%
function [satelliteimg, bbox, resolution, windowcornersLLA] = satelliteImageRetriever2(center, zoomlevel, windowsize, apikey)
% params
% APIKEY = 'ArSkGTLs-eC_9nbM84_EJ-tjISwN7rcDT0Vvw1jQhccWLoAGJYE4jX2AapF9aBKa';
% clear all
% windowsize = [82.9421 111.07];
% originalsize = [1003,746];
% bbox = [41.930, -87.770, 41.929, -87.769];
% center = [(bbox(1)+bbox(3))/2 (bbox(2)+bbox(4))/2];
% zoomlevel = 20;
% apikey = [];
if isempty(apikey)
    APIKEY = 'AtH2nrD6TJrRtOuyPgzKy1vo4o-GvSsk_hoFOLWUyO_SxIuC934k3aij-voob3vc';
else
    APIKEY = apikey;
end%endif
% earth model
SPHEROID = referenceEllipsoid('wgs84');
% check zoom level
if zoomlevel <1 || zoomlevel > 23
    error('Zoom Level must be > 0 and < 24.')
end
if mod(zoomlevel,1) ~= 0
    zoomlevel = round(zoomlevel);
    warning(['Zoom Level must be an integer. Rounding to ', ...
             num2str(zoomlevel)]);
end
% check latitude
if abs(center(1))>85.05112878
    warning(['Max latitude should less than 85 degree.']);
    return;
end
% check longitude
if abs(center(2))>180
    warning(['Max longitude should less than 180 degree.']);
    return;
end
% reconstruct center, to add a elevation value
if size(center,2) == 2
    center = [center 0];
elseif size(center,2) == 3;
    center = center;
else
    error('Invalid center point value, it should be [lat, long, alt] or [lat, long].');
end
%
% windowcorners in local NED coordinate, Upper Left->BL->UR->BR
windowcorners = [windowsize(2)/2 -windowsize(1)/2;
                 -windowsize(2)/2 -windowsize(1)/2;
                 windowsize(2)/2 windowsize(1)/2;
                 -windowsize(2)/2 windowsize(1)/2;];
% convert the points from local NED back to LLA
windowcornersLLA = zeros(4,3);
for i = 1:4
    % NED to ECEF
    [X, Y, Z] = ned2ecef(windowcorners(i,1), windowcorners(i,2), 0,...
                        center(1), center(2), center(3), SPHEROID);
    % ECEF to LLA
    lla = ecef2lla([X Y Z]);
    windowcornersLLA(i,:) = lla;
end%endfor i
% use UL and BR to construct bounding box
bbox = [windowcornersLLA(1,1:2) windowcornersLLA(4,1:2)];
% retrieve image
[image_cropped, w, h, resolution] = satelliteImageRetrieverBoundingBox(bbox, zoomlevel, APIKEY);
%
satelliteimg = image_cropped;
%
if abs(floor(w*100) - floor(windowsize(1)*100))>1 || abs(floor(h*100) - floor(windowsize(2)*100))>1
    disp('WH error.');
end
end%endfunction