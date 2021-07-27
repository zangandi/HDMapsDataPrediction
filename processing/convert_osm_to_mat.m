%% This function saves osm map data to mat
%
%
clear all
%
osm_link_nodes_dir = '.\data\xian_osm_1009\osm\';
osm_link_list = csvread('.\data\xian_osm_1009\links_ways.txt');
osm_node_list = csvread('.\data\xian_osm_1009\nodes.csv');
%
number_of_links = size(osm_link_list,1);
%
osm = [];
%
errcount = 0;
%
missing_nodes_list = [];
%
link_id_list = [];
%
for i = 1:number_of_links
    %
    link_id = osm_link_list(i);
    %
    link_dir = strcat(osm_link_nodes_dir,num2str(link_id),'.nodes');
    %
    node_ids = csvread(link_dir);
    %
    nodes = zeros(size(node_ids,1),3);
    %
    flag = 0;
    %
    for j = 1:size(node_ids,1)
        %
        idx = findidx(osm_node_list(:,1), node_ids(j));
        %
        if ~isempty(idx)
            nodes(j,:) = [node_ids(j) osm_node_list(idx,2:3)];
        else
            missing_nodes_list = cat(1, missing_nodes_list, node_ids(j));
            flag = 1;
        end
    end%endfor j
    %
%     link.nodes = nodes;
%     link.id = link_id;
    %
    if flag == 0
        if i == 0
            %
%             osm{i} = link;
            %
            osm{i} = nodes;
        else
            %
%             osm = cat(1, osm, link);
            %
            osm = cat(1, osm, {nodes});
        end
    else
        errcount = errcount + 1;
        disp(i);
    end
    %
    link_id_list = cat(1, link_id_list, link_id);
    
    %
end%endfor i
%

save('osm_0614_link.mat', 'osm', 'link_id_list');

% missing_nodes_list1 = removeDuplicatedListMat(missing_nodes_list);
% fid = fopen('missing_osm_nodes_1009.csv','w');
% for i = 1:size(missing_nodes_list1)
%     if i == 1
%         fprintf(fid,'%s\n',num2str(missing_nodes_list1(1)));
%     else
%         if isempty(findidx(missing_nodes_list1(1:i-1),missing_nodes_list1(i)))
%             fprintf(fid,'%s\n',num2str(missing_nodes_list1(i)));
%         end
%     end
% end%endfor i
% fclose(fid);