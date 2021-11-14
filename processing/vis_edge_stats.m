%

all_length = [];
all_num_of_batches = [];
has_traffic = [];
all_mdcs= [];

for i = 1:size(all_links,1)
    this_link = all_links{i};
    if this_link.total_mdc(1) ~=0
        %
        all_length = cat(1, all_length, this_link.dist);
        all_num_of_batches = cat(1, all_num_of_batches, this_link.num_of_batches);
        %
        if this_link.tti(1) == 0
            has_traffic = cat(1, has_traffic, 0);
        else
            has_traffic = cat(1, has_traffic, 1);
        end
        all_mdcs = cat(1, all_mdcs, this_link.total_mdc(1));
        %
    end
        
end

figure
hold on
xlabel('Edge length (m)');
ylabel('Edge MDC')

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