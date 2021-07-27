%%
%
function [d, t, idx] = unixtime2weekdate(unix_time, ref_timestr, ref_date, time_zone)

% unix_time = trace(1,1);
% time_zone = 8;

unix_time = unix_time + time_zone*60*60;

timestr = datestr(unix_time/86400 + datenum(1970,1,1));


[d, t, idx] = time2weekdate(timestr, ref_timestr, ref_date);