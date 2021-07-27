%%

function [tof] = isclose(A, B, t)
%
tof = 1;
%
if ~isequal(size(A), size(B))
    warning('Check dimentions.')
    return
end
%
for i = 1:size(A,1)
    for j = 1:size(A,2)
        if abs(A(i,j) - B(i,j))>= t
            tof = 0;
            break
        end
    end
end%endfunction