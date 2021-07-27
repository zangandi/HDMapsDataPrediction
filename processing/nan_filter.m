clear all%
%
indir = 'G:\datasets\ready_1207\advanced_train\';
inlist = dir(strcat(indir,'*.csv'));
outdir = 'G:\datasets\ready_1207\filtered_90\';
mkdir(outdir);
%
for i = 1:length(inlist)
    data = csvread(strcat(indir, inlist(i).name));
    %
    total_time = sum(data(:,2));
    %
    t_ratio = zeros(size(data,1),1);
    %
    if total_time ~= 0
        for j = 1:size(data,1)
            t_ratio(j) = sum(data(1:j,2))/total_time;
        end
    new_data = cat(2, data(:,1:70),t_ratio);
    csvwrite(strcat(outdir, inlist(i).name), new_data);
    end
end