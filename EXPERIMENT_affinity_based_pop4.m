%   adaptive vs static panmictic GA
clc
clear
close all
runz = 50;
variables = 10;
generation = 5000;
% regulator
proportional = 2;
integrator = 0.005;

fw = [4 8 16 32 64 128 256];

filterwindow = 16;

for meranie=5:6
    
filterwindow = fw(meranie);

% required_aff = 0.4;
disp([num2str(meranie) '. meranie'])

required_aff = meranie * 0.1;

for r=1:runz

% je to jedno ci sa algoritmus naparametrizuje pri vyvoreni alebo pri seedovani  
ostrov = ISLAND;
ostrov = ostrov.set('space','homo',-500,500,variables,'fitfunc','eggholder','popsize',100);
ostrov = ostrov.seed();

% ostrov = ISLAND();
% ostrov = ostrov.seed('space','homo',-500,500,30,'fitfunc','schwef','size',1000);
for i=1:generation
    ostrov = ostrov.update();                       % aktualizuje statisticke udaje pre ostrov
    ostrov = ostrov.fitit();
    
    reqpopsize(i) = ostrov.statfilt('affinity','mean',filterwindow);
    elite = ostrov.select('best',3);                % vyberie 5 najpelsich
    rest = ostrov.select('random',round((100-reqpopsize(i)*100-3)*proportional));              % zvisok doplni nahodnym vyberom
    rest = rest.toolbox26('crossov',2,1);           % funkcia crossov zo stareho toolboxu
    
   
    
%     action(i) = proportional * (mutmiera(i) - required_aff) + integrator * sum(mutmiera - repmat(required_aff,1,length(mutmiera)));
%     if action(i) < 0
%         action(i) = 0;
%     end
%     
%     if action(i) > 1
%         action(i) = 1;
%     end
    
    rest = rest.toolbox26('mutx',0.03,rest.space);   % to iste
    rest = rest.toolbox26('muta',0.03,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
    ostrov = elite.join(rest);                      % spoji elitu so zviskom
end

best = ostrov.select('best',1);   % vyberie a vrati format individual
solution = best;

run(:,r) = ostrov.gettrail('min');

disp(['adaptive run ' num2str(r)])

end

plot(ostrov.gettrail('size'))
pause(0.001)
retdir = cd('experiments');
eval(['popsizereg_fw' num2str(filterwindow) '_r_' num2str(runz) '_p_' num2str(proportional) ' = mean(run,2);']);
save(['popsizereg_fw' num2str(filterwindow) '_r_' num2str(runz) '_p_' num2str(proportional)  '.mat'],['popsizereg_fw' num2str(filterwindow) '_r_'  num2str(runz) '_p_' num2str(proportional) ]);
cd(retdir);

end


for rr=1:runz

% je to jedno ci sa algoritmus naparametrizuje pri vyvoreni alebo pri seedovani  
ostrov = ISLAND;
ostrov = ostrov.set('space','homo',-500,500,variables,'fitfunc','eggholder','popsize',100);
ostrov = ostrov.seed();

% ostrov = ISLAND();
% ostrov = ostrov.seed('space','homo',-500,500,30,'fitfunc','schwef','size',1000);
for i=1:generation
    ostrov = ostrov.update();                       % aktualizuje statisticke udaje pre ostrov
    ostrov = ostrov.fitit();
    elite = ostrov.select('best',3);                % vyberie 5 najpelsich
    rest = ostrov.select('random',27);              % zvisok doplni nahodnym vyberom
    rest = rest.toolbox26('crossov',2,1);           % funkcia crossov zo stareho toolboxu
    rest = rest.toolbox26('mutx',0.03,rest.space);   % to iste
    rest = rest.toolbox26('muta',0.03,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
    ostrov = elite.join(rest);                      % spoji elitu so zviskom
end

best = ostrov.select('best',1);   % vyberie a vrati format individual
solution = best;

runc(:,rr) = ostrov.gettrail('min');

disp(['classic run ' num2str(rr)])

end
retdir = cd('experiments');
classicrun = mean(runc,2);
save('noreg.mat','classicrun');
cd(retdir);
% plot(ostrov.gettrail('evaltime'),ostrov.gettrail('min','mean'))

% plot(mean(run')) 
% hold 
% plot(mean(runc'),'r')
% legend(['adaptive run from ' num2str(r) ' runs with regulated affinity of ' num2str(required_aff)],['classic run from ' num2str(r) ' runs'])