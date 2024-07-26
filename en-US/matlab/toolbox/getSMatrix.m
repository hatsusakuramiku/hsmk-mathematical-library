function [SMatrix, IMatrix] = getSMatrix(order)
    vector = ones(1,order - 1);
    SMatrix = diag(vector,1) + diag(vector,-1);
    IMatrix = eye(order);
end