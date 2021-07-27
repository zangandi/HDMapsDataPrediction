%% This function is used to draw line on canvas
% aZ
function [canvas] = drawLine2D(canvas, p1, p2)
% Solve line equation Ax + By + C = 0
[A, B, C] = solveLineEquation(p1, p2);
% Render
if B == 0 % Vertical line
    for i = max(min(p2(2),p1(2)),1):min(max(p2(2),p1(2)),size(canvas,2))
        if round(-C/A)>0 && round(-C/A) <= size(canvas,1)
            canvas(round(-C/A), i) = 1;
        end
    end%endfor i
elseif A == 0 % Horizontal line
    for i = max(min(p2(1),p1(1)),1):min(max(p2(1),p1(1)),size(canvas,1))
        if round(-C/B)>0 && round(-C/B) <= size(canvas,2)
            canvas(i, round(-C/B)) = 1;
        end
    end%endfor i
else
    if abs(B/A) <=1
        for i = max(1,min(p2(2),p1(2))):min(max(p2(2),p1(2)),size(canvas,2))
            if round(-B/A*i-C/A)>0 && round(-B/A*i-C/A)<= size(canvas,1)
                canvas(round(-B/A*i-C/A), i) = 1;
            end
        end%endfor i      
    else
        for i = max(1,min(p2(1),p1(1))):min(max(p2(1),p1(1)),size(canvas,1))
            if round(-A/B*i-C/B)>0 && round(-A/B*i-C/B)<= size(canvas,2)
                canvas(i, round(-A/B*i-C/B)) = 1;
            end
        end%endfor i 
    end%endif
end
end%endfunction