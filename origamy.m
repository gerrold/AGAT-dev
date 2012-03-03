% linear deceptive function
% accepts n variebles in range 0-1.
function[fitvec]=origamy(population)
    beta = 0.3;
    alpha = 1/size(population,2):1/size(population,2):1;
    
    fitvec = zeros(size(population,1),1);
    
    for i=1:size(population,1)
       for ii=1:size(population,2)
            fitvec(i) = fitvec(i) + getlocfit(population(i,ii),alpha(ii));
       end 
        fitvec(i) = -(fitvec(i)/size(population,2))^beta;
    end
    
    fitvec=-real(fitvec);
    
%     fitvec = -1 * (1/size(population,2) * sum(getlocfit(population,repmat(alpha,size(population,1),1)))) ^ beta;
%     fitvec = getlocfit(population(1,1),alpha(1));
    function[locfit]=getlocfit(gx,alpha)
        if gx < 0
            error('the value cannot be negative');
        else if gx <= 4/5*alpha
                locfit = -gx/alpha + 4/5;
            else if ((4/5)*alpha < gx) && (gx <= alpha)
                    locfit = (5*gx)/alpha - 4;
                else if alpha < gx && gx <= (1+4*alpha)/5
                        locfit = (5*(gx-alpha))/(alpha-1);
                    else if (1+4*alpha)/5 < gx && gx <= 1
                            locfit = (gx-1)/(1-alpha) + 4/5;
                        else
                            error('the value over 1 is not alloved')
                        end
                    end
                end
            end
        end
    end
end