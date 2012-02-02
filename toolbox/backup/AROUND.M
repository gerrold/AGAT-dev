% around - intermediate crossover with increasing/decreasing of the population living area
%
%	Description:
%	The function creates a new population of the strings, which rises after
%	intermediate crossover operation of all (couples of) strings of the old
%	population. The selection of strings into couples is either random or
%	the neighbouring strings are selected, depending on the parameter sel.
%	From each couple of parents will be calculated a new couple of offsprings
%	as follows: 
%
%	Offspring = (Parent1+Parent2)/2 +(-) alfa(Parent_distance)/2
%
%
%	Syntax:  Newpop=around(Oldpop,sel,alfa,Space) 
%
%	Newpop - new population
%	Oldpop - old population
%	sel - selection type of crossover couples:
%		0-random couples
%		1-neighbouring strings in the population 
%       alfa - enlargement parameter,  0.1<alfa<10, (usually: alfa=1.25; or 0.75<alfa<2)
%       Space  - matrix of boundaries in the form: [vector of lower limits of genes;
%                                                   vector of upper limits of genes];
%

% I.Sekaj, 5/2000

function[Newpop]=around(Oldpop,sel,alfa,Space)

Newpop=Oldpop;
[lpop,lstring]=size(Oldpop);
flag=zeros(1,lpop);
num=fix(lpop/2);
i=1;
m=1;

for cyk=1:num	

if sel==0     

while flag(i)~=0
 i=i+1;
end;
flag(i)=1;
j=ceil(lpop*rand);
while flag(j)~=0
  j=ceil(lpop*rand);
end;
flag(j)=2; 

elseif sel==1   

i=2*cyk-1;
j=i+1;

end;

for k=1:lstring
  b(k)=min(Oldpop(i,k),Oldpop(j,k));	
  d(k)=max(Oldpop(i,k),Oldpop(j,k))-b(k);   
  c(k)=(Oldpop(i,k)+Oldpop(j,k))/2;
end;
for k=1:lstring
  Newpop(m,k)=c(k)+alfa*(2*rand-1)*d(k)/2;
  Newpop(m+1,k)=c(k)+alfa*(2*rand-1)*d(k)/2;  
  if Newpop(m,k)<Space(1,k) Newpop(m,k)=Space(1,k); end;		
  if Newpop(m,k)>Space(2,k) Newpop(m,k)=Space(2,k); end;		
  if Newpop(m+1,k)<Space(1,k) Newpop(m+1,k)=Space(1,k); end;		
  if Newpop(m+1,k)>Space(2,k) Newpop(m+1,k)=Space(2,k); end;		
end;
m=m+2;

end; % num

