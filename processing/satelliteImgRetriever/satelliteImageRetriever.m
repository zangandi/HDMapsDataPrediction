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
%       resolution:
%       minimap:
%
function [satelliteimg, windowcornersLLA, resolution, minimap] = satelliteImageRetriever(center, zoomlevel, windowsize)
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
% retrieve image
image = zeros(256*3,256*3,3);
if (tileX>0 && tileX<2^zoomlevel-1)&&(tileY>0 && tileY<2^zoomlevel-1)  
    for i = 1:3
        for j = 1:3
            % convert tile to quadkey
            [quadkey] = tile2quad(tileX-2+i, tileY-2+j,zoomlevel);
            % retrieve image
            line=['http://a0.ortho.tiles.virtualearth.net/tiles/a',...
                         quadkey,'.jpeg?g=131&',APIKEY];
            patch = imread(['http://a0.ortho.tiles.virtualearth.net/tiles/a',...
                         quadkey,'.jpeg?g=131&',APIKEY]);
            %
            if size(patch,3)==3
                image((j-1)*256+1:j*256,(i-1)*256+1:i*256,:) = double(patch);
            else
                disp('No image retrieved.');
                return
            end
        end%endfor j
    end%endfor i
end%endif
image = image/256;
% imshow(image)
% find corners of center patch
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
% center in local
localcenter_lat = (center(1)-corners(1,1))/(corners(2,1)-corners(1,1))*256;
localcenter_lon = (center(2)-corners(1,2))/(corners(3,2)-corners(1,2))*256;
% windowcorners in local, UL->BL->UR->BR
windowcorners = [windowsize(2)/2 -windowsize(1)/2;
                 -windowsize(2)/2 -windowsize(1)/2;
                 windowsize(2)/2 windowsize(1)/2;
                 -windowsize(2)/2 windowsize(1)/2;];
% convert corners from NED to ECEF to LLA to pixel
windowcornersXY = zeros(4,2);
windowcornersLLA = zeros(4,3);
for i = 1:4
    % NED to ECEF
    [X, Y, Z] = ned2ecef(windowcorners(i,1), windowcorners(i,2), 0,...
                        center(1), center(2), center(3), SPHEROID);
    % ECEF to LLA
    lla = ecef2lla([X Y Z]);
    windowcornersLLA(i,:) = lla;
    % LLA to pixel
    windowcornersXY(i,1) = (lla(1)-corners(1,1))/(corners(2,1)-corners(1,1))*256;
    windowcornersXY(i,2) = (lla(2)-corners(1,2))/(corners(3,2)-corners(1,2))*256;
end%endfor i
% round cornerXY
windowcornersXY = round(windowcornersXY);
% crop image
localcenter_lat = round(localcenter_lat);
localcenter_lon = round(localcenter_lon);
R = median(abs([(windowcornersXY(1,1)-localcenter_lat) ...
                (windowcornersXY(2,1)-localcenter_lat) ...
                (windowcornersXY(1,2)-localcenter_lon) ...
                (windowcornersXY(3,2)-localcenter_lon)]));
satelliteimg = image(256+localcenter_lat-R:256+localcenter_lat+R,...
                     256+localcenter_lon-R:256+localcenter_lon+R,:);
% calculate resolution
resolution = (windowsize(1)/size(satelliteimg,2)+...
            windowsize(2)/size(satelliteimg,1))/2;
% imshow(satelliteimg)
% create minimap
minimap = image;
% draw center
minimap(256+localcenter_lat-10:256+localcenter_lat+10,...
        256+localcenter_lon-10:256+localcenter_lon+10,2) = 1;
% draw bbox
% minimap()
end%endfunction