%%  This function is used to find the closest (in Euclidean distance)
%   index with given vertex (Nd) and vertices list
%   Andi Zang
%   01/07/2016
%   INPUT:
%
%
%
%   OUTPUT:
%
%
function [idx, min_dist] = closestLLA(vertex, vertices, NUM)
%   check inputs
if size(vertex,2)~=size(vertices,2)
    disp('Dimensions of two inputs should be the same.');
    return;
end
%   
N = size(vertex,2);
%
edist = zeros(size(vertices,1),1);
%
for i = 1:N
    edist = edist + (vertices(:,i) - vertex(i)).*(vertices(:,i) - vertex(i));
end%endfor i
%
edist = sqrt(edist);
%
[~, I] = sort(edist, 'ascend');
%
idx = [];
min_dist = [];
%
for i = 1:NUM
    idx = cat(1, idx, I(i));
    min_dist = cat(1, min_dist, edist(I(i)));
end%endfor i 
%     [min_dist,idx] = min(edist);
%     if min_dist <= dist_threshold
%         idx = idx;
%     else
%         idx = [];
%     end
end

