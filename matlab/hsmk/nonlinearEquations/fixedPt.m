function [fixedPoint, fixedPointFval,iteratePoint] = fixedPt(fun, maxIter, x0, option,area)

    arguments
        fun {mustBeUnderlyingType(fun, 'sym')} % 输入的函数
        maxIter (1, 1) {mustBeInteger,mustBeGreaterThanOrEqual(maxIter, 1)} = 1000 % 最大迭代次数
        x0 {mustBeReal} = 0 % 初始点
        option {mustBeMember(option, [1, 0])} = 0 % 如果为 1 就绘图
        area {mustBeVector,mustBeReal} = -10:0.01:10 % 绘图区间
    end

    syms x

    if numel(symvar(fun)) ~= 1
        throw(MException('MATLAB:fixedPt:InvalidInput', sprintf("输入的公式 %s 不是单变量函数", char(fun))))
    end

    if isvector(x0)

        if size(x0(:, 1)) ~= 1
            x0 = x0';
        end

    else
        throw(MException('MATLAB:fixedPt:InvalidInput', sprintf("输入的初始点 %s 不是一列向量", char(x0))))
    end

    if symvar(fun) ~= x
        subs(fun, symvar(fun), x);
    end

    fixedPoint = solve(fun == x);
    iteratePoint = sym(zeros(length(x0), maxIter));
    fixedPointFval = subs(fun,x,fixedPoint);

    for i = 1:maxIter
        iteratePoint(:, i) = subs(fun, x, x0);
    end

    if option == 1
        fun1 = matlabFunction(fun, "Vars", x);
        hold on
        plot(area, fun1(area), 'red');
        plot(double(fixedPoint), fun1(double(fixedPoint)), 'black+');
        for i = 1:length(fixedPoint)
            text(fixedPoint(i),fixedPointFval(i) + 1,sprintf("(%.2f, %.2f)",fixedPoint(i),fixedPointFval(i)));
        end
        legend(sprintf("f(x) = %s", char(fun)), "不动点");
        
    end

end
