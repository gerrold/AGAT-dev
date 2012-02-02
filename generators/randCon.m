function[cmatrix]=randCon(nodes,cAmm)
for i=1:nodes
    for k=1:cAmm
        cmatrix(i,k)=ceil(rand(1)*nodes);
    end;
end;