%% This function reads road map
%
clear all
%
map_dir = '..\didi_tti\xian\boundary2.txt';
%
map = readtable(map_dir, 'Delimiter', '\t');
%
node_list = [360, 360];
%
road_map = cell(size(map,1),1);
%
for i = 1:size(map,1)%
    % link id
    id = map(i,:).obj_id;
    % link nodes
    node_string = map(i,:).geom;
    node_string = node_string{1};
    %
%     if strcmp(node_string(1:7),'POLYGON')
%         % this is a polygon
%         node_list = node_string(9:end-1);
%         M = textscan(node_list, '%s', 'Delimiter', '()');
        
    if strcmp(node_string(1:15),'MULTILINESTRING')
        % this is a multi-line
        node_string = node_string(16:end-1);
        % break node string into each link
        M = textscan(node_string, '%s', 'Delimiter', '()');
        % check M
        links = cell(0);
        %
        for j = 1:size(M{1},1)
            %
            m = M{1}{j};
            %
            point = [];
            %
            if isempty(m) || strcmp(m,',')
                continue;
            else
                % get point pairs
                cpoints_string = strsplit(m,',');
                cpoints = zeros(size(cpoints_string,2),2);
                %
                for k = 1:size(cpoints_string,2)
                    %
                    cpoint_string = cpoints_string{k};
                    cpoint_cell =strsplit(cpoint_string);
                    %
                    cpoints(k,1) = str2double(cpoint_cell{1});
                    cpoints(k,2) = str2double(cpoint_cell{2});
                end%endfor k
                % 
                ref_node = cpoints(1,:);
                nref_node = cpoints(end,:);
                % add reference and next reference node to node list
                ref_idx = findidx(node_list, ref_node);
                if isempty(ref_idx)
                    node_list = cat(1, node_list, ref_node);
                end
                nref_idx = findidx(node_list, nref_node);
                if isempty(nref_idx)
                    node_list = cat(1, node_list, nref_node);
                end
                %
                links = cat(1, links, cpoints);
            end
        end%endfor j
        %
        road_map{i}.id = id;
        road_map{i}.links = links;
    end
end

save('xian2.mat', 'node_list', 'road_map')