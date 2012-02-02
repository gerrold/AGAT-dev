% selrand - random selection 
%
%
%	Description:
%	The function selects randomly from the old population a required number
%	of strings. 
%
%
%	Syntax:
%
%	Newpop=selrand(Oldpop,Oldfit,Num);
%	[Newpop,Newfit]=selrand(Oldpop,Oldfit,Num);
%
%	       Newpop - new selected population
%	       Newfit - fitness vector of Newpop
%	       Oldpop - old population
%	       Oldfit - fitness vector of Oldpop
%	       Num    - number of selected strings
%

% I.Sekaj, 5/2000

function[Newpop,Newfit]=selrand(Oldpop,Oldfit,n)

[lpop,lstring]=size(Oldpop);

for i=1:n	
  j=ceil(lpop*rand);
  Newpop(i,:)=Oldpop(j,:);
  Newfit(i)=Oldfit(j);
end;


