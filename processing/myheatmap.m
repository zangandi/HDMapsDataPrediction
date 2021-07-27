%%
%
%
% May 30, 2018
% Add inf value to represent black
% Add flag
%
%
function [heatmap] = myheatmap(img,flag,cutrange)
%
if size(img,3)~=1
    disp('Must be single channel image.')
    return
end%endif
% initialize heatmap
% heatmap = zeros(size(img,1), size(img,2), 3);
% inf mask
inf_mask = img==inf;
%
minvalue = min(min(img));
for i = 1:size(img,1)
    for j = 1:size(img,2)
        if img(i,j) == inf
            img(i,j) = minvalue;
        end
    end
end
% change inf value to the smallest value
maxvalue = max(max(img));
if isempty(cutrange)
    myrange = maxvalue - minvalue;
else
    myrange = max(cutrange) - min(cutrange);
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            if img(i,j) < min(cutrange)
                img(i,j) = min(cutrange);
            elseif img(i,j) > max(cutrange)
                img(i,j) = max(cutrange);
            else
                img(i,j) = img(i,j);
            end
        end
    end
end
%
% for i = 1:size(img,1)
%     for j = 1:size(img,2)
%         %
%         intensity = maxvalue - img(i,j);
%         % normalize
%         normalized_intensity = (intensity)/myrange*240/360;
%         % convert to hsv color
%         hsvcolor = ones(length(intensity),1,3);
%         hsvcolor(:,1,1) = normalized_intensity;
%         % convert to rgb color
%         rgbcolor = hsv2rgb(hsvcolor);
%         %
%         heatmap(i,j,1) = rgbcolor(1);
%         heatmap(i,j,2) = rgbcolor(2);
%         heatmap(i,j,3) = rgbcolor(3);
%     end%endfor j
% end%endfor i
%
if flag == 1
    intensity = maxvalue - img;
elseif flag == -1
    intensity = img - minvalue;
else
    disp('Please check your flag.');
end
% normalize
normalized_intensity = (intensity)/myrange*240/360;
%
hsvcolor = cat(3, normalized_intensity,...
                  ones(size(img)),...
                  ones(size(img)));
heatmap = hsv2rgb(hsvcolor);
% add black layer
for i = 1:size(img,1)
    for j = 1:size(img,2)
        if inf_mask(i,j) == 1
            heatmap(i,j,1) = 0;
            heatmap(i,j,2) = 0;
            heatmap(i,j,3) = 0;
        end
    end
end
end%endfunction