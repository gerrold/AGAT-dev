% selsus - stochastic universal selection
%
%
%	Description:
%	The function selects from the old population a required number of strings using
%	the "stochastic universal sampling" method. Under this selection method the number of a 
%       parent copies in the selected new population is proportional to its fitness. 
%	
% 
%	Syntax:
%
%	Newpop=selsus(Oldpop,Oldfit,Num);
%	[Newpop,Newfit]=selsus(Oldpop,Oldfit,Num);
%
%	       Newpop - new selected population
%	       Newfit - fitness vector of Newpop
%	       Oldpop - old population
%	       Oldfit - fitness vector of Oldpop
%	       Num    - required number of selected strings
%

% I.Sekaj, 5/2000

function[Newpop,Newfit]=selsus(Oldpop,Fvpop,n)

[lpop,lstring]=size(Oldpop);

Fvpop=Fvpop-min(Fvpop)+1;  % uprava na kladnu f., min=1

sumfv=sum(Fvpop);

for i=1:lpop	
  men=Fvpop(i)*sumfv;
  w0(i)=1/men;	% tvorba inverznych vah
end;
w0(i+1)=0;
w=zeros(1,lpop+1);
for i=lpop:-1:1	
  w(i)=w(i+1)+w0(i);
end;
maxw=max(w);
if maxw==0 maxw=0.00001;end;
w=(w/maxw)*100;		% vahovaci vektor

del=100/n;          % rovnomerne rozdeli interval na vyberove body 
b0=rand*del-0.00001;
for i=1:n
    b(i)=(i-1)*del+b0;
end;

for i=1:n			
  for j=1:lpop
    if (b(i)<w(j) & b(i)>w(j+1)) break; end;
  end;
  Newpop(i,:)=Oldpop(j,:);
  Newfit(i)=Fvpop(j); 
end;
  