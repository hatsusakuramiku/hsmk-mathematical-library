% -*- coding: utf-8 -*-
classdef TaylorSeries < Interpolation
    %TAYLORSERIES 此处显示有关此类的摘要
    %   此处显示详细说明

    properties%(Access = private)
        center;
        derivativeFunction;
    end

    methods
        function taylorSeries = TaylorSeries(f,n,x_0)
            if any(n < 0 | ~isequal(length(symvar(f)),1) | ~isfinite(subs(diff(f,symvar(f)),symvar(f),x_0)))
                error("请确保展开阶数大于0且输入公式有且仅有一个自变量且输入公式在x_0处可导！")
            else
                if ~isinteger(n)
                    warning("输入阶数不是整数，将采用向下取整方式转化为整数！")
                    disp("请按任意键继续！")
                    pause;
                end
            end
            taylorSeries@Interpolation(f,n)
            taylorSeries.center = x_0;
        end

        function N = getN(taylorSeries)
            N = taylorSeries.order;
        end

        function fun = getfun(taylorSeries)
            fun = taylorSeries.fittingFunction;
        end

        function center = getcenter(taylorSeries)
            center = taylorSeries.center;
        end

        function polynomial = getpolynomial(taylorSeries)
            polynomial = taylorSeries.polynomial;
        end
    end
    methods
        function taylorSeries = getDerivativeFunction(taylorSeries)
            syms x;
            taylorSeries.derivativeFunction = cell(1, taylorSeries.order+1); % 创建一个细胞数组来存储导数函数
            for n = 0:taylorSeries.order
                taylorSeries.derivativeFunction{n+1} = diff(taylorSeries.fun, x, n); % 求解第 n 阶导数，并存储在数组中
            end
        end

    end
end

