% latitude longtitude to pixel coordinates

function [pixelX, pixelY] = latlon2pixel(lat,lon,lvl)

pixelX = ((lon+180)/360)*256*2^lvl;
temp = sin(lat*pi/180);
pixelY = (0.5-log((1+temp)/(1-temp))/(4*pi))*256*2^lvl;

