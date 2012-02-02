% worldtest - aka testing the functionality of the world generating
% algorithm
clear
clc
close all

w = WORLD;
w = w.set('space','homo',-500,500,10,'initPopSize',10,'initSize',10,'structure',w.cmg('grid',5,5),'fitfunc','schwef','type','PSO')
w = w.genesis()


for g=1:10000
    disp(['PSO generation: ' num2str(g)])
    for i=1:w.initSize        
        island = w.islands(i);
        island = island.move();       
        island = island.update();
        pause(0.001)
        w.islands(i) = island;
    end;
    w = w.update();
end


w2 = WORLD;
w2 = w2.set('space','homo',-500,500,10,'initPopSize',50,'initSize',10,'structure',w.cmg('grid',5,5),'fitfunc','schwef')
w2 = w2.genesis()




for g=1:10000
    disp(['PGA generation: ' num2str(g)])
    for i=1:w2.initSize        
        island = w2.islands(i);
        island = island.fitit();
        
        elite = island.select('best',3);                % vyberie 5 najpelsich
        rest = island.select('random',47);              % zvisok doplni nahodnym vyberom
        rest = rest.toolbox26('crossov',2,1);           % funkcia crossov zo stareho toolboxu
        rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
        rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
        island = elite.join(rest);                      % spoji elitu so zviskom        
        
        island = island.update();
        
        w2.islands(i) = island;
    end;
    w2 = w2.update();
end

pso = mean(w.trail.bestknown,1);
pga = mean(w2.trail.min,1);

plot([pso(2:end)'  pga' ])
legend('pso','pga')