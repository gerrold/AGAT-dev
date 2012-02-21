% Quadratic
% Number of variables : n
% The global optimum is:  f(x)=0; x(i)=0, i=1:n
% -10 < x(i) < 10 (unconstrained)

function[Fit]=quadratic(Pop)

global evals

[lpop,lstring]=size(Pop);

for i=1:lpop

    x=Pop(i,:);

    Fit(i)=0;

    for j=1:lstring
        Fit(i) = Fit(i) + x(j)^2;
    end;

    evals=evals+1;
end;
