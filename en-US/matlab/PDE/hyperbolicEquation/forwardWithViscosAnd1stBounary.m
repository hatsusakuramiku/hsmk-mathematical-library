function [fval, fvalMatrix] = forwardWithViscosAnd1stBounary(xRange, initial, coefficient, fun, conditions, xNum, tNum, tStep)
    % 适用方程:
    % $$ \frac{u^{n + 1}_j - u^n_j}{\tau} + b\frac{u^n_{j} - u^n_{j - 1}}{h}= a\frac{u^n_{j + 1} - 2u^n_j + u^n_{j - 1}}{h^2}  $$

    arguments
        xRange {mustBeVector, mustBeReal} % 计算区间
        initial {mustBeScalarOrEmpty} % 初始条件
        coefficient {mustBeVector, mustBeReal} % 第一个元素为空间二次偏导系数，第二个元素为空间一次偏导系数
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

    gridRadio_1 = coefficient(1) * tStep / xStep ^ 2;
    gridRadio_2 = coefficient(2) * tStep / xStep;

    if gridRadio_1 < 0
        throw(MException('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'gridRadio must be positive.'));
    elseif gridRadio_1 < gridRadio_2
        warning('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'gridRadio is too small.');
    elseif gridRadio_1 > (gridRadio_2 + 1) / 2
        warning('MATLAB:forwordDifferenceWith1stBoundary:InvalidInput', 'gridRadio is too large.');
    end

    %% 计算
    [aMatrix, bMatrix, cMatrix] = getMatrix(xNum - 1);
    matrix = (gridRadio_1 - gridRadio_2 / 2) .* aMatrix + (1 - 2 * gridRadio_1) .* bMatrix + (gridRadio_1 + gridRadio_2 / 2) .* cMatrix;
    xVector = xRange(1) + xStep:xStep:xRange(2) - xStep;
    funvector = func(fun, xVector) .* tStep;
    funvector(1) = conditions(1) * (gridRadio_1 + gridRadio_2 / 2) + funvector(1);
    funvector(end) = conditions(2) * (gridRadio_1 - gridRadio_2 / 2 + funvector(end));
    fvalMatrix = zeros(tNum + 1, xNum + 1);
    fvalMatrix(1, :) = func(initial, xRange(1):xStep:xRange(2));

    for i = 2:1:tNum + 1
        fvalMatrix(i, 2:end - 1) = (matrix * fvalMatrix(i - 1, 2:end - 1)')' + funvector;
    end

    fval = fvalMatrix(end, :);
end
