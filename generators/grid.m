%generates a homogen 2D grid structure connectivity matrix, and connects every neighbour
%of every spiece usage: connect2D(sizeX,sizeY)
function[cmatrix]=grid(sizeX,sizeY)
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

        cmatrix(c,:) = [help(islx,isly)-1 help(islx,isly)+1 help(islx,isly)-sizeX help(islx,isly)+sizeX];
        c = c + 1;
%         xt = xt + 1;
       end
    end;
    %cleaning up
    cmatrix(cmatrix < 0) = 0;
    cmatrix(cmatrix > sizeX*sizeY) = 0;
    cmatrix(((1:sizeY)*sizeX),2) = 0;
    cmatrix(((1:sizeY-1)*sizeX)+1,1) = 0;
    
end