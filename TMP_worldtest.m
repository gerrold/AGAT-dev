% worldtest - aka testing the functionality of the world generating
% algorithm
clear
clc
close all

w = WORLD;
w = w.set('space','homo',-500,500,10,'initPopSize',10,'initSize',1,'structure',w.cmg('star',5),'fitfunc','schwef','type','PSO')
w = w.genesis()


for g=1:100
    for i=1:w.initSize
        island = w.islands(i);
        island = island.move();
        scatter(island.genes(:,1),island.genes(:,2),12,'k')
        hold on
%         contour(map)
        scatter(island.bestknown.pos(1),island.bestknown.pos(2),10,'bx')
        
        hold off
        axis([-500 500 -500 500]);
        title([num2str(island.bestknown.value) ' @ ' num2str(island.bestknown.pos)])
        island = island.update();
        pause(0.001)
        w.islands(i) = island;
    end;
end