%
%
clear all
% define zoome level range
zoomlevel = [20];
% define latitude range
latlist = [0:1:85];
long = -80;
% define dx, dy
dx = [0:1:255];
dy = [0];

spheroid = referenceEllipsoid('wgs84'); 
%
dp = zeros(length(latlist),length(dx));
for a = 1:length(zoomlevel)
    for b = 1:length(latlist)
        for c = 1:length(dx)
            for d = 1:length(dy)
                lat = latlist(b);
                l = zoomlevel(a);
                %
                pixelX = ((long+180)/360)*256*2^l;
                pixelY = (0.5-log((1+sin(lat*pi/180))/...
                         (1-sin(lat*pi/180)))/(4*pi))*256*2^l;
                % new pixel
                newX = pixelX + dx(c);
                newY = pixelY + dy(d);
                % 
                newlon1 = (360*newX)/(256*2^l) - 180;
                k = (1/2 - (newY)/(256*2^l))*4*pi;
                newlat1 = asind((exp(k)-1)/(exp(k)+1));
                %
                p1_ecef = lla2ecef([newlat1 newlon1 0]);
                %
                resolution = (cos(lat*pi/180)*2*pi*6378137)/(256*2^l);
                %
                
                E= dx(c)*resolution;
                N = -dy(d)*resolution;
                D = 0;
                % 
                [p2_ecefX, p2_ecefY, p2_ecefZ] = ned2ecef(N,E,D,lat,long,0,spheroid);
                p2_ecef = [p2_ecefX, p2_ecefY, p2_ecefZ];
                newp2 = ecef2lla(p2_ecef);
                newlat2 = newp2(1);
                newlon2 = newp2(2);
                %
                dp(b,c) = norm(p1_ecef-p2_ecef);
            end
        end
    end
end

% h = surf(latlist,zoomlevel,de*100,'EdgeColor','none');
h = mesh(dx,latlist,dp);
ylabel('latitude (degree)','Fontsize',18)
xlabel('d_x (pixel)','Fontsize',18)
zlabel('d_p (meter)','Fontsize',18)
axis([0 255 0 85])
box off