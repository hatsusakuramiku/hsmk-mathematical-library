classdef TaylorSeries < Interpolation

    properties(Access = private)
        fittingFunction; % 拟合函数
        center; % 中心点
        remainder; % 余项，此类仅支持拉格朗日余项，即$ \frac{f^{(n+1)}(x_{0})(x - x_{0})^{n+1}}{(n + 1)!}  $
        polynomiaVector; % 多项式数组，存储$ \frac{f^{(n)}(x_{0})(x - x_{0})^{n}}{n!}  $ n = 0,1,2,...,order
        polynomia; % 多项式，存储$ \frac{f^{(n)}(x_{0})(x - x_{0})^{n}}{n!}  $ n = 0,1,2,...,order
    end

    properties (Dependent)
        tempFittingFunction; % 修改输入的公式的符号以方便计算
    end

    methods

        function tempFittingFunction = get.tempFittingFunction(interpolation)
            % 修改输入的公式的符号以方便计算
            % @Attribute #tempFittingFunction 的值依赖于 @Attribute #fittingFunction
            % 类中调用 @Attribute #tempFittingFunction 时检查 @Attribute #fittingFunction 的值，如果 @Attribute #fittingFunction 为空则 @Attribute #tempFittingFunction 为空
            % 如果 @Attribute #fittingFunction 不为空则 使用"sym('x')"替换 @Attribute #fittingFunction 中的符号并赋值给 @Attribute #tempFittingFunction
            % 如果 @Attribute #fittingFunction 中的符号变量不是 'x' 则使用 "sym('x')" 替换；如果 @Attribute #fittingFunction 中的符号变量个数大于 2 且不是是 'x' 替换第一个符号为
            % "sym('x')"；只要有一个符号为 'x' 则不替换
            len = length(interpolation.fittingFunction);
            tempFittingFunction = sym(zeros(1, len));

            for i = 1:len
                symbol = symvar(interpolation.fittingFunction(i));

                if numel(symbol) > 0 && ~ismember('x', symbol)
                    tempFittingFunction(i) = subs(interpolation.fittingFunction(i), symbol(1), sym('x'));
                else
                    tempFittingFunction(i) = interpolation.fittingFunction(i);
                end

            end

        end

    end

    methods

        function taylorSeries = TaylorSeries(fittingFunction, center, order, accuracy)
            % TAYLORSERIES 构造函数
            %   taylorSeries = TAYLORSERIES(fittingFunction, center, order, accuracy) 创建 TaylorSeries 对象。
            %   fittingFunction 是要拟合的函数，center 是拟合多项式的中心点、、order 是拟合多项式的阶数、、accuracy 是计算精度。
            %   如果没有提供 accuracy 参数，则使用默认值 0.001。
            arguments
                fittingFunction (1, :) {mustBeUnderlyingType(fittingFunction, 'sym')} = 0
                center (1, :) double {mustBeReal} = 0
                order (1, :) {mustBeInteger} = 1
                accuracy (1, :) {mustBeReal} = 0.001
            end

            tool = Tool();
            l = tool.lenConvert({fittingFunction, center, order, accuracy});
            taylorSeries@Interpolation(l{3}, l{4});
            taylorSeries.fittingFunction = l{1};
            taylorSeries.center = l{2};
            tool.derivativeCheck(taylorSeries.tempFittingFunction, taylorSeries.center, taylorSeries.order);
            tool.valueCheck(taylorSeries.tempFittingFunction, taylorSeries.center);

        end

        function tayCell = getTayVector(taylorSeries)
            % GETTAYVECTOR 获取多项式数组
            tayCell = taylorSeries.taylorVectorization();
        end

        function fittingFunction = getFittingFunction(taylorSeries)
            % GETFITTINGFUNCTION 获取拟合函数
            fittingFunction = taylorSeries.fittingFunction;
        end

        function order = getOrder(taylorSeries)
            % GETORDER 获取拟合函数的阶数
            order = taylorSeries.order;
        end

        function center = getCenter(taylorSeries)
            % GETCENTER 获取拟合函数的中心点
            center = taylorSeries.center;
        end

        function accuracy = getAccuracy(taylorSeries)
            % GETACCURACY 获取计算精度
            accuracy = taylorSeries.accuracy;
        end

        function polynomia = getPolynomia(taylorSeries)
            % GETPOLYNOMIA 获取多项式
            taylorSeries = taylorSeries.generatePolynomial();
            polynomia = taylorSeries.polynomia;
        end

        function taylorSeries = generatePolynomial(taylorSeries)
            % generatePOLYNOMIAL 生成多项式
            %   taylorSeries = generatePOLYNOMIAL(taylorSeries) 生成多项式
            taylorSeries = taylorSeries.generatePolynomialVector();
            len = length(taylorSeries.polynomiaVector);
            poynomia = sym(zeros(1, len));

            for i = 1:len
                poynomia(i) = sum(taylorSeries.polynomiaVector{i});
            end

            taylorSeries.polynomia = poynomia;
        end

        function remainder = getRemainder(taylorSeries)
            % GETREMAINDER 获取余项
            remainder = taylorSeries.remainder;
        end

        function taylorSeries = generateRemainder(taylorSeries)
            % generateREMAINDER 生成余项
            %   taylorSeries = generateREMAINDER(taylorSeries) 生成余项
            taylorSeries = taylorSeries.generatePolynomialVector();
        end

    end

    methods (Hidden = true)

        function tay = taylorVectorization(taylorSeries)
            % TAYLORVECTORIZATION 将 TaylorSeries 对象转化为多项式数组
            %   tay = TAYLORVECTORIZATION(taylorSeries) 将 TaylorSeries 对象转化为多项式数组
            len = length(taylorSeries.fittingFunction);
            tay = cell(1, len);

            for i = 1:len
                tay{i} = TaylorSeries(taylorSeries.fittingFunction(i), taylorSeries.center(i), taylorSeries.order(i), taylorSeries.accuracy(i));
            end

        end

        function taylorSeries = generatePolynomialVector(taylorSeries)
            % generatePOLYNOMIALVECTOR 生成多项式数组
            %   taylorSeries = generatePOLYNOMIALVECTOR(taylorSeries) 生成多项式数组
            syms x
            [taylorSeries, derCell] = taylorSeries.generateDerivative();
            taylorSeries.polynomiaVector = cell(ones(1, length(derCell)));

            for i = 1:length(derCell)
                len = length(derCell{i});
                temp = derCell{i};
                vector = ones(1, len) .* taylorSeries.center(i);
                xVector = taylorSeries.tool.xVectorProd(vector);
                taylorSeries.polynomiaVector{i} = [xVector .* temp ./ sym(cumprod(1:1:len)), subs(taylorSeries.tempFittingFunction(i), x, taylorSeries.center(i))];
            end

        end

        function [taylorSeries, derCell] = generateDerivative(taylorSeries)
            % GENERATEDERIVATIVE 生成导数
            %   [taylorSeries, derCell] = GENERATEDERIVATIVE(taylorSeries) 生成导数
            syms x
            TFFuntion = taylorSeries.tempFittingFunction;
            len = length(taylorSeries.fittingFunction);
            derCell = cell(1, len);
            remainer = sym(zeros(1, len));

            for i = 1:len
                derCell{i} = taylorSeries.tool.derivativeVector(TFFuntion(i), taylorSeries.order(i));
                remainer(i) = subs(derCell{i}(end), x, str2sym('A')) / factorial(taylorSeries.order(i) + 1) * (x - taylorSeries.center(i)) ^ (taylorSeries.order(i) + 1);
                derCell{i} = derCell{i}(1:end - 1);
            end

            taylorSeries.remainder = remainer;
        end

    end

end
