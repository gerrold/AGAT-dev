% seltourn - tounament selection 
%
%
%	Description:
%	The function selects using tournament selection from the old population 
%       a required number of strings. 
%
%
%	Syntax:
%
%	Newpop=seltourn(Oldpop,Oldfit,Num);
%	[Newpop,Newfit]=seltourn(Oldpop,Oldfit,Num);
%
%	       Newpop - new selected population
%              Newfit - fitness vector of Newpop
%	       Oldpop - old population
%              Oldfit - fitness vector of Oldpop
%	       Num    - number of selected strings
%

% I.Sekaj, 8/2002

function[Newpop,Newfit]=seltourn(Oldpop,Fit,n)

[lpop,lstring]=size(Oldpop);

for i=1:n	
  j=ceil(lpop*rand);
  k=ceil(lpop*rand);
  if j==k
    Newpop(i,:)=Oldpop(j,:);
    Newfit(i)=Fit(j);
  elseif Fit(j)<=Fit(k) 
    Newpop(i,:)=Oldpop(j,:); 
    Newfit(i)=Fit(j);
  else
    Newpop(i,:)=Oldpop(k,:);
    Newfit(i)=Fit(k);
  end;
end;
     



