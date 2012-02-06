a=rand(10);  % a=rand(20); a=rand(100);

disp('affin');
tic;
q=0;
for r=1:1000
    q=q+affin(a,0.1);
end;
q
t1=toc

disp('globaff');
tic;
q=0;
for r=1:1000
    q=q+globaff(a,0.1);
end;
q
t2=toc

disp('globaff2');
tic;
q=0;
for r=1:1000
    q=q+globaff2(a,0.1);
end;
q
t3=toc

t1/t2
t1/t3