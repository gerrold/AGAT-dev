%   panmictic algorithm testing!
clc
clear
close all

% je to jedno ci sa algoritmus naparametrizuje pri vyvoreni alebo pri seedovani  
% ostrov = ISLAND('space','homo',-500,500,10,'fitfunc','schwef','population',30);
% ostrov = ostrov.seed();

ostrov = ISLAND();
ostrov = ostrov.seed('space','homo',-500,500,10,'fitfunc','schwef','size',30);
for i=1:100
    ostrov = ostrov.update();           % aktualizuje statisticke udaje pre ostrov
    elite = ostrov.select('best',3);    % vyberie 5 najpelsich
    rest = ostrov.select('random',27);  % zvisok doplni nahodnym vyberom
    rest = rest.toolbox26('crossov',2,1);    % funkcia crossov zo stareho toolboxu
    rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
    rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
    ostrov = elite.join(elite,rest);          % spoji elitu so zviskom
    disp(['aktualna generacia: ' num2str(i)])
end

best = ostrov.select('best',1,'individual');   % vyberie a vrati format individual
solution = best.population.gene
plot(ostrov.gettrail('evaltime'),ostrov.gettrail('min','mean'))
legend('min','mean')