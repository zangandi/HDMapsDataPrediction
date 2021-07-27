clear all
%
a1 = load('G:\run_0113\512.mat');
a2 = load('G:\run_0113\514.mat');
a3 = load('G:\run_0113\516.mat');
%
% fast_mat = cat(1, a1.fast_mat, a2.fast_mat, a3.fast_mat);
fast_mat = a3.fast_mat;
%
number_of_trips = size(fast_mat,2);
%
L = 1;
S = size(fast_mat,1);
results_cell = cell(S, L);
%
all_data = fast_mat;
% 
for k = 1:S
    for j = 1:number_of_trips
        data = all_data(k,j);
        data = data{1};
        for m = 1:size(data,1)-1
            %
            if ~isnan(data(m,1)) && ~isnan(data(m,2))
                progress_ratio = ceil(m/size(data,1)*L);
                %
                current_list = results_cell{k,progress_ratio};
                %
                if isempty(current_list)
                    results_cell{k,progress_ratio} = data(m,:);
                else
                    results_cell{k,progress_ratio} = cat(1, current_list, data(m,:));
                end
            end
        end
        %disp(j)
    end%endfor j
    disp(k)
end%endfor i
%
mape_mat = zeros(S, L);
mse_mat = zeros(S, L);
%
for i = 1:S
    for j = 1:L
        data = results_cell{i,j};
        mape_mat(i,j) = mape(data);
        mse_mat(i,j) = immse(data(:,2), data(:,1));
    end
end
%