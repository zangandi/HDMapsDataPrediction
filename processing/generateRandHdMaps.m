%% 

clear all
% load links
load osm_1013_link.mat
% load 
zoomlevel = 13;
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
addpath('.\satelliteImgRetriever\')
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
%
load hd_seed.mat
%
[canvas, w, h, resolution] = bbox2canvas(bbox, zoomlevel);
for i = 1:length(link_id_list)
    links = osm{i};
    links = cat(2, links(:,1)+ osm_to_didi_mis_lat, links(:,2) + osm_to_didi_mis_lon);
    links = {links};
    %
    [mask] = drawLinksFast(bbox, links, zoomlevel);
    %
    canvas = canvas + mask;
end
canvas = double(canvas>0);
imshow(canvas)
%
% dialate
se = strel('disk',1);
canvas2 = imdilate(canvas,se);
imshow(canvas2)
%
canvas = canvas2;
%
[x,y] = find(canvas==1);
%
N = 9;
%
hd_maps = zeros(size(canvas,1), size(canvas,2), 4);
hd_maps_vis = inf(size(canvas,1), size(canvas,2));
%
for i = 1:N
    % generate random hd maps
    r = normrnd(hd.mu(i),hd.sigma(i),length(x),1);
    %
    for j = 1:length(x)
        while r(j) < hd.vmin(i) || r(j) > hd.vax(i)
            r(j) = normrnd(hd.mu(i),hd.sigma(i),1,1);
        end
        hd_maps(x(j),y(j),i) = r(j);
        hd_maps_vis(x(j),y(j)) = r(j)/10^5;
    end
end%endfor i

%
hd_maps_vis = nan(size(canvas,1), size(canvas,2));
cvalue = [];
for i = 1:size(canvas,1)
    for j = 1: size(canvas,2)
        if hd_maps(i,j,1) ~= 0
            hd_maps_vis(i,j) = hd_maps(i,j,1);
            cvalue = cat(1, cvalue ,hd_maps(i,j,1));
        end
    end
end
hist(cvalue,100);
heatmap = myheatmap(hd_maps_vis,1,[]);
imshow(heatmap)
imwrite(heatmap, 'xian_hd_maps_0602.png')
save('xian_hd_maps_0602.mat','hd_maps', 'canvas','bbox','zoomlevel','hd');
