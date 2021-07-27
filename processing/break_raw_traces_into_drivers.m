%% This function loads trace files as mat
%
%
clear all
%
trace_dir = 'G:\datasets\didi_traces\xian\gps_20161001';
%
trace_data = readtable(trace_dir,'ReadVariableNames', false);
%
save_dir = 'data\traces01\';
%
tic;
%
count = 1;
%
driver_list = {};
%
for i = 1:size(trace_data,1)
    if i == 1
        %
        fid = fopen(strcat(save_dir,num2str(count)),'w+');        
        %
        fprintf(fid,'%s, %s, %d, %f, %f\n', trace_data{i,1}{1}, trace_data{i,2}{1},...
                                            trace_data{i,3}, trace_data{i,4}, trace_data{i,5});
        driver_list = cat(1, driver_list, trace_data{i,1}{1});
    elseif i == size(trace_data,1)
        fprintf(fid,'%s, %s, %d, %f, %f\n', trace_data{i,1}{1}, trace_data{i,2}{1},...
                                            trace_data{i,3}, trace_data{i,4}, trace_data{i,5});
        fclose(fid);
    else
        % if driver is the same one
        if strcmp(trace_data{i,1}{1}, trace_data{i-1,1}{1})
            fprintf(fid,'%s, %s, %d, %f, %f\n', trace_data{i,1}{1}, trace_data{i,2}{1},...
                                            trace_data{i,3}, trace_data{i,4}, trace_data{i,5});
        else
            fclose(fid);
            count = count + 1;
            %
            driver_list = cat(1, driver_list, trace_data{i,1}{1});
            fid = fopen(strcat(save_dir,num2str(count)),'w+');   
            fprintf(fid,'%s, %s, %d, %f, %f\n', trace_data{i,1}{1}, trace_data{i,2}{1},...
                                            trace_data{i,3}, trace_data{i,4}, trace_data{i,5});
        end
    end
    if mod(i,10000) == 0
        disp(i);
    end
end
t1 = toc;