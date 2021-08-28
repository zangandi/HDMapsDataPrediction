%% 

clear all
%
load xian_hd_maps_0602.mat
load all_nodes_adjacency_0810.mat
%
% end_point_ids_list
% adjacency_matrix
% node_to_node_links
%
full_adjacency_matrix = zeros(size(adjacency_matrix));
%
addpath('.\satelliteImgRetriever\')
osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
zoomlevel = 13;
%
all_links = cell(0);
%
counter = 0;
%
for i = 1:size(end_point_ids_list,1)
    for j = 1:size(end_point_ids_list,1)
        if ~isempty(node_to_node_links{i,j})
            %
            start_node_id = end_point_ids_list(i);
            end_node_id = end_point_ids_list(j);
            %
            start_node_id_in_osm = find(osm_node_list(:,1)==start_node_id);
            end_node_id_in_osm = find(osm_node_list(:,1)==end_node_id);
            %
            start_node_loc = osm_node_list(start_node_id_in_osm, 2:3);
            end_node_loc = osm_node_list(end_node_id_in_osm, 2:3);
            %
            this_segments = node_to_node_links{i,j};
            %
%             figure
%             hold on
%             color_string = ['rgb'];
%             plot(start_node_loc(1),start_node_loc(2),'co');
%             plot(end_node_loc(1),end_node_loc(2),'ko');
            for k = 1:1%size(this_segments,1)
                this_segment = this_segments{k};
%                     plot(this_segment(:,1), this_segment(:,2),color_string(k));
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
                %
                blank_canvas = zeros(513,510);
                %
                for l = 1:size(loc_list,1)
                    blank_canvas(loc_list(l,1), loc_list(l,2)) = 1;
                end
                %
                vis = zeros(513,510,3);
                hd_channel = hd_maps(:,:,1)./max(max(hd_maps(:,:,1)));
                vis(:,:,1) = hd_channel;
                vis(:,:,2) = blank_canvas;
                imshow(vis)
                %
                
                
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
                this_link = [];
                this_link.start_node_id = start_node_id;
                this_link.end_node_id = end_node_id;
                this_link.i = i;
                this_link.j = j;
                this_link.start_node_id_in_osm = start_node_id_in_osm;
                this_link.end_node_id_in_osm = end_node_id_in_osm;
                this_link.locs = this_segment_shift;
                this_link.num_of_batches = num_of_batches;
                this_link.hd_maps = hd_maps_of_this_link;
                this_link.lengh = dist;
                %
            end
            %
            all_links = cat(1, all_links, this_link);
            counter = counter + 1
        end
    end
end
%
save('hd_maps_for_each_link_08_26.mat', 'all_links');