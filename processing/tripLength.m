function [total_dist] = tripLength(locs)
total_dist = 0;

for i = 1:size(locs,1)-1
    total_dist = total_dist + distanceLLA(locs(i,:), locs(i+1,:), 0);
end