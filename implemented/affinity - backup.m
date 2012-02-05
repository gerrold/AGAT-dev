function[aff]=affinity(g1,g2,eps)

aff=sum(abs(g1 - g2) < eps,2)/size(g1,2);

end