function [list2] = removeDuplicatedListMat(list1)
%
list2 = list1;
pointer = 1;

while pointer ~= size(list2,1)
    flag = 0;
    for i = pointer+1:size(list2,1)
        if list2(pointer,:) == list2(i,:)
            flag = 1;
            break;
        end
    end%endfor i
    if flag == 1
        list2(pointer,:) = [];
    else
        pointer = pointer + 1;
    end
end
%
end%