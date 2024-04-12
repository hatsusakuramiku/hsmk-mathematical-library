function [aMatrix, bMatrix, cMatrix] = getMatrix(xNum)
    aMatrix = diag(ones(1, xNum - 1), 1);
    bMatrix = diag(ones(1, xNum), 0);
    cMatrix = diag(ones(1, xNum - 1), -1);
end