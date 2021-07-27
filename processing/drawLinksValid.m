%% This function draws links within given bbox
%
%
%
function [canvas, image] = drawLinksValid(links, zoomlevel)

% links = link.links;
zoomlevel = 14;
%
% number of links
number_links = length(links);
%
se_list = [];
%
for i = 1:number_links
    segment = links{i};
    se_list = cat(1, se_list, segment);
end%endfor i
%
se_list = cat(2, se_list(:,2), se_list(:,1));
%
lat_max = max(se_list(:,1))+0.01;
lat_min = min(se_list(:,1))-0.01;
lon_max = max(se_list(:,2))+0.01;
lon_min = min(se_list(:,2))-0.01;
bbox = [lat_max, lon_min, lat_min, lon_max];
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
text_location = zeros(number_links,2);
%
for i = 1:number_links
    %
    nodes = links{i};
    % !!!!!!!!!!!!!!!!!!!!!!!!
    nodes = cat(2, nodes(:,2), nodes(:,1));
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
        if xy1(1)>0&&xy1(2)>0&&xy1(1)<=size(image,1)&&xy1(2)<=size(image,2)
            canvas_nodes_t(xy1(1), xy1(2)) = 1;
        end
        if xy2(1)>0&&xy2(2)>0&&xy2(1)<=size(image,1)&&xy2(2)<=size(image,2)
            canvas_nodes_t(xy2(1), xy2(2)) = 1; 
            text_location(i,:) = xy2;
        end
        canvas_links_t = drawLine2D(canvas_links_t, xy1, xy2);
        % dilate
        se1 = strel('disk',2);
        se2 = strel('disk',1);
        canvas_nodes_t = imdilate(canvas_nodes_t,se1);
        canvas_links_t = imdilate(canvas_links_t,se2);
        canvas_t = canvas_t + canvas_nodes_t + canvas_links_t;
    end%endfor j
    canvas_t = double(canvas_t>0);
    %
    canvas = canvas + cat(3, canvas_t*rgb(1,i,1),...
                             canvas_t*rgb(1,i,2),...
                             canvas_t*rgb(1,i,3));
end%endfor i
%
canvas2 = canvas;
for i = 1:number_links
    canvas2 = insertText(canvas2,...
                              text_location(i,2:-1:1),...
                              num2str(i),...
                              'TextColor', reshape(rgb(1,i,:),1,3),...
                              'BoxOpacity',0.0,...
                              'FontSize', 20);
end
%
imshow(canvas2)
imwrite(canvas3,'didi_map_overlay.png')
%
canvas3 = cat(3,image(:,:,1)+canvas2(:,:,1),...
                image(:,:,2)+canvas2(:,:,2),...
                image(:,:,3)+canvas2(:,:,3));
imshow(canvas3)
%
end%endfunction