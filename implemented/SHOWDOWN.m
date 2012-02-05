% the ultimate showdown between two algorithms

for i=2:1:100
    f = rand(i,100); % generating a random matrix to compare

    tic
    [dup oldres each] = oldaff(f,0.1);
    times(i,1) = toc;
%     disp('oldaff done')
    tic
    newres = globaff(f,0.1);
    times(i,2) = toc;
    
    i
end
 plot(times)
 legend('old','new')
%  bar(times)