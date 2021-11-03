clear all
addpath('..\jsonlab-2.0\')

A = loadjson('..\mapmatching\mm_test.json');
M = shaperead('..\mapmatching\network\edges.shp');
N = shaperead('..\mapmatching\network\nodes.shp');

savejson([],M,'..\mapmatching\network\edges.shp.json');
savejson([],N,'..\mapmatching\network\nodes.shp.json');

raw_str = A{6}.mmRaw;
mm_str = A{6}.mmWKT;

[raw_lon, raw_lat] = linestring2xy(raw_str);
[mm_lon, mm_lat] = linestring2xy(mm_str);
figure
hold on
mapshow(M)
plot(raw_lon, raw_lat,'ro');
plot(raw_lon, raw_lat,'r-')
plot(mm_lon, mm_lat,'go')
plot(mm_lon, mm_lat,'g-')

C = loadjson('..\mapmatching\network\edges.shp.json');