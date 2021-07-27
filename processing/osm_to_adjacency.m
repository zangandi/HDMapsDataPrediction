%% OSM to adjacency matrix
%
%
%
clear all
%
link_ids = csvread('.\data\xian_osm_1009\links_ways.txt');
%
link_node_dir = '.\data\xian_osm_1009\osm\';
%


osm_adjacency = zeros(length(link_ids), length(link_ids));
osm_intersection = cell(length(link_ids), length(link_ids));
%
fid = fopen('osm_adjacency_log.txt', 'w');
%
for i = 1:length(link_ids)-1
    %
    link1 = csvread(strcat(link_node_dir,num2str(link_ids(i)),'.nodes'));
    %
    if length(link1) < 2
        fprintf(fid, '%s\n', strcat(num2str(link_ids(i)), ' has fewer than 2 nodes.'));
    end
    %
    for j = i+1:1:length(link_ids)
        %     
        link2 = csvread(strcat(link_node_dir,num2str(link_ids(j)),'.nodes'));
        %
        for k = 1:length(link1)
            for l = 1:length(link2)
                if link1(k) == link2(l)
                    % count + 1
                    osm_adjacency(i,j) = osm_adjacency(i,j) + 1;
                    % save the intersection
                    osm_intersection{i,j} = cat(1, osm_intersection{i,j}, link1(k));
                    %
                end
            end%endfor k
        end%endfor l
        %
    end
end
fclose(fid);%

save('osm_1013_adjacency.mat', 'osm_adjacency', 'osm_intersection')

[x,y] = find(osm_adjacency==2);
load osm_1013_link.mat
a=8;
link1 = osm{x(a)};
link2 = osm{y(a)};
figure;
hold on;
plot(link1(:,2), link1(:,1), 'r-');
plot(link2(:,2), link2(:,1), 'g-');


x = 0:pi/100:2*pi;
y = sin(x);
plot(x,y)