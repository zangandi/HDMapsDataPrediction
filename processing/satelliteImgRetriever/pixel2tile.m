% pixel to tile coordinate

function [tileX, tileY] = pixel2tile(pixelX, pixelY)

tileX = floor(pixelX/256);
tileY = floor(pixelY/256);