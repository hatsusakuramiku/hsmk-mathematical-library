function [point, fval, fittingMatrix] = binarySearch(inputFunction, area, accuracy, maxInext)
    %BINARYSEARCH 二分查找法
    %   [point, fval, fittingMatrix] = binarySearch(inputFunction, area, accuracy, maxInext)
    %   Inputs
    %       inputFunction - 输入的函数，要求为单符号连续函数且在给定区间内连续且仅有一个零点
    %       area - 输入的区间，要求给定函数在给定区间内有且仅有一个零点！
    %       accuracy - 输入的精度，要求精度必须为正数，默认为0.001
    %       maxInext - 输入的最大迭代次数，默认为1000
    %   Outputs
    %       point - 输入的函数在给定区间内拟合零点
    %       fval - 输入的函数在给定区间内的拟合零点处的函数值
    %       fittingMatrix - 输入的函数在给定区间内的拟合过程中各点的矩阵，矩阵的行数为 m 列数为 3，其中 m 为拟合点的数量，第一列为区间左端点，第二列为区间右端点，第三列为拟合点的坐标
    %   Examples
    %       syms x
    %       fun = exp(x^2) - 1
    %       area = [-1, 1]
    %       accuracy = 0.0001
    %       [point, fval, fittingMatrix] = binarySearch(fun, area, accuracy)
    %       [point, fval] = binarySearch(fun, area, accuracy)
    %       point = binarySearch(fun, area, accuracy)
    %
    %   Author: HSMK
    %   Date: 2022-10-26
    %   Version: 1.0
    %   Required Matlab Version: 2019a or later and Symbolic Math Toolbox
    arguments
        inputFunction {mustBeUnderlyingType(inputFunction, 'sym')}
        area {mustBeVector}
        accuracy {mustBePositive} = 0.0001
        maxInext {mustBePositive} = 1000
    end

    nargoutchk(1, 2); % 要求输出参数数量在1-2个

    % 预处理
    try
        double(subs(inputFunction, symvar(inputFunction), sum(area) / 2));
    catch e
        throw(MException('MATLAB:binarySearch:InvalidInput', sprintf('输入公式 %s 无法在给定的计算区间 [%s] 内求解，请确保给定函数在给定区间内有且仅有一个零点', sym2str(inputFunction), num2str(area))));
    end

    tool = Tool(); % 工具类
    syms x
    inputFunction = subs(inputFunction, symvar(inputFunction), x);
    area = tool.vector2Area(area, 2); % 转换区间，确保区间仅有两个端点且左端点小于右端点
    fittingMatrix = [area(1), area(2), (area(1) + area(2)) / 2];

    % 如果左右端点符号相同则直接返回
    if sign(subs(inputFunction, x, area(1))) == sign(subs(inputFunction, x, area(2)))
        point = NaN(1, 2);
        fval = NaN(1, 2);
        return
    end

    % 二分法求解
    a = area(1);
    b = area(2);
    c = (a + b) / 2;
    iter = 0;

    while (abs(subs(inputFunction, x, c)) > accuracy) && (iter < maxInext)

        if sign(subs(inputFunction, x, a)) == sign(subs(inputFunction, x, c))
            b = c;
        else
            a = c;
        end

        iter = iter + 1;
        c = (a + b) / 2;
    end

    point = c;
    fval = subs(inputFunction, x, point);
    fittingMatrix = [fittingMatrix; a, b, c];

end
