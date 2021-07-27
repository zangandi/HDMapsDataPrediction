function [local_hd_maps_min, local_hd_maps_max] = localMinMax(hd_maps)
all_values = [];
for i = 1:size(hd_maps,1)
    for j = 1:size(hd_maps,2)
        if hd_maps(i,j) ~= 0
            all_values = cat(1, all_values, hd_maps(i,j));
        end
    end
end
local_hd_maps_min = min(all_values);
local_hd_maps_max = max(all_values);
end