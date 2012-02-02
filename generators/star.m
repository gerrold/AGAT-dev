function[cmatrix]=star(nodes)
cmatrix(1,1)=inf;
for i=2:nodes
    cmatrix(i,1)=1;
end;