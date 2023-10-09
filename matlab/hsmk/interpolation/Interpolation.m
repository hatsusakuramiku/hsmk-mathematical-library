classdef Interpolation
    properties(Access = protected)
        fittingFunction; % 拟合函数
        xCoordinate; % x坐标
        yCoordinate; % y坐标
        order; % 拟合阶次
        polynomial; % 拟合多项式
        fittingError; % 拟合误差
        fittingMaxError; % 拟合误差
        tempFittingFunction; % 临时拟合函数
    end

    methods(Access = public)
        function interpolation = Interpolation(fittingFunction,order,xCoordinate,yCoordinate)
            syms x
            switch abs(nargin)
                case 4
                    interpolation.fittingFunction = fittingFunction;
                    if ~isempty(interpolation.fittingFunction)
                        interpolation.tempFittingFunction = subs(fittingFunction,symvar(fittingFunction),x);
                    else
                        interpolation.tempFittingFunction = [];
                    end
                    interpolation.order = order;
                    interpolation.xCoordinate = xCoordinate;
                    interpolation.yCoordinate = yCoordinate;
                case 3
                    interpolation.fittingFunction = fittingFunction;
                    if ~isempty(interpolation.fittingFunction)
                        interpolation.tempFittingFunction = subs(fittingFunction,symvar(fittingFunction),x);
                    else
                        interpolation.tempFittingFunction = [];
                    end
                    interpolation.order = order;
                    interpolation.xCoordinate = xCoordinate;
                    interpolation.yCoordinate = [];
                case 2
                    interpolation.fittingFunction = fittingFunction;
                    if ~isempty(interpolation.fittingFunction)
                        interpolation.tempFittingFunction = subs(fittingFunction,symvar(fittingFunction),x);
                    else
                        interpolation.tempFittingFunction = [];
                    end
                    interpolation.order = order;
                    interpolation.xCoordinate = [];
                    interpolation.yCoordinate = [];
                case 1
                    interpolation.fittingFunction = fittingFunction;
                    if ~isempty(interpolation.fittingFunction)
                        interpolation.tempFittingFunction = subs(fittingFunction,symvar(fittingFunction),x);
                    else
                        interpolation.tempFittingFunction = [];
                    end
                    interpolation.order = [];
                    interpolation.xCoordinate = [];
                    interpolation.yCoordinate = [];
                case 0
                    interpolation.fittingFunction = [];
                    interpolation.tempFittingFunction = [];
                    interpolation.order = [];
                    interpolation.xCoordinate = [];
                    interpolation.yCoordinate = [];
                otherwise
                    error("输入的参数数目不正确！");
            end
        end

        function fittingFunction = getFittingFunction(interpolation)
            fittingFunction = interpolation.fittingFunction;
        end

        function interpolation = setFittingFunction(interpolation,fittingFunction)
            interpolation.fittingFunction = fittingFunction;
        end

        function polynomial = getPolynomial(interpolation)
            polynomial = interpolation.polynomial;
        end

        function xCoordinate = getXCoordinate(interpolation)
            xCoordinate = interpolation.xCoordinate;
        end

        function yCoordinate = getYCoordinate(interpolation)
            yCoordinate = interpolation.yCoordinate;
        end

        function order = getOrder(interpolation)
            order = interpolation.order;
        end

        function interpolation = setOrder(interpolation,order)
            if isempty(order) || unique(order) ~= 1 || fix(order) ~= order
                error("输入参数错误！ 请确保输入参数是非负整数！")
            end
            interpolation.order = order;
        end

        function fittingMaxError = getFittingMaxError(interpolation)
            if isempty(interpolation.fittingMaxError)
                interpolation = interpolation.generateMaxError;
            end
            fittingMaxError = interpolation.fittingMaxError;
        end

        function fittingError = getFittingError(interpolation)
            fittingError = interpolation.fittingError;
        end

    end
    methods(Access = protected)
        function interpolation = generateMaxError(interpolation)
            syms x;
            derivativeFunction = diff(interpolation.tempFittingFunction,x,interpolation.order + 1);
            if isempty(symvar(derivativeFunction)) && int(derivativeFunction) == 0
                interpolation.fittingMaxError = 0;
                return
            elseif isempty(symvar(derivativeFunction))
                interpolation.fittingMaxError = double(derivativeFunction);
                return
            end
            supDerivativeFunction = matlabFunction(derivativeFunction .* (-1));
            infDerivativeFunction = matlabFunction(derivativeFunction);
            inf = fminbnd(infDerivativeFunction,min(interpolation.xCoordinate),max(interpolation.xCoordinate));
            sup = fminbnd(supDerivativeFunction,min(interpolation.xCoordinate),max(interpolation.xCoordinate));
            interpolation.fittingMaxError = max(abs(inf),abs(sup));
        end

        function sum = factorial(~,n,xCoordinate,option)
            sum = sym(1);
            switch(abs(nargin))
                case 2
                    sum = sum .* factorial(n);
                case 3
                    if isempty(n)
                        syms x;
                        for i = 1:length(xCoordinate)
                            sum = sum * (x - xCoordinate(i));
                        end
                        sum = simplify(sum);
                        return

                    elseif  numel(n) ~= 1 || n <= 0 || fix(n) ~= n
                        error("输入参数错误！ 请确保输入参数的非负整数！")
                    elseif n > length(xCoordinate)
                        error("超出数组索引！")
                    end
                    if length(unique(xCoordinate)) ~= length(xCoordinate)
                        warning("数组中存在两个或多个相同元素，可能导致返回值为0！")
                    end
                    for i = 1:length(xCoordinate)
                        if i == n
                            continue
                        end
                        sum = sum * (xCoordinate(n) - xCoordinate(i));
                    end
                case 4
                    if isequal(option,'exceptN')
                        syms x;
                        if isempty(n)
                            for i = 1:length(xCoordinate)
                                sum = sum * (x - xCoordinate(i));
                            end
                            sum = simplify(sum);
                            return

                        elseif  numel(n) ~= 1 || n <= 0 || fix(n) ~= n
                            error("输入参数错误！ 请确保输入参数的非负整数！")
                        elseif n > length(xCoordinate)
                            error("超出数组索引！")
                        elseif length(unique(xCoordinate)) ~= length(xCoordinate)
                            warning("数组中存在两个或多个相同元素，可能导致返回值为0！")
                        end
                        for i = 1:length(xCoordinate)
                            if i == n
                                continue
                            end
                            sum = sum * (x - xCoordinate(i));
                        end
                    else
                        error("可选参数输入错误! ")
                    end
                otherwise
                    error("输入的参数数目不正确！");
            end
        end
    end
end