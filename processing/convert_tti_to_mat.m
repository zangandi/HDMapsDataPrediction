%% This function coverts tti file into a mat
%
%
%
clear all
%
load xian_filtered.mat
load didi_maps_13.mat
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
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
%
for i = 1:size(tti_data,1)
    %
    current_link_id = tti_data{i,1};
    % find it
    idx = findidx(filtered_road_map_ids, current_link_id);
    if ~isempty(idx)
        % convert time to date and time slot
        datetime_string = tti_data{i,2};
        [day, time,] = time2weekdate(datetime_string, '2018-01-01 00:00:00', 1);
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