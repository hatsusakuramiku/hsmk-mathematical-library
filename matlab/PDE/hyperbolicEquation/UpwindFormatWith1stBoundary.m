function [fval, fvalMatrix] = UpwindFormatWith1stBoundary(xRange, initial, coefficient, fun, conditions, xNum, tNum, tStep)
    % 适用方程:
    % $$ \frac{\partial u}{\partial t} = a\frac{\partial u}{\partial x} $$

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

    gridRadio = tStep / xStep;

    if gridRadio < 0
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'gridRadio must be positive.'));
    elseif gridRadio > abs(1 / coefficient)
        warning('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'gridRadio = %f is too large, which should be smaller than %f.', gridRadio, abs(1 / coefficient));
    end

    %% 计算

    fvalMatrix = zeros(tNum + 1, xNum + 1);
    xVector = xRange(1):xStep:xRange(2);
    fvalMatrix(:, 1) = ones(tNum + 1, 1) * conditions(1);
    fvalMatrix(:, end) = ones(tNum + 1, 1) * conditions(2);
    fvalMatrix(1, :) = func(initial, xVector);

    if coefficient > 0
        aMatrix = (1 - coefficient * gridRadio) .* diag(ones(1, xNum)) + coefficient * gridRadio .* diag(ones(1, xNum - 1), -1);
        funVector = func(fun, xRange(1) + xStep:xStep:xRange(2)) .* tStep;
        funVector(1) = funVector(1) + conditions(1) * coefficient * gridRadio;

        for i = 2:1:xNum + 1
            fvalMatrix(i, 2:end) = (aMatrix * fvalMatrix(i - 1, 2:end)')' + funVector;
        end

    else
        aMatrix = (1 + coefficient * gridRadio) .* diag(ones(1, xNum)) - coefficient * gridRadio .* diag(ones(1, xNum - 1), 1);
        funVector = func(fun, xRange(1):xStep:xRange(2) - xStep) .* tStep;
        funVector(end) = funVector(end) + conditions(2) * coefficient * gridRadio;

        for i = 2:1:xNum + 1
            fvalMatrix(i, 1:end - 1) = (aMatrix * fvalMatrix(i - 1, 1:end - 1)')' + funVector;
        end

    end

    fval = fvalMatrix(end, :);
end
