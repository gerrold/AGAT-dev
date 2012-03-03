%testing out the new origamy function

res= 0.01;

m=zeros(size(0:res:1));

for x=0:res:1
    for y=0:res:1
        m(round(x/res + 1),round(y/res + 1)) = origamy([x y]);
    end
end

m=real(m);

surf(m)