%% This function returns line equation with given inputs p1 and p2.
% aZ
function [A, B, C] = solveLineEquation(p1, p2)
% Solve line equation Ax + By + C = 0
% Solve A
A = p2(2) - p1(2);
% Solve B
B = p1(1) - p2(1);
% Solve C
C = p2(1)*p1(2) - p1(1)*p2(2);
end%endfunction