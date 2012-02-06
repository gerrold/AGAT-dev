% the ultimate showdown between two algorithms
clc
clear
for i=2:1:100
    f = rand(i,200); % generating a random matrix to compare

    tic
    newres = globaff2(f,0.1);
%     oldres = globaff2(f,0.1);
    times(i,1) = toc;
%     disp('oldaff done')
    tic
    oldres = affin2(f,0.1);
    
    times(i,2) = toc;
    [oldres newres]
    i
end
 plot(times)
 legend('globaff2','affin2')
%  bar(times)