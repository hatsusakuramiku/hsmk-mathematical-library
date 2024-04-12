function [fval, fvalMatrix] = Lax_Wendroff2orderWith1stBoundary(xRange, initial, coefficient, fun, conditions, xNum, tNum, tStep)
    % 适用方程:
    % $$ \frac{\partial u}{\partial t} + a\frac{\partial u}{\partial x} = 0$$

    arguments
        xRange {mustBeVector, mustBeReal} % 计算区间
        initial {mustBeScalarOrEmpty} % 初始条件
        coefficient {mustBeReal} % 空间一次偏导系数
        fun {mustBeScalarOrEmpty} % 非齐次项
        conditions {mustBeVector, mustBeReal} % 边界条件
        xNum {mustBePositive, mustBeInteger} % 空间点数
        tNum {mustBePositive, mustBeInteger} % 时间点数
        tStep {mustBePositive} % 时间步长
    end

    %% 参数校验

    range_check(xRange);

    xStep = (xRange(2) - xRange(1)) / xNum;

    % 初始条件与非齐次项需为 函数句柄、符号表达式、数值
    if ~isFunOrNumOrSym({initial, fun})
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'initial and fun must be a function handle, a symbolic expression, or a numerical value.'));
    end

    % 边界条件必须为数值，且最多两个，不足则补零
    if length(conditions) ~= 2
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'conditions must have at most 2 elements.'));
    end

    vectorStandardization(conditions, 2);

    if numel(coefficient) ~= 1
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'coefficient must be a scalar.'));
    elseif coefficient == 0
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'coefficient must be non-zero.'));
    end

    gridRadio = coefficient * tStep / xStep;

    if gridRadio < 0
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'gridRadio must be positive.'));
    elseif gridRadio > 1
        warning('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'gridRadio = %f is too large, which should be smaller than %f.', gridRadio, 1);
    end

    %% 计算

    fvalMatrix = zeros(tNum + 1, xNum + 1);
    xVector = xRange(1):xStep:xRange(2);
    fvalMatrix(:, 1) = ones(tNum + 1, 1) * conditions(1);
    fvalMatrix(:, end) = ones(tNum + 1, 1) * conditions(2);
    fvalMatrix(1, :) = func(initial, xVector);

    aMatrix = diag(ones(1, xNum - 1)) .* (3/4) + ((diag(ones(1, xNum - 2), -1) + diag(ones(1, xNum - 2), 1))) ./ 8;
    bMatrix = diag(ones(1, xNum - 1)) .* (1/6 - gridRadio ^ 2) - ((diag(ones(1, xNum - 2), -1) + diag(ones(1, xNum - 2), 1))) .* (1/6 - gridRadio + gridRadio ^ 2) ./ 2;
    cMatrix = diag(ones(1, xNum - 1)) ./ 12 - ((diag(ones(1, xNum - 2), -1) + diag(ones(1, xNum - 2), 1))) ./ 24;
    fvalMatrix(2, :) = UpwindFormatWith1stBoundary(xRange, initial, coefficient, fun, conditions, xNum, 1, tStep);
    funVector = func(fun, xRange(1) + xStep:xStep:xRange(2) - xStep);
    funVector(1) = funVector(1) + conditions(1) * ((1/6 - gridRadio + gridRadio ^ 2) ./ 2 -3/24);
    funVector(end) = funVector(end) + conditions(2) * ((1/6 - gridRadio + gridRadio ^ 2) ./ 2 -3/24);

    for i = 3:1:tNum + 1
        fvalMatrix(i, 2:end - 1) = aMatrix \ (bMatrix * fvalMatrix(i - 1, 2:end - 1)' + funVector' + cMatrix * fvalMatrix(i - 2, 2:end - 1)')';
    end

    fval = fvalMatrix(end, :);
end
