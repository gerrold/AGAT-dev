%   testing the speed of the invmx4 fitnes function
clc
clear
close all
t=[0;0];

for c=1:10000
    tic
    f = invmx4([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16; 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]);
    t(1) = t(1) + toc;

    tic
    f = invmx4old([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16; 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]);
    t(2) = t(2) + toc;
end
bar(t)
title(['sucin casu po ' num2str(c) ' evaulacii'])
t(1)/t(2)