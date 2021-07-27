%% This function check if a targest B exists in A 
%
%
function [idx] = findidx(A, B)
%
if size(A,2) ~= size(B,2) && size(B,1) ~= 1
    warning('Check dimensions.')
end
%
idx = [];
%
for i = 1:size(A,1)
    if sum(A(i,:)==B) == size(A,2)
        idx = cat(1, idx, i);
    end
end%endfor i
end