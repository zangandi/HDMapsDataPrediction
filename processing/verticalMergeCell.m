function [C] = verticalMergeCell(A, B, hitmap)
[ma,na] = size(A);
[mb,nb] = size(B);
[mh,nh] = size(hitmap);
if ma ~= mb || na ~= nb || ma ~= mh || na ~= nh
    warning('Check sizes of A and B.');
    C = [];
    return 
end
%
% C = cell(ma, na);
%
% for i = 1:ma
%     for j = 1:mb
%         if isempty(A{i,j}) && isempty(B{i,j})
%             C{i,j} = [];
%         elseif isempty(A{i,j}) && ~isempty(B{i,j})
%             C{i,j} = B{i,j};
%         elseif ~isempty(A{i,j}) && isempty(B{i,j})
%             C{i,j} = A{i,j};
%         else
%             C{i,j} = cat(1, A(i,j), B(i,j));
%         end
%     end
% end
C = A;

[x,y] = find(hitmap~=0);

for i = 1:length(x)
    for j = 1:length(y)
        if isempty(A{x(i),y(j)}) && isempty(B{x(i),y(j)})
            continue;
        elseif isempty(A{x(i),y(j)}) && ~isempty(B{x(i),y(j)})
            C{x(i),y(j)} = B(x(i),y(j));
        elseif ~isempty(A{x(i),y(j)}) && isempty(B{x(i),y(j)})
            continue;
        else
            C{x(i),y(j)} = cat(1, A{x(i),y(j)}, B(x(i),y(j)));
        end
    end
end
end