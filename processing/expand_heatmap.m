function [new_heatmap] = expand_heatmap(heatmap,rn,cn)
    r = size(heatmap,1);
    c = size(heatmap,2);
    %
    if size(heatmap,3) == 1
        new_heatmap = zeros(rn*r, cn*c);
    elseif size(heatmap,3) == 3
        new_heatmap = zeros(rn*r, cn*c, 3);
    else
        disp('Please check input heatmap.')
    end
    %
    for i = 1:r
        for j = 1:c
            if size(heatmap,3) == 1
                new_heatmap((i-1)*rn+1:i*rn, (j-1)*cn+1:j*cn) = heatmap(i,j);
            elseif size(heatmap,3) == 3
                new_heatmap((i-1)*rn+1:i*rn, (j-1)*cn+1:j*cn,1) = heatmap(i,j,1);
                new_heatmap((i-1)*rn+1:i*rn, (j-1)*cn+1:j*cn,2) = heatmap(i,j,2);
                new_heatmap((i-1)*rn+1:i*rn, (j-1)*cn+1:j*cn,3) = heatmap(i,j,3);
            else
                disp('Please check input heatmap.')
            end
        end
    end
    %
end