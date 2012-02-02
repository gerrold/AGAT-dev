% crossov - multipoint crossover
%
%	Description:
%	The function creates a new population of strings, which rises after
%	1- to 4-point crossover operation of all (couples of) strings of the old
%	population. The selection of strings into couples is either random or
%	the neighbouring strings are selected, depending on the parameter sel.
%
%
%	Syntax: 
%
%	Newpop=crossov(Oldpop,num,sel)
%
%	Newpop - new population 
%	Oldpop - old population
%	         num - the number of crossover points from 1 to 4
%	         sel - type of the string-couple selection:
%	               0 - random 
%	               1 - neighbouring strings in the population 
%

% I.Sekaj, 2/2001

function[Newpop]=crossov(Oldpop,pts,sel)

Newpop=Oldpop;
[lpop,lstring]=size(Oldpop);
flag=zeros(1,lpop);
num=fix(lpop/2);
i=1;

for cyk=1:num	

	if sel==0
		while flag(i)~=0
		 i=i+1;
		end;

		flag(i)=1;
		j=ceil(lpop*rand);

		while flag(j)~=0
		  j=ceil(lpop*rand);
		end;
		flag(j)=2; 

	elseif sel==1   
		i=2*cyk-1;
		j=i+1;
	end;



	if pts>4 
		pts=4;		
	end;
	
	n=lstring*(1-(pts-1)*0.15);
	p=ceil(rand*n);
	if p==lstring 
		p=lstring-1; 
	end;
	
	v=p;

	for k=1:(pts-1)
		h=ceil(rand*n);
		if h==1 
			h=2; 
		end
		
		p=p+h;
		if p>=lstring 
			break; 
		end; 
	v=[v,p];
	end;

	lv=length(v);
	if lv==4
	  Newpop(i,:)=[Oldpop(i,1:v(1)),Oldpop(j,(v(1)+1):v(2)),Oldpop(i,(v(2)+1):v(3)),Oldpop(j,(v(3)+1):v(4)),Oldpop(i,(v(4)+1):lstring)];
	  Newpop(j,:)=[Oldpop(j,1:v(1)),Oldpop(i,(v(1)+1):v(2)),Oldpop(j,(v(2)+1):v(3)),Oldpop(i,(v(3)+1):v(4)),Oldpop(j,(v(4)+1):lstring)];
	elseif lv==3;
	  Newpop(i,:)=[Oldpop(i,1:v(1)),Oldpop(j,(v(1)+1):v(2)),Oldpop(i,(v(2)+1):v(3)),Oldpop(j,(v(3)+1):lstring)];
	  Newpop(j,:)=[Oldpop(j,1:v(1)),Oldpop(i,(v(1)+1):v(2)),Oldpop(j,(v(2)+1):v(3)),Oldpop(i,(v(3)+1):lstring)];
	elseif lv==2;
	  Newpop(i,:)=[Oldpop(i,1:v(1)),Oldpop(j,(v(1)+1):v(2)),Oldpop(i,(v(2)+1):lstring)];
	  Newpop(j,:)=[Oldpop(j,1:v(1)),Oldpop(i,(v(1)+1):v(2)),Oldpop(j,(v(2)+1):lstring)];
	else
	  Newpop(i,:)=[Oldpop(i,1:v(1)),Oldpop(j,(v(1)+1):lstring)];
	  Newpop(j,:)=[Oldpop(j,1:v(1)),Oldpop(i,(v(1)+1):lstring)];
	end;
end; % flag

