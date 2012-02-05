% the ultimate showdown between two algorithms
clc
clear

f = rand(1000,1000); % generating a random matrix to compare

tic
[dup oldres each] = oldaff(f,0.1);
times(1) = toc;
disp('oldaff done')
tic
newres = (globaff(f,0.1)*200)/(size(f,1)^2 - size(f,1));
times(2) = toc;





 
 bar(times)