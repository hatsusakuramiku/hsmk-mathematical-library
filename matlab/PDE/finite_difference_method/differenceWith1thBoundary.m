function fval = differenceWith1thBoundary(leftEndPoint, rightEndPoint, intervalNum, p, r, q, f, alpha, beta)
    % DIFFERENCEWITH1THBOUNDARY  使用直接差分法对第一类边界条件的二阶偏微分方程在指定区间内进行数值逼近
    %   fval = DIFFERENCEWITH1THBOUNDARY(leftEndPoint, rightEndPoint, intervalNum, p, r, q, f, alpha, beta)
    %
    %   Inputs:
    %       leftEndPoint   计算区间左端点
    %       rightEndPoint  计算区间右端点
    %       intervalNum    计算区间进行网格剖分的网格个数
    %       p              二阶偏导的系数
    %       r              一阶偏导的系数
    %       q              原函数的系数
    %       f              非齐次项
    %       alpha          第一类边界条件左端点函数值
    %       beta           第一类边界条件右端点函数值
    %
    %   Outputs:
    %       fval           在各剖分节点处的逼近数值
    %
    %   Examples:
    %       % 
    %       fval = differenceWith1thBoundary(0, pi, 8, @(x)x , 1, 0, @(x) x*cos(x) + cos(x), 1, -1);
    %
    %   详细信息请查看帮助文档 <a href=""> DIFFERENCEWITH1THBOUNDARY </a>

    % 参数检查
    arguments
        leftEndPoint{mustBeReal}                                                    % 左端点必须为实数
        rightEndPoint{mustBeReal, mustBeGreaterThan(rightEndPoint, leftEndPoint)}   % 右端点必须为实数，且左端点必须小于右端点
        intervalNum{mustBeInteger, mustBeGreaterThan(intervalNum, 2)}               % 网格个数必须为正整数，且大于 2
        p{mustBeScalarOrEmpty}                                                      % 二阶偏导系数，仅接受 sym 类型或函数句柄或数值
        r{mustBeScalarOrEmpty}
        q{mustBeScalarOrEmpty}
        f{mustBeScalarOrEmpty}
        alpha{mustBeReal}
        beta{mustBeReal}
    end

    %% 计算
    h = (rightEndPoint - leftEndPoint) / intervalNum;
    h_ = h ^ 2;
    h__ = h * 2;
    h___ = h / 2;
    vector = (leftEndPoint + h):h:(rightEndPoint - h);
    halfVector = (leftEndPoint + h___):h:(rightEndPoint - h___);

    pValue = func(p, halfVector);
    rValue = func(r, vector);
    qValue = func(q, vector);
    fValue = func(f, vector);

    A = zeros(intervalNum - 1, intervalNum - 1);
    fValue(1) = fValue(1) + (pValue(1) / h_ + rValue(1) / h__) * alpha;
    fValue(end) = fValue(end) + (pValue(end) / h_ - rValue(end) / h__) * beta;

    for i = 1:1:intervalNum - 1

        if i == 1
            A(i, i + 1) = -pValue(i + 1) / h_ + rValue(i) / (h__);
        elseif i == intervalNum - 1
            A(i, i - 1) = -pValue(i) / h_ - rValue(i) / (h__);
        else
            A(i, i + 1) = -pValue(i + 1) / h_ + rValue(i) / (h__);
            A(i, i - 1) = -pValue(i) / h_ - rValue(i) / (h__);
        end

        A(i, i) = (pValue(i) + pValue(i + 1)) / h_ + qValue(i);
    end

    fval = [alpha, (A \ (fValue'))', beta];

    function result = func(fun, x)

        if isa(fun, 'function_handle')
            result = fun(x);
        elseif isa(fun, 'sym')
            result = double(subs(fun, symvar(fun), x));
        elseif isa(fun,"double")
            result = fun .* ones(1, length(x));
        else
            throw(exceptions("DIFFERENCEWITH1THBOUNDARY:func","参数 f 必须为函数句柄或 sym 类型或数值。"));
        end

    end

end

