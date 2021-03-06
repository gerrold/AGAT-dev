% Testovacia funkcia - inverzia matice 4x4, I.Sekaj 2009
% prvky inv. matice su z intervalu (-2;2)

function[Fit]=invmx4old(Pop)


A = [1 2 3 4 ;1 2 5 2; 1 5 2 4; 1 0 1 2];
J = eye(4);

[lpop,lstring]=size(Pop);

for i=1:lpop

    Q(1,:) = Pop(i,1:4);
    Q(2,:) = Pop(i,5:8);
    Q(3,:) = Pop(i,9:12);
    Q(4,:) = Pop(i,13:16);

%     Q = reshape(Pop(i,:),4,4)';
    E = J-A*Q;
    Fit(i) = sum(sum(abs(E)));

end;