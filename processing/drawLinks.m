%% This function draws links within given bbox
%
%
%
function [mask, canvas, image] = drawLinks(bbox, links, zoomlevel)

% links = link.links;
% zoomlevel = 16;
%
% number of links
number_links = length(links);
% get color codes
h = [1:number_links]/number_links;
s = ones(1, number_links);
v = ones(1, number_links);
rgb = hsv2rgb(cat(3, h,s,v));
%
[image, ~, ~, ~] = satelliteImageRetrieverBoundingBox(bbox, zoomlevel, []);
%
canvas_links = zeros(size(image,1), size(image,2), 3);
canvas_nodes = zeros(size(image,1), size(image,2), 3);
canvas = zeros(size(image,1), size(image,2), 3);
%
for i = 1:number_links
    %
    nodes = links{i};
    % !!!!!!!!!!!!!!!!!!!!!!!!
%     nodes = cat(2, nodes(:,2), nodes(:,1));
    %
    canvas_t = zeros(size(image,1), size(image,2));
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
        % dilate
%         se1 = strel('disk',2);
%         se2 = strel('disk',1);
%         canvas_nodes_t = imdilate(canvas_nodes_t,se1);
%         canvas_links_t = imdilate(canvas_links_t,se2);
        canvas_t = canvas_t + canvas_nodes_t + canvas_links_t;
    end%endfor j
    canvas_t = double(canvas_t>0);
    %
    canvas = canvas + cat(3, canvas_t*rgb(1,i,1),...
                             canvas_t*rgb(1,i,2),...
                             canvas_t*rgb(1,i,3));
end%endfor i
%
mask = double(canvas(:,:,1)>0)+double(canvas(:,:,2)>0)+double(canvas(:,:,3)>0);
mask = double(mask>0);
%
end%endfunction