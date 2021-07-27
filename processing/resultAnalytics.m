% This function stats prediction results
%
clear all
%
result_dir = 'G:\datasets\ready_1207\advanced_test\';
% get file list
result_trips_list = dir(strcat(result_dir,'*.csv'));
%
figure
hold on
%
L = 100;
%
normalized_ratio_to_duration = [];
%
for i = 1:size(result_trips_list,1)
    %
    trip_id_full = result_trips_list(i).name;
    trip_id_string = trip_id_full(1:end-4);
    % load raw data
    data_predict = csvread(strcat(result_dir, trip_id_full));
    if size(data_predict,1)>=100
        %
        mdc_raw = data_predict(:,2);
        mdc_predict = data_predict(:,1); 
        %
        predict_to_raw_ratio = mdc_predict./mdc_raw;
        %
        current_normalized_ratio_to_duration = zeros(1,L);
        %
        for j = 1:L
            if j == 1
                spot = predict_to_raw_ratio(1);
            elseif j == L
                spot = predict_to_raw_ratio(L);
            else
                spot = predict_to_raw_ratio(round(j/L*size(mdc_raw,1)));
            end
            current_normalized_ratio_to_duration(j) = spot;
        end
        %
        normalized_ratio_to_duration = cat(1, normalized_ratio_to_duration, current_normalized_ratio_to_duration);
        %
    end
    %
    %
    plot([1:100], current_normalized_ratio_to_duration, 'ro');
end
plot([1:100], median(normalized_ratio_to_duration), 'b-');