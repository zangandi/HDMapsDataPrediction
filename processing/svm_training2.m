%%
%
%
%
%
%
clear all;
%
csv_dir = 'G:\datasets\ready_0110\train\';
csv_list = dir(strcat(csv_dir,'*.csv'));
%
all_data = [];
% load data
for i = 1:100:length(csv_list)
    csv_name = strcat(csv_dir,csv_list(i).name);
    data = csvread(csv_name);
    all_data = cat(1, all_data, data);
    if mod(i,100) == 1
        disp(i)
    end
end%endfor i
% train
% split data
y = all_data(:,1);
x29 = all_data(:,2:30);
x89 = all_data(:,2:90);
x93 = all_data(:,2:94);
% train
tic;
%MdlLin29 = fitrsvm(x29,y);
t1 = toc;
%MdlLin89 = fitrsvm(x89,y);
t2 = toc;
MdlLin93 = fitrsvm(x93,y);
t3 = toc;

%
save('svm_models93.mat', 'MdlLin93')