% genrpop - generating of a random real-coded population
% 
%	Description: 
%	The function generates a population of random real-coded strings
%	which items (genes) are limited by a two-row matrix Space. The first
%	row of the matrix Space consists of the lower limits and the second row 
%	consists of the upper limits of the possible values of genes. 
%	The length of the string is equal to the length of rows of the matrix Space.
%	
%
%	Syntax: 
%
%	Newpop=genrpop(popsize, Space)
%           
%	   Newpop - random generated population
%	   popsize - required number of strings in the population
%	   Space - 2-row matrix, which 1-st row is the vector of the lower limits
%		   and the 2-nd row is the vector of the upper limits of the
%		   gene values.
%

% I.Sekaj, 5/2000

function[Newpop]=genrpop(popsize, Space);

[lpop,lstring]=size(Space);

for r=1:popsize
	for s=1:lstring
		d=Space(2,s)-Space(1,s);
		Newpop(r,s)=rand*d+Space(1,s);

		if Newpop(r,s)<Space(1,s) 
			Newpop(r,s)=Space(1,s); 
		end;

		if Newpop(r,s)>Space(2,s) 
			Newpop(r,s)=Space(2,s); 
		end;
	end;
end; 