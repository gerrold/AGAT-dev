% extract and sumarize adapteworlds
clc
clear adataset
clear cdataset
ii = 1;
for i=1:length(adapted_worlds)
    for j=1:size(adapted_worlds(i).trail.min,1)
        adataset(ii,:) = adapted_worlds(i).trail.min(j,1:4000);        
        ii = ii + 1;
    end
    adatasett(i,:) = min(adataset);   
end



for i=1:length(classic_worlds)
    ii = 1;
    for j=1:size(classic_worlds(i).trail.min,1)
        cdataset(ii,:) = classic_worlds(i).trail.min(j,1:4000);        
        ii = ii + 1;
    end
    cdatasett(i,:) = min(cdataset);
end


plot(mean(adatasett),'b')
hold on
plot(mean(cdatasett),'r')
xlabel('generacie')
ylabel('priemerny fitnes')
title('eggholder 10 behov priemer')
legend('adaptivny','klassicky')
hold off