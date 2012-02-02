%creates a claw like structure with a specific width (the number of
%fingers) and level the number of joints
function[cmatrix]=claw(width,lvl)
    for i=1:(width*lvl)
        if i <= width*(lvl-1)
            cmatrix(i,:) = i+width;
        else
            cmatrix(i,:) = width*lvl+1
        end
    end
    cmatrix(width*lvl+1,:) = width*lvl+1;
end