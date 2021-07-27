%% This function check if a targest B exists in A 
%
%
function [idx] = findidxcell(A, B)
%
if ~isempty(A)
    if size(A,2) ~= size(B,2) && size(B,1) ~= 1
        warning('Check dimensions.')
    end
    %
    idx = [];
    %
    for i = 1:size(A,1)
        if A{i} == B
            idx = cat(1, idx, i);
        end
    end%endfor i
else
    idx = [];
end