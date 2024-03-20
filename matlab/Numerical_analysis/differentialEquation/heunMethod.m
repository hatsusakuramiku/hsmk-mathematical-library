function [result, intervalMatrix] = heunMethod(fun, t_0, y_0, endPoint, step)
    %HEUN 使用Heun方法求解常微分方程
    % [result, intervalMatrix] = heunMethod(fun, t_0, y_0, endPoint, step)
    % 适用如下形式的方程
    % y' = f(t, y), y(t_0) = y_0
    %
    %   Inputs
    %       fun - 输入函数 {mustBeUnderlyingType(fun, 'function_handle')}
    %       t_0 - 初始坐标 {mustBeReal}
    %       y_0 - 初始值 {mustBeReal}
    %       endPoint - 结束坐标 {mustBeReal}
    %       step - 步长 {mustBeReal, mustBeGreaterThan(step, 0)}
    %   Outputs
    %       result - 结果
    %       intervalMatrix - 迭代矩阵
    %   Examples
    %       [result, intervalMatrix] = heunMethod(fun, t_0, y_0, endPoint, step)

    %% 输入参数校验
    arguments
        fun {mustBeUnderlyingType(fun, 'function_handle')}
        t_0 {mustBeReal}
        y_0 {mustBeReal}
        endPoint {mustBeReal}
        step {mustBeReal, mustBeGreaterThan(step, 0)}
    end

    try
        range = range_check([t_0, endPoint]);
        rangeLength = range(2) - range(1);
    catch ME
        throw(ME);
    end

    try
        fun(t_0, y_0);
    catch ME
        throw(MException('MATLAB:heunMethod:InvalidInput', '输入函数不合法, 输入函数必须是二元函数'));
    end

    %% 计算

    tVector = t_0:step:endPoint;

    if isdecimal(rangeLength / step)
        warning("区间长度不是步长的整数倍，可能导致较大精度损失!");
        tVector = [tVector, endPoint];
    end

    intervalLength = length(tVector);

    intervalMatrix = [tVector; zeros(1, intervalLength)];
    intervalMatrix(2, 1) = y_0;

    for i = 1:intervalLength - 1
        k1 = step * fun(tVector(i), intervalMatrix(2, i));
        k2 = step * fun(tVector(i) + step, intervalMatrix(2, i) + k1);
        intervalMatrix(2, i + 1) = intervalMatrix(2, i) + (k1 + k2) / 2;
    end

    result = intervalMatrix(2, end);
end

