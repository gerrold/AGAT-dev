%mutn                - adit�vna mut�cia s norm�lnym rozdelen�m pravdepodobnosti
%
%	Charakteristika:
%	Funkcia zmutuje popul�ciu re�azcov s intenzitou �mernou parametru 
%	rate (z rozsahu od 0 do 1). Mutovan�ch je len nieko�ko g�nov v r�mci 
%	celej popul�cie. Mut�cie vznikn� pripo��tan�m alebo odpo��tan�m 
%	n�hodn�ch ��sel ohrani�en�ch ve�kost� k p�vodn�m hodnot�m n�hodne 
%	vybran�ch g�nov celej popul�cie. Absol�tne hodnoty pr�pustn�ch ve�kost� 
%	adit�vnych mut�ci� s� ohrani�en� hodnotami vektora Amp. Po tejto oper�cii 
%	s� e�te v�sledn� hodnoty g�nov ohrani�en� (saturovan�) na hodnoty prvkov 
%	matice Space. Prv� riadok mat�ce ur�uje doln� ohrani�enia a druh� riadok 
%	horn� ohrani�enia jednotliv�ch g�nov. 
%
%
%	Syntax: 
%
%	Newpop=mutn(Oldpop,rate,Amp,Space)
%
%	       Newpop - nov�, zmutovan� popul�cia
%	       Oldpop - star� popul�cia
%	       Amp    - vektor ohrani�en� pr�pustn�ch adit�vnych hodn�t mut�ci�
%	       Space  - matica obmedzen�, ktorej 1.riadok je vektor  minim�lnych a 2.  
%	                riadok je vektor maxim�lnych pr�pustn�ch mutovan�ch hodn�t
%	       rate   - miera po�etnosti mutovania g�nov v popul�cii (od 0 do 1)
%
% I.Sekaj, 5/2000

function[Newpop]=mutn(Oldpop,factor,Amps,Space)

[lpop,lstring]=size(Oldpop);

if factor>1 factor=1; end;
if factor<0 factor=0; end;

n=ceil(lpop*lstring*factor*rand);

Newpop=Oldpop;

for i=1:n
r=ceil(rand*lpop);
s=ceil(rand*lstring);
Newpop(r,s)=Oldpop(r,s)+(randn/4)*Amps(s);
if Newpop(r,s)<Space(1,s) Newpop(r,s)=Space(1,s); end;
if Newpop(r,s)>Space(2,s) Newpop(r,s)=Space(2,s); end;
end;

