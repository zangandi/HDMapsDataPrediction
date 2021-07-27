%% This function is used to retrieve satellite image with given center point,
%  zoomlevel, and window size.
%  Andi Zang
%  function [satelliteimg, corners] = satelliteImageRetriever(center, zoomlevel, windowsize)
%  INPUT
%       center: [latitude longitude] in degree
%       zoomlevel: 1-19
%       windowsize: [W H] in meters
%  OUTPUT
%       satelliteimg:
%       corners:
%       resolution: [1 by 2], latitudinal resolution and longitudinal
%                   resolution
%       minimap:
%
function [satelliteimg, windowcornersLLA, resolution, tileXYquadkey, tileXY] = lla2tile(center, zoomlevel)
% test data
% center = [48.215141,11.502916,542.461276];
% zoomlevel = 20;
% params
% APIKEY = 'ArSkGTLs-eC_9nbM84_EJ-tjISwN7rcDT0Vvw1jQhccWLoAGJYE4jX2AapF9aBKa';
APIKEY = 'AtH2nrD6TJrRtOuyPgzKy1vo4o-GvSsk_hoFOLWUyO_SxIuC934k3aij-voob3vc';
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
% convert location to tile pixel
pixelX = ((center(2)+180)/360)*256*2^zoomlevel;
pixelY = (0.5-log((1+sin(center(1)*pi/180))/...
         (1-sin(center(1)*pi/180)))/(4*pi))*256*2^zoomlevel;
% convert tile pixel to tile
tileX = floor(pixelX/256);
tileY = floor(pixelY/256);
tileXY = [tileX tileY];
% conver tile x&y to quadkey
quadkey = tile2quad(tileX, tileY, zoomlevel);
tileXYquadkey = quadkey;
% retrieve image
satelliteimg = imread(['http://a0.ortho.tiles.virtualearth.net/tiles/a',...
                         quadkey,'.jpeg?g=131&',APIKEY]);
% check image
if size(satelliteimg,3)~=3 % no image
    disp('No image retrieved.');
    return
end
% calculate corner locations
corners = zeros(4,2); % UL->BL->UR->BR
count = 1;
for i = tileX:tileX+1
    for j = tileY:tileY+1
        lon = (360*i*256)/(256*2^zoomlevel)-180;
        k = (1/2 - (j*256)/(256*2^zoomlevel))*4*pi;
        sinLat = (exp(k)-1)/(exp(k)+1);
        lat = asind(sinLat);
        %
        corners(count,:) = [lat lon];
        count = count + 1;
    end%endfot j
end%endfor i
windowcornersLLA = corners;
% calculate resolution
% conver corners to ecef
corners_ecef = lla2ecef(cat(2, corners, [0;0;0;0]));
% calculate distance
L = norm((corners_ecef(1,:) - corners_ecef(2,:)));
R = norm((corners_ecef(3,:) - corners_ecef(4,:)));
U = norm((corners_ecef(1,:) - corners_ecef(3,:)));
B = norm((corners_ecef(2,:) - corners_ecef(4,:)));
% L->U
resolution = [(L+R)/2/256 (U+B)/2/256];
end%endfunction