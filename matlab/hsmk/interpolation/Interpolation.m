classdef Interpolation
    properties(Access = protected)
        fittingFunction; % 拟合函数
        xCoordinate; % x坐标
        yCoordinate; % y坐标
        order; % 拟合阶次
        polynomial; % 拟合多项式
        tempFittingFunction; % 临时拟合函数
    end

    methods(Access = public)
        function interpolation = Interpolation(fittingFunction,order,xCoordinate,yCoordinate)
            syms x
            switch abs(nargin)
                case 4
                    interpolation.fittingFunction = fittingFunction;
                    interpolation.order = order;
                    interpolation.xCoordinate = xCoordinate;
                    interpolation.yCoordinate = yCoordinate;
                    interpolation.tempFittingFunction = subs(fittingFunction,symvar(fittingFunction),x);
                case 3
                    interpolation.fittingFunction = fittingFunction;
                    interpolation.order = order;
                    interpolation.xCoordinate = xCoordinate;
                    interpolation.tempFittingFunction = subs(fittingFunction,symvar(fittingFunction),x);
                case 2
                    interpolation.fittingFunction = fittingFunction;
                    interpolation.order = order;
                    interpolation.tempFittingFunction = subs(fittingFunction,symvar(fittingFunction),x);
                otherwise
                    error("输入的参数数目不正确！"); 
            end

        end
        function maxError = getMaxError(interpolation)
            syms x;
            derivativeFunction = diff(interpolation.tempFittingFunction,x,interpolation.order);
            if isempty(symvar(derivativeFunction)) && int(derivativeFunction) == 0
                maxError = 0;
                return
            else
                if isempty(symvar(derivativeFunction))
                    maxError = double(derivativeFunction);
                    return
                end
            end
            underivativeFunction = derivativeFunction .* (-1);
            underivativeFunction = matlabFunction(underivativeFunction);
            derivativeFunction = matlabFunction(derivativeFunction);
            inf = fminbnd(derivativeFunction,min(interpolation.xCoordinate),max(interpolation.xCoordinate));
            sup = fminbnd(underivativeFunction,min(interpolation.xCoordinate),max(interpolation.xCoordinate));
            maxError = max(abs(inf),abs(sup));
        end
    end

    methods(Access = protected)
        function sum = factorial(interpolation,vager)
            sum = 1;
            switch(abs(nargin))
                case 1
                    syms x;
                    for i = 1:length(interpolation.xCoordinate)
                        sum = sum * (x - interpolation.xCoordinate(i)) / i;
                    end
                    sum = simplify(sum);
                case 2
                    if ~isinteger(vager)
                        warning("输入阶乘数不是整数，将采用向下取整方式转化为整数！")
                        disp("请按任意键继续！")
                        pause;
                    end
                    n = floor(vager);
                    if n == 0
                        return
                    end
                    for i = 1:n
                        sum = sum * i;
                    end
                otherwise
                    error("输入的参数数目不正确！");
            end
        end
    end
end