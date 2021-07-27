%%
%
clear all
%
a1 = load('G:\run_0113\112.mat');
a2 = load('G:\run_0113\114.mat');
a3 = load('G:\run_0113\116.mat');
a4 = load('G:\run_0113\316.mat');
a5 = load('G:\run_0113\516.mat');
a6 = load('G:\run_0113\536.mat');
%
fast_mat = cat(1, a1.fast_mat, a2.fast_mat, a3.fast_mat,...
                  a4.fast_mat, a5.fast_mat, a6.fast_mat);
S = size(fast_mat,1);
%
number_of_trips = size(fast_mat,2);
%
L = 100;
results = zeros(number_of_trips, L, S);
results_ratio = zeros(number_of_trips, L, S);
gt = zeros(number_of_trips, L, S);
%
mse_result = zeros(S, number_of_trips);
trip_length = zeros(S, number_of_trips);
%
all_data = fast_mat;
% 
for k = 1:S
    for j = 1:number_of_trips
        data = all_data(k,j);
        data = data{1};
        %
        this_mse = immse(data(:,1),data(:,2));
        this_length = 0;
    %
        for i = 1:size(data,1)-1
            current_distance = distanceLLA(data(i,:), data(i,:), 1);
            this_length = this_length + current_distance;
        end%
        %
        mse_result(k,j) = this_mse;
        trip_length(k,j) = this_length;
        %
        current_result = zeros(1,L);
        current_MDC_ratio = ones(1,L)*999;
        current_gt = zeros(1,L);
        %
        for m = 1:size(data,1)-1
            %
            progress_ratio = ceil(m/size(data,1)*L);
            %
            this_mdc = data(m,1);
            this_gt = data(m,2);
            if this_gt~= 0
                this_mdc_ratio = abs(this_mdc-this_gt)/this_gt;
            else
                this_mdc_ratio = 0;
            end
            % update
            if current_MDC_ratio(progress_ratio) > this_mdc_ratio
                current_MDC_ratio(progress_ratio) = this_mdc_ratio;
                current_gt(progress_ratio) = this_gt;
                current_result(progress_ratio) = this_mdc;
            end
        end
        %
        results(j,:,k) = current_result;
        results_ratio(j,:,k) = current_MDC_ratio;
        gt(j,:,k) = current_gt;
    end%endfor j
end%endfor i
% visualize
H = 100;
range = [0, 2];
number_of_vertical_grids = (range(2) - range(1))*H;
%
stages_visualization_hit_map = inf(number_of_vertical_grids, L, S);
median_mdc = zeros(S,L);
%
for i = 1:S
    %
    this_mdc_ratio = zeros(number_of_trips,L);
    for j = 1:number_of_trips
        for k = 1:L
            this_mdc = results(j,k,i);
            this_gt = gt(j,k,i);
            % 
            if this_gt~= 0
                this_ratio = this_mdc/this_gt;
            else
                this_ratio = 0;
            end
            %
            if this_ratio < range(1)
                this_y = 1;
            elseif this_ratio > range(2)
                this_y = number_of_vertical_grids;
            else
                this_y = floor((this_ratio-range(1))/(range(2) - range(1))*number_of_vertical_grids);
                if this_y == 0
                    this_y = 1;
                end
                if stages_visualization_hit_map(this_y, k, i) == inf
                    stages_visualization_hit_map(this_y, k, i) = 1;
                else
                    stages_visualization_hit_map(this_y, k, i) = stages_visualization_hit_map(this_y, k, i) + 1;
                end
            end
            %
%             if stages_visualization_hit_map(this_y, k, i) == inf
%                 stages_visualization_hit_map(this_y, k, i) = 1;
%             else
%                 stages_visualization_hit_map(this_y, k, i) = stages_visualization_hit_map(this_y, k, i) + 1;
%             end
            %
            this_mdc_ratio(j,k) = this_ratio;
            %
        end
    end%endfor j
    %
    median_mdc(i,:) = median(this_mdc_ratio,1);
end%endfor i


figure;
FS = 3
hold on;
grid on
plot([1:100], median_mdc(1,:),'r-', 'linewidth', FS);
plot([1:100], median_mdc(2,:),'b-', 'linewidth', FS);
plot([1:100], median_mdc(5,:),'g-', 'linewidth', FS);
plot([1:100], median_mdc(4,:),'c-', 'linewidth', FS);
plot([1:100], median_mdc(3,:),'m-', 'linewidth', FS);
plot([1:100], median_mdc(6,:),'y-', 'linewidth', FS);
plot([1:100],ones(1,100), 'k--');
legend({'1B+LSTM', '1A+LSTM', '1T+LSTM', '3T+LSTM', '5T+LSTM', '5T+RNN', 'reference line:y=1'},'location','bestoutside');
xlabel('Normalized trip progress (%)')
ylabel('^{MDC''}/_{Ground truth} * 100%')
hold off;