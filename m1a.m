% first measurement experimental comparison
clc; clear; close all


% indivOnIsland = 100;
panmixi = 10;      % how much generations runs on an island during one cycle
migcycle = 10;      % the number of migration cycles
worldsize = 3000;   % the total number of individuals on the world
islandNum = 30;

%---------------calculating agregated data and seeding
world = WORLD;
world = world.set('space',{'homo',-500,500,10},'initPopSize',ceil(worldsize/islandNum),'initSize',islandNum,'structure',world.cmg('star',islandNum),'fitfunc','schwef');
world = world.genesis();

disp(['initialising a world of ' num2str(islandNum) ' with population of ' num2str(ceil(worldsize/islandNum)) 'each island in:'])
% disp('3...')
% pause(1)
% disp('2...')
% pause(1)
% disp('1...')
% pause(1)
% disp('GO!!!')

% ostrov = ISLAND('space','homo',-500,500,10,'fitfunc','schwef','population',30);
% ostrov = ostrov.seed();
for m=1:migcycle
    for p=1:size(world.islands,2)
    % ostrov = ISLAND();
    % ostrov = ostrov.seed('space','homo',-500,500,30,'fitfunc','schwef','size',1000);
        ostrov = world.islands(p);
        for i=1:panmixi
            ostrov = ostrov.update();                       % aktualizuje statisticke udaje pre ostrov
            ostrov = ostrov.fitit();                      % nie je potrebny kedze sa defaulte aktualizuje
            ostrov = ostrov.migrate('out',ostrov.select('best',1));
            ostrov = ostrov.migrate('in');
            elite = ostrov.select('best',1);                % vyberie 5 najpelsich
            rest = ostrov.select('random',ceil(worldsize/islandNum)-3);              % zvisok doplni nahodnym vyberom
            rest = rest.toolbox26('crossov',2,1);           % funkcia crossov zo stareho toolboxu
            rest = rest.toolbox26('mutx',0.2,rest.space);   % to iste
            rest = rest.toolbox26('muta',0.1,rest.space(2,:) .* 0.01, rest.space);    % aditivna mutacia o 1% zo space hodnoty
            ostrov = elite.join(rest);                      % spoji elitu so zviskom
            disp(['ostrov #' num2str(p) ' genes = '  num2str(size(ostrov.genes)) ])
            stat(i+m-1,p) = ostrov.getstats('min');
            plot(stat)
            pause(0.00001)
        end
        world.islands(p) = ostrov;
        world = world.migrate();
    end
end