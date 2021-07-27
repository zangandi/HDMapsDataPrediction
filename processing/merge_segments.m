%% This function merges several segments into fewer polylines
%
%
function [new_link] = merge_segments(link)
%
n = size(link,1);
%
se_list = [];
%
for i = 1:n
    segment = link{i};
    se_list = cat(1, se_list, [segment(1,:) segment(end,:)]);
end%endfor i
%
[~, link] = removeDuplicated(se_list, link);
%
n = size(link,1);
%
se_list = [];
%
for i = 1:n
    segment = link{i};
    se_list = cat(1, se_list, [segment(1,:) segment(end,:)]);
end%endfor i
%
adjacency_matrix = zeros(n,n);
%
for i = 1:n
    for j = 1:n
        if i ~= j
            if se_list(i,1:2) == se_list(j,1:2)
                adjacency_matrix(i,j) = 1;
            elseif se_list(i,1:2) == se_list(j,3:4)
                adjacency_matrix(i,j) = 2;
            elseif se_list(i,3:4) == se_list(j,1:2)
                adjacency_matrix(i,j) = 3; 
            elseif se_list(i,3:4) == se_list(j,3:4)
                adjacency_matrix(i,j) = 4;
            else
                adjacency_matrix(i,j) = 0; 
            end
        end
    end%endfor j
end%endfor i
% find end points
hit_count = sum(adjacency_matrix>0,2);
% if sum(hit_count == 1) ~= 2 && sum(hit_count == 1) ~= 4
%     warning('Need two/four end points.')
%     return
% else
%     if sum(hit_count == 1) == 4
%         endpoint_idx = find(hit_count==1);
%         % 
%         dist = zeros(4,1);
%         %
%         for i = 1:4
%             for j = 1:4
%                 if i ~= j
%                     dist(i) = min(dist(i),...
%                         -norm(se_list(endpoint_idx(i),1:2)-se_list(endpoint_idx(j),1:2)));
%                 end
%             end
%         end
%         %
%         [~, I] = sort(dist);
%         pair1 = endpoint_idx(I(4));
%         pair2 = endpoint_idx(I(3));
%         %
%         dist1 = norm(se_list(pair1,1:2)-se_list(pair2,1:2));
%         dist2 = norm(se_list(pair1,1:2)-se_list(pair2,3:4));
%         dist3 = norm(se_list(pair1,3:4)-se_list(pair2,1:2));
%         dist4 = norm(se_list(pair1,3:4)-se_list(pair2,3:4));
%         %
%         if dist1 == min([dist1,dist2,dist3,dist4])
%             adjacency_matrix(pair1, pair2) = 1;
%             adjacency_matrix(pair2, pair1) = 1;
%         elseif dist2 == min([dist1,dist2,dist3,dist4])
%             adjacency_matrix(pair1, pair2) = 2;
%             adjacency_matrix(pair2, pair1) = 2;
%         elseif dist3 == min([dist1,dist2,dist3,dist4])
%             adjacency_matrix(pair1, pair2) = 3;
%             adjacency_matrix(pair2, pair1) = 3;
%         else 
%             adjacency_matrix(pair1, pair2) = 4;
%             adjacency_matrix(pair2, pair1) = 4;
%         end
%         %
%         hit_count(pair1) = 2;
%         hit_count(pair2) = 2;
%     end
% end
%

while sum(hit_count == 1) ~= 2
    endpoint_idx = find(hit_count==1);
    % 
    dist = zeros(length(endpoint_idx),1);
    %
    for i = 1:length(endpoint_idx)
        for j = 1:length(endpoint_idx)
            if i ~= j
                dist(i) = min(dist(i),...
                    -norm(se_list(endpoint_idx(i),1:2)-se_list(endpoint_idx(j),1:2)));
            end
        end
    end
    %
    [~, I] = sort(dist);
    pair1 = endpoint_idx(I(end));
    pair2 = endpoint_idx(I(end-1));
    %
    dist1 = norm(se_list(pair1,1:2)-se_list(pair2,1:2));
    dist2 = norm(se_list(pair1,1:2)-se_list(pair2,3:4));
    dist3 = norm(se_list(pair1,3:4)-se_list(pair2,1:2));
    dist4 = norm(se_list(pair1,3:4)-se_list(pair2,3:4));
    %
    if dist1 == min([dist1,dist2,dist3,dist4])
        adjacency_matrix(pair1, pair2) = 1;
        adjacency_matrix(pair2, pair1) = 1;
    elseif dist2 == min([dist1,dist2,dist3,dist4])
        adjacency_matrix(pair1, pair2) = 2;
        adjacency_matrix(pair2, pair1) = 2;
    elseif dist3 == min([dist1,dist2,dist3,dist4])
        adjacency_matrix(pair1, pair2) = 3;
        adjacency_matrix(pair2, pair1) = 3;
    else 
        adjacency_matrix(pair1, pair2) = 4;
        adjacency_matrix(pair2, pair1) = 4;
    end
    %
    hit_count(pair1) = 2;
    hit_count(pair2) = 2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
endpoint_idx = find(hit_count==1);
start_point_idx = endpoint_idx(1);
end_point_idx = endpoint_idx(2);
%
end_point_indicator = adjacency_matrix(end_point_idx,find(adjacency_matrix(end_point_idx,:)~=0));
%
pointer = start_point_idx;
%
new_link = [];
new_link_2 = [];
while pointer~= end_point_idx
    % next one index
    next_segment = find(adjacency_matrix(pointer,:)~=0);
    %
    if next_segment > n
        aa
    end
    % update
    adjacency_matrix(next_segment,pointer) = 0;
    %
    segment = link{pointer};
    %
    if adjacency_matrix(pointer,next_segment) == 1
        new_link = cat(1, new_link, segment(end:-1:1,:));
        new_link_2 = cat(1, new_link_2, {segment(end:-1:1,:)});
    elseif adjacency_matrix(pointer,next_segment) == 2
        new_link = cat(1, new_link, segment(end:-1:1,:));
        new_link_2 = cat(1, new_link_2, {segment(end:-1:1,:)});
    elseif adjacency_matrix(pointer,next_segment) == 3
        new_link = cat(1, new_link, segment);
        new_link_2 = cat(1, new_link_2, {segment});
    elseif adjacency_matrix(pointer,next_segment) == 4
        new_link = cat(1, new_link, segment);
        new_link_2 = cat(1, new_link_2, {segment});
    else
        warning('Check in while')
        return
    end%endif
    %
    pointer = next_segment;
end%endwhile
%
if end_point_indicator == 1
    new_link = cat(1, new_link, segment(end:-1:1,:));
    new_link_2 = cat(1, new_link_2, {segment(end:-1:1,:)});
elseif end_point_indicator == 2
    new_link = cat(1, new_link, segment(end:-1:1,:));
    new_link_2 = cat(1, new_link_2, {segment(end:-1:1,:)});
elseif end_point_indicator == 3
    new_link = cat(1, new_link, segment);
    new_link_2 = cat(1, new_link_2, {segment});
elseif end_point_indicator == 4
    new_link = cat(1, new_link, segment);
    new_link_2 = cat(1, new_link_2, {segment});
else
    warning('Check in the last step')
    return
end%endif

end