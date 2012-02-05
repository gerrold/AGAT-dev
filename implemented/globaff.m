function[aaff]=globaff(g,eps)

if size(g,1) > 2
    aaff = globaff(g(2:size(g,1),:),eps);
    aaff = sum(affinity(repmat(g(1,:),size(g(2:size(g,1),:),1),1),g(2:size(g,1),:),eps)) + aaff;
else
    aaff = affinity(g(1,:),g(2,:),eps);
end
    function[aff]=affinity(g1,g2,eps)
        aff=sum(abs(g1 - g2) < eps,2)/size(g1,2);
    end
end