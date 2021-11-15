%% Mape function
%

function [this_MAPE] = mape2(ye, Yv)
    pre_MAPE = abs((ye-Yv)./Yv);
    this_MAPE = mean(pre_MAPE(isfinite(pre_MAPE)));
end