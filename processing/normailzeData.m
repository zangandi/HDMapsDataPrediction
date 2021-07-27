function [data_normalized] = normailzeData(data_raw, data_min, data_max)
data_normalized = zeros(size(data_raw,1),size(data_raw,2));
for i = 1:size(data_raw,1)
    for j = 1:size(data_raw,2)
        if data_raw(i,j)~= 0
            data_normalized(i,j) = (data_raw(i,j) - data_min)/(data_max - data_min);
        end
    end
end
end