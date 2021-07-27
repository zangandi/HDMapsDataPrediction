%% This function convert csv to mat
%
%
clear all%
%
out_dir = 'G:\run_0113\';
model_list = {'lstm-','normal-lstm-','normal-rnn-'};
string1 = 'exp';
n_exp = 6;
step = [1,3,5,7];
% fast_mat = [];
%
for i = 1:length(step)
    for j = 1:n_exp
        for k = 1:length(model_list)
            folder_name = strcat(num2str(step(i)), model_list{k}, string1, num2str(j));
            folder_dir = strcat(out_dir, folder_name);
            folder_mat = strcat(out_dir, folder_name, '.mat');
            %
            if exist(strcat(out_dir,num2str(step(i)),num2str(k),num2str(j),'.mat'),'file')~= 2
                %
                if exist(folder_dir,'dir')== 7
                    % find all csv files
                    result_csv_list = dir(strcat(folder_dir,'\*.csv'));
                    fast_mat = cell(1, length(result_csv_list));
                    for l = 1:length(result_csv_list)
                        % read
                        csv_dir = strcat(folder_dir, '\', result_csv_list(l).name);
                        data = csvread(csv_dir);
                        fast_mat{l} = data;
                    end%endfor l
                    % save
                    save(strcat(out_dir,num2str(step(i)),num2str(k),num2str(j),'.mat'), 'fast_mat');
                end
            end
            %
        end
    end
end
% number_of_trips = 10000;
% fast_mat = cell(6,number_of_trips);
% result_csv_list = dir(strcat(out_dir,dir_list{1},'\*.csv'));
% for i = 1:6
%     for j = 1:number_of_trips
%         csv_dir = strcat(out_dir, dir_list{i}, '\', result_csv_list(j).name);
%         %
%         data = csvread(csv_dir);
%         %
%         fast_mat{i,j} = data;
%     end
%     disp(i)
% end
% 
% save('.\results\6_normal_lstm_stages_on_train_results_run0119.mat', 'fast_mat');