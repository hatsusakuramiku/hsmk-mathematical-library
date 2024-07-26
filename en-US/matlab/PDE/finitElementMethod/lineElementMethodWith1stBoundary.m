function [fval, fvalMatrix] = lineElementMethodWith1stBoundary(xRange, coefficients, boundaries, fun, steps)
    % 对如下定解问题特化(latex 语法)
    % $Lu = -\frac{d}{dx}(p\frac{d}{dx}) + qu = f, a < x < b$
    % $u(a) = \alpha, u(b) = \beta$

    arguments
        xRange {mustBeVector}
        coefficients {mustBeUnderlyingType(coefficients, 'cell')}
        boundaries {mustBeReal, mustBeVector}
        fun {mustBeUnderlyingType(fun, 'function_handle')}
        steps {mustBeVector}
    end

    %% 参数校验

    range_check(xRange);

    % % 系数与非齐次项需为 函数句柄、符号表达式、数
    if ~all(cellfun(@(x)isa(x, "function_handle"), coefficients))
        throw(MException('MATLAB:lineElementMethodWith1stBoundary:InvalidInput', '系数需为 funct_handle'))
    end

    if numel(boundaries) > 2
        throw(MException('MATLAB:lineElementMethodWith1stBoundary:InvalidInput', '边界条件最多两个，不足则补零'));
    end

    boundaries = vectorStandardization(boundaries, 2);

    % 输入的步长必须为单个正整数或在区间范围内的步长向量
    if numel(steps) == 1
        len = xRange(2) - xRange(1);
        steps = ones(1, steps) .* (len / steps);
    elseif ~isStepOk(xRange, steps)
        throw(MException('MATLAB:lineElementMethodWith1stBoundary:InvalidInput', '输入步长向量各元素之和必须等于区间长度'));
    end

    %% 计算

    % 生成基函数
    len = length(steps);
    lens = len + 1;
    xVector = ones(1, lens) .* xRange(1);
    aMatrix = zeros(len - 1, len - 1);
    funCell = cell(len - 1, 1);
    funVec = zeros(len - 1, 1);
    phiCell = cell(3, len);
    fval = zeros(1, lens);
    fval(1) = xRange(1); fval(end) = xRange(2);
    xVector(end) = xRange(2);

    for i = 1:1:len - 1
        xVector(i + 1) = xVector(i + 1) + sum(steps(1:i));
        phiCell{1, i} = @(x) - coefficients{1}(xVector(i) + steps(i) .* x) ./ steps(i) + steps(i) .* coefficients{2}(xVector(i) + steps(i) .* x) .* (x - x .^ 2);
        phiCell{2, i} = @(x)coefficients{1}(xVector(i) + steps(i) .* x) ./ steps(i) + steps(i) .* coefficients{2}(xVector(i) + steps(i) .* x) .* (x .^ 2) + ...
            coefficients{1}(xVector(i + 1) + steps(i + 1) .* x) ./ steps(i + 1) + steps(i + 1) .* coefficients{2}(xVector(i + 1) + steps(i + 1) .* x) .* (1 - 2 .* x + x .^ 2);
        phiCell{3, i} = @(x)-coefficients{1}(xVector(i + 1) + steps(i + 1) .* x) ./ steps(i + 1) + steps(i + 1) .* coefficients{2}(xVector(i + 1) + steps(i + 1) .* x) .* (x - x .^ 2);

        if i == 1
            funCell{i} = @(x) fun(xVector(i + 1) + steps(i + 1) .* x) .* (steps(i + 1)) .* (1 - x) + fun(xVector(i) + steps(i) .* x) .* (steps(i)) .* x - ...
                boundaries(1) .* (coefficients{1}(xVector(i) + steps(i) .* x) ./ steps(i) + steps(i) .* coefficients{2}(xVector(i) + steps(i) .* x) .* (x - x .^ 2));
        elseif i == len - 1
            funCell{i} = @(x) fun(xVector(i + 1) + steps(i + 1) .* x) .* (steps(i + 1)) .* (1 - x) + fun(xVector(i) + steps(i) .* x) .* (steps(i)) .* x + ...
                boundaries(2) .* (coefficients{1}(xVector(i + 1) + steps(i + 1) .* x) ./ steps(i + 1) + steps(i + 1) .* coefficients{2}(xVector(i + 1) + steps(i + 1) .* x) .* (x - x .^ 2));
        else
            funCell{i} = @(x) fun(xVector(i + 1) + steps(i + 1) .* x) .* (steps(i + 1)) .* (1 - x) + fun(xVector(i) + steps(i) .* x) .* (steps(i)) .* x;
        end

    end

    for i = 1:1:len - 1

        if i == 1
            aMatrix(i + 1, i) = integral(phiCell{3, i}, 0, 1);
        elseif i == len - 1
            aMatrix(i - 1, i) = integral(phiCell{1, i}, 0, 1);
        else
            aMatrix(i + 1, i) = integral(phiCell{3, i}, 0, 1);
            aMatrix(i - 1, i) = integral(phiCell{1, i}, 0, 1);
        end

        aMatrix(i, i) = integral(phiCell{2, i}, 0, 1);
        funVec(i) = integral(funCell{i}, 0, 1);
    end

    fval(2:end - 1) = aMatrix\funVec;
    fvalMatrix = aMatrix;

end
