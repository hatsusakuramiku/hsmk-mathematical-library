classdef Interpolation
    properties(Access = protected)
        fittingFunction; % 拟合函数
        order; % 拟合阶次
        polynomial; % 拟合多项式
        fittingError; % 拟合误差
    end
    properties (Constant)
        x = sym('x');
    end

    properties(Dependent)
        tempFittingFunction; % 临时拟合函数
    end

    methods
        function tempFittingFunction = get.tempFittingFunction(interpolation)
            if ~isempty(interpolation.fittingFunction)
                tempFittingFunction = subs(interpolation.fittingFunction,symvar(interpolation.fittingFunction),interpolation.x);
            else
                tempFittingFunction = [];
            end
        end

        function interpolation = Interpolation(fittingFunction, order)
            interpolation.fittingFunction = [];
            interpolation.order = [];
            if abs(nargin) == 1
                interpolation.fittingFunction = fittingFunction;
            elseif abs(nargin) == 2
                if isempty(order) || numel(order) ~= 1 || fix(order) ~= order
                    error("输入参数错误！ 请确保输入阶数是非负整数！")
                end
                interpolation.fittingFunction =fittingFunction;
                interpolation.order = order;
            elseif abs(nargin) == 0
            else
                error("输入参数过多！")
            end
        end

    end

    methods

        function fittingFunction = getFittingFunction(interpolation)
            fittingFunction = interpolation.fittingFunction;
        end

        function interpolation = setFittingFunction(interpolation,fittingFunction)
            interpolation.fittingFunction = fittingFunction;
        end

        % function tempFittingFunction = getTempFittingFunction(interpolation)
        %     tempFittingFunction = interpolation.tempFittingFunction;
        % end

        function polynomial = getPolynomial(interpolation)
            polynomial = interpolation.polynomial;
        end

        function order = getOrder(interpolation)
            order = interpolation.order;
        end

        function interpolation = setOrder(interpolation,order)
            if isempty(order) || numel(order) ~= 1 || fix(order) ~= order
                error("输入参数错误！ 请确保输入参数是非负整数！")
            end
            interpolation.order = order;
        end

        function fittingError = getFittingError(interpolation)
            fittingError = interpolation.fittingError;
        end

    end
    methods(Access = protected)
        function sum = factorial(interpolation,n,xCoordinate,option)
            sum = sym(1);
            switch(abs(nargin))
                case 2
                    sum = sum .* factorial(n);
                case 3
                    if isempty(n)
                        for i = 1:length(xCoordinate)
                            sum = sum * (interpolation.x - xCoordinate(i));
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
                        if isempty(n)
                            for i = 1:length(xCoordinate)
                                sum = sum * (interpolation.x - xCoordinate(i));
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
                            sum = sum * (interpolation.x - xCoordinate(i));
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