%%


function [data_in_log_10] = data2Log10(raw_data)
data_in_log_10 = zeros(size(raw_data,1),size(raw_data,2));
for i = 1:size(raw_data,1)
    for j = 1:size(raw_data,2)
        if raw_data(i,j)~= 0
            data_in_log_10(i,j) = log10(raw_data(i,j));
        end
    end
end
end