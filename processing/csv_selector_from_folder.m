%%
%
%
%
%
%

clear all
%
raw_dir = 'G:\datasets\ready_1224\';
save_train_dir = 'G:\datasets\ready_0110\train\';
% save_test_dir = 'G:\datasets\ready_1224\2000_testing\';
%
all_files = [];
%
for i = 1:30
    current_raw_dir = strcat(raw_dir, num2str(i),'\');
    current_files = dir(strcat(current_raw_dir,'*.csv'));
    all_files = cat(1, all_files, current_files);
end
%
number_of_train = 13000;
% number_of_test = 200;
%
random_file_list = randi([1 length(all_files)], 1, number_of_train);
% move train
for i = 1:number_of_train
    a = copyfile(strcat(all_files(random_file_list(i)).folder,'\',...
                    all_files(random_file_list(i)).name),...
             save_train_dir);
         
end
% move test
% for i = number_of_train+1:number_of_train+number_of_test
%     a = copyfile(strcat(all_files(random_file_list(i)).folder,'\',...
%                     all_files(random_file_list(i)).name),...
%              save_test_dir);
%     if a == 0
%         break
%     end
% end