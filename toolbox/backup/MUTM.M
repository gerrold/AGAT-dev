% mutm - multiplicative mutation
%
%	Description:
%	The function mutates the population of strings with the intensity
%	proportional to the parameter rate from interval <0;1>. Only a few genes  
%	from a few strings are mutated in the population. The mutations are realized
%	by multiplication of the mutated genes with real numbers from bounded intervals.
%	The intervals are defined in the two-row matrix Amps. The first row of the 
%	matrix represents the lower boundaries and the second row represents the upper 
%	boundaries of the multiplication constants. Next the mutated strings
%	are limited using boundaries defined in a similar two-row matrix Space. 
%
%
%	Syntax: 
%
%	Newpop=mutm(Oldpop,rate,Amps,Space)
%
%	       Newpop - new mutated population
%	       Oldpop - old population
%	       Amps   - matrix of multiplicative constant boundaries in the form:
%			[real-number vector of lower limits;
%                        real-number vector of upper limits];
%	       Space  - matrix of gene boundaries in the form: 
%	                [real-number vector of lower limits of genes;
%                        real-number vector of upper limits of genes];
%	       rate   - mutation intensity, 0 =< rate =< 1
%

% I.Sekaj, 5/2000

function[Newpop]=mutm(Oldpop,factor,Amps,Space)

[lpop,lstring]=size(Oldpop);

if factor>1 factor=1; end;
if factor<0 factor=0; end;

n=ceil(lpop*lstring*factor*rand);

Newpop=Oldpop;

for i=1:n
r=ceil(rand*lpop);
s=ceil(rand*lstring);
d=Amps(2,s)-Amps(1,s);
Newpop(r,s)=Oldpop(r,s)*(rand*d+Amps(1,s));
if Newpop(r,s)<Space(1,s) Newpop(r,s)=Space(1,s); end;
if Newpop(r,s)>Space(2,s) Newpop(r,s)=Space(2,s); end;
end;

