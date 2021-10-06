%% This function converts links to shapefile
%
%
[S,A] = shaperead('C:\Users\zanga\Documents\GitHub\HDMapsDataPrediction\mapmatching\edges.shp');
load osm_0614_link.mat
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
% this_segment_shift = cat(2, this_segment(:,1)+ osm_to_didi_mis_lat, this_segment(:,2) + osm_to_didi_mis_lon);
%
% attributes in his template
% new_S = [];
% new_S.Geometry = [];
% new_S.BoundingBox = [];
% new_S.X = [];
% new_S.Y = [];
new_S = S;
% new_S.id = [];
% new_S.node_ids = []; 
% BoundingBox
% [min X, min Y; max X, max Y]

%

for i = 1:size(osm)
    % 
    points = osm{i};
    lat = points(:,2);
    node_ids = points(:,1);
    lon = points(:,3);
    % align
    lat = lat + osm_to_didi_mis_lat;
    lon = lon + osm_to_didi_mis_lon;
    %
    lat_w_nan = cat(1, lat, NaN);
    lon_w_nan = cat(1, lon, NaN);
    %
    min_lat = min(lat);
    max_lat = max(lat);
    min_lon = min(lon);
    max_lon = max(lon);
    % assign values
    new_S(i,1).Geometry = 'Line';
    new_S(i,1).BoundingBox = [min_lat, min_lon; max_lat, max_lon];
    new_S(i,1).X = lat_w_nan;
    new_S(i,1).Y = lon_w_nan;
%     new_S(i).id = link_id_list(i);
%     new_S(i).node_ids = node_ids;
%     if ~isa(node_ids,'double')
%         aaa
%     end
end%endfor i
mapshow(S)
% save shape file
shapewrite(new_S, 'C:\Users\zanga\Documents\GitHub\HDMapsDataPrediction\mapmatching\xian_1001_aligned.shp')


shapeinfo('C:\Users\zanga\Documents\GitHub\HDMapsDataPrediction\mapmatching\xian_1001_aligned.shp')
shapeinfo('C:\Users\zanga\Documents\GitHub\HDMapsDataPrediction\mapmatching\edges.shp')
