%% Trip intersects trip
%

function [tof, intersection] = tripIntersectsTrip(link_id1, link_id2, osm, link_id_list)
%
link_id1_index = find(link_id_list == link_id1);
link_id2_index = find(link_id_list == link_id2);
%
if ~isempty(link_id1_index) && ~isempty(link_id2_index)
    link1 = osm{link_id1_index};
    link2 = osm{link_id2_index};
    %
    tof = false;
    intersection = [];
    %
    for i = 1:size(link1,1)
        for j = 1:size(link2,1)
            if link1(i,1) == link2(j,1)
                tof = true;
                intersection = link1(i,1);
                break
            end
        end
    end
else
    warning('Link(s) cannot be found.');
end
end