% Rana (normalized)
% Number of variables : n
% The global optimum is: f(x)=-512.7532; x(i)=-514.0417, i=1:n 
% -520 < x < 520 (constrained) 

function[Fit]=rana(Pop)

[lpop,lstring]=size(Pop);

global evals

for i=1:lpop

    x=Pop(i,:);

    Fit(i) = 0;

    for j=1:(lstring-1)
        Fit(i) = Fit(i) + x(j)*sin(sqrt(abs(x(j+1)+1-x(j))))*cos(sqrt(abs(x(j+1)+1+x(j)))) + ...
                 (x(j+1)+1)*cos(sqrt(abs(x(j+1)+1-x(j))))*sin(sqrt(abs(x(j+1)+1+x(j))));  
    end;

    Fit(i) = Fit(i)/lstring;

    evals=evals+1;

end;