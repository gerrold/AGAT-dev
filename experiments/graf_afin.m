% graf uspesnosti jednotlivych hladin regulacie afinity 

% load dat1

plot(affreg_lvl_10_r_50,'r')
hold on
plot(affreg_lvl_20_r_50,'g')
plot(affreg_lvl_30_r_50,'b')
plot(affreg_lvl_40_r_50,'c')
plot(affreg_lvl_50_r_50,'m')
plot(affreg_lvl_60_r_50,'y')
plot(affreg_lvl_70_r_50,'k')
plot(affreg_lvl_80_r_50,'--r')
plot(affreg_lvl_90_r_50,'--g')
plot(affreg_lvl_100_r_50,'--b')
%plot(classicrun,'-.k')

legend('10%','20%','30%','40%','50%','60%','70%','80%','90%','100%','bez regulacie')
title('priemer z 50 merani, pri regulacii affinity')
xlabel('generacia')
ylabel('fitnes hodnota')


% a=ginput(10); % naklikanie koncovych bodov fintess priebehov 
% od 10% do 100%

for j=1:length(a)
    aa(j)=(a(j)-mina)/(maxa-mina)  % normovanie na interval <0,1>
end
an=1-aa; % doplnok k 1+
figure;
plot(an);  
xlabel('afinita % / 10');
ylabel('uspesnost');
