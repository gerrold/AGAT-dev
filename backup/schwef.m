% Schwefel's objective function
% global optimum: x(i)=420.9687 ;  Fit(x)=-n*418.9829 , n-number of variables
% -500 < x(i) < 500

function[Fit]=schwef(Pop)

[lpop,lstring]=size(Pop);

for i=1:lpop
  G=Pop(i,:);
  Fit(i)=0;	
  for j=1:lstring
    Fit(i)=Fit(i)-G(j)*sin(sqrt(abs(G(j))));
  end;     
end;
