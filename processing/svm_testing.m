%% svm_testing
%
%
%
clear all%
% load svm models
load('svm_models_rlinear.mat')
%
results_dir = 'G:\run_0113\test\';
results_list = dir(strcat(results_dir,'*.csv'));
%
save_dir29 = 'G:\run_0113\svm29\';
save_dir89 = 'G:\run_0113\svm89\';
save_dir93 = 'G:\run_0113\svm93\';
%
for i = 1:length(results_list)
    data = csvread(strcat(results_dir, results_list(i).name));
    %%%%%
    fid29 = fopen(strcat(save_dir29,results_list(i).name),'w+');
    %
    for j = 1:size(data,1)-1
        %
        features29 = data(j,2:30);
        pmdc = predict(MdlLin29,features29);
        %
        fprintf(fid29,'%.6f, %.6f\n', pmdc, data(j,1));
    end
    fclose(fid29);
    %%%%%
    fid89 = fopen(strcat(save_dir89,results_list(i).name),'w+');
    %
    for j = 1:size(data,1)-1
        %
        features89 = data(j,2:90);
        pmdc = predict(MdlLin89,features89);
        %
        fprintf(fid89,'%.6f, %.6f\n', pmdc, data(j,1));
    end
    fclose(fid89);
    %%%%%
    fid93 = fopen(strcat(save_dir93,results_list(i).name),'w+');
    %
    for j = 1:size(data,1)-1
        %
        features93 = data(j,2:94);
        pmdc = predict(MdlLin93,features93);
        %
        fprintf(fid93,'%.6f, %.6f\n', pmdc, data(j,1));
    end
    fclose(fid93);
end


result_csv_list = dir(strcat(save_dir29,'\*.csv'));
fast_mat = cell(1, length(result_csv_list));
for l = 1:length(result_csv_list)
    % read
    csv_dir = strcat(save_dir29, '\', result_csv_list(l).name);
    data = csvread(csv_dir);
    fast_mat{l} = data;
end%endfor l
% save
save('G:\run_0113\svm29.mat', 'fast_mat');

result_csv_list = dir(strcat(save_dir89,'\*.csv'));
fast_mat = cell(1, length(result_csv_list));
for l = 1:length(result_csv_list)
    % read
    csv_dir = strcat(save_dir89, '\', result_csv_list(l).name);
    data = csvread(csv_dir);
    fast_mat{l} = data;
end%endfor l
% save
save('G:\run_0113\svm89.mat', 'fast_mat');

result_csv_list = dir(strcat(save_dir93,'\*.csv'));
fast_mat = cell(1, length(result_csv_list));
for l = 1:length(result_csv_list)
    % read
    csv_dir = strcat(save_dir93, '\', result_csv_list(l).name);
    data = csvread(csv_dir);
    fast_mat{l} = data;
end%endfor l
% save
save('G:\run_0113\svm93.mat', 'fast_mat');