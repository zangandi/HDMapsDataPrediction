%% this function converts linestring into normal array
%
%
function [lon, lat] = linestring2xy(linestring)
%linestring = mm;
%
numbers_string = linestring(12:end-1);
numbers_string_split = strsplit(numbers_string, ',');
%
lon = zeros(size(numbers_string_split,2),1);
lat = zeros(size(numbers_string_split,2),1);
%
for i = 1:size(numbers_string_split,2)
    lon_lat_str = strsplit(numbers_string_split{i});
    lon(i) = str2double(lon_lat_str{1});
    lat(i) = str2double(lon_lat_str{2});
end
end