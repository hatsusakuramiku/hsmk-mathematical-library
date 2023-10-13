classdef TaylorSeries < Interpolation
    properties(Access = private)
        center; % 展开式的中心，要求拟合函数在中心处导数存在
        remainder; % 余项，此类仅支持拉格朗日余项，即$ \frac{f^{(n+1)}(x_{0})(x - x_{0})^{n+1}}{(n + 1)!}  $
        polynomiaVector; % 多项式数组，存储$ \frac{f^{(n)}(x_{0})(x - x_{0})^{n}}{n!}  $ n = 0,1,2,...,order
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
    methods
        function taylorSeries = TaylorSeries(fittingFunction,center,order,accuracy)
            if nargin == 0
                fittingFunction = [];
                center = [];
                order = [];
                accuracy = [];
            elseif nargin == 1
                order = [];
                center = [];
                accuracy = [];
            elseif nargin == 2
                order = [];
                accuracy = [];
            elseif nargin == 3
                accuracy = [];
            elseif nargin == 4
                if isempty(accuracy)
                    warning("未输入参数，将使用默认值'0.0001")
                    accuracy = 0.0001;
                elseif ~isempty(accuracy) && accuracy < 0
                    error("输入参数必须是正数！")
                end
            else
                error("输入参数数目错误！")
            end
            if ~isempty(order) && any(numel(order) ~= 1 | order < 0 | fix(order) ~= order)
                error("请确保展开阶数为大于0的整数！")
            end
            if ~isempty(fittingFunction) && nargin >= 2
                if length(symvar(fittingFunction)) > 1
                    error("请确保输入公式有且仅有一个自变量！")
                elseif isempty(center)
                    warning("未输入展开式的中心值，将使用默认值'0'！");
                    center = 0;
                end
                temp = limit(diff(fittingFunction,symvar(fittingFunction)),symvar(fittingFunction),center);
                if  isinf(temp) || isnan(temp)
                    error("请确保输入公式在中心处可导！")
                end
            end
            taylorSeries@Interpolation(fittingFunction,order,accuracy);
            taylorSeries.center = center;
        end

        function polynomiaVector = getPolynomiaVector(taylorSeries,fittingFunction,center,order,varargin)
            syms a;
            option = {'getmore'};
            if nargin == 1
                taylorSeries.getPolynomiaVector(taylorSeries.fittingFunction,taylorSeries.center,taylorSeries.order);
            elseif nargin >= 4 && nargin <= 5
                taylorSeries.paramJudgement(fittingFunction,center,order);
                len = order + 2;
                outlen = len;
                if isempty(varargin) || (~isempty(varargin) && ~ismember(varargin,option))
                    error("可选参数输入错误！")
                elseif ~isempty(varargin) && ismember(varargin,option)
                    outlen = len;
                end
            else
                error("输入参数数量错误！")
            end
            taylorSeries.paramJudgement(fittingFunction,center,order);
            x = symvar(fittingFunction);
            derivativeFunction = sym(zeros(1,len)); %#ok<PROPLC> % 创建一个细胞数组来存储导数函数
            for n = 0:len - 1
                derivativeFunction(n + 1) = diff(fittingFunction, x, n); %#ok<PROPLC> % 求解第 n 阶导数，并存储在数组中
            end
            polynomiaVector = (x - center) .^ (0:1:len - 1);
            tempDerivativeFunction = subs(derivativeFunction(setdiff(1:len,len)),x,center); %#ok<PROPLC>
            tempDerivativeFunction = [tempDerivativeFunction,subs(derivativeFunction(end),x,a)]; %#ok<PROPLC>
            polynomiaVector = (tempDerivativeFunction ./ factorial(0:1:(len - 1))) .* polynomiaVector;
            polynomiaVector = polynomiaVector(1:outlen);
        end

        function polynomiaVector = getpolynomiavector(taylorSeries,varargin)
            option = {'getmore'};
            if nargin == 1
                polynomiaVector = taylorSeries.getPolynomiaVector();
            elseif nargin == 2
                if isempty(varargin) || (~isempty(varargin) && ~ismember(varargin,option))
                    error("可选参数输入错误！")
                elseif ~isempty(varargin) && ismember(varargin,option)
                    polynomiaVector = taylorSeries.getPolynomiaVector(taylorSeries.fittingFunction,taylorSeries.center,taylorSeries.order,"getmore");
                end
            else
                error("输入参数数量错误！")
            end
        end

        function remainder = getRemainder(taylorSeries,fittingFunction,center,order)
            if nargin == 1
                polynomiaVector = taylorSeries.getpolynomiavector("getmore"); %#ok<PROPLC>
            elseif nargin == 4
                polynomiaVector = taylorSeries.getPolynomiaVector(fittingFunction,center,order,"getmore"); %#ok<PROPLC>
            end
            remainder = polynomiaVector(end); %#ok<PROPLC>
        end

    end

    methods(Hidden)

        function paramJudgement(taylorSeries,fittingFunction,center,order,accuracy)
            switch(nargin)
                case 1
                    warning("未输入参数！")
                case 2
                    if isempty(fittingFunction)
                        error("输入参数为空！")
                    elseif ~isempty(fittingFunction) && length(symvar(fittingFunction)) > 1
                        error("请确保输入公式有且仅有一个自变量！")
                    end
                case 3
                    taylorSeries.paramJudgement(fittingFunction);
                    if isempty(center)
                        error("输入参数为空！")
                    else
                        temp = limit(diff(fittingFunction,symvar(fittingFunction)),symvar(fittingFunction),center);
                        if  isinf(temp) || isnan(temp)
                            error("请确保输入公式在中心处可导！")
                        end
                    end
                case 4
                    taylorSeries.paramJudgement(fittingFunction,center);
                    if isempty(order)
                        error("输入参数为空！")
                    elseif ~isempty(order) && any(numel(order) ~= 1 | order < 0 | fix(order) ~= order)
                        error("请确保展开阶数为大于0的整数！")
                    end
                case 5
                    taylorSeries.paramJudgement(fittingFunction,center,order);
                    if isempty(accuracy)
                        warning("输入参数为空！")
                    elseif ~isempty(accuracy) && accuracy < 0
                        error("输入参数必须是正数！")
                    end
                otherwise
                    error("输入参数数量错误！")
            end
        end
    end
end