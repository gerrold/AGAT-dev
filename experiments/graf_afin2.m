

a=ginput(10); % naklikanie koncovych bodov fintess priebehov od 10% do 100%

mina=min(a); maxa=max(a);

for j=1:length(a)
    aa(j)=(a(j)-mina)/(maxa-mina)  % normovanie na interval <0,1>
end
an=1-aa; % doplnok k 1

figure;
plot(an);  
xlabel('afinita % / 10');
ylabel('uspesnost');
