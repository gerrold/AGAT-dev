% seldiv - selection based on the maximum diversity measure
%
%	Description:
%	The function selects from the input population a required number of strings
%	which has the maximal value of Euklidian distance between its genes and the reference
%       string. The reference string can be either the most fit string (with the smallest value
%	of the objective f. value) or a string which, contains mean values of all corresponding 
%	strings of the population. The number of the selected strings depends on the 
%	vector Nums in the form: Nums=[number of copies of the best string, ... ,
%                                      number of copies of the i-th best string, ...]
%
%
%	Syntax:
%
%	Newpop=seldiv(Oldpop,Oldfit,Nums,sw)
%	[Newpop,Newfit]=seldiv(Oldpop,Oldfit,Nums,sw)
%
%	       Newpop - new selected population
%	       Oldpop - old population
%	       Oldfit - vector of the objective function values of Oldpop
%              Newfit - vector of the objective function values of Newpop
%	       Nums   - vector in the form: Nums=[number of copies of the best string, ... ,
%                                                 number of copies of the i-th best string,
%                                                  ...]
%	       sw     - switch: 0 - the reference string consists from genes which are 
%                                   mean values of corresponding genes of the Oldpop 
%                               1 - the reference string is the best string forom Oldpop
%

% I.Sekaj, 5/2000

function[Newpop,Newfit]=seldiv(Oldpop,Fvpop,Nums,sw)

[lpop,lstring]=size(Oldpop);
Newpop0=[]; Newfit0=[];

if sw==1   

mini=10e10;   
for i=1:lpop
  if Fvpop(i)<mini
    mini=Fvpop(i);
    ix=i;
  end;
end;
str=Oldpop(ix,:);

elseif sw==0	

for j=1:lstring		
  str(j)=mean(Oldpop(:,j));
end;

end; 

for i=1:lpop	
  div(i)=0;
  for j=1:lstring
    div(i)=div(i)+abs(str(j)-Oldpop(i,j));
  end;
end;


N=length(Nums);
if N>lpop, N=lpop; end;

for j=1:N	

maxi=0;
for i=1:lpop
  if div(i)>maxi
    maxi=div(i);
    ix=i;
  end;
end;
div(ix)=0;
Newpop0=[Newpop0;Oldpop(ix,:)];
Newfit0=[Newfit0;Fvpop(ix)];

end;

r=1;		
for i=1:N
  for j=1:Nums(i)
    Newpop(r,:)=Newpop0(i,:);
    Newfit(r)=Newfit0(i); 
    r=r+1;
  end;
end;  

