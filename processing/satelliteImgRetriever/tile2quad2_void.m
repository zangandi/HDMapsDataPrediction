% tile to quadkey

function [quadkey] = tile2quad2(tileX, tileY)

quadkey = [];

tileX = dec2bin(tileX);
tileY = dec2bin(tileY);

% if (length(tileX)~=length(tileY))
%     if (length(tileX) > length(tileY))
%         tileY = sscanf(tileY,'%ld');
%         tileY = sprintf('%0*d',length(tileX),tileY);
%     else
%         tileX = sscanf(tileX,'%ld');
%         tileX = sprintf('%0*d',length(tileY),tileX);
%     end
% end
if (length(tileX)~=length(tileY))
    if (length(tileX) > length(tileY))
        for i = 1:length(tileX)-length(tileY)
            tileY = strcat('0',tileY);
        end%endfor i
    else
        for i = 1:length(tileY)-length(tileX)
            tileX = strcat('0',tileX);
        end%endfor i
    end
end

tileX = num2str(tileX);
tileY = num2str(tileY);

for i = 1:length(tileX)
    quadkey = [quadkey tileY(i) tileX(i)];
end

quadkey = bin2dec(num2str(quadkey));
quadkey = dec2base(quadkey,4);
end%endfunction

