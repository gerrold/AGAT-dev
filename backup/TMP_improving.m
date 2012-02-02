% improving performance
clc
clear

ostrov = ISLAND();
ostrov = ostrov.seed('space','homo',-500,500,20,'fitfunc','schwef','size',50);
ostrov = ostrov.fitit();
tic
ext = ostrov.extract('genes');
toc