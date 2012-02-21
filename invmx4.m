% Testovacia funkcia - inverzia matice 4x4, I.Sekaj 2009
% prvky inv. matice su z intervalu (-2;2)
% optimalizoval E.Putz 2012

function[Fit]=invmx4(Pop)


A = [1 2 3 4 ;1 2 5 2; 1 5 2 4; 1 0 1 2];
J = eye(4);
Q = zeros(4,4);
Fit = zeros(size(Pop,1),1);

for i=1:size(Pop,1)
    Q = reshape(Pop(i,:),4,4)';
    Q = J-A*Q;
    Fit(i) = sum(sum(abs(Q)));
end;