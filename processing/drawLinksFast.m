%% This function draws links within given bbox
%
%
%
function [mask] = drawLinksFast(bbox, links, zoomlevel)

% links = link.links;
% zoomlevel = 16;
%
% number of links
number_links = length(links);
%
[image, ~, ~, ~] = bbox2canvas(bbox, zoomlevel);
%
for i = 1:number_links
    %
    nodes = links{i};
    % !!!!!!!!!!!!!!!!!!!!!!!!
%     nodes = cat(2, nodes(:,2), nodes(:,1));
    %
    for j = 1:size(nodes,1)-1
        canvas_links_t = zeros(size(image,1), size(image,2));
        canvas_nodes_t = zeros(size(image,1), size(image,2));
        p1 = nodes(j,:);
        p2 = nodes(j+1,:);
        %
        [xy1] = lla2bbox(p1, bbox, [size(image,1), size(image,2)]);
        [xy2] = lla2bbox(p2, bbox, [size(image,1), size(image,2)]);
        t = 0;
        if xy1(1)>0&&xy1(2)>0&&xy1(1)<=size(image,1)&&xy1(2)<=size(image,2)
            canvas_nodes_t(xy1(1), xy1(2)) = 1;
        end
        if xy2(1)>0&&xy2(2)>0&&xy2(1)<=size(image,1)&&xy2(2)<=size(image,2)
            canvas_nodes_t(xy2(1), xy2(2)) = 1; 
        end
        canvas_links_t = drawLine2D(canvas_links_t, xy1, xy2);
        image = image + canvas_links_t + canvas_nodes_t;
    end%endfor j
    
end%endfor i
%
mask = double(image>0);
%
end%endfunction