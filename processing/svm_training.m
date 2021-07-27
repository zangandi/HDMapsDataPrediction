%%
%
%
%
%
%
clear all;
%
csv_dir = 'G:\datasets\ready_0110\train_filtered\';
csv_list = dir(strcat(csv_dir,'*.csv'));
%
all_data = [];
% load data
for i = 1:1000:length(csv_list)
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
MdlLin29 = fitrlinear(x29,y);
t1 = toc
MdlLin89 = fitrlinear(x89,y);
t2 = toc
MdlLin93 = fitrlinear(x93,y);
t3 = toc

%
save('svm_models_rlinear.mat', 'MdlLin29', 'MdlLin89','MdlLin93');