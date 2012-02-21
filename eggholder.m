% Egg holder
% Number of variables : n
% The global optimum is: n=5  f(x)=-3719.7  x=[481.3291  436.7954  451.5467 466.7904  422.3174]
% -500 < x(i) < 500

function[Fit]=eggholder(Pop)

global evals

[lpop,lstring]=size(Pop);

for i=1:lpop

    x=Pop(i,:);

    Fit(i) = 0;

    for j=1:(lstring-1)
        Fit(i) = Fit(i) - x(j)*sin(sqrt(abs(x(j)-(x(j+1)+47)))) - (x(j+1)+47)*sin(sqrt(abs(x(j+1)+47+x(j)/2)));
    end;

    evals=evals+1;
end;
