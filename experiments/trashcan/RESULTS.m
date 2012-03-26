% subplot(1,2,1)
% plot(ostrov.gettrail('size'))
% subplot(1,2,2)
plot(popsizereg_10_r_50)
hold
plot(classicrun,'r')
xlabel('generations')
ylabel('fitnes')
legend('adaptivne','bezne')