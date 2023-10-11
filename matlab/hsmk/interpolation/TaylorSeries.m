classdef TaylorSeries < Interpolation

    properties(Access = private)
        center; % 展开式的中心
        remainder; % 余项
    end

    properties(Dependent,Access = private)
        derivativeFunction; % 导函数
    end

    methods
        function derivativeFunction = get.derivativeFunction(taylorSeries)
            if ~isempty(taylorSeries.fittingFunction) && ~isempty(taylorSeries.order)
                derivativeFunction = sym(zeros(1,taylorSeries.order + 2)); % 创建一个细胞数组来存储导数函数
                for n = 0:taylorSeries.order + 1
                    derivativeFunction(n + 1) = diff(taylorSeries.tempFittingFunction, taylorSeries.x, n); % 求解第 n 阶导数，并存储在数组中
                end
            else
                derivativeFunction = [];
            end
        end
    end

    methods(Access = public)
        function taylorSeries = TaylorSeries(fittingFunction,center,order)
            % 构造函数
            switch(abs(nargin))
                case 0
                    fittingFunction = [];
                    center = [];
                    order = [];
                case 1
                    center = [];
                    order = [];
                case 2
                    order = [];
                case 3
                otherwise
                    error("输入参数数量错误！")
            end

            if ~isempty(fittingFunction) && ~isempty(center)
                if center ~= 0 || subs(1 / diff(fittingFunction,symvar(fittingFunction)),symvar(fittingFunction),center) ~= 0
                    if any(order < 0 | ~isequal(length(symvar(fittingFunction)),1) | ~isfinite(subs(diff(fittingFunction,symvar(fittingFunction)),symvar(fittingFunction),center)))
                        error("请确保展开阶数大于0，且输入公式有且仅有一个自变量，且输入公式在中心处可导！")
                    end
                else
                    error("请确保展开阶数大于0，且输入公式有且仅有一个自变量，且输入公式在中心处可导！")
                end
            elseif  ~isempty(fittingFunction) && isempty(center)
                warning("未输入展开式的中心值，将使用默认值'0'！");
                center = 0;
                if subs(1 / diff(fittingFunction,symvar(fittingFunction)),symvar(fittingFunction),center) ~= 0
                    if any(order < 0 | ~isequal(length(symvar(fittingFunction)),1) | ~isfinite(subs(diff(fittingFunction,symvar(fittingFunction)),symvar(fittingFunction),center)))
                        error("请确保展开阶数大于0，且输入公式有且仅有一个自变量，且输入公式在 x = 0 处可导！")
                    end
                else
                    error("请确保展开阶数大于0，且输入公式有且仅有一个自变量，且输入公式在 x = 0 处可导！")
                end
            end
            taylorSeries@Interpolation(fittingFunction,order)
            taylorSeries.center = center;
        end

        function center = getCenter(taylorSeries)
            center = taylorSeries.center;
        end

        function taylorSeries = setCenter(taylorSeries,center)
            taylorSeries.center = center;
        end

        function derivativeFunction = getDerivativeFunction(taylorSeries)
            derivativeFunction = taylorSeries.derivativeFunction;
        end

        function polynomial = getPolynomial(taylorSeries)
            % 重写基类方法
            if isempty(taylorSeries.polynomial)
                taylorSeries = taylorSeries.generatePolynomial;
            end
            polynomial = taylorSeries.polynomial;
        end

    end

    methods(Access = private)
        function taylorSeries = generatePolynomial(taylorSeries)
            syms x y;
            len = length(taylorSeries.derivativeFunction);
            polynomiaVector = (x - taylorSeries.center) .^ (0:1:len - 1);
            tempDerivativeFunction = subs(taylorSeries.derivativeFunction(setdiff(1:len,len)),x,taylorSeries.center);
            tempDerivativeFunction = [tempDerivativeFunction, subs(taylorSeries.derivativeFunction(end),x,y)];
            polynomiaVector = (tempDerivativeFunction ./ taylorSeries.factorial(0:1:(len - 1))) .* polynomiaVector;
            taylorSeries.polynomial = simplify(sum(polynomiaVector(1:(len - 1))));
            taylorSeries.remainder = polynomiaVector(end);
        end
    end
end

