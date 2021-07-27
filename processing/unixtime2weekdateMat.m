function [d_t_idx] = unixtime2weekdateMat(unix_time_list, ref_timestr, ref_date, time_zone)
d_t_idx = zeros(size(unix_time_list,1),3);
%
for i = 1:size(unix_time_list,1)
    [d, t, idx] = unixtime2weekdate(unix_time_list(i), ref_timestr, ref_date, time_zone);
    d_t_idx(i,:) = [d,t,idx];
end

end