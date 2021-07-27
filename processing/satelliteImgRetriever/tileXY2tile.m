%% This function is used to retrieve satellite image with given tileXY
%  Andi Zang
%  function [satelliteimg, windowcornersLLA, resolution, tileXYquadkey] = tileXY2tile(tileXY)
%  INPUT
%       tileXY = [tileX tileY]
%  OUTPUT
%       satelliteimg:
%       corners:
%       resolution: [1 by 2], latitudinal resolution and longitudinal
%                   resolution
%       minimap:
%
function [satelliteimg, windowcornersLLA, resolution, tileXYquadkey] = tileXY2tile(tileXY, zoomlevel, apikey)
% test data
% center = [48.215141,11.502916,542.461276];
% zoomlevel = 20;
% params
% APIKEY = 'ArSkGTLs-eC_9nbM84_EJ-tjISwN7rcDT0Vvw1jQhccWLoAGJYE4jX2AapF9aBKa';
if isempty(apikey)
    APIKEY = 'AtH2nrD6TJrRtOuyPgzKy1vo4o-GvSsk_hoFOLWUyO_SxIuC934k3aij-voob3vc';
else
    APIKEY = apikey;
end%endif
% convert tile pixel to tile
tileX = tileXY(1);
tileY = tileXY(2);
% conver tile x&y to quadkey
quadkey = tile2quad(tileX, tileY, zoomlevel);
tileXYquadkey = quadkey;
% retrieve image
satelliteimg = imread(['http://a0.ortho.tiles.virtualearth.net/tiles/a',...
                         quadkey,'.jpeg?g=131&',APIKEY]);
% check image
if size(satelliteimg,3)~=3 % no image
    disp('No image retrieved.');
    satelliteimg = [];
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