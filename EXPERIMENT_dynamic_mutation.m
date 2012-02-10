%   panmictic algorithm testing!
clc
clear
close all
runz = 10;
variables = 100;
generation = 100;

for r=1:runz

% je to jedno ci sa algoritmus naparametrizuje pri vyvoreni alebo pri seedovani  
ostrov = ISLAND;
ostrov = ostrov.set('space','homo',-500,500,variables,'fitfunc','schwef','popsize',30);
ostrov = ostrov.seed();

% ostrov = ISLAND();
% ostrov = ostrov.seed('space','homo',-500,500,30,'fitfunc','schwef','size',1000);
for i=1:generation
    ostrov = ostrov.update();                       % aktualizuje statisticke udaje pre ostrov
    ostrov = ostrov.fitit();
    elite = ostrov.select('best',3);                % vyberie 5 najpelsich
    rest = ostrov.select('random',27);              % zvisok doplni nahodnym vyberom
    rest = rest.toolbox26('crossov',2,1);           % funkcia crossov zo stareho toolboxu
    
    mutmiera(i) = ostrov.statfilt('affinity','mean',3);
    
    rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
    rest = rest.toolbox26('muta',mutmiera(i),rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
    ostrov = elite.join(rest);                      % spoji elitu so zviskom
end

best = ostrov.select('best',1);   % vyberie a vrati format individual
solution = best;

run(:,r) = ostrov.gettrail('min');

disp(['adaptive run ' num2str(r)])

end

for rr=1:runz

% je to jedno ci sa algoritmus naparametrizuje pri vyvoreni alebo pri seedovani  
ostrov = ISLAND;
ostrov = ostrov.set('space','homo',-500,500,variables,'fitfunc','schwef','popsize',30);
ostrov = ostrov.seed();

% ostrov = ISLAND();
% ostrov = ostrov.seed('space','homo',-500,500,30,'fitfunc','schwef','size',1000);
for i=1:generation
    ostrov = ostrov.update();                       % aktualizuje statisticke udaje pre ostrov
    ostrov = ostrov.fitit();
    elite = ostrov.select('best',3);                % vyberie 5 najpelsich
    rest = ostrov.select('random',27);              % zvisok doplni nahodnym vyberom
    rest = rest.toolbox26('crossov',2,1);           % funkcia crossov zo stareho toolboxu
    rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
    rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
    ostrov = elite.join(rest);                      % spoji elitu so zviskom
end

best = ostrov.select('best',1);   % vyberie a vrati format individual
solution = best;

runc(:,rr) = ostrov.gettrail('min');

disp(['classic run ' num2str(rr)])

end

% plot(ostrov.gettrail('evaltime'),ostrov.gettrail('min','mean'))

plot(mean(run')) 
hold 
plot(mean(runc'),'r')
legend(['adaptive run from ' num2str(r) ' runs'],['classic run from ' num2str(r) ' runs'])