classdef LeastSquares
    % LEASTSQUARES 最小二乘法类
    %   包含一些使用最小二乘法进行拟合的函数
    %
    %   Author: HSMK
    %   Date: 2022-11-15
    %   Version: 1.0
    %   Required Matlab Version: 2019a or later and Symbolic Math Toolbox

    methods (Access = public)

        function [polynomial, coefficients] = lSline(obj, xCoordinate, yCoordinate, option)
            %LSLINE 使用最小二乘法拟合直线
            %   适用公式(此处使用Latex语法):
            %   1. $y = Ax + B$ option = 0
            %   2. $y = \frac{A}{x} + B$ option = 1
            %   3. $y = \frac{D}{x + C}$ option = 2
            %   4. $y = \frac{1}{Ax + B}$ option = 3
            %   5. $y = A \ln(x) + B$ option = 4
            %   6. $y = Ce^{Ax}$ option = 5
            %   7. $y = Cx^{A}$ option = 6
            %   polynomial = LSLINE(xCoordinate, yCoordinate, option)
            %   Inputs
            %       xCoordinate - x坐标 {mustBeVector, mustBeReal}
            %       yCoordinate - y坐标 {mustBeVector, mustBeReal}
            %       option - 拟合方式 {mustBeMember(option, [0, 1, 2, 3, 4, 5, 6])}
            %   Outputs
            %       polynomial - 拟合直线方程
            %       coefficients - 拟合曲线系数
            arguments (Input)
                obj
                xCoordinate {mustBeVector, mustBeReal}
                yCoordinate {mustBeVector, mustBeReal}
                option {mustBeMember(option, [0, 1, 2, 3, 4, 5, 6])} = 0
            end

            narginchk(2, 4);

            if numel(unique(xCoordinate)) ~= numel(xCoordinate)
                throw(MException('MATLAB:LeastSquares:InvalidInput', '输入X坐标不唯一'));
            end

            tool = Tool();
            outCell = tool.colVector2Row({xCoordinate, yCoordinate});
            xCoordinate = outCell{1};
            yCoordinate = outCell{2};

            try

                switch option
                    case 1
                        obj.inv12Line(xCoordinate, yCoordinate);
                    case 2
                        obj.inv22Line(xCoordinate, yCoordinate);
                    case 3
                        obj.inv32Line(xCoordinate, yCoordinate);
                    case 5
                        obj.ln12Line(xCoordinate, yCoordinate);
                    case 6
                        obj.ln22Line(xCoordinate, yCoordinate);
                end

            catch ME
                throw(ME);
            end

            len = length(xCoordinate);
            eX2 = sum(xCoordinate .^ 2);
            eX = sum(xCoordinate);
            eXY = sum(xCoordinate .* yCoordinate);
            eY = sum(yCoordinate);
            aMatrix = [eX2, eX; eX, len];
            bVector = [eXY; eY];
            result = linsolve(aMatrix, bVector);
            coefficients = result;
            polynomial = obj.getPolynomial(result(1), result(2), option);
        end

        function [polynomial, coefficients] = lSParabola(obj, xCoordinate, yCoordinate)
            % LSPARABOLA 使用最小二乘法拟合抛物线
            %   适用公式(此处使用Latex语法):
            %   $y = A x^2 + B x + C$
            %   polynomial = LSPARABOLA(xCoordinate, yCoordinate)
            %   Inputs
            %       xCoordinate - x坐标 {mustBeVector, mustBeReal}
            %       yCoordinate - y坐标 {mustBeVector, mustBeReal}
            %   Outputs
            %       polynomial - 拟合抛物线方程
            %       coefficients - 拟合曲线系数

            arguments
                obj
                xCoordinate {mustBeVector, mustBeReal}
                yCoordinate {mustBeVector, mustBeReal}
            end

            syms x;
            tool = Tool();
            outCell = tool.colVector2Row({xCoordinate, yCoordinate});
            xCoordinate = outCell{1};
            yCoordinate = outCell{2};
            aMatrix = obj.getAMatrix(xCoordinate, 2);
            bVector = obj.getBVector(xCoordinate, yCoordinate, 2);
            result = linsolve(aMatrix, bVector);
            polynomial = result(3) * x ^ 2 + result(2) * x + result(1);
            coefficients = result;
        end

        function polynomial = lSQuadrature(obj, xCoordinate, yCoordinate, n, weight)
            % LSQUADRATURE 使用最小二乘法拟合多项式
            %   此处使用正交多项式作最小二乘法拟合，递推公式详见 《数值分析》（第五版） 李庆超 王能超 易大义著 —— 清华大学出版社 P76 3.4.2 用正交多项式作拟合
            %   注意：此函数未经校验
            %   适用公式(此处使用Latex语法):
            %   $y = a_{0} + a_{1}x{1} + a_{2}x{2} + a_{3}x{3} + ...$

            arguments
                obj
                xCoordinate {mustBeVector, mustBeReal}
                yCoordinate {mustBeVector, mustBeReal}
                n {mustBeInteger, mustBePositive} = 3
                weight {mustBeVector, mustBeReal} = ones(1, length(xCoordinate))
            end

            tool = Tool();
            outCell = tool.colVector2Row({xCoordinate, yCoordinate, weight});
            xCoordinate = outCell{1};
            yCoordinate = outCell{2};
            weight = outCell{3};
            polynomialVector = obj.quadraturePolynomial(xCoordinate, weight, n);
            aVector = sym(zeros(1, length(polynomialVector)));

            for i = 1:length(polynomialVector)
                t = subs(polynomialVector(i), sym("x"), xCoordinate);
                aVector(i) = obj.innerProduct(yCoordinate, t, weight) / obj.innerProduct(t, t, weight);
            end

            polynomial = sum(polynomialVector .* aVector);
        end

    end

    methods (Hidden = true)

        function polynomial = getPolynomial(~, a, b, n)
            syms x

            switch n
                case 0
                    polynomial = a * x + b;
                case 1
                    polynomial = a * (1 / x) +b;
                case 2
                    polynomial = a * b / (x - 1 / a);
                case 3
                    polynomial = 1 / (a * x + b);
                case 4
                    polynomial = a * str2sym("ln(x)") + b;
                case 5
                    polynomial = exp(b) * exp(a * x);
                case 6
                    polynomial = exp(b) * x ^ a;
            end

        end

        function [xCoordinate, yCoordinate] = inv12Line(~, xCoordinate, yCoordinate)
            % y = A/x + B => y = A*(1/x) +B
            if ~isempty(xCoordinate(xCoordinate == 0))
                error('x不能等于0')
            end

            xCoordinate = 1 ./ xCoordinate;
        end

        function [xCoordinate, yCoordinate] = inv22Line(~, xCoordinate, yCoordinate)
            % y = D/(x+C) => y = (-1/C)*(xy) + D/C
            xCoordinate = xCoordinate .* yCoordinate;
        end

        function [xCoordinate, yCoordinate] = inv32Line(~, xCoordinate, yCoordinate)
            % y = 1(A*x + B) => y = 1/y = A*x + B
            if ~isempty(yCoordinate(yCoordinate == 0))
                error('y不能等于0')
            end

            yCoordinate = 1 ./ yCoordinate;
        end

        function [xCoordinate, yCoordinate] = ln12Line(~, xCoordinate, yCoordinate)
            % y = C*e^(A*x) => ln(y) = Ax + ln(C)
            if ~isempty(yCoordinate(yCoordinate <= 0))
                error('y不能小于0')
            end

            yCoordinate = log(yCoordinate);
        end

        function [xCoordinate, yCoordinate] = ln22Line(~, xCoordinate, yCoordinate)
            % y = C*x^A => ln(y) = A*ln(x) + ln(C)
            if ~isempty(yCoordinate(yCoordinate <= 0)) || ~isempty(xCoordinate(yCoordinate <= 0))
                error('y和x不能小于0')
            end

            xCoordinate = log(xCoordinate);
            yCoordinate = log(yCoordinate);
        end

        function aMatrix = getAMatrix(~, x, n)
            maxOrder = 2 * n;
            len = n + 1;
            N = length(x);
            xMatrix = repmat(x', 1, maxOrder);
            xMatrix = cumprod(xMatrix, 2);
            xVector = [N, sum(xMatrix, 1)];
            aMatrix = zeros(len, len);

            for i = 1:len
                aMatrix(i, :) = xVector(i:1:i + n);
            end

        end

        function bMatrix = getBVector(~, x, y, n)
            bMatrix = zeros(n + 1, 1);

            for i = 1:n + 1
                bMatrix(i) = sum(y .* x .^ (i - 1));
            end

        end

        function polynomial = quadraturePolynomial(obj, xc, w, n)
            syms x

            if n <= 2
                throw(MException('MATLAB:computeDifference:InvalidInput', '输入的范数阶数不合法，请检查并修改条件'));
            end

            p = sym(zeros(1, n));
            p(1) = 1;
            p(2) = (x - obj.getAlpha(p(1), xc, w));

            for i = 3:n
                p(i) = (x - obj.getAlpha(p(i - 1), xc, w)) * p(i - 1) - obj.getBeta(p(i - 1), p(i - 2), xc, w);
            end

            polynomial = p;
        end

        function alpha = getAlpha(obj, pk, xc, w)
            syms x
            pk = subs(pk, x, xc);
            t = obj.innerProduct(xc .* pk, pk, w) / obj.innerProduct(pk, pk, w);
            alpha = sum(t);
        end

        function beta = getBeta(obj, pk, pk1, xc, w)
            syms x
            pk = subs(pk, x, xc);
            pk1 = subs(pk1, x, xc);
            t = obj.innerProduct(pk, pk, w) / obj.innerProduct(pk1, pk1, w);
            beta = sum(t);
        end

        function result = innerProduct(~, x, y, w)
            narginchk(3, 4);
            len = length(x);

            if nargin == 3
                w = ones(1, len);
            end

            result = sum(w .* x .* y);
        end

    end

end
