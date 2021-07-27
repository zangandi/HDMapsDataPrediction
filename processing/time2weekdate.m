%%

%
function [d, t, idx] = time2weekdate(timestr, ref_timestr, ref_date)
%
% timestr = '2018-05-01 00:1:00';
% ref_timestr = '2018-01-01 00:00:00';
% ref_date = 1;
% calculate day
number_of_days = floor(datenum(timestr) - datenum(ref_timestr));
d = mod(number_of_days,7) + ref_date;
% calculate time
time_list = datevec(timestr);
total_mins = time_list(4)*60 + time_list(5);
t = floor(total_mins/10)+1;
idx = (d-1)*6*24 + t;
end