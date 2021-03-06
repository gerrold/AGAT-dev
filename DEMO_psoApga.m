% worldtest - aka testing the functionality of the world generating
% algorithm
clear
clc
close all

w = WORLD;
w = w.set('space','homo',-500,500,10,'initPopSize',10,'initSize',10,'structure',w.cmg('grid',5,5),'fitfunc','schwef','type','PSO')
% nastavila sa premenna pre generovanie jedincov
w = w.genesis()     % vytvori sa svet


for g=1:1 % cyklus 1000 generacii    
    for i=1:w.initSize        
        island = w.islands(i); % pristupujeme k i temu ostrov
        island = island.move();       % pouziejem metodu na vykonanie PSO
        island = island.update();       % aktualizujeme lokalne statisticke udaje
        w.islands(i) = island;      % vkladame naspat ostrov do i-tej premennej
    end;
    w = w.update();             % aktualizujeme globalne statisticke premenne
end


w2 = WORLD;
% nastavy sa svet v premennej w2
w2 = w2.set('space','homo',-500,500,10,'initPopSize',50,'initSize',10,'structure',w.cmg('grid',5,5),'fitfunc','schwef')
w2 = w2.genesis() % vytvori sa svet

for g=1:1000                                           % cyklus 1000 generacii
    for i=1:w2.initSize                                
        island = w2.islands(i);
        island = island.fitit();
        
        elite = island.select('best',3);                % vyberie 5 najpelsich
        if mod(g,50)
            island = island.migrate('out',elite);              % migracia smerom von
            island = island.migrate('in');                     % migracia do populacie
        end
        rest = island.select('random',47);              % zvisok doplni nahodnym vyberom
        rest = rest.toolbox26('crossov',2,1);           % funkcia crossov zo stareho toolboxu
        rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
        rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
        island = elite.join(rest);                      % spoji elitu so zviskom        
        
        island = island.update();                       % aktualizujeme lokalne statisticke udaje
        
        w2.islands(i) = island;                         % vkladame naspat ostrov do i-tej premennej
    end;
    w2 = w2.migrate();
    w2 = w2.update();
end

pso = mean(w.trail.bestknown,1);
pga = mean(w2.trail.min,1);

plot([pso(2:end)'  pga' ])
legend('pso','pga')