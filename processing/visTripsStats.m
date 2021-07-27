%% This function visualizes trip stats
%
%
%
clear all
mm_data = load('mm_trip_stats.mat');
mdc_data = load('mdc_trip_stats.mat');

a = mm_data.timewindow_count;
b = mdc_data.timewindow_count;

rn = 10;
cn = 5;
ap = expand_heatmap(myheatmap(a',1,[]),rn,cn);
bp = expand_heatmap(myheatmap(b',1,[]),rn,cn);

imshow(ap)


% figure
% hold on;
% image('CData',flipdim(bp,1),'XData',[0 120],'YData',[0 140])
% image('CData',flipdim(ap,1),'XData',[0 120],'YData',[160 300])
% axis off;
% x0 = 0;
% y0 = 150;
% for i = 0:12
%     plot([x0 x0], [0 300], 'k-')
%     text(x0, y0, strcat(num2str(i*2),':00'));
%     x0 = x0 + 10;  
% end
% date_str = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'};
% 
% x0 = -5;
% y0 = 290;
% for i = 1:7
%     text(x0, y0, date_str{i});
%     y0 = y0 - 20;
% end
% 
% x0 = -5;
% y0 = 130;
% for i = 1:7
%     text(x0, y0, date_str{i});
%     y0 = y0 - 20;
% end

figure
hold on;
image('CData',flipdim(ap,1),'XData',[0 120],'YData',[0 140])
axis off;
x0 = 0;
y0 = 150;
for i = 0:12
    plot([x0 x0], [0 140], 'k-')
    if i == 12
        text(x0, y0, '23:59:59','fontsize',20);
    else
        text(x0, y0, strcat(num2str(i*2),':00 -'),'fontsize',20);
    end
    x0 = x0 + 10;  
end
date_str = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'};

x0 = -8;
y0 = 130;
for i = 1:7
    text(x0, y0, date_str{i},'fontsize',20);
    y0 = y0 - 20;
end
% 
% text(0, 165, 'Time slot, 10 minutes per grid','fontsize',20)
% text(-15, 130, 'Day','fontsize',20)