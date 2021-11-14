%

all_length = [];
all_time = [];
all_num_of_batches = [];
all_num_of_edges = [];
has_traffic = [];
all_mdcs= [];

for i = 1:size(training_data,2)
    this_link = training_data{i};
    %
    all_length = cat(1, all_length, this_link.length);
    all_num_of_batches = cat(1, all_num_of_batches, size(this_link.timestamp,1));
    all_time = cat(1, all_time, this_link.duration);
    all_num_of_edges = cat(1, all_num_of_edges, size(this_link.cpath,2));
    all_mdcs = cat(1, all_mdcs, this_link.mdc);
    %   
end

figure
hold on
xlabel('Trip length (m)');
ylabel('Trip duration (s)');

plot(all_length, all_time,'r.');


figure
hold on
xlabel('Trip length (m)');
ylabel('Trip MDC');

plot(all_length, all_mdcs,'g.');

figure
hold on
xlabel('Trip duration (s)');
ylabel('Trip MDC');

plot(all_time, all_mdcs,'b.');




for i = 1:size(all_length,1)
    if has_traffic(i) == 0
        plot(all_length(i), all_mdcs(i), 'r*');
    else
        plot(all_length(i), all_mdcs(i), 'g*');
    end
end
legend({'w/o traffic', 'w/ traffic'},'location','southeast')



has_t_length= 0;
no_t_length = 0;
for i = 1:size(all_length,1)
    if has_traffic(i) == 0
        no_t_length = no_t_length + all_length(i);
    else
        has_t_length = has_t_length + all_length(i);
    end
end