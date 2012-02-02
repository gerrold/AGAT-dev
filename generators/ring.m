%generates a ring connection matrix
function[cmatrix]=ring(Am,way)

for i=1:Am
    cmatrix(i,1)=i+1;
    if i==Am
        cmatrix(i,1)=1;
    end;
    if way == 1
        cmatrix(i,2)=i-1;
        if i==1
            cmatrix(i,2)=Am;
        end;
    end;
end;