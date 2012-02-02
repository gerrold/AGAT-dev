% selbest - selection of best strings
%
%	Description:
%	The function copies from the old population into the new population
%	required a number of strings according to their fitness. The number of the
%	selected strings depends on the vector Nums as follows:
%	Nums=[number of copies of the best string, ... ,
%             number of copies of the i-th best string, ...]
%	The best string is the string with the lowest value of its objective function.
%
%
%	Syntax:
%
%	Newpop=selbest(Oldpop,Oldfit,Nums);
%	[Newpop,Newfit]=selbest(Oldpop,Oldfit,Nums);
%
%	Newpop - new selected population
%       Newfit - fitness vector of Newpop
%	Oldpop - old population
%	Oldfit - fitness vector of Oldpop
%	Nums   - vector in the form: Nums=[number of copies of the best string, ... ,
%                                          number of copies of the i-th best string, ...]
%

% I.Sekaj, 12/1998

function[Newpop,Newfit]=selbest(Oldpop,Fvpop,Nums)

N=length(Nums);

[fit,nix]=sort(Fvpop);

for i=1:N			
 Newpop0(i,:)=Oldpop(nix(i),:);
end;
Newfit0=fit;

r=1;				
for i=1:N
  for j=1:Nums(i)
    Newpop(r,:)=Newpop0(i,:);
    Newfit(r)=Newfit0(i);
    r=r+1;
  end;
end;  