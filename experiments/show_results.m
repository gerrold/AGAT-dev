close all
clc
figure
plot(popsize_pval_0_r_50,'r')
hold on
plot(popsize_pval_10_r_50,'g')
plot(popsize_pval_15_r_50,'b')
plot(popsize_pval_20_r_50,'c')
plot(popsize_pval_25_r_50,'m')
plot(popsize_pval_30_r_50,'y')
plot(popsize_pval_35_r_50,'--r')
plot(popsize_pval_40_r_50,'--g')
plot(popsize_pval_45_r_50,'--b')
plot(classicrun,'--k','LineWidth',2)
hold off
legend('p = 0,0','p = 1.0','p = 1.5','p = 2.0','p = 2.5','p = 3.0','p = 3.5','p = 4.0','p = 4.5','without adaptivity')
xlabel('generations')
ylabel('fitnes value')
title('eggholder p constans stepping')