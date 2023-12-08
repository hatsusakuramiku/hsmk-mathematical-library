function [newtonRaphsonFun, newtonRaphsonPoint, iteratePoint] = newtonRaphson(fun, maxIter, x0, accuracy)

    arguments
        fun {mustBeUnderlyingType(fun, 'sym')} % 输入的函数
        maxIter (1, 1) {mustBeInteger, mustBeGreaterThanOrEqual(maxIter, 1)} = 1000 % 最大迭代次数
        x0 {mustBeReal} = 0 % 初始点
        accuracy {mustBeReal} = 1e-6 % 精度
    end

    syms x

    if numel(symvar(fun)) ~= 1
        throw(MException('MATLAB:newtonRaphson:InvalidInput', sprintf("输入的公式 %s 不是单变量函数", char(fun))))
    end

    if symvar(fun) ~= x
        subs(fun, symvar(fun), x);
    end

    try
        newtonRaphsonFun = x - fun / diff(fun);
        iteratePoint = sym([x0, zeros(1, maxIter)]);

        for i = 2:maxIter + 1

            if abs(subs(fun, x, iteratePoint(i - 1))) < accuracy
                break;
            end

            iteratePoint(i) = subs(newtonRaphsonFun, x, iteratePoint(i - 1));
        end

        newtonRaphsonPoint = iteratePoint(end);

    catch ME
        throw(ME)
    end

end
