 function [polynomial, coefficients] = lSParabola(xCoordinate, yCoordinate)   
    % LSPARABOLA 使用最小二乘法拟合抛物线
    %   适用公式(此处使用Latex语法):
    %   $y = A x^2 + B x + C$
    %   polynomial = LSPARABOLA(xCoordinate, yCoordinate)
    %   Inputs
    %       xCoordinate - x坐标 {mustBeVector, mustBeReal}
    %       yCoordinate - y坐标 {mustBeVector, mustBeReal}
    %   Outputs
    %       polynomial - 拟合抛物线方程
    %       coefficients - 拟合曲线系数
    % 
    %   详细文档参见：<a href="../../html/lSParabola._help.html">lSParabola</a>
    %

    arguments
        xCoordinate {mustBeVector, mustBeReal}
        yCoordinate {mustBeVector, mustBeReal}
    end

    if numel(unique(xCoordinate)) ~= numel(xCoordinate)
        throw(MException('MATLAB:LeastSquares:InvalidInput', '输入X坐标不唯一'));
    elseif size(xCoordinate, 1) ~= size(yCoordinate, 1)
        throw(MException('MATLAB:LeastSquares:InvalidInput', '输入X和Y坐标维度不一致'));
    elseif numel(xCoordinate) ~= numel(yCoordinate)
        throw(MException('MATLAB:LeastSquares:InvalidInput', '输入X和Y坐标长度不相等'));
    end

    aMatrix = getAMatrix(xCoordinate, 2);
    bVector = getBVector(xCoordinate, yCoordinate, 2);
    result = linsolve(aMatrix, bVector);
    polynomial =@(x) result(3) * x .^ 2 + result(2) * x + result(1);
    coefficients = result;

    function aMatrix = getAMatrix(x, n)
        % 生成矩阵
        maxOrder = 2 * n;
        len = n + 1;
        N = length(x);
        xMatrix = repmat(x', 1, maxOrder);%
        xMatrix = cumprod(xMatrix, 2);
        xVector = [N, sum(xMatrix, 1)];
        aMatrix = zeros(len, len);

        for i = 1:len
            aMatrix(i, :) = xVector(i:1:i + n);
        end

    end

    function bMatrix = getBVector(x, y, n)
        bMatrix = zeros(n + 1, 1);

        for i = 1:n + 1
            bMatrix(i) = sum(y .* x .^ (i - 1));
        end

    end
end