classdef TaylorSeries < Interpolation

    properties(Access = private)
        center;
        derivativeFunction;
    end

    methods
        function taylorSeries = TaylorSeries(fittingFunction,center,order)
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
                if any(order < 0 | ~isequal(length(symvar(fittingFunction)),1) | ~isfinite(subs(diff(fittingFunction,symvar(fittingFunction)),symvar(fittingFunction),center)))
                    error("请确保展开阶数大于0且输入公式有且仅有一个自变量且输入公式在x_0处可导！")
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

        function derivativeFunction = getderivativeFunction(taylorSeries)
            derivativeFunction = taylorSeries;
        end

    end

    methods(Access = private)
        function taylorSeries = generateDerivativeFunction(taylorSeries)
            syms x;
            taylorSeries.derivativeFunction = sym(zeros(1,taylorSeries.order + 2)); % 创建一个细胞数组来存储导数函数
            for n = 0:taylorSeries.order + 1
                taylorSeries.derivativeFunction(n + 1) = diff(taylorSeries.tempFittingFunction, x, n); % 求解第 n 阶导数，并存储在数组中
            end
        end

        function taylorSeries = generatePolynomial(taylorSeries)
            taylorSeries = taylorSeries.generateDerivativeFunction;
            taylorSeries.polynomial = sum(taylorSeries.derivativeFunction ./ taylorSeries.factorial(0:1:(length(taylorSeries.derivativeFunction) - 1)));
        end
    end
end

