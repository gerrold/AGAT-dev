% function for class testing
clc
clear
tic
ostrov = ISLAND('space','homo',-100,100,5,'fitfunc','schwef')
% ostrov = ostrov.set(ostrov,'fitfunc', 'schwef')
ostrov = ostrov.seed()
ostrov = ostrov.fitit()
% xtract = ostrov.extract('genes')
% ostrov2 = ostrov.join(ostrov,ostrov,ostrov,ostrov,ostrov,ostrov)
% ostrov3 = ostrov.toolbox26('muta',0.5,[-1 -1 -1 -1 -1; 1 1 1 1 1],ostrov.space)
ostrov4 = ostrov.sortit()
ostrov = ostrov.update()
subo1 = ostrov.select('best',6,'worst',3)
toc