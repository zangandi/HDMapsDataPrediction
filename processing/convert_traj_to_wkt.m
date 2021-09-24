clear all
%
input_dir = 'C:\Users\zanga\Documents\GitHub\HDMapsDataPrediction\processing\data\gps_20161001\';
output_dir = 'C:\Users\zanga\Documents\GitHub\HDMapsDataPrediction\processing\data\';
%
% example
% traj = 'LINESTRING(0.200812146892656 2.14088983050848,
%        1.44262005649717 2.14879943502825,3.06408898305084 2.16066384180791,
%        3.06408898305084 2.7103813559322,3.70872175141242 2.97930790960452,
%        4.11606638418078 2.62337570621469)'
prefix = 'LINESTRING(';
suffix = ')';
%
all_trip_names = dir(strcat(input_dir,'*.csv'));
%
fid = fopen(strcat(output_dir,'test.wkt'),'w');
%
for i = 1:size(all_trip_names,1)
    trace = csvread(strcat(input_dir,all_trip_names(i).name),1,0);
    %
    raw_lat = trace(:,3);
    raw_lon = trace(:,2);
    raw_alt = zeros(size(trace,1),1);
    %
%     raw_locs = cat(2, raw_lat, raw_lon, raw_alt);
%     %
%     raw_locs_ecef = lla2ecef(raw_locs);
%     %
%     filtered_locs = raw_locs(1,:);
%     filtered_locs_ecef = raw_locs_ecef(1,:);
%     for j = 2:size(raw_locs,1)-1
%         if norm(raw_locs_ecef(j,:) - raw_locs_ecef(j-1,:))>=1
%             filtered_locs = cat(1, filtered_locs, raw_locs(j,:));
%             filtered_locs_ecef = cat(1, filtered_locs_ecef, raw_locs_ecef(j,:));
%         end
%     end%enfor j
%     if norm(raw_locs_ecef(end,:) - raw_locs_ecef(end-1,:))>=1
%         filtered_locs = cat(1, filtered_locs, raw_locs(end,:));
%         filtered_locs_ecef = cat(1, filtered_locs_ecef, raw_locs_ecef(end,:));
%     else
%         filtered_locs(end,:) = raw_locs(end,:);
%         filtered_locs_ecef(end,:) = raw_locs_ecef(end,:);
%     end
    %
    fprintf(fid, 'LINESTRING(');
    for j = 1:size(raw_lat,1)-1
        fprintf(fid,'%.5f %.5f,',raw_lat(j),raw_lon(j));
    end
    fprintf(fid,'%.5f %.5f)\n',raw_lat(end),raw_lon(end));
end
fclose(fid);