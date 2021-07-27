%% This function coverts tti file into a mat
%
%
%
clear all
%
load xian_filtered.mat
%
tti_dir = 'G:\datasets\didi_tti\xian\road.txt';
%
tti_data = readtable(tti_dir,'ReadVariableNames', false);
%
number_of_links = size(filtered_road_map_ids,1);
number_of_dates = 7;
number_of_time_slots = 6*24;
%
raw_data_mat = cell(number_of_links, number_of_dates, number_of_time_slots);
raw_data_count = zeros(number_of_links, number_of_dates, number_of_time_slots);
%
for i = 1:size(tti_data,1)
    %
    current_link_id = tti_data{i,1};
    % find it
    idx = findidx(filtered_road_map_ids, current_link_id);
    if ~isempty(idx)
        % convert time to date and time slot
        datetime_string = tti_data{i,2};
        [day, time, day_time_idx] = time2weekdate(datetime_string, '2018-01-01 00:00:00', 1);
        %
        tti = tti_data{i,3};
        avgspeed = tti_data{i,4};
        %
        raw_data_count(idx, day, time) = raw_data_count(idx, day, time) + 1;
        %
        if isempty(raw_data_mat{idx, day, time})
            raw_data_mat{idx, day, time}.tti = tti;
            raw_data_mat{idx, day, time}.avgspeed = avgspeed;
        else
            raw_data_mat{idx, day, time}.tti = cat(1, raw_data_mat{idx, day, time}.tti, tti);
            raw_data_mat{idx, day, time}.avgspeed = cat(1, raw_data_mat{idx, day, time}.avgspeed, avgspeed);
        end%endif            
    end
end%endfor i

save('tti_mat.mat', 'raw_data_mat', 'raw_data_count')
%%%%%

load tti_mat.mat


% find the majority
avg_tti = zeros(number_of_links, number_of_dates, number_of_time_slots);
avg_speed = zeros(number_of_links, number_of_dates, number_of_time_slots);
%
for i = 1:number_of_links
    for j = 1:number_of_dates
        for k = 1:number_of_time_slots
            %
            tti = raw_data_mat{i, j, k}.tti;
            speed = raw_data_mat{i, j, k}.avgspeed;
            %
            tti = median(tti);
            speed = median(speed);
            %
            avg_tti(i,j,k) = tti;
            avg_speed(i,j,k) = speed;
        end
    end
end

save('tti_mat.mat', 'raw_data_mat', 'raw_data_count', 'avg_tti', 'avg_speed')

clear all
load tti_mat.mat
load didi_maps_13.mat
load xian_filtered.mat
%
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
%
number_of_links = 238;
%
blank_image = bbox2canvas(bbox, 13);
%
tti_sequence = zeros(size(road_map_per_link,1), size(road_map_per_link,2),...
                     number_of_dates*number_of_time_slots);
speed_sequence = zeros(size(road_map_per_link,1), size(road_map_per_link,2),...
                     number_of_dates*number_of_time_slots);
vis_tti_sequence = zeros(size(road_map_per_link,1), size(road_map_per_link,2),...
                     number_of_dates*number_of_time_slots);
vis_speed_sequence = zeros(size(road_map_per_link,1), size(road_map_per_link,2),...
                     number_of_dates*number_of_time_slots);      
%
for i = 1:number_of_dates
    for j = 1:number_of_time_slots
        day_time_idx = (i-1)*number_of_time_slots+j;
        %
        current_tti_map = zeros(size(road_map_per_link,1), size(road_map_per_link,2),number_of_links);
        current_speed_map = zeros(size(road_map_per_link,1), size(road_map_per_link,2),number_of_links);
        %
        vis_tti_map = nan(size(road_map_per_link,1), size(road_map_per_link,2));
        vis_speed_map = nan(size(road_map_per_link,1), size(road_map_per_link,2));
        %
        for k = 1:number_of_links
            current_tti_map(:,:,k) = road_map_per_link(:,:,k) * avg_tti(k,i,j);
            current_speed_map(:,:,k) = road_map_per_link(:,:,k) * avg_speed(k,i,j);
            %
        end%endfor k
        %
        tti_map = zeros(size(road_map_per_link,1), size(road_map_per_link,2));
        speed_map = zeros(size(road_map_per_link,1), size(road_map_per_link,2));
        %
        for l = 1:size(road_map_per_link,1)
            for m = 1:size(road_map_per_link,2)
                if mask2(l,m) ~= 0
                    tti_map(l,m) = max(current_tti_map(l,m,:));
                    speed_map(l,m) = max(current_speed_map(l,m,:));
                    %
                    vis_tti_map(l,m) = max(current_tti_map(l,m,:));
                    vis_speed_map(l,m) = max(current_speed_map(l,m,:));
                end
            end%endform
        end%endfor l
        %
%         imshow(myheatmap(vis_speed_map,1,[]));
        %
        tti_sequence(:,:,day_time_idx) = tti_map;
        speed_sequence(:,:,day_time_idx) = speed_map;
        %
        vis_tti_sequence(:,:,day_time_idx) = vis_tti_map;
        vis_speed_sequence(:,:,day_time_idx) = vis_speed_map;
        %
        disp(day_time_idx);
    end%endfor j
end%endfor i
%
save('traffic_1029.mat','tti_sequence', 'speed_sequence', 'bbox','vis_tti_sequence', 'vis_speed_sequence');