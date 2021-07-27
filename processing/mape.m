%% Mape function
%

function [med_e] = mape(data)
    if size(data,2) ~= 2
        return
    end
    e = data(:,1) - data(:,2);
    %
    e = abs(e);
    %
    pe = [];
    %
    for i = 1:size(data,1)
        if data(i,2) ~= 0
            pe = cat(1,pe,e(i)/data(i,2));
        end
    end
    %
    med_e = median(pe);
    %
end