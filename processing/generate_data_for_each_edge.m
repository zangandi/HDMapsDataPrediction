clear all

edge_shp = shaperead('..\mapmatching\network\edges.shp');
%
all_edges_length = zeros(size(edge_shp,1),1);
%
for i = 1:size(edge_shp,1)
    %
    lat = edge_shp(i).Y;
    lon = edge_shp(i).X;
    % 
    lat = lat(1:end-1);
    lon = lon(1:end-1);
    %
    dist = 0;
    %
    trajs = cat(2,lat',lon');
    %
    for j = 1:size(lat,2)-1
        p1 = trajs(j,:);
        p2 = trajs(j+1,:);
        dist = dist + distanceLLA(p1,p2,0);
    end
    all_edges_length(i) = dist;
end
save('all_edges_length.mat','all_edges_length')
