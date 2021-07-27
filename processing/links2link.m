%% This function converts sublinks into a sorted link
%
%
%
function [link] = links2link(links)
%
links = link.links
%
m = zeros(size(links,1), size(links,1));
%
for i = 1:size(links,1)-1
    % current nodes
    this_nodes = links{i};
    for j = i+1:size(links,1)
        next_nodes = links{j};
        %
        if isequal(this_nodes(1,:), next_nodes(1,:))
            m(i,j) = 1;
        elseif isequal(this_nodes(1,:), next_nodes(end,:))
            m(i,j) = 2;
        elseif isequal(this_nodes(end,:), next_nodes(1,:))
            m(i,j) = 3;
        elseif isequal(this_nodes(end,:), next_nodes(end,:))
            m(i,j) = 4;
        else
            m(i,j) = 0;
        end
    end%endfor j
    %
    next_nodes
    
    %
    if i == 1
        
    else
        
    end%endif
end%endfor i
end%endfunction