%%


clear all
%
a1 = load('G:\run_0113\513.mat');
a2 = load('G:\run_0113\523.mat');
a3 = load('G:\run_0113\533.mat');
a4 = load('G:\run_0113\514.mat');
%
fast_mat = cat(1, a1.fast_mat, a2.fast_mat, a3.fast_mat, a4.fast_mat);
%
number_of_trips = size(fast_mat,2);
%
L = 100;
S = size(fast_mat,1);
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
hold on;
plot([1:100], median_mdc(1,:),'r-');
plot([1:100], median_mdc(2,:),'b-');
plot([1:100], median_mdc(3,:),'m-');
plot([1:100],ones(1,100), 'k--');
%legend({'B w/o', 'B w/', 'A w/o', 'A w/', 'T w/o', 'T w/'});
legend({'5A+srLSTM', '5A+LSTM', '5A+RNN', 'reference line:y=1'});
xlabel('Normalized trip progress (%)')
ylabel('^{MDC''}/_{Ground truth} * 100%')
hold off;

%%%%


%%%%
newmap = stages_visualization_hit_map(:,:,3);
for i = 1:size(newmap,2)
    newmap(:,i) = newmap(:,i)./2000;
end

%
% 
figure
hold on;
newimage = myheatmap(newmap,1,[]);
image('CData',newimage,'XData',[0 L],'YData',[0 2])
% plot([1:L],median_mdc(4,:), 'r-', 'linewidth', 2);
plot([1:L], ones(1,L), 'k--');
% legend({'5A+srLSTM','reference line:y=1'});
legend({'reference line:y=1'});
ylim([0 2])
xlim([0 L])
xlabel('Normalized trip progress (%)')
ylabel('^{MDC''}/_{Ground truth} * 100%')
hold off;


%%%%
% % ROC-like
% %
% % %
% roc_L = 100;
% %
% roc_all = zeros(S,roc_L);
% %
% for i = 1:roc_L
%     %
%     roc_ratio = i/roc_L;
%     %
%     for j = 1:S
%         % 
%         in_this_step_bar = 0;
%         total_size = 0;
%         %
%         for k = 1:number_of_trips
%             this_trip = all_data{j,k};
%             this_bar = (max(this_trip(:,2)) - min(this_trip(:,2))) * roc_ratio + min(this_trip(:,2));
%             in_this_bar = sum(this_trip(:,1)<=this_bar);
%             in_this_step_bar = in_this_step_bar + in_this_bar;
%             total_size = total_size + length(this_trip);
%         end%endfor k
%         %
%         roc_all(j,i) = in_this_step_bar/total_size;
%     end
% end
% %
% roc_gt = zeros(1,roc_L);
% in_this_step_bar = 0;
% total_size = 0;
% for i = 1:roc_L
%     roc_ratio = i/roc_L;
%     for k = 1:number_of_trips
%         this_trip = all_data{1,k};
%         this_bar = (max(this_trip(:,2)) - min(this_trip(:,2))) * roc_ratio + min(this_trip(:,2));
%         in_this_bar = sum(this_trip(:,2)<=this_bar);
%         in_this_step_bar = in_this_step_bar + in_this_bar;
%         total_size = total_size + length(this_trip);
%     end%endfor k
%     roc_gt(i) = in_this_step_bar/total_size;
% end
% %
% 
% figure;
% hold on;
% plot([1:L], roc_all(1,:),'r-');
% plot([1:L], roc_all(2,:),'b-');
% plot([1:L], roc_all(3,:),'k-');
% plot([1:L], roc_all(4,:),'m-');
% 
% plot([1:roc_L], roc_gt, 'g');
% % legend({'B w/o', 'B w/', 'A w/o', 'A w/', 'T w/o', 'T w/'});
% legend({'BF w/o', 'BF w/', 'AF w/o', 'AF w/', 'Ground truth'});
% xlabel('Normalized trip progress (%)')
% ylabel('^{Data usage prediction}/_{Ground truth} * 100%')
% hold off;