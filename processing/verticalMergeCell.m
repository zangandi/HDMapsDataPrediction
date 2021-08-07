function [C] = verticalMergeCell(A,B)
[ma,na] = size(A);
[mb,nb] = size(B);
if ma ~= mb || na ~= nb
    warning('Check sizes of A and B.');
    C = [];
    return 
end
%
C = cell(ma, na);
%
for i = 1:ma
    for j = 1:mb
        if isempty(A{i,j}) && isempty(B{i,j})
            C{i,j} = [];
        elseif isempty(A{i,j}) && ~isempty(B{i,j})
            C{i,j} = B{i,j};
        elseif ~isempty(A{i,j}) && isempty(B{i,j})
            C{i,j} = A{i,j};
        else
            C{i,j} = cat(1, A(i,j), B(i,j));
        end
    end
end
end