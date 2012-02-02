function[map]=mapme(cmatrix)
[rows lenght]=size(cmatrix);
for i=1:lenght
    names(i)=i;
end;

cm=zeros(rows);
for x=1:rows
    for y=1:lenght
        trgt=cmatrix(x,y);
        if trgt ~= inf 
            if trgt ~= 0
                cm(x,trgt)=1;
            end;
        end;
    end;
end;


map=biograph(cm)
view(map)