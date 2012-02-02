% change - elimination of duplicite strings in the population
%
%	Description:
%	The function is searching for and changing all duplicite strings
%	in a population. Depending on the parameter option the duplicite strings
%	are either modificated using the simple or multiplicative mutation
%	or they are replaced by a new random real-number string.
%
%
%	Syntax:
%
%	Newpop=change(Oldpop,option,Space)
%
%	Newpop - new modificated population 
%	Oldpop - old population
%	option - 0 - duplicite strings are mutated in one gene 
%	             in the ranges defined by the matrix Space
%	         1 - duplicite strings are multiplicated in one random gene by a random
%	             constant from the range defined by the matrix Space
%	         2 - duplicite strings are replaced by a new random real-number 
%		     string, which items are limited by the matrix Space
%	Space -  2-row matrix, which 1-st row is the vector of the lower limits
%		   and the 2-nd row is the vector of the upper limits of the
%		   genes.
%

% I.Sekaj 8/2000

function[Newpop]=change(Oldpop,option,Space)

[lpop,lstring]=size(Oldpop);
Newpop=Oldpop;

for s1=1:(lpop-1)
  for s2=(s1+1):lpop
    ch=lstring;
    for g=1:lstring
      if Newpop(s1,g)==Newpop(s2,g) ch=ch-1; end;
    end;
    if ch==0
      if option==0		
        s=ceil(rand*lstring);
        d=Space(2,s)-Space(1,s);
        Newpop(s2,s)=rand*d+Space(1,s);
        if Newpop(s2,s)<Space(1,s) Newpop(s2,s)=Space(1,s); end;
        if Newpop(s2,s)>Space(2,s) Newpop(s2,s)=Space(2,s); end;
      elseif option==1		
        s=ceil(rand*lstring);
        d=Space(2,s)-Space(1,s);
        Newpop(s2,s)=Newpop(s2,s)*(rand*d+Space(1,s));
        if Newpop(s2,s)<Space(1,s) Newpop(s2,s)=Space(1,s); end;
        if Newpop(s2,s)>Space(2,s) Newpop(s2,s)=Space(2,s); end;
      elseif option==2		
        rr=genrpop(1,Space);
        Newpop(s2,:)=rr;
      end; 
    end;
  end;
end;


