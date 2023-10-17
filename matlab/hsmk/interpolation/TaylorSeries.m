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
            %GET.DERIVATIVEFUNCTION 修改derivativeFunction的值.当使用命令taylorSeries.derivativeFunction时，
            %    根据taylorSeries.order与taylorSeries.fittingFunction的值修改derivativeFunction的值并返回。
            %    当taylorSeries.order与taylorSeries.fittingFunction的值至少一个为空时，修改derivativeFunction
            %    的值为空；当taylorSeries.order与taylorSeries.fittingFunction的值均为空时，derivativeFunction
            %    的值为taylorSeries.fittingFunction的 0 到taylorSeries.order + 1 阶导函数数组，其自变量为'x'。
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
        %TAYLORSERIEX TaylorSeries类的构造函数.
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
                elseif accuracy < 0
                    error("输入参数必须是非负数！")
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

        function [polynomiaVector,taylorSeriesOut] = getPolynomiaVector(taylorSeries,fittingFunction,center,order,varargin)
            % 获取多项式向量
            syms a;
            option = {"getmore"};
            if nargout == 1 || nargout == 0
                if nargin == 1
                    if ~isempty(taylorSeries.polynomiaVector)
                        polynomiaVector = taylorSeries.polynomiaVector;
                    else
                        polynomiaVector = taylorSeries.getPolynomiaVector(taylorSeries.tempFittingFunction,taylorSeries.center,taylorSeries.order);
                    end
                elseif nargin == 4 || nargin == 5
                    taylorSeries.paramJudgement(fittingFunction,center,order);
                    len = order + 2;
                    outlen = len - 1;
                    if nargin == 5
                        if isempty(varargin) || isempty(varargin{1})
                            error("可选参数不能为空！")
                        else
                            varargin = string(varargin);
                        end
                        if length(varargin) == 1 && isequal(varargin{1},option{1})
                            outlen = outlen + 1;
                        else
                            error("可选参数输入错误！")
                        end
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
                else
                    error("输入参数数量错误！")
                end
            elseif nargout == 2
                if nargin == 1
                    if ~isempty(taylorSeries.polynomiaVector)
                        polynomiaVector = taylorSeries.polynomiaVector;
                        taylorSeriesOut = taylorSeries;
                        return
                    else
                        polynomiaVector = taylorSeries.getPolynomiaVector(taylorSeries.tempFittingFunction,taylorSeries.center,taylorSeries.order);
                        taylorSeries.polynomiaVector = polynomiaVector;
                        taylorSeriesOut = taylorSeries;
                        return
                    end
                elseif nargin == 4 || nargin == 5
                    if nargin == 5
                        polynomiaVector = taylorSeries.getPolynomiaVector(fittingFunction,center,order,varargin);
                    else
                        polynomiaVector = taylorSeries.getPolynomiaVector(fittingFunction,center,order);
                    end
                    taylorSeriesOut = TaylorSeries(fittingFunction,center,order);
                    taylorSeriesOut.polynomiaVector = polynomiaVector;
                else
                    error("输入参数数量错误！")
                end
            else
                error("输出参数数目或格式不对！")
            end
        end

        function [polynomial,taylorSeries] = getPolynomia(taylorSeries,fittingFunction,center,order)
            if nargout == 1 || nargout == 0
                if nargin == 1
                    if isempty(taylorSeries.polynomial)
                        polynomiaVector = taylorSeries.getPolynomiaVector(); %#ok<PROPLC>
                        polynomial = simplify(sum(polynomiaVector)); %#ok<PROPLC>
                        return
                    else
                        polynomial = taylorSeries.polynomial;
                        return
                    end
                elseif nargin == 4
                    polynomiaVector = taylorSeries.getPolynomiaVector(fittingFunction,center,order); %#ok<PROPLC>
                    polynomial = simplify(sum(polynomiaVector)); %#ok<PROPLC>
                else
                    error("输入参数错误！")
                end
            elseif nargout == 2
                if nargin == 1
                    if isempty(taylorSeries.polynomial)
                        [polynomiaVector,taylorSeries] = taylorSeries.getPolynomiaVector(); %#ok<PROPLC>
                        polynomial = simplify(sum(polynomiaVector)); %#ok<PROPLC>
                        taylorSeries.polynomial = polynomial;
                        return
                    else
                        polynomial = taylorSeries.polynomial;
                        return
                    end
                elseif nargin == 4
                    taylorSeries = TaylorSeries(fittingFunction,center,order);
                    [polynomiaVector,taylorSeries] = taylorSeries.getPolynomiaVector(); %#ok<PROPLC>
                    polynomial = simplify(sum(polynomiaVector)); %#ok<PROPLC>
                    taylorSeries.polynomial = polynomial;
                else
                    error("输入参数错误！")
                end
            else
                error("输出参数数目或格式不对！")
            end
        end

        function [fittingError,taylorSeries] = getFittingError(taylorSeries,varargin)
            len = length(varargin);
            if nargout == 1 || nargout == 0
                if nargin == 1
                    if isempty(taylorSeries.fittingError)
                        polynomial = taylorSeries.getPolynomia();
                        fittingError = subs(taylorSeries.tempFittingFunction - polynomial,taylorSeries.x,taylorSeries.center);
                    else
                        fittingError = taylorSeries.fittingError;
                    end
                elseif nargin == 4 || nargin == 5
                    if len == 1
                        if isnumeric(varargin{1}) && isscalar(varargin{1})
                            point = varargin{1};
                        else
                            error("输入参数错误！")
                        end
                        if isempty(taylorSeries.fittingError)
                            polynomial = taylorSeries.getPolynomia();
                            fittingError = subs(taylorSeries.tempFittingFunction - polynomial,taylorSeries.x,point);
                        else
                            fittingError = taylorSeries.fittingError;
                        end
                    elseif len == 3
                        fittingFunction = varargin{1};
                        center = varargin{2};%#ok<PROPLC>
                        order = varargin{3};
                        taylorSeries.paramJudgement(fittingFunction,center,order);%#ok<PROPLC>
                        polynomial = taylorSeries.getPolynomia(fittingFunction,center,order);%#ok<PROPLC>
                        x = symvar(fittingFunction);
                        fittingError = subs(fittingFunction - polynomial,x,center);%#ok<PROPLC>
                    elseif len == 4
                        fittingFunction = varargin{1};
                        center = varargin{2};%#ok<PROPLC>
                        order = varargin{3};
                        if isnumeric(varargin{4}) && isscalar(varargin{4})
                            point = varargin{4};
                        else
                            error("输入参数错误！")
                        end
                        taylorSeries.paramJudgement(fittingFunction,center,order);%#ok<PROPLC>
                        polynomial = taylorSeries.getPolynomia(fittingFunction,center,order); %#ok<PROPLC>
                        x = symvar(fittingFunction);
                        fittingError = subs(fittingFunction - polynomial,x,point);
                    else
                        error("输入参数数量错误！")
                    end
                else
                    error("输入参数数量错误！")
                end
            elseif nargout == 2
                if nargin == 1
                    if isempty(taylorSeries.fittingError)
                        [polynomial,taylorSeries] = taylorSeries.getPolynomia();
                        fittingError = subs(taylorSeries.tempFittingFunction - polynomial,taylorSeries.x,taylorSeries.center);
                        taylorSeries.fittingError = fittingError;
                    else
                        fittingError = taylorSeries.fittingError;
                    end
                elseif nargin == 4 || nargin == 5
                    if len == 1
                        if isnumeric(varargin{1}) && isscalar(varargin{1})
                            point = varargin{1};
                        else
                            error("输入参数错误！")
                        end
                        if isempty(taylorSeries.polynomial)
                            [polynomial,taylorSeries] = taylorSeries.getPolynomia();
                            fittingError = subs(taylorSeries.tempFittingFunction - polynomial,taylorSeries.x,point);
                        end
                    elseif len == 3
                        fittingFunction = varargin{1};
                        center = varargin{2};%#ok<PROPLC>
                        order = varargin{3};
                        taylorSeries.paramJudgement(fittingFunction,center,order);%#ok<PROPLC>
                        [polynomial,taylorSeries] = taylorSeries.getPolynomia(fittingFunction,center,order);%#ok<PROPLC>
                        x = symvar(fittingFunction);
                        fittingError = subs(fittingFunction - polynomial,x,center);%#ok<PROPLC>
                        taylorSeries.fittingError = fittingError;
                    elseif len == 4
                        fittingFunction = varargin{1};
                        center = varargin{2};%#ok<PROPLC>
                        order = varargin{3};
                        if isnumeric(varargin{4}) && isscalar(varargin{4})
                            point = varargin{4};
                        else
                            error("输入参数错误！")
                        end
                        taylorSeries.paramJudgement(fittingFunction,center,order);%#ok<PROPLC>
                        [polynomial,taylorSeries] = taylorSeries.getPolynomia(fittingFunction,center,order); %#ok<PROPLC>
                        x = symvar(fittingFunction);
                        fittingError = subs(fittingFunction - polynomial,x,point);
                    else
                        error("输入参数数量错误！")
                    end
                else
                    error("输入参数数量错误！")
                end
            else
                error("输出参数数目或格式不对！")
            end
        end

        function [polynomiaVector,taylorSeries] = getpolynomiavector(taylorSeries,varargin)
            if nargout == 1 || nargout == 0
                if nargin == 1
                    if isempty(taylorSeries.polynomiaVector)
                        polynomiaVector = taylorSeries.getpolynomiaVector();
                    else
                        polynomiaVector = taylorSeries.polynomiaVector;
                    end
                elseif nargin == 2
                    polynomiaVector = taylorSeries.getPolynomiaVector(taylorSeries.tempFittingFunction, taylorSeries.center, taylorSeries.order, varargin);
                else
                    error("输入参数错误！");
                end
            elseif nargout == 2
                if nargin == 1
                    if isempty(taylorSeries.polynomiaVector)
                        [polynomiaVector,taylorSeries] = taylorSeries.getpolynomiaVector();
                    else
                        polynomiaVector = taylorSeries.polynomiaVector;
                    end
                elseif nargin == 2
                    [polynomiaVector,taylorSeries] = taylorSeries.getPolynomiaVector(taylorSeries.tempFittingFunction, taylorSeries.center, taylorSeries.order, varargin);
                else
                    error("输入参数错误！");
                end
            else
                error("输出参数数目或格式不对！")
            end
        end

        function [remainder,taylorSeries] = getRemainder(taylorSeries,fittingFunction,center,order)
            if nargout == 1 || nargout == 0
                if nargin == 1
                    if isempty(taylorSeries.remainder)
                        [polynomiaVector,taylorSeries] = taylorSeries.getpolynomiavector("getmore"); %#ok<PROPLC>
                        remainder = polynomiaVector(end); %#ok<PROPLC>
                    else
                        remainder = taylorSeries.remainder;
                    end
                elseif nargin == 4
                    polynomiaVector = taylorSeries.getPolynomiaVector(fittingFunction,center,order,"getmore"); %#ok<PROPLC>
                    remainder = polynomiaVector(end); %#ok<PROPLC>
                end
            elseif nargout == 2
                if nargin == 1 && nargout == 2
                    if isempty(taylorSeries.remainder)
                        [polynomiaVector,taylorSeries] = taylorSeries.getpolynomiavector("getmore"); %#ok<PROPLC>
                        remainder = polynomiaVector(end); %#ok<PROPLC>
                        taylorSeries.remainder = remainder;
                        return
                    else
                        remainder = taylorSeries.remainder;
                        return
                    end
                elseif nargin == 4
                    [polynomiaVector,taylorSeries] = taylorSeries.getPolynomiaVector(fittingFunction,center,order,"getmore"); %#ok<PROPLC>
                    remainder = polynomiaVector(end); %#ok<PROPLC>
                    taylorSeries.remainder = remainder;
                end
            else
                error("输出参数数目或格式不对！")
            end
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
                        error("输入参数必须是非负数！")
                    end
                otherwise
                    error("输入参数数量错误！")
            end
        end
    end
end