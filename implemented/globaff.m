function[aaff]=globaff(g,eps)
aaff = 0;
    for i=1:size(g,1)
        aaff = aaff + sum(sum(abs(repmat(g(i,:),size(g,1),1) - g) < eps,2))/size(g,2) - 1;
    end
    aaff = aaff/(size(g,1)^2 - size(g,1))*100;   
end