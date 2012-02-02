%generates an octagonal gridlike structure

function[cmatrix]=octag(sizeX,sizeY)
    i=1;
    for x=1:sizeX
        for y=1:sizeY
            help(x,y)=i;
            i=i+1;
        end;
    end;

    xt=1;
    yt=1;
    c = 1;
    for islx=1:sizeX
%        if xt > sizeX
%            xt = 1;
%            yt = yt + 1;
%        end   
       for isly = 1:sizeY
           try
            cmatrix(c,1) = help(islx-1,isly); %left
           catch
            cmatrix(c,1) = 0;
           end; try
            cmatrix(c,2) = help(islx+1,isly); %right
           catch
                cmatrix(c,2) = 0;
           end; try
            cmatrix(c,3) = help(islx,isly-1); %down
           catch
                cmatrix(c,3) = 0;
           end; try
            cmatrix(c,4) = help(islx,isly+1); %up
           catch
                cmatrix(c,4) = 0;
           end; try
            cmatrix(c,5) = help(islx-1,isly-1); %bottom left
           catch
                cmatrix(c,5) = 0;
           end; try
            cmatrix(c,6) = help(islx+1,isly-1); %bottom right
           catch
                cmatrix(c,6) = 0;
           end; try
            cmatrix(c,7) = help(islx-1,isly+1); %top left
           catch
                cmatrix(c,7) = 0;
           end; try
            cmatrix(c,8) = help(islx+1,isly+1); %top right
           catch
                cmatrix(c,8) = 0;
           end;
        c = c + 1;
%         xt = xt + 1;
       end
    end;    
end