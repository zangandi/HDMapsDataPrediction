clear all
%
addpath('../jsonlab-2.0/')
%
addpath('.\satelliteImgRetriever\')
%
edge_shp = shaperead('..\mapmatching\network\edges.shp');
load xian_hd_maps_0602.mat
load traffic_1029.mat
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
zoomlevel = 13;
all_links = cell(0);
%
speed_count = 0;

for i = 1:size(edge_shp,1)
%     this_link = edge_shp(i);
    lat = edge_shp(i).Y;
    lon = edge_shp(i).X;
    % 
    lat = lat(1:end-1);
    lon = lon(1:end-1);
    %
    this_segment = cat(2,lat', lon');
    %
    this_segment_shift = cat(2, this_segment(:,1)+ osm_to_didi_mis_lat, this_segment(:,2) + osm_to_didi_mis_lon);
    [this_segment_shift_interpolated, dist] = llaPolylineInterpolation(this_segment_shift, 5);
    %
    loc_list = [];
    loc_shift_list = [];
    for l = 1:size(this_segment_shift_interpolated,1)
        xy1 = lla2bbox(this_segment_shift_interpolated(l,:), bbox, [size(hd_maps,1), size(hd_maps,2)]);
        if l == 1
            loc_list = cat(1, loc_list, xy1);
            loc_shift_list = [0,0];
        else
            if ~isequal(xy1,loc_list(end,:))
                loc_shift_list = cat(1, loc_shift_list, xy1-loc_list(end,:));
                loc_list = cat(1, loc_list, xy1);
            end
        end
    end
    %
    if size(loc_list,1) ~= size(loc_shift_list,1)
        warning(i);
    end
    blank_canvas = zeros(513,510);
    %
    for l = 1:size(loc_list,1)
        if loc_list(l,1)<=513 && loc_list(l,1)>0 &&...
                loc_list(l,2)<=510 && loc_list(l,2) >0
            blank_canvas(loc_list(l,1), loc_list(l,2)) = 1;
        end
    end
    %
    se = strel('square',5);
    blank_canvas_dilated = imdilate(blank_canvas,se);
    
%     vis = zeros(513,510,3);
%     hd_channel = hd_maps(:,:,1)./max(max(hd_maps(:,:,1)));
%     vis(:,:,1) = hd_channel;
%     vis(:,:,2) = blank_canvas;
%     vis(:,:,3) = blank_canvas_dilated;
%     imshow(vis)
    %
    total_mdc = zeros(1,3);
    %
    for l = 1:3
        total_mdc(l) = sum(sum(hd_maps(:,:,l).*blank_canvas_dilated));
    end
    %
    num_of_batches = size(loc_list,1);
    %
    hd_maps_of_this_link = zeros(5,5,3,num_of_batches);
    %
    for l = 1:num_of_batches
        this_xy = loc_list(l,:);
        try
            this_batch = hd_maps(this_xy(1)-2:this_xy(1)+2,...
                                 this_xy(2)-2:this_xy(2)+2,1:3);
        catch
            this_batch = zeros(5,5,3);
        end
        hd_maps_of_this_link(:,:,:,l) = this_batch;
    end
    %
    speed_of_this_link = zeros(num_of_batches,1);
    tti_of_this_link = zeros(num_of_batches,1);
    %
    for l = 1:num_of_batches
        this_xy = loc_list(l,:);
        if this_xy(1)>=1 && this_xy(1)<=size(speed_sequence,1) &&...
           this_xy(2)>=1 && this_xy(2)<=size(speed_sequence,2) 
            this_speed = speed_sequence(this_xy(1),this_xy(2),:);
            this_tti = tti_sequence(this_xy(1),this_xy(2),:);
        else
            this_speed = 0;
        end
        if sum(this_speed>0)>0
            speed_of_this_link = speed_sequence(this_xy(1),this_xy(2),:);
            tti_of_this_link = tti_sequence(this_xy(1),this_xy(2),:);
            speed_count = speed_count + 1;
            break
        end
    end
    %
    this_link = [];
    this_link.id = i;
    this_link.locs = this_segment_shift;
    this_link.num_of_batches = num_of_batches;
    this_link.hd_maps = hd_maps_of_this_link;
    this_link.lengh = dist;
    this_link.loc_shift_list = loc_shift_list;
    this_link.total_mdc = total_mdc;
    this_link.locs_in_maps = loc_list;
    this_link.speed = speed_of_this_link;
    this_link.tti = tti_of_this_link;
    this_link.dist = dist;
    %
%     vis = zeros(513,510,3);
%     hd_channel = hd_maps(:,:,1)./max(max(hd_maps(:,:,1)));
%     vis(:,:,1) = speed_sequence(:,:,1);
%     vis(:,:,2) = blank_canvas;
%     vis(:,:,3) = hd_channel;
%     imshow(vis)
    %
    all_links = cat(1, all_links, this_link);
    i
end
save('hd_maps_and_traffic_for_each_link_11_03.mat', 'all_links');