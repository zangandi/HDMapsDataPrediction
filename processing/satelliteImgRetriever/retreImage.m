%Retrieve image from Bing map with center point: latitude (latcen), longtitude (loncen)
%and level (lvl)

function retreImage(lat,lon,lvl)
% key of Bing map
key = 'ArSkGTLs-eC_9nbM84_EJ-tjISwN7rcDT0Vvw1jQhccWLoAGJYE4jX2AapF9aBKa';

lat = min(max(lat,-85.05112878),85.05112878);
lon= min(max(lon,-180),180);

[pixelX, pixelY] = latlon2pixel(lat,lon,lvl);
[tileX, tileY] = pixel2tile(pixelX, pixelY);
[quadkey] = tile2quad(tileX, tileY);

pic = imread(['http://h0.ortho.tiles.virtualearth.net/tiles/h', quadkey,'.jpeg?g=131&',key]);
imwrite(pic,['lat:', num2str(lat), 'lon:', num2str(lon) 'level:', num2str(lvl),'.jpg']);