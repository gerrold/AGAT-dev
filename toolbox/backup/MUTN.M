%mutn                - aditívna mutácia s normálnym rozdelením pravdepodobnosti
%
%	Charakteristika:
%	Funkcia zmutuje populáciu reazcov s intenzitou úmernou parametru 
%	rate (z rozsahu od 0 do 1). Mutovaných je len nieko¾ko génov v rámci 
%	celej populácie. Mutácie vzniknú pripoèítaním alebo odpoèítaním 
%	náhodných èísel ohranièených ve¾kostí k pôvodným hodnotám náhodne 
%	vybraných génov celej populácie. Absolútne hodnoty prípustných ve¾kostí 
%	aditívnych mutácií sú ohranièené hodnotami vektora Amp. Po tejto operácii 
%	sú ešte výsledné hodnoty génov ohranièené (saturované) na hodnoty prvkov 
%	matice Space. Prvý riadok matíce urèuje dolné ohranièenia a druhý riadok 
%	horné ohranièenia jednotlivých génov. 
%
%
%	Syntax: 
%
%	Newpop=mutn(Oldpop,rate,Amp,Space)
%
%	       Newpop - nová, zmutovaná populácia
%	       Oldpop - stará populácia
%	       Amp    - vektor ohranièení prípustných aditívnych hodnôt mutácií
%	       Space  - matica obmedzení, ktorej 1.riadok je vektor  minimálnych a 2.  
%	                riadok je vektor maximálnych prípustných mutovaných hodnôt
%	       rate   - miera poèetnosti mutovania génov v populácii (od 0 do 1)
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

