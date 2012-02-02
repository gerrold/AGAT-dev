%generates a migration scheme and returns the required amount of islands
%value. usage: [cMatrix reqAm]=bTree(lvl) where: cMatrix is the connection
%matrix, and reqAm is the required amount of islands. lvl stands for the
%number of subdivisions or the brancheness of the tree.

function[cMatrix reqAm]=bTree(lvl)

reqAm = (2^lvl) -1;

cMatrix(1,1)=1;
for i=1:(reqAm - 1)
    if mod(i+1,2) == 1
        cMatrix(i+1,1)=(i)/2;
        
    else
        cMatrix(i+1,1)=(i+1)/2;
        
    end;
    
end;

cMatrix(1,1)=inf;