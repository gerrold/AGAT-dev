% vyhodnotenie

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
plot(classicrun,'-.k')

legend('10%','20%','30%','40%','50%','60%','70%','80%','90%','100%','bez regulacie')
title('priemer z 50 merani, pri regulacii affinity pre RANA')
xlabel('generacia')
ylabel('fitnes hodnota')
hold off