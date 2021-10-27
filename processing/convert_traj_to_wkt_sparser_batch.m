clear all
%
input_dir = 'G:\didi\data\gps_201610';
output_dir = 'G:\didi\data\';
%
all_trip_names = dir(strcat(input_dir,'*.csv'));
%
prefix = 'LINESTRING(';
suffix = ')';
%

osm_to_didi_mis_lon = 0.0047;
osm_to_didi_mis_lat =-0.0016;
%
T = 5;
%
for k = 28:30
    if k <10
        folder_name = strcat(input_dir,'0',num2str(k),'\');
    else
        folder_name = strcat(input_dir,num2str(k),'\');
    end
    %
    all_trip_names = dir(strcat(folder_name,'*.csv'));
    %
    fid = fopen(strcat(output_dir,num2str(k),'.wkt'),'w');
    %
    stats = zeros(size(all_trip_names,1),4);
    %
    for i = 1:size(all_trip_names,1)
        trace = csvread(strcat(folder_name,all_trip_names(i).name),1,0);
        if size(trace,1) >= 100
            %
            raw_lat = trace(:,3)-osm_to_didi_mis_lat;
            raw_lon = trace(:,2)-osm_to_didi_mis_lon;
            raw_alt = zeros(size(trace,1),1);
            %
            raw_locs = cat(2, raw_lat, raw_lon, raw_alt);
            %
            raw_locs_ecef = lla2ecef(raw_locs);
            %
            filtered_locs = raw_locs(1,:);
            filtered_locs_ecef = raw_locs_ecef(1,:);
            %
            this_total_length = 0;
            %
            for j = 2:size(raw_locs,1)-1
                if norm(raw_locs_ecef(j,:) - raw_locs_ecef(j-1,:))>=T
                    filtered_locs = cat(1, filtered_locs, raw_locs(j,:));
                    filtered_locs_ecef = cat(1, filtered_locs_ecef, raw_locs_ecef(j,:));
                end
                this_total_length = this_total_length + norm(raw_locs_ecef(j,:) - raw_locs_ecef(j-1,:));
            end%enfor j
            if norm(raw_locs_ecef(end,:) - raw_locs_ecef(end-1,:))>=T
                filtered_locs = cat(1, filtered_locs, raw_locs(end,:));
                filtered_locs_ecef = cat(1, filtered_locs_ecef, raw_locs_ecef(end,:));
            else
                filtered_locs(end,:) = raw_locs(end,:);
                filtered_locs_ecef(end,:) = raw_locs_ecef(end,:);
            end
            %
            %
            stats(i,1) = size(raw_lat,1);
            stats(i,2) = size(filtered_locs,1);
            stats(i,3) = this_total_length;
            stats(i,4) = trace(end,1) - trace(1,1);
            %
        %     fid = fopen(strcat(output_dir,all_trip_names(i).name),'w');
        %     fprintf(fid,'latitude,longitude\n');
        %     for j = 1:size(filtered_locs,1)
        %         fprintf(fid,'%.5f, %.5f\n',filtered_locs(j,1:2));
        %     end
        %     fclose(fid);
            fprintf(fid, 'LineString(');
            for j = 1:size(filtered_locs,1)-1
                fprintf(fid,'%.5f %.5f,',filtered_locs(j,2),filtered_locs(j,1));
            end
            fprintf(fid,'%.5f %.5f)\n',filtered_locs(end,2),filtered_locs(end,1));

        end
    end
    fclose(fid);
    save(strcat('G:\didi\data\',num2str(k),'_stats.mat'),'stats')
    disp(k)
end