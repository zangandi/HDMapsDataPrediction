%%

clear all

a1 = load('G:\datasets\run1216\2.mat');
a2 = load('G:\datasets\run1216\3.mat');
a3 = load('G:\datasets\run1216\4.mat');
% a4 = load('G:\run_0113\svm93.mat');
%
% fast_mat = cat(1, a1.fast_mat, a2.fast_mat, a3.fast_mat, a4.fast_mat);
fast_mat = cat(1, a1.fast_mat, a2.fast_mat, a3.fast_mat);
% fast_mat = a1.fast_mat;
%
E = size(fast_mat,1);
L = size(fast_mat,2);
%
all_mape = zeros(E,L);

for i = 1:E
    for j = 1:L
        this_mape = mape(fast_mat{i,j});
        all_mape(i,j) = this_mape;
    end
end

median(all_mape,2)

a = sort(all_mape(1,:));

all_mse = zeros(E,1);
for i = 1:E
    all_data = [];
    for j = 1:L
        if sum(sum(isnan(fast_mat{i,j}))) == 0
            all_data = cat(1, all_data, fast_mat{i,j});
        end
    end
%     all_data2 = [];
%     for j = 1:size(all_data,1)
%         if all_data(j,1) ~= 0 && all_data(j,2) ~= 0 && ~isnan(all_data(j,2)) && ~isnan(all_data(j,1))
%             all_data2 = cat(1, all_data2, all_data(j,:));
%         end
%     end
    %
    this_mse = immse(all_data(:,2), all_data(:,1));
    all_mse(i) = this_mse;
end
all_mse

% x = all_data2(:,2);
% y = all_data2(:,1);
% err = (norm(x(:)-y(:),2).^2)/numel(x);