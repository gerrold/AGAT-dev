function[aaff]=globaff2(g,eps)

[r,s]=size(g);
rm = zeros(r,s);
aaff = 0;
    for i=1:r
        rm = repmat(g(i,:),r,1);
        rm = abs(rm-g);
        rm = rm < eps;
        aaff = aaff + sum(sum(rm));
        aaff = aaff /s - 1;
    end
    aaff=aaff/(r^2-r)*100;
end