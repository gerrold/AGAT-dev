% Advanced paralalel algorithm adaptivity
clc
clear all

% ----------------------------------
% configuration data
generations = 5000;    %   how many generation will run

initpopsize = 50;
islandNum = 9;
minIslandNum = 3;   % min pocet ostrovov
resources = initpopsize/1.5 * islandNum;    % polovica poctu jedincov * pocet ostrovov

blobTreshold = initpopsize * 1.5;
starving_tresh = ceil(generations*0.0001);

filter_window = 128;

measure_num = 10;
% ----------------------------------

for meas = 1:measure_num
  
    wa = WORLD;
    wa = wa.set('space','homo',-500,500,5,'initPopSize',initpopsize,'initSize',islandNum,'structure',wa.cmg('grid',3,3),'fitfunc','fnc1','vars',struct('generation',1,'convergence',0,'starvtime',0,'stagnation',0,'id',0,'pid',0));
    wa = wa.genesis();

    for idset = 1:length(wa.islands)
        wa.islands(idset).vars.id = idset;
    end

    
    % -------------------------
    % gathered data:
    islnum = []; % the number of islands

    for g=1:generations
        tic
        disp(['Adaptive PGA: ' num2str(g) ' run ' num2str(meas)])
         
        islnum(g) = length(wa.islands);

          kill = [];
          for i = 1:length(wa.islands)

            % the island should not to be killed
            
            island = wa.islands(i);
            island = island.fitit();
            island = island.update();
            

            %--------algorithm starts here
            island.vars.convergence(g) = island.statfilt('min','mean',filter_window);
            if island.vars.generation <= 2
                selRest = resources/islandNum * 2;            
            else
                selRest = ressup(i);
            end
            %-----------------------------
            elite = island.select('best',3);                % vyberie 3 najpelsich
            rest = island.select('random',round(selRest));              % zvisok doplni nahodnym vyberom
            rest = rest.toolbox26('crossov',2,1);           % funkcia crossov zo stareho toolboxu
            rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
            rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
            island = elite.join(rest);                      % spoji elitu so zviskom        

            island.vars.generation = island.vars.generation + 1; % dalsia generacia
    % ----------------- blobulation
            if island.vars.generation < filter_window
                if size(island.genes,1) > blobTreshold      % ostrov je vacsi nez maximum                   
                    [island newisland] = island.blobulate(2);
                    newisland.vars.generation = 0;
                    newisland.vars.id = idset;
                    newisland.vars.pid = island.vars.id;
                    idset = idset + 1;
                    wa.islands(length(wa.islands)+1) = newisland;                
                end
                 if island.vars.starvtime > starving_tresh && island.vars.stagnation ~= 1  % ostrov dlhsie stagnuje ako je dovolene
                     for s = 1:length(wa.islands)       % hladam stagnovany ostrov na zlucenie
                         if wa.islands(s).vars.stagnation == 1  % som nasiel 
                             wa.islands(s) = wa.islands(s).join(island);
                             kill(length(kill)+1) = i; % instruction to kill the island in the end
                             break;
                         end
                         if s == length(wa.islands)  % som nenasiel 
                             island.vars.stagnation = 1;
                         end
                     end
                 end
            end
            
            % ------- end of blobulations
            if islnum(g) < minIslandNum % ak pocet ostrovo je menej nez minimum
                % vytvori novy ostrov ako dalsi
                wa.islands(islnum(g)+1) = ISLAND;        
                wa.islands(islnum(g)+1) = wa.islands(islnum(g)+1).set('space','homo',-500,500,10,'initPopSize',initpopsize,'initSize',islandNum,'structure',wa.cmg('grid',3,3),'fitfunc','eggholder','vars',struct('generation',1,'convergence',0,'starvtime',0,'stagnation',0,'id',0,'pid',0));
                wa.islands(islnum(g)+1) = wa.islands(islnum(g)+1).seed();
            end
    
            wa.islands(i) = island;
        end;

        wa = wa.update();
    %   -----------normalization
        if g>=2
            nabs = zeros(size(wa.islands,2),1);
            for p=1:size(wa.islands,2)
                nabs(p) = abs(wa.islands(p).vars.convergence(length(wa.islands(p).vars.convergence)-1) - wa.islands(p).vars.convergence(length(wa.islands(p).vars.convergence)));

                if nabs(p) == 0
                    wa.islands(p).vars.starvtime = wa.islands(p).vars.starvtime + 1;
                end
            end    
          nabs = nabs + 1;
        ressup = round(((nabs/sum(nabs)))*resources);
        end
    %   ------------------------
         if length(kill) > 0            % removing islands marked for kill
                wa = wa.delisland(kill);  % nice paralel command, i JUST LOVE Matlab
         end
         wa.locvars = islnum;
         toc         
    end
    
    adapted_worlds(meas) = wa;
   
end
 retdir = cd('experiments')
    save('fitnes_based_islsize_adapted_fnc1.mat','adapted_worlds')
    cd(retdir)

%----------------------------------good old classic

for meas2 = 1:measure_num

    disp(['PGA run ' num2str(meas2) '/' num2str(measure_num)])
    
w = WORLD;
w = w.set('space','homo',-500,500,5,'initPopSize',initpopsize,'initSize',9,'structure',w.cmg('grid',3,3),'fitfunc','fnc1');
w = w.genesis();

for g=1:generations
%     disp(['PGA generation: ' num2str(g)])
    for i=1:w.initSize        
        island = w.islands(i);
        island = island.fitit();
        
        elite = island.select('best',3);                % vyberie 5 najpelsich
        rest = island.select('random',initpopsize-3);              % zvisok doplni nahodnym vyberom
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

classic_worlds(meas2) = w;
end

retdir = cd('experiments')
save('fitnes_based_islsize_classic_fnc1.mat','classic_worlds')
cd(retdir)