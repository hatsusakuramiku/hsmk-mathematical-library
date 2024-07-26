function [P1Matrix, P2Matrix] = getPmatrix(xNum)
    len = xNum - 1;
    P2Matrix = diag(ones(1,len^2-len), len) + diag(ones(1,len ^ 2 -  len), -len);
    P1Matrix = diag(ones(1,len^2))+diag(ones(1,len^2));

    for i = 2:1:len - 1
        P1Matrix((i -1) * len + 1, (i -1) * len)=0;
    end

end
