
function [this_MAPE] = wmape(ye, Yv, w)
    pre_MAPE = abs((ye-Yv)./Yv);
    this_MAPE = sum((pre_MAPE(isfinite(pre_MAPE))).*w);
end