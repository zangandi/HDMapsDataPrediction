  for j = 1:size(link.links,1)
            %
            nodes = link.links{j};
            %
            sublink_name = strcat(num2str(link.id),'.',num2str(j),'.nodes');
            %
        % add buffer zone
        lat_min = lat_min - 0.0001;
        lat_max = lat_max + 0.0001;
        lon_min = lon_min - 0.0001;
        lon_max = lon_max + 0.0001;
        %
        bbox = [lat_max, lon_min, lat_min, lon_max];
        %
        [mask, canvas] = drawLinks(bbox, link.links(42:43), 16);
  end
  
  p1 = link.links{42};
  p1 = p1(end,:);
  p1ecef = lla2ecef([p1 0]);
  
  dist = [];
for j = 1:size(link.links,1)
    nn = link.links{j};
    for k = 1:size(nn,1)
        ns = nn(k,:);
        nsecef = lla2ecef([ns 0]);
        if k == 1
            cdist = norm(nsecef-p1ecef);
        else
            cdist = min(cdist,norm(nsecef-p1ecef));
        end
    end
    dist = cat(1, dist, cdist);
end