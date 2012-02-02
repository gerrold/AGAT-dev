% mutx - simple mutation
%
%	Description:
%	The function mutates the population of strings with the intensity
%	proportional to the parameter rate from interval <0;1>. Only a few genes  
%	from a few strings are mutated in the population. The mutated values are
%	selected from the bounded real-number space, which is defined by the two-row 
%	matrix Space. The first row of the matrix represents the lower boundaries and the 
%	second row represents the upper boundaries of corresponding genes in the strings. 
%
%
%	Syntax: 
%
%	Newpop=mutx(Oldpop,rate,Space)
%
%	       Newpop - new mutated population
%	       Oldpop - old population
%	       Space  - matrix of boundaries in the form: [vector of lower limits of genes;
%                                                          vector of upper limits of genes];
%	       rate   - mutation intensity, 0 =< rate =< 1
%

% I.Sekaj, 5/2000

function[Newpop]=mutx(Oldpop,factor,Space)

[lpop,lstring]=size(Oldpop);

if factor>1 factor=1; end;
if factor<0 factor=0; end;

n=ceil(lpop*lstring*factor*rand);

Newpop=Oldpop;

for i=1:n
r=ceil(rand*lpop);
s=ceil(rand*lstring);
d=Space(2,s)-Space(1,s);
Newpop(r,s)=rand*d+Space(1,s);
if Newpop(r,s)<Space(1,s) Newpop(r,s)=Space(1,s); end;
if Newpop(r,s)>Space(2,s) Newpop(r,s)=Space(2,s); end;
end;

