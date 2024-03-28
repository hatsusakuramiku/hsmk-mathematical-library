function [fval, fvalMatrix] = forwordDifferenceWith1stBoundary(xRange, initial, coefficient, fun, conditions, xNum, tNum, tStep)

    arguments
        xRange {mustBeVector, mustBeReal} % 计算区间
        initial {mustBeScalarOrEmpty} % 初始条件
        coefficient {mustBeReal} % 二次偏导系数
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
    if length(conditions) > 2
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'conditions must have at most 2 elements.'));
    end

    vectorStandardization(conditions, 2);

    gridRadio = coefficient * tStep / xStep;

    if gridRadio < 0
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'gridRadio must be positive.'));
    elseif gridRadio > 0.5
        warning('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'gridRadio is too large.');
    end

    %% 计算

    fvalMatrix = zeros(tNum + 1, xNum + 1);
    xVector = xRange(1):xStep:xRange(2);
    fvalMatrix(:, 1) = ones(tNum + 1, 1) * conditions(1);
    fvalMatrix(:, end) = ones(tNum + 1, 1) * conditions(2);
    fvalMatrix(1, :) = func(initial, xVector);

    funVector = func(fun, xVector) .* tStep;

    for i = 2:1:tNum + 1

        for j = 2:1:xNum
            fvalMatrix(i, j) = fvalMatrix(i - 1, j) * (1 - 2 * gridRadio) + gridRadio * (fvalMatrix(i - 1, j + 1) + fvalMatrix(i - 1, j - 1)) + funVector(j);
        end

    end

    fval = fvalMatrix(end, :);
end
