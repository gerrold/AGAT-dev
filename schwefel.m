% Schwefel (normalized)
% Number of variables : n
% The global optimum is: f(x)=-418.9829; x(i)=420.9687, i=1:n  
% -512 < x(i) < 512 (constrained)

function[Fit]=schwefel(Pop)

global evals

[lpop,lstring]=size(Pop);

for i=1:lpop

    x=Pop(i,:);

    Fit(i)=0;

    for j=1:lstring
        Fit(i) = Fit(i) - x(j)*sin(sqrt(abs(x(j))));
    end;
    
     Fit(i) = Fit(i)/lstring;

    evals=evals+1;
end;
