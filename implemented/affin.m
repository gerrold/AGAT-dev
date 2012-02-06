% afinita populacie
function[aff]=affin(pop,eps)

[vp,vr]=size(pop);
n=0; a=0;

for prvy=1:(vp-1)
    for druhy=(prvy+1):vp
        n=n+1;
        a=a+sum(abs(pop(prvy,:)-pop(druhy,:))< eps)/vr;
    end;
end;

aff=a/n;