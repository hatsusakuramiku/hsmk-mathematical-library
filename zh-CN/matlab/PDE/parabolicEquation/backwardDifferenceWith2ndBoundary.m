function [fval, fvalMatrix] = backwardDifferenceWith2ndBoundary(xRange, initial,coefficient, fun, conditions, xNum, tNum, tStep)
    arguments
        xRange {mustBeVector, mustBeReal} % 计算区间
        initial {mustBeScalarOrEmpty} % 初始条件
        coefficient {mustBeReal} % 二次偏导系数
        fun {mustBeScalarOrEmpty} % 非齐次项
        conditions {mustBeUnderlyingType(conditions, 'cell')} % 边界条件
        xNum {mustBePositive, mustBeInteger} % 空间点数
        tNum {mustBePositive, mustBeInteger} % 时间点数
        tStep {mustBePositive} % 时间步长
    end

    %% 参数校验

    range_check(xRange);

    xStep = (xRange(2) - xRange(1)) / xNum;

    % 初始条件与非齐次项需为 函数句柄、符号表达式、数值
    if ~isFunOrNumOrSym({initial, fun})
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', '初始条件与非齐次项需为 函数句柄、符号表达式、数值。'));
    end

    % 边界条件必须为数值，且最多两个，不足则补零
    if length(conditions) > 2
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', '边界条件最多两个，不足则补零。'));
    elseif ~isFunOrNumOrSym(conditions)
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', '边界条件需为 函数句柄、符号表达式、数值。'));
    end

    cellStandardization(conditions, 2);

    gridRadio = coefficient * tStep / xStep; % 网格比

    if gridRadio < 0
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', '网格比不能小于0。'));
    end

    %% 计算

    fvalMatrix = zeros(tNum + 1, xNum + 1);
    xVector = xRange(1):xStep:xRange(2);
    boundaryMatrix = get2ndBoundaryPoint(xRange, initial, conditions{1}, conditions{2}, tStep, tNum);
    fvalMatrix(:, 1) = boundaryMatrix(:, 1);
    fvalMatrix(:, end) = boundaryMatrix(:, 2);
    fvalMatrix(1, :) = func(initial, xVector);

    [SMtrix, IMatrix] = getSMatrix(xNum - 1);
    aMatrix = (1 + 2 * gridRadio) .* IMatrix - gridRadio .* SMtrix;

    funVector = func(fun, xRange(1) + xStep:xStep:xRange(2) - xStep) .* tStep;

    for i = 2:1:tNum + 1
        funVector_ = funVector + fvalMatrix(i - 1, 2:end - 1);
        funVector_(1) = funVector_(1) + gridRadio * boundaryMatrix(i, 1);
        funVector_(end) = funVector_(end) + gridRadio * boundaryMatrix(i, 2);
        fvalMatrix(i, 2:end - 1) = aMatrix \ funVector_';
    end

    fval = fvalMatrix(end, :);
end
