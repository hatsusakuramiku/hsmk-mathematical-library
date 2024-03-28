function [fval, fvalMatrix] = backwordDifferenceWith1stBoundary(xRange, initial, coefficient, fun, conditions, xNum, tNum, tStep)

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
    xVector = xRange(1) + xStep:xStep:xRange(2) - xStep;
    fvalMatrix(:, 1) = ones(tNum + 1, 1) * conditions(1);
    fvalMatrix(:, end) = ones(tNum + 1, 1) * conditions(2);
    fvalMatrix(1, 2:end - 1) = func(initial, xVector);

    aMatrix = zeros(xNum - 1, xNum - 1);

    for i = 1:1:xNum - 1

        if i == 1
            aMatrix(i, i + 1) = -gridRadio;
        elseif i == xNum - 1
            aMatrix(i, i - 1) = -gridRadio;
        else
            aMatrix(i, i - 1) = -gridRadio;
            aMatrix(i, i + 1) = -gridRadio;
        end

        aMatrix(i, i) = 1 + 2 * gridRadio;
    end

    funVector = func(fun, xVector) .* tStep;
    funVector(1) = funVector(1) + gridRadio * conditions(1);
    funVector(end) = funVector(end) + gridRadio * conditions(2);

    for i = 2:1:tNum + 1
        funVector_ = funVector + fvalMatrix(i - 1, 2:end - 1);
        fvalMatrix(i, 2:end - 1) = aMatrix \ funVector_';
    end

    fval = fvalMatrix(end, :);
end
