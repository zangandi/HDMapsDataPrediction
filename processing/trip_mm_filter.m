%% This function filters trip follows simple rules
%
%
function [new_trip_filtered] = trip_mm_filter(trip, osm, link_id_list)
%
new_trip = trip;
% case 1
for i = 2:size(trip,1)-1
    if trip(i-1,6) == trip(i+1,6) && trip(i-1,6) ~= trip(i,6)
        new_trip(i,6) = trip(i-1,6);
        disp(i)
    end
end
% case 2
for i = 2:size(trip,1)-2
    if trip(i-1,6) ~= trip(i,6) && trip(i,6) ~= trip(i+1,6) &&...
       trip(i+1,6) ~= trip(i+2,6) && trip(i-1,6) == trip(i+2,6)   
        new_trip(i,6) = trip(i-1,6);
        new_trip(i+1,6) = trip(i-1,6);
        disp(i)
    end
end
%
new_trip_filtered = new_trip(1,:);
%

% final walk through
for i = 2:size(trip,1)
    if trip(i,6) == trip(i-1,6)
        new_trip_filtered = cat(1, new_trip_filtered, new_trip(i,:));
    elseif tripIntersectsTrip(trip(i,6), trip(i-1,6), osm, link_id_list)
        new_trip_filtered = cat(1, new_trip_filtered, new_trip(i,:));
    else
        break
    end
end
% 
if size(new_trip_filtered,1) < 50
    new_trip_filtered = [];
end
end