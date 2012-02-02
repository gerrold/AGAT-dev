% test for functions
clc
clear
ostrov = ISLAND();                      % removed the setup from the constructor... does not work because of a bug
ostrov = ostrov.set(ostrov,'space','homo',-100,100,5,'fitfunc','schwef');
ostrov = ostrov.seed()
ostrov = ostrov.fitit()
ostrovD = ostrov.join(ostrov,ostrov)
tic
ostrovMut = ostrov.toolbox26('crossov',2,1)
toc