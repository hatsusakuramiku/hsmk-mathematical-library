function fval = differenceWith1stBoundary(range, coefficients, fun, conditions, intervalNum)
    % DIFFERENCEWITH1THBOUNDARY  使用直接差分法对第一类边界条件的二阶偏微分方程在指定区间内进行数值逼近
    %   fval = differenceWith1thBoundary(range, coefficients, fun, conditions, intervalNum)
    %   适用方程格式如下
    %   -x\frac{d}{dx}(p)\frac{du}{dx} + r\frac{du}{dx} + qu = f
    %
    %   Inputs:
    %       range          计算区间
    %       coefficients   系数，依次是 二阶偏导系数，一阶偏导系数，零阶偏导系数
    %       fun            非齐次项
    %       conditions     边界条件
    %       intervalNum    区间数
    %
    %   Outputs:
    %       fval           在各剖分节点处的逼近数值
    %
    %   Examples:
    %       fun = @(x) x .* cos(x) + cos(x);
    %       p = @(x) x;
    %       r = 1;
    %       q = 1;
    %       a1 = 1;a2 = -1;
    %       range = [0, pi];
    %       fval = differenceWith1thBoundary(range, {p, r, q}, fun, [a1, a2]);
    %
    %   详细信息请查看帮助文档 <a href=""> DIFFERENCEWITH1THBOUNDARY </a>
    %% 参数检查
    arguments
        range {mustBeVector, mustBeReal}
        coefficients {mustBeUnderlyingType(coefficients, 'cell')}
        fun {mustBeScalarOrEmpty}
        conditions {mustBeVector, mustBeReal}
        intervalNum {mustBeInteger, mustBeGreaterThanOrEqual(intervalNum, 2)} = 100
    end

    range_check(range);

    if length(coefficients) > 3
        throw(MException('MATLAB:differenceWith1thBoundary:InvalidInput', 'coefficients must have at most 3 elements.'));
    end

    cellStandardization(coefficients, 3); % 标准化，确保长度为 3

    if ~isFunOrNumOrSym(coefficients) || ~isFunOrNumOrSym(fun)
        throw(MException('MATLAB:differenceWith1thBoundary:InvalidInput', 'coefficients must be a function handle, a symbolic expression, or a numerical value.'));
    end

    conditions = vectorStandardization(conditions, 2); % 标准化，确保长度为 2

    %% 计算
    h = (range(2) - range(1)) / intervalNum;
    h_ = h ^ 2;
    h_double = h * 2;
    h_half = h / 2;
    vector = (range(1) + h):h:(range(2) - h);
    halfVector = (range(1) + h_half):h:(range(2) - h_half);

    pValue = func(coefficients{1}, halfVector);
    rValue = func(coefficients{2}, vector);
    qValue = func(coefficients{3}, vector);
    fValue = func(fun, vector);

    A = zeros(intervalNum - 1, intervalNum - 1);
    fValue(1) = fValue(1) + (pValue(1) / h_ + rValue(1) / h_double) * conditions(1);
    fValue(end) = fValue(end) + (pValue(end) / h_ - rValue(end) / h_double) * conditions(2);

    for i = 1:1:intervalNum - 1

        if i == 1
            A(i, i + 1) = -pValue(i + 1) / h_ + rValue(i) / (h_double);
        elseif i == intervalNum - 1
            A(i, i - 1) = -pValue(i) / h_ - rValue(i) / (h_double);
        else
            A(i, i + 1) = -pValue(i + 1) / h_ + rValue(i) / (h_double);
            A(i, i - 1) = -pValue(i) / h_ - rValue(i) / (h_double);
        end

        A(i, i) = (pValue(i) + pValue(i + 1)) / h_ + qValue(i);
    end

    fval = [conditions(1), (A \ (fValue'))', conditions(2)];

end
