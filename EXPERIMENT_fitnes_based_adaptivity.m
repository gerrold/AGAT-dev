% Advanced paralalel algorithm adaptivity
clc
clear all
% ----------------------------------
% configuration data
generations = 1000;    %   how many generation will run

initpopsize = 50;
islandNum = 9;

resources = initpopsize/2 * 9;    % polovica poctu jedincov * pocet ostrovov

% ----------------------------------


wa = WORLD;
wa = wa.set('space','homo',-500,500,10,'initPopSize',initpopsize,'initSize',islandNum,'structure',wa.cmg('grid',3,3),'fitfunc','eggholder','vars',struct('generation',1,'convergence',0));
wa = wa.genesis();



for g=1:generations
    disp(['Adaptive PGA: ' num2str(g)])
    
    for i=1:wa.initSize        
        island = wa.islands(i);
        island = island.fitit();
        island = island.update();
        %--------algorithm starts here
        island.vars.convergence(g) = island.statfilt('min','mean',128);
        if island.vars.generation <= 2
            selRest = resources/islandNum * 2;            
        else
            selRest = ressup(i);
%             disp(['support pre ostrov ' num2str(i) ' je ' num2str(ressup(i))])
        end
        %-----------------------------
        elite = island.select('best',3);                % vyberie 5 najpelsich
        rest = island.select('random',selRest);              % zvisok doplni nahodnym vyberom
        rest = rest.toolbox26('crossov',2,1);           % funkcia crossov zo stareho toolboxu
        rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
        rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
        island = elite.join(rest);                      % spoji elitu so zviskom        
        
        island.vars.generation = island.vars.generation + 1; % dalsia generacia
                
        wa.islands(i) = island;
        
       
    end;
    
    wa = wa.update();
%   -----------normalization
    if g>=2
        clear nabs
        for p=1:size(wa.islands,2)
            nabs(p) = abs(wa.islands(p).vars.convergence(g-1) - wa.islands(p).vars.convergence(g));
            try  
%             nabs(p) = abs(mean(wa.islands(p).vars.convergence(g-16:end)));
            catch
                nabs(p) = abs(mean(wa.islands(p).vars.convergence(:)));
            end
        end    
%     nabs = nabs - min(nabs);
      nabs = nabs + 1;
    ressup = round((nabs/sum(nabs))*resources);
    end
%   ------------------------
        
    
end


%----------------------------------good old classic

w = WORLD;
w = w.set('space','homo',-500,500,10,'initPopSize',50,'initSize',9,'structure',w.cmg('grid',3,3),'fitfunc','eggholder');
w = w.genesis();

for g=1:generations
    disp(['PGA generation: ' num2str(g)])
    for i=1:w.initSize        
        island = w.islands(i);
        island = island.fitit();
        
        elite = island.select('best',3);                % vyberie 5 najpelsich
        rest = island.select('random',47);              % zvisok doplni nahodnym vyberom
        rest = rest.toolbox26('crossov',2,1);           % funkcia crossov zo stareho toolboxu
        rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
        rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
        island = elite.join(rest);                      % spoji elitu so zviskom        
        
        island = island.update();
        
        w.islands(i) = island;
    end;
    w = w.update();
end

plot(min(w.trail.min))
hold on
plot(min(wa.trail.min),'r')
hold off
legend('classic','adaptive')