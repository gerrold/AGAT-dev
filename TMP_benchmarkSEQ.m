% benchmark oldbox vs AGAT
clear all
close all
clc

runs = 10;
generations = 100;
populationsize = 30;
schweffe = 500;
vec = [30 50 100 250 500 1000];

for ttt=1:1
    populationsize = vec(ttt);
    
    clear ostrov;
    clear rest;
    clear elite;
    
for cic = 1:runs
    tic
    ostrov = ISLAND();
    ostrov = ostrov.seed('space','homo',-500,500,schweffe,'fitfunc','schwef','size',populationsize);
    for i=1:generations
        ostrov = ostrov.fitit();
%         ostrov = ostrov.update();           % aktualizuje statisticke udaje pre ostrov
        elite = ostrov.select('best',3);    % vyberie 3 najpelsich
        rest = ostrov.select('random',populationsize - 3);  % zvisok doplni nahodnym vyberom
        rest = rest.toolbox26('crossov',2,1);    % funkcia crossov zo stareho toolboxu
        rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
        rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
        ostrov = elite.join(rest);          % spoji elitu so zviskom
        disp(['seq: ' num2str(ttt) ' AGAT beh: ' num2str(cic) ' generacia: ' num2str(i)])
    end
    benchmark(cic,1) = toc;
end

% benchglob(1,ttt) = mean(benchmark(1,:));

ret = cd('toolbox');
clear ostrov;
clear rest;
clear elite;

for cic = 1:runs
     clear ostrov;
    clear rest;
    clear elite;
    tic
    space = [ones(1,schweffe)*-500 ; ones(1,schweffe)*500];
    ostrov = genrpop(populationsize,space);
    for i=1:generations
        fit = schwef(ostrov);
%         ostrov = ostrov.update();           % aktualizuje statisticke udaje pre ostrov
        elite = selbest(ostrov,fit,3);    % vyberie 3 najpelsich
        rest = selrand(ostrov,fit,populationsize - 3);  % zvisok doplni nahodnym vyberom
        rest = crossov(rest,2,1);    % funkcia crossov zo stareho toolboxu
        rest = mutx(rest,0.2,space);   % to iste
        rest = muta(rest,0.1,space(2,:) .* 0.01, space);    % aditivna mutacia o 1% zo space hodnoty
        ostrov = [elite; rest];          % spoji elitu so zviskom
        disp([ 'seq: ' num2str(ttt) ' toolbox26 beh: ' num2str(cic) ' generacia: ' num2str(i)])
    end
    benchmark(cic,2) = toc;
end

% benchglob(2,ttt) = mean(benchmark(2,:));

cd(ret);
end
plot(benchmark)
legend('AGAT','toolbox26')