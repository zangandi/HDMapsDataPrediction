%% [] 
%
function [pdf] = getPFD(y1, y2, n)
if size(y1,1) ~= size(y2,1)
    disp('e1')
    return
end

pdf = zeros(n,1);

pre_MAPE = abs((y1-y2)./y2);
mape_list = pre_MAPE(isfinite(pre_MAPE));

for i = 1:n
    this_idx_upper = mape_list<= i/n;
    this_idx_lower = mape_list >= (i-1)/n;
    this_idx = double(this_idx_upper).* double(this_idx_lower);
    pdf(i) = sum(this_idx);
end
%
pdf = pdf./sum(pdf)*100;
end