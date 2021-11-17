clear all
% load trips
load('G:\didi\run_0113\111.mat');
% load edge information

y2 = zeros(size(fast_mat,2),1);
% duration, distance, mdc1, mdc2, mdc3, edge distance
y1 = zeros(size(fast_mat,2),1);
for i = 1:size(fast_mat,2)
    this_trip = fast_mat{i};
    %
    y1(i) = sum(this_trip(:,1));
    y2(i) = sum(this_trip(:,2));
    % 
end

mae(y1-y2)
this_MAPE = mape2(y2, y1)

[pdf2] = getPFD(y1, y2, 20);

YPred = y2;
YTest = y1;
save('D:\Dropbox\results\clean\lstm.mat','YPred', 'YTest');