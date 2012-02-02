% benchmark oldbox vs AGAT
clear
clc

runs = 1;
generations = 10;
populationsize = 100;
schwefel = 10000;

ostrov = ISLAND();
ostrov = ostrov.seed('space','homo',-500,500,schwefel,'fitfunc','schwef','size',populationsize);
for i=1:generations
    tic
%     ostrov = ostrov.fitit();
    benchmark(1,1,generations) = toc;
    tic
    elite = ostrov.select('best',3);    % vyberie 3 najpelsich
    benchmark(1,2,generations) = toc;
    tic
    rest = ostrov.select('random',populationsize - 3);  % zvisok doplni nahodnym vyberom
    benchmark(1,3,generations) = toc;
    tic
    rest = rest.toolbox26('crossov',2,1);    % funkcia crossov zo stareho toolboxu
    benchmark(1,4,generations) = toc;
    tic
    rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
    benchmark(1,5,generations) = toc;
    tic
    rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
    benchmark(1,6,generations) = toc;
    tic
    ostrov = elite.join(elite,rest);          % spoji elitu so zviskom
    benchmark(1,7,generations) = toc;
    tic
    disp(['agat ' num2str(i)])
end


ret = cd('toolbox');
clear ostrov;
clear rest;
clear elite;

space = [ones(1,schwefel)*-500 ; ones(1,schwefel)*500];
ostrov = genrpop(populationsize,space);
for i=1:generations
    tic
        fit = schwef(ostrov);
    benchmark(2,1,generations) = toc;
    tic
%         ostrov = ostrov.update();           % aktualizuje statisticke udaje pre ostrov
        elite = selbest(ostrov,fit,3);    % vyberie 3 najpelsich
    benchmark(2,2,generations) = toc;
    tic
        rest = selrand(ostrov,fit,populationsize - 3);  % zvisok doplni nahodnym vyberom
        benchmark(2,3,generations) = toc;
    tic
        rest = crossov(rest,2,1);    % funkcia crossov zo stareho toolboxu
        benchmark(2,4,generations) = toc;
    tic
        rest = mutx(rest,0.2,space);   % to iste
        benchmark(2,5,generations) = toc;
    tic
        rest = muta(rest,0.1,space(2,:) .* 0.01, space);    % aditivna mutacia o 1% zo space hodnoty
        benchmark(2,6,generations) = toc;
    tic
        ostrov = [elite; rest];          % spoji elitu so zviskom
        benchmark(2,7,generations) = toc;
    tic
    disp(['toolbox26 ' num2str(i)])    
end
    
    
results = mean(benchmark,3);
cd(ret);
barh(results,'stacked')
legend('fitnes','selbest','selrand','crossov','mutx','muta','joining')