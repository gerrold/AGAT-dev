% TESTING the migration algorithm
clc
clear

world = WORLD;
world.initSize = 2;
world.structure.connection = [2;1];
world = world.set('space',{'homo',-500,500,10},'initPopSize',10);

world = world.genesis()
world.islands(1).genes = ones(10);
world.islands(1) = world.islands(1).migrate('out',world.islands(1).select('random',1));
world.islands(2).genes = ones(10)*2;
world = world.migrate();
world.islands(2) = world.islands(2).migrate('in');
world.islands.genes
world.islands.genes