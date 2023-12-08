classdef LagrangeInterpolation < Coordinates

    properties
        polynomiaVector;
        polynomia;
        remainder;
    end

    methods

        function lagrangeFunSeris = LagrangeInterpolation(xCoordinate, yCoordinate)

            arguments
                xCoordinate {mustBeVector, mustBeReal}
                yCoordinate {mustBeVector, mustBeReal}
            end

            lagrangeFunSeris@Coordinates(xCoordinate, yCoordinate);

        end

        function polynomia = getPolynomia(lagrangeFunSeris, option)
            narginchk(1, 2);

            if isempty(lagrangeFunSeris.polynomia)
                lagrangeFunSeris = lagrangeFunSeris.generatePolynomial();
            end

            if nargin == 2 && ismember(option, "double")
                len = length(lagrangeFunSeris.yCoordinate);
                polynomiaTemp = sym(zeros(1, len));
                tPolynomiaVector = lagrangeFunSeris.polynomiaVector;
                y = lagrangeFunSeris.yCoordinate;

                for i = 1:len
                    [varC, varT] = coeffs(tPolynomiaVector(i));
                    polynomiaTemp(i) = sum(double(varC) .* varT) * y(i);
                end

                polynomia = sum(polynomiaTemp);
                return
            end

            polynomia = lagrangeFunSeris.polynomia;
        end

        function polynomiaVector = getpolynomiaVector(lagrangeFunSeris)

            if isempty(lagrangeFunSeris.polynomiaVector)
                lagrangeFunSeris = lagrangeFunSeris.generatePolynomialVector();
            end

            polynomiaVector = lagrangeFunSeris.polynomiaVector;
        end

        function remainder = getRemainder(lagrangeFunSeris)

            if isempty(lagrangeFunSeris.remainder)
                lagrangeFunSeris = lagrangeFunSeris.generateRemainder();
            end

            remainder = lagrangeFunSeris.remainder;

        end

    end

    methods (Hidden = true)

        function obj = generatePolynomial(obj)

            if isempty(obj.polynomiaVector)
                obj = obj.generatePolynomialVector();
            end

            obj.polynomia = sum(obj.polynomiaVector .* obj.yCoordinate);
        end

        function obj = generatePolynomialVector(obj)
            obj.polynomiaVector = obj.lFunVector(obj.xCoordinate);
        end

        function funVector = lFunVector(~, xVector)
            syms x
            tool = Tool();
            len = length(xVector);
            funVector = sym(zeros(1, len));

            for i = 2:len -1
                t1 = tool.vectorFactorial(x - xVector([1:i - 1, i + 1:len]));
                t2 = tool.vectorFactorial(xVector(i) - xVector([1:i - 1, i + 1:len]));
                funVector(i) = t1 / t2;
            end

            t1 = tool.vectorFactorial(x - xVector(2:len));
            t2 = tool.vectorFactorial(xVector(1) - xVector(2:len));
            funVector(1) = t1 / t2;
            funVector(end) = tool.vectorFactorial(x - xVector(1:len - 1)) / tool.vectorFactorial(xVector(end) - xVector(1:len - 1));
        end

        function obj = generateRemainder(obj)
            syms x
            xCoord = obj.xCoordinate;
            len = length(xCoord);
            obj.remainder = sym('M') * tool.vectorFactorial(x - xCoord) / factorial(len);
        end

    end

end
