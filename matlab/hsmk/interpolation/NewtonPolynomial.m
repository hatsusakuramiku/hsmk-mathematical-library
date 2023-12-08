classdef NewtonPolynomial < Coordinates
    %NewtonPolynomial 牛顿多项式
    %
    % Example
    %   xCoordinate = [0 1 2 3 4];
    %   yCoordinate = [0 1 4 9 16];
    %   newtonPolynomial = NEWTONPOLYNOMIAL(xCoordinate, yCoordinate);
    %   polynomia = newtonPolynomial.getPolynomia();
    %   polynomiaVector = newtonPolynomial.getPolynomiaVector();
    %   remainder = newtonPolynomial.getRemainder();
    %

    properties (Access = private)
        differenceQuotientTable; % 差商表
        polynomia; % 多项式
        remainder; % 余项,形式为拉格朗日余项
        polynomiaVector; % 多项式向量
    end

    methods (Access = public)

        function newtonPolynomial = NewtonPolynomial(xCoordinate, yCoordinate)
            %NEWTONPOLYNOMIAL 构造函数
            %
            %   newtonPolynomial = NEWTONPOLYNOMIAL(xCoordinate, yCoordinate)
            %
            %   Iputs
            %        xCoordinate - x坐标 {mustBeVector, mustBeReal}
            %        yCoordinate - y坐标 {mustBeVector, mustBeReal}

            arguments
                xCoordinate {mustBeVector, mustBeReal}
                yCoordinate {mustBeVector, mustBeReal}
            end

            if numel(unique(xCoordinate)) ~= numel(xCoordinate)
                throw(MException('MATLAB:newtonPolynomial:InvalidInput', '输入x坐标不唯一'));
            end

            if numel(xCoordinate) ~= numel(yCoordinate)
                throw(MException('MATLAB:newtonPolynomial:InvalidInput', '输入坐标不匹配'));
            end

            newtonPolynomial@Coordinates(xCoordinate, yCoordinate);
        end

        function differenceQuotientTable = getDifferenceQuotientTable(newtonPolynomial)
            %GETDIFFERENCEQUOTIENTTABLE 获取差商表
            if isempty(newtonPolynomial.differenceQuotientTable)
                newtonPolynomial = newtonPolynomial.generateDifferenceQuotientTable();
            end

            differenceQuotientTable = newtonPolynomial.differenceQuotientTable;
        end

        function polynomia = getPolynomia(newtonPolynomial, option)
            %GETPOLYNOMIA 获取多项式

            narginchk(1, 2);

            if isempty(newtonPolynomial.polynomia)
                newtonPolynomial = newtonPolynomial.generatePolynomial();
            end

            if nargin == 2 && ismember(option, "double")

                if isempty(newtonPolynomial.polynomiaVector)
                    newtonPolynomial = newtonPolynomial.generatePolynomialVector();
                end

                len = length(newtonPolynomial.polynomiaVector);
                polynomiaTemp = sym(zeros(1, len));
                tPolynomiaVector = newtonPolynomial.polynomiaVector;

                for i = 1:len
                    [varC, varT] = coeffs(tPolynomiaVector(i));
                    polynomiaTemp(i) = sum(double(varC) .* varT);
                end

                polynomia = sum(polynomiaTemp);
                return
            end

            polynomia = newtonPolynomial.polynomia;
        end

        function polynomiaVector = getPolynomiaVector(newtonPolynomial)
            %GETPOLYNOMIAVECTOR 获取多项式向量

            if isempty(newtonPolynomial.polynomiaVector)
                newtonPolynomial = newtonPolynomial.generatePolynomialVector();
            end

            polynomiaVector = newtonPolynomial.polynomiaVector;
        end

        function remainder = getRemainder(newtonPolynomial)
            %GETREMAINDER 获取余项

            if isempty(newtonPolynomial.remainder)
                newtonPolynomial = newtonPolynomial.generateRemainder();
            end

            remainder = newtonPolynomial.remainder;
        end

    end

    methods (Hidden = true)

        function result = differenceQuotientVector(~, xVector, y, x)
            len = length(xVector);
            result = [y, zeros(1, len)];

            for i = 1:len
                result(i + 1) = (xVector(i) - result(i)) / x;
            end

        end

        function newtonPolynomial = generateDifferenceQuotientTable(newtonPolynomial)
            xC = newtonPolynomial.xCoordinate;
            yC = newtonPolynomial.yCoordinate;
            len = length(xC);
            table = zeros(len, len);
            table(1, :) = table(1, :) + [yC(1), zeros(1, len - 1)];

            for i = 2:len
                table(i, :) = [newtonPolynomial.differenceQuotientVector(table(i, 1:i - 1), yC(i), xC(i) - xC(i - 1)), zeros(1, len - i)];
            end

            newtonPolynomial.differenceQuotientTable = table;

        end

        function newtonPolynomial = generatePolynomialVector(newtonPolynomial)
            syms x
            table = newtonPolynomial.getDifferenceQuotientTable();
            xC = newtonPolynomial.xCoordinate;
            len = length(xC);
            y = diag(table);
            y = y';
            tempX = cumprod(x - xC);
            newtonPolynomial.remainder = sym('M') * tempX(end) / factorial(len);
            newtonPolynomial.polynomiaVector = y .* [sym(1), tempX(1:len - 1)];
        end

        function newtonPolynomial = generatePolynomial(newtonPolynomial)
            newtonPolynomial.polynomia = sum(newtonPolynomial.getPolynomiaVector());
        end

        function newtonPolynomial = generateRemainder(newtonPolynomial)
            syms x
            tool = Tool();
            xCoord = newtonPolynomial.xCoordinate;
            len = length(xCoord);
            newtonPolynomial.remainder = sym('M') * tool.vectorFactorial(x - xCoord) / factorial(len);
        end

        function matrixCell = normalization(~, inputCell)

            arguments
                ~
                inputCell {mustBeUnderlyingType(inputCell, 'cell'), mustBeVector}
            end

            len = length(inputCell);

            % 对第一个元素进行处理
            if size(inputCell{1}, 1) == 1
                inputCell{1} = inputCell{1}';
            end

            row_num = size(inputCell{1}, 1);

            % 对后续元素进行处理
            for i = 2:len

                if size(inputCell{i}, 1) == 1
                    inputCell{i} = inputCell{i}';
                end

                if size(inputCell{i}, 1) ~= row_num
                    throw(MException('MATLAB:Tool:InvalidInput', '输入矩阵的维度不一致，请检查并修改条件'));
                end

            end

            matrixCell = inputCell;
        end

    end

end
