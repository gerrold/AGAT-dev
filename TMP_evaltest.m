% testing the functionality of the algorithm
clear
clc
global ostrov;
ostrov = ISLAND();
ostrov = ostrov.seed('space','homo',-500,500,10,'fitfunc','schwef','size',30,'control','cont');
ostrov = ostrov.evolve('generation',100)
