% Rastrigin
% Number of variables : n
% The global optimum is:  f(x)=0; x(i)=0, i=1:n
% -5 < x(i) < 5  (unconstrained)

function[Fit]=rastrigin(Pop)

global evals

[lpop,lstring]=size(Pop);

for i=1:lpop

    x=Pop(i,:);

    Fit(i) = lstring*10;

    for j=1:lstring
        Fit(i) = Fit(i) + (x(j)^2-10*cos(2*pi*x(j)));
    end;

    evals=evals+1;
end;
