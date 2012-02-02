ostrov = obj;

% ostrov = ostrov.update();           % aktualizuje statisticke udaje pre ostrov
elite = ostrov.select('best',3);    % vyberie 5 najpelsich
rest = ostrov.select('random',27);  % zvisok doplni nahodnym vyberom
rest = rest.toolbox26('crossov',2,1);    % funkcia crossov zo stareho toolboxu
rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
ostrov = elite.join(rest);          % spoji elitu so zviskom
disp('ficim')
 
obj = ostrov;
clear ostrov;