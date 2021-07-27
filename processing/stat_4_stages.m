% This function stats prediction results
%
clear all
%
run_dir = 'G:\datasets\run1231-gpu-7\';
%
stage1_dir = strcat('G:\datasets\run1216\stage1\');
% get file list
result_stage1_list = dir(strcat(stage1_dir,'*.csv'));
% initialize result list
%   stage1
%   stage2
%   stage3
%   stage4
L = 100;
%
S = 2;
%
results = zeros(length(result_stage1_list), L, S);
results_ratio = zeros(length(result_stage1_list), L, S);
% ground truth
gt = zeros(length(result_stage1_list), L, S);
%
all_results = zeros(S,580402);
all_gt = zeros(S,580402);
all_preogress_ratio = zeros(S,580402);
%
fast_mat = cell(S,length(result_stage1_list));
%
for i = 1:S
    %
    total_length = 0;
    %
    stage_dir = strcat(run_dir,'stage',num2str(i),'\');
    for j = 1:length(result_stage1_list)
        csv_dir = strcat(stage_dir, result_stage1_list(j).name);
        %
        data = csvread(csv_dir);
        %
        fast_mat{i,j} = data;
        %
        current_result = zeros(1,L);
        current_MDC_ratio = ones(1,L)*999;
        current_gt = zeros(1,L);
        %
        for k = 1:size(data,1)-1
            %
            progress_ratio = ceil(k/size(data,1)*L);
            %
            this_mdc = data(k,1);
            this_gt = data(k,2);
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
            %
            total_length = total_length + 1;
            all_results(i,total_length) = this_mdc;
            all_gt(i,total_length) = this_gt;
            all_preogress_ratio(i,total_length) = k/size(data,1);
        end
        %
        results(j,:,i) = current_result;
        results_ratio(j,:,i) = current_MDC_ratio;
        gt(j,:,i) = current_gt;
        %
        disp(j)
    end%endfor j
end%endfor i
%
a = results(:,:,1);
%
H = 100;
range = [0, 2];
number_of_vertical_grids = (range(2) - range(1))*H;
%
stages_visualization_hit_map = inf(number_of_vertical_grids, L, S);
%
median_mdc = zeros(S,L);
%
for i = 1:S
    %
    this_mdc_ratio = zeros(length(result_stage1_list),L);
    for j = 1:length(result_stage1_list)
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
%
figure
for i = 1:S
    subplot(2,2,i)
    hold on;
    newimage = myheatmap(stages_visualization_hit_map(:, :, i),1,[]);
    image('CData',newimage,'XData',[0 L],'YData',[0 5])
    plot([1:L],median_mdc(i,:), 'w-');
    plot([1:L], ones(1,L), 'w-');
    ylim([0 5])
    xlim([0 L])
    title(strcat('Stage',num2str(i)))
    hold off;
end

figure
hold on;
newimage = myheatmap(stages_visualization_hit_map(:, :, 4),1,[]);
image('CData',newimage,'XData',[0 L],'YData',[0 2])
plot([1:L],median_mdc(4,:), 'w-', 'linewidth', 3);
plot([1:L], ones(1,L), 'w--');
legend({'Stage 4'});
ylim([0 2])
xlim([0 L])
hold off;
%
save('step7.mat', 'fast_mat', 'stages_visualization_hit_map');
% figure
% hold on
% %
% L = 100;
% %
% normalized_ratio_to_duration = [];
% %
% for i = 1:size(result_trips_list,1)
%     %
%     trip_id_full = result_trips_list(i).name;
%     trip_id_string = trip_id_full(1:end-4);
%     % load raw data
%     data_predict = csvread(strcat(result_dir, trip_id_full));
%     if size(data_predict,1)>=100
%         %
%         mdc_raw = data_predict(:,2);
%         mdc_predict = data_predict(:,1); 
%         %
%         predict_to_raw_ratio = mdc_predict./mdc_raw;
%         %
%         current_normalized_ratio_to_duration = zeros(1,L);
%         %
%         for j = 1:L
%             if j == 1
%                 spot = predict_to_raw_ratio(1);
%             elseif j == L
%                 spot = predict_to_raw_ratio(L);
%             else
%                 spot = predict_to_raw_ratio(round(j/L*size(mdc_raw,1)));
%             end
%             current_normalized_ratio_to_duration(j) = spot;
%         end
%         %
%         normalized_ratio_to_duration = cat(1, normalized_ratio_to_duration, current_normalized_ratio_to_duration);
%         %
%     end
%     %
%     %
%     plot([1:100], current_normalized_ratio_to_duration, 'ro');
% end
% plot([1:100], median(normalized_ratio_to_duration), 'b-');
%% ROC like stuff
% roc_range = 100;
% 
% figure
% for i = 1:4
%     total_over_gt_max = 0;
%     for j = 1:length(result_stage1_list)
%         gt_max = max(gt(j,:,i));
%         number_over_gt_max = sum(results(j,:,i)>gt_max);
%         total_over_gt_max = total_over_gt_max + number_over_gt_max;
%     end%endfor j
%     total_over_gt_max
% end
% 
% for i = 1:4
%     mean((desired - mean).^2);
% end
% 
% 
% 
% figure
% hold on;
% plot([1:L], all_gt(1,1:L), 'g-');
% plot([1:L], all_results(1,1:L), 'r--');
% % plot([1:1000], all_gt(2,1:1000), 'b-');
% plot([1:L], all_results(2,1:L), 'b--');
% % plot([1:1000], all_gt(3,1:L), 'k-');
% plot([1:L], all_results(3,1:L), 'k--');
% % plot([1:1000], all_gt(4,1:1000), 'c-');
% plot([1:L], all_results(4,1:L), 'c--');
% ylim([0 2])
% xlim([0 L])
% legend({'ground truth','stage 1', 'stage 2', 'stage 3', 'stage 4'})
% hold off