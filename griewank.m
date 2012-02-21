% Griewank
% Number of variables : n
% The global optimum is: f(x)=0; x(i)=0, i=1:n
% -500 <= x(i) <= 500

function[Fit]=griewank(Pop)

[lpop,lstring]=size(Pop);

for i=1:lpop

    x=Pop(i,:);
    
    s1 = 0;
    s2 = 1;

    for j = 1:lstring;
        s1 = s1 + x(j)^2;
    end
    for j = 1:lstring;
        s2 = s2 * cos(x(j)/sqrt(j));
    end

    Fit(i) = s1/4000 - s2 + 1;

end;


