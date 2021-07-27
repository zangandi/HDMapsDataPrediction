%% This function converts links to adjacency matrix
%
%
%


function [adjacency_matrix, intersection_matrix]  = links2adjacency(links, threshold, r_flag)
%


%
links = filtered_road_map_links;
threshold = 1;
r_flag = 1;
%
adjacency_matrix = zeros(length(links), length(links));
intersection_matrix = cell(length(links), length(links));
%
for i = 1:length(links)-1
    % current link
    current_link = links{i};
    if r_flag == 1
        current_link = cat(2, current_link(:,2), current_link(:,1));
    else
        current_link = cat(2, current_link(:,1), current_link(:,1));
    end
    for j = i+1:length(links)
        this_link = links{j};
        if r_flag == 1
            this_link = cat(2, this_link(:,2), this_link(:,1));
        else
            this_link = cat(2, this_link(:,1), this_link(:,1));
        end
        % find the intersection(s)
        [lat_i, lon_i] = polyxpoly(current_link(:,1), current_link(:,2), this_link(:,1), this_link(:,2));
        %
        if ~isempty(lat_i)
            adjacency_matrix(i,j) = length(lat_i);
            intersection_matrix{i,j} = cat(2, lat_i, lon_i);
        end
    end%endfor j
end%endfor j
