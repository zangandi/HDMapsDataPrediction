clear all
%
load('.\results\step5-6stages.mat');

%
number_of_trips = size(fast_mat,2);
%
L = 10;
S = 4;
%
mse_result = cell(S, L);
%
all_data = fast_mat;
% 
for k = 1:S
    for j = 1:number_of_trips
        data = all_data(k,j);
        data = data{1};
        %
        for m = 1:size(data,1)-1
            %
            progress_ratio = ceil(m/size(data,1)*L);
            %
            pre_list = mse_result{k,progress_ratio};
            %
            new_list = cat(1, pre_list, data(m,:));
            %
            mse_result{k,progress_ratio} = new_list;
        end
        %
    end%endfor j
end%endfor i
%


mse_value = zeros(S,L);
for i = 1:S
    for j = 1:L
        this_list = mse_result{i,j};
        mse_value(i,j) = immse(this_list(:,1), this_list(:,2));
    end
end


figure;
hold on;
plot([1:L], mse_value(1,:),'r-');
plot([1:L], mse_value(2,:),'b-');
plot([1:L], mse_value(3,:),'k-');
plot([1:L], mse_value(4,:),'c-');
% legend({'B w/o', 'B w/', 'A w/o', 'A w/', 'T w/o', 'T w/'});
legend({'BF w/o', 'BF w/', 'AF w/o', 'AF w/'});
xlabel('Normalized trip progress (10% per bin)')
ylabel('MSE of the portion of the trip')
hold off;