% benchmark oldbox vs AGAT
clear
clc

runs = 10;
generations = 100;
populationsize = 100;
schwefel = 100;

ostrov = ISLAND();
ostrov = ostrov.seed('space','homo',-500,500,schwefel,'fitfunc','schwef','size',populationsize);
benchmark = zeros(2,7,generations);
for i=1:generations
    benchmark(1,1,generations) = cputime;
    elite = ostrov.select('best',3);    % vyberie 3 najpelsich
    benchmark(1,2,generations) = cputime;
    rest = ostrov.select('random',populationsize - 3);  % zvisok doplni nahodnym vyberom
    benchmark(1,3,generations) = cputime;
    rest = rest.toolbox26('crossov',2,1);    % funkcia crossov zo stareho toolboxu
    benchmark(1,4,generations) = cputime;
    rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
    benchmark(1,5,generations) = cputime;
    rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
    benchmark(1,6,generations) = cputime;
    ostrov = elite.join(rest);          % spoji elitu so zviskom
    benchmark(1,7,generations) = cputime;
    disp(['agat ' num2str(i)])
end

ret = cd('toolbox');
clear ostrov;
clear rest;
clear elite;

space = [ones(1,schwefel)*-500 ; ones(1,schwefel)*500];
ostrov = genrpop(populationsize,space);
for i=1:generations
        fit = schwef(ostrov);
    benchmark(2,1,generations) = cputime;
%         ostrov = ostrov.update();           % aktualizuje statisticke udaje pre ostrov
        elite = selbest(ostrov,fit,3);    % vyberie 3 najpelsich
    benchmark(2,2,generations) = cputime;
    rest = selrand(ostrov,fit,populationsize - 3);  % zvisok doplni nahodnym vyberom
        benchmark(2,3,generations) = cputime;
   rest = crossov(rest,2,1);    % funkcia crossov zo stareho toolboxu
        benchmark(2,4,generations) = cputime;
        rest = mutx(rest,0.2,space);   % to iste
        benchmark(2,5,generations) = cputime;
        rest = muta(rest,0.1,space(2,:) .* 0.01, space);    % aditivna mutacia o 1% zo space hodnoty
        benchmark(2,6,generations) = cputime;
        ostrov = [elite; rest];          % spoji elitu so zviskom
        benchmark(2,7,generations) = cputime;
    disp(['toolbox26 ' num2str(i)])    
end
    
    
results = mean(benchmark,3);
cd(ret);
barh(results,'stacked')
xlabel('CPU time')
legend('fitnes','selbest','selrand','crossov','mutx','muta','joining')