function [tf] = iscrossLLA(a, b, c, d)
%% this function is used to find if line a-b cross line c-d
% 01/21 change algorithm
nC = findNorm2(c, a, b);
nD = findNorm2(d, a, b);
nA = findNorm2(a, c, d);
nB = findNorm2(b, c, d);
if(~ieq(nC,nD)&&~ieq(nA,nB))
	tf = true;
else
	tf = false;
end
end

function [tf] = ieq(a, b)
%% this function is used to find if vec a is equal to vec b
if(norm(a-b)<0.0001)
    tf = true;
else
    tf = false;
end
end

function [nUnitVec] = findNorm2(c, a, b)
%% this function is used to calculate normal vector to line a-b 
% from point c
AB = b - a;
AC = c - a;
AD = dot(AC, AB/norm(AB))*AB/norm(AB);
d = AD + a;
if((d(1)==c(1)&&d(2)==c(2)))
    nUnitVec = [0 0];
else
    nUnitVec = (c - d)/norm(c - d);
end
end