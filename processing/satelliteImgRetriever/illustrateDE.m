%
%
clear all
% define zoome level
zoomlevel = [17:.1:21];
% define latitude
latlist = [0:0.1:80];
long = -0;
%
de = zeros(length(zoomlevel), length(latlist));
for h = 1:length(zoomlevel)
    for p = 1:length(latlist)
        lat = latlist(p);
        center = [lat, long];
        o = zoomlevel(h);
        % convert lat lon to tile
        pixelX = ((center(2)+180)/360)*256*2^o;
        pixelY = (0.5-log((1+sin(center(1)*pi/180))/...
            (1-sin(center(1)*pi/180)))/(4*pi))*256*2^o;
        % convert tile pixel to tile
        tileX = floor(pixelX/256);
        tileY = floor(pixelY/256);
        % calculate corner locations
        corners = zeros(4,2); % UL->BL->UR->BR
        count = 1;
        for i = tileX:tileX+1
            for j = tileY:tileY+1
                lon = (360*i*256)/(256*2^o)-180;
                k = (1/2 - (j*256)/(256*2^o))*4*pi;
                sinLat = (exp(k)-1)/(exp(k)+1);
                lat = asind(sinLat);
                %
                corners(count,:) = [lat lon];
                count = count + 1;
            end%endfot j
        end%endfor i
        corners_ecef = lla2ecef(cat(2, corners, zeros(4,1)));
        % calculate distance
        de(h,p) = abs(norm(corners_ecef(4,:)-corners_ecef(2,:))...
                     -norm(corners_ecef(3,:)-corners_ecef(1,:)));
    end%endfor j
end%endfor i

% h = surf(latlist,zoomlevel,de*100,'EdgeColor','none');
h = mesh(latlist,zoomlevel,de*100);
xlabel('latitude (degree)','Fontsize',18)
ylabel('zoom level','Fontsize',18)
zlabel('d_e (meter)','Fontsize',18)
box off