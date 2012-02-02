% muta - aditive mutation
%
%	Description:
%	The function mutates the population of strings with the intensity
%	proportional to the parameter rate from interval <0;1>. Only a few genes  
%	from a few strings are mutated in the population. The mutations are realized
%	by addition or substraction of random real-numbers to the mutated genes. The 
%	absolute values of the added constants are limited by the vector Amp. 
%	Next the mutated strings are limited using boundaries defined in 
%	a two-row matrix Space. The first row of the matrix represents the lower 
%	boundaries and the second row represents the upper boundaries of corresponding 
%	genes.
%
%
%	Syntax: 
%
%	Newpop=muta(Oldpop,rate,Amp,Space)
%
%	       Newpop - new, mutated population
%	       Oldpop - old population
%	       Amp   -  vector of absolute values of real-number boundaries
%	       Space  - matrix of gene boundaries in the form: 
%	                [real-number vector of lower limits of genes
%                        real-number vector of upper limits of genes];
%	       rate   - mutation intensity, 0 =< rate =< 1
%

% I.Sekaj, 5/2000

function[Newpop]=muta(Oldpop,factor,Amps,Space)

	[lpop,lstring]=size(Oldpop);

	if factor>1 
		factor=1; 
	end;
	if factor<0 
		factor=0; 
	end;

	n=ceil(lpop*lstring*factor*rand);

	Newpop=Oldpop;

	for i=1:n
		r=ceil(rand*lpop);
		s=ceil(rand*lstring);
		Newpop(r,s)=Oldpop(r,s)+(2*rand-1)*Amps(s);
	if Newpop(r,s)<Space(1,s) 
		Newpop(r,s)=Space(1,s); 
	end;
	if Newpop(r,s)>Space(2,s) 
		Newpop(r,s)=Space(2,s); 
	end;
end;