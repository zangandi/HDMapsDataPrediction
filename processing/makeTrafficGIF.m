%% 
clear all
%
load traffic_1029.mat
%
filename = 'traffic_2.gif';
%
speed_min = min(min(min(vis_speed_sequence)));
speed_max = max(max(max(speed_sequence)));
%
for k = 1:size(speed_sequence,3)
    im = myheatmap(vis_speed_sequence(:,:,k),1,[50, 0]);
    %
    d = floor((k-1)/(6*24))+1;
    h = floor((k - (d-1)*6*24-1)/6);
    m = k - (d-1)*6*24 - h*6;
    %
    switch d
        case 1
            text1 = 'Mon';
        case 2
            text1 = 'Tue';
        case 3
            text1 = 'Wed';
        case 4
            text1 = 'Thu';
        case 5
            text1 = 'Fri';
        case 6
            text1 = 'Sat';
        case 7
            text1 = 'Sun';
    end
    switch m
        case 1
            text3 = '[01-10]';
        case 2
            text3 = '[11-20]';
        case 3
            text3 = '[21-30]';
        case 4
            text3 = '[31-40]';
        case 5
            text3 = '[41-50]';
        case 6
            text3 = '[50-00]';
    end
    %
    im = insertText(im,[10 20],strcat(text1, '-', num2str(h), ':', text3), 'TextColor', 'w', 'FontSize', 30);
%     imshow(im)
    [A,map] = rgb2ind(im,256);
    if k == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.01);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.01);
    end
end%endfor k
