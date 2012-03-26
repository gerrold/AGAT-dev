

% a=ginput(10); % naklikanie koncovych bodov fintess priebehov od 10% do 100%

subplot(1,2,1)

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
% plot(classicrun,'-.k')

legend('10%','20%','30%','40%','50%','60%','70%','80%','90%','100%','bez regulacie')
title('priemer z 50 merani, pri regulacii affinity pre invmx4')
xlabel('generacia')
ylabel('fitnes hodnota')
hold off

subplot(1,2,2)


for seq = 10:10:100
    eval(['current = affreg_lvl_' num2str(seq) '_r_50;'])
    penalty = 0;
    for i = 20 : length(current)
%         mean(abs(current(i:i+19) - current((i-1):i+18)))    %   for debuging purposes, remove when done
        correction = 0;
        if 1000-i < 100     %change back to 5000
            correction = i-1000+100;
        end
        
        if mean(abs(current(i:i+100-correction) - current((i-1):i+99-correction))) < 0.0001
%              a(seq/10,1)=i;
%              a(seq/10,2)=current(i);
        penalty = penalty + 1
            if penalty > 0.1 * seq
                break;
            end
        end
    end
    a(seq/10,2)=i;
    a(seq/10,1)=current(i);
end

axx=a;
a=a(:,1);

mina=min(a); maxa=max(a);

for j=1:length(a)
    aa(j)=(a(j)-mina)/(maxa-mina);  % normovanie na interval <0,1>
end
% an=1-aa; % doplnok k 1
an = aa;

title('uspenost: reg_aff_filtwin128_eggholder')

%figure;
plot(an);  
xlabel('afinita % / 10');
ylabel('uspesnost');

subplot(1,2,1)
hold on
scatter(axx(:,2),axx(:,1))
hold off
