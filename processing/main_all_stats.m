%
clear all
%
addpath('.\satelliteImgRetriever\')
osm_node_list = csvread('.\data\xian_osm_1009\nodes.csv');
bbox = [34.279936, 108.92185, 34.207309, 109.009348];
%
all_traces = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%
for m = 1:30
    trace_dir = 'G:\datasets\didi\data\mm\gps_201610';
    if m <10
        trace_dir = strcat(trace_dir, '0', num2str(m), '\');
    else
        trace_dir = strcat(trace_dir, num2str(m), '\');
    end
    %
    all_trace_dir = dir(strcat(trace_dir,'*.csv'));
    % % write meta data
    %
    for i = 1:100:length(all_trace_dir)-1
        %
        trace_uuid = all_trace_dir(i).name;
        trace_uuid = trace_uuid(1:end-4);
        % load trace
        trace = csvread(strcat(trace_dir,all_trace_dir(i).name),1,0);
        %
        all_feature = [];
        basic_feature = [];
        % validate trace
        if ValidateTrace(trace, 6, 100, bbox, 100)
%             return
            % get internal features
            internal_feature = getInternalFeatures(trace);
            all_traces = cat(1, all_traces, internal_feature);
        else
            disp(strcat(trace_uuid, [' pass.']));
        end
    end%endfor i
end