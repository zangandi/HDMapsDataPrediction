%% Bing Satellite Imagery Retriever
%  v1.0
%  This function is used to retrieve satellite image with given bounding
%  box and zoom level.
%  Andi Zang
%  02/23/2018
%  function [satelliteimg, corners] = satelliteImageRetriever(bbox, zoomlevel)
%  INPUT
%       bbox: 1 X 4, [top_left_lat, top_left_lon, bottom_right_lat, bottom_right_lon] in degree
%       zoomlevel: 1-20
%  OUTPUT
%       image_cropped: returned satellite image
%       w,h: the size of returned satellite image in meter
%       resolution: ground resolution of returned satellite image
%
function [image_cropped, w, h, resolution] = satelliteImageRetrieverBoundingBox(bbox, zoomlevel, apikey)
% params
% APIKEY = 'ArSkGTLs-eC_9nbM84_EJ-tjISwN7rcDT0Vvw1jQhccWLoAGJYE4jX2AapF9aBKa';
% clear all
% bbox = [41.930, -87.770, 41.929, -87.769];
% zoomlevel = 20;
if isempty(apikey)
    APIKEY = 'AtH2nrD6TJrRtOuyPgzKy1vo4o-GvSsk_hoFOLWUyO_SxIuC934k3aij-voob3vc';
else
    APIKEY = apikey;
end%endif
% 
% check zoom level
if zoomlevel <1 || zoomlevel > 23
    error('Zoom Level must belong to [1, 23].')
end
if mod(zoomlevel,1) ~= 0
    zoomlevel = round(zoomlevel);
    warning(['Zoom Level must be an integer. Rounding to ', ...
             num2str(zoomlevel)]);
end
% check bounding box corners
if bbox(1) <= bbox(3) || bbox(2)>= bbox(4)
    error('Please check the bounding box.');
end
% check latitude
if max(abs(bbox(1)),abs(bbox(3)))>=85.0
    error(['Max latitude should less than 85 degree.']);
end
% check longitude
if max(abs(bbox(2)),abs(bbox(4)))>=180
    error(['Max longitude should less than 180 degree.']);
end

% convert location to tile pixel
pixelX_top_left = ((bbox(2)+180)/360)*256*2^zoomlevel;
pixelY_top_left = (0.5-log((1+sin(bbox(1)*pi/180))/...
         (1-sin(bbox(1)*pi/180)))/(4*pi))*256*2^zoomlevel;
pixelX_bottom_right = ((bbox(4)+180)/360)*256*2^zoomlevel;
pixelY_bottom_right = (0.5-log((1+sin(bbox(3)*pi/180))/...
         (1-sin(bbox(3)*pi/180)))/(4*pi))*256*2^zoomlevel;
% convert tile pixel to tile
tileX_top_left = floor(pixelX_top_left/256);
tileY_top_left = floor(pixelY_top_left/256);
tileX_bottom_right = floor(pixelX_bottom_right/256);
tileY_bottom_right = floor(pixelY_bottom_right/256);
% find x, y ration in tile coordinate
ratioX_top_left = pixelX_top_left/256 - tileX_top_left;
ratioY_top_left = pixelY_top_left/256 - tileY_top_left;
ratioX_bottom_right = pixelX_bottom_right/256 - tileX_bottom_right;
ratioY_bottom_right = pixelY_bottom_right/256 - tileY_bottom_right;
% initialize canvas
N = tileX_bottom_right - tileX_top_left+1;
M = tileY_bottom_right - tileY_top_left+1;
% warn, if either M or N is way too large
if M > 16 || N > 16
    warning('The image you retrieve is too large, you can either reduce the size of bounding box or reduce the zoom level.');
    warning(strcat('w:',num2str(256*N),'x h:',num2str(256*M)));
end
image = zeros(256*M,256*N,3);
% retrieve tiles and merge tiles
for m = tileY_top_left: tileY_bottom_right
    for n = tileX_top_left: tileX_bottom_right
        % query aerial image again
        [satelliteimg, ~, ~, ~] = tileXY2tile([n m], zoomlevel, APIKEY);
        % merge to canvas
        xrangeStart = (m - tileY_top_left)*256+1;
        xrangeEnd = (m - tileY_top_left + 1)*256;
        yrangeStart = (n - tileX_top_left)*256+1;
        yrangeEnd = (n - tileX_top_left + 1)*256;
        image(xrangeStart:xrangeEnd, yrangeStart:yrangeEnd, :) = double(satelliteimg)/255;
    end%endfor n
end%endfor m  
% crop image
x_top_left = max(round(ratioX_top_left*256),1);
y_top_left = max(round(ratioY_top_left*256),1);
x_bottom_left = max(round(ratioX_bottom_right*256),1)+(N-1)*256;
y_bottom_left = max(round(ratioY_bottom_right*256),1)+(M-1)*256;
image_cropped = image(y_top_left:y_bottom_left,x_top_left:x_bottom_left,:);
% calculate image size in real scale
top_left = [bbox(1:2) 0];
top_right = [bbox(1) bbox(4) 0];
bottom_left = [bbox(3) bbox(2) 0];
bottom_right = [bbox(3:4) 0];
% convert to ECEF space
top_left_ecef = lla2ecef(top_left);
top_right_ecef = lla2ecef(top_right);
bottom_left_ecef = lla2ecef(bottom_left);
bottom_right_ecef = lla2ecef(bottom_right);
%
h1 = norm(bottom_left_ecef - top_left_ecef);
h2 = norm(bottom_right_ecef - top_right_ecef);
w1 = norm(top_right_ecef - top_left_ecef);
w2 = norm(bottom_right_ecef - bottom_left_ecef);
% check the w
if abs(floor(w2*100) - floor(w1*100))>1
    disp(strcat('Target AOI is too large, which causes the resolutio',...
         'n differential of upper bound and lower bound exceeds 1cm per pixel.'))
end%endif
%
w = (w1+w2)/2;
h = (h1+h2)/2;
%
resolution_x = h/size(image_cropped,1);
resolution_y = w/size(image_cropped,2);
%
if abs(floor(resolution_x*100) - floor(resolution_y*100))>1
    disp(strcat('Target AOI is too large, which causes the resolutio',...
         'n differential of left bound and right bound exceeds 1cm per pixel.'))
end%endif
%
resolution = (resolution_x+resolution_y)/2;
end%endfunction