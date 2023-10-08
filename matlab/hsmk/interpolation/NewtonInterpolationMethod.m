classdef NewtonInterpolationMethod
    properties (Access = private)
        X; % Input x-coordinates
        Y; % Input y-coordinates
        N; % Order of the polynomial
        differenceQuotientMatrix; % Difference quotient matrix
        differenceQuotientTable; % Difference quotient table
        polynomial; % nth order polynomial, n = length(X) - 1
        singleSeparatePolynomial; % Single separate polynomial
        xSingleSeparatePolynomial % x times single separate polynomial
        separatePolynomial; % Separate polynomial
        polynomialCell; % Polynomial matrix
        fun;
        derivativeFunction;
    end

    methods
        % NewtonInterpolationMethod - Class constructor
        %   Creates an instance of the NewtonInterpolationMethod class.
        %   Arguments:
        %       inputArg1 - Input x-coordinates
        %       inputArg2 - Input y-coordinates
        function newtonPolynomial = NewtonInterpolationMethod(inputArg1, inputArg2)
            % Check if input arguments are valid
            if any(length([inputArg1, inputArg2]) < 4 | isempty([inputArg1, inputArg2]) | ~isequal(length(inputArg1), length(inputArg2)))
                error("Invalid input arguments! Make sure the input coordinates correspond and the count is more than 2!")
            end
            % Initialize properties
            newtonPolynomial.X = inputArg1;
            newtonPolynomial.Y = inputArg2;
            newtonPolynomial.N = length(newtonPolynomial.X) - 1;
            newtonPolynomial.polynomialCell = {sym(ones(1, 1)), sym(ones(length(newtonPolynomial.X), 1)), sym(zeros(length(newtonPolynomial.X), 1))};
            % Call Newton's Interpolation method
            newtonPolynomial = newtonPolynomial.newtonInterpolationMethod();
        end
        % getnewtonInterpolation - Get the result of Newton's Interpolation
        %   Calculates and returns the polynomial obtained from Newton's Interpolation.
        function newtonPolynomial = getnewtonInterpolation(newtonPolynomial)

            syms x;
            newtonPolynomial.polynomialCell{2} = sym(ones(length(newtonPolynomial.X), 1));
            newtonPolynomial.xSingleSeparatePolynomial = sym(ones(length(newtonPolynomial.X), 1));
            newtonPolynomial.polynomialCell{2}(1) = newtonPolynomial.polynomialCell{2}(1) * newtonPolynomial.Y(1);
            % Calculate each term of the polynomial
            for i = 2:length(newtonPolynomial.X)

                for j = 1:i - 1
                    newtonPolynomial.polynomialCell{2}(i) = newtonPolynomial.polynomialCell{2}(i) * (x - newtonPolynomial.X(j));
                end

                newtonPolynomial.xSingleSeparatePolynomial(i) = newtonPolynomial.xSingleSeparatePolynomial(i) * newtonPolynomial.polynomialCell{2}(i);
                newtonPolynomial.polynomialCell{2}(i) = newtonPolynomial.polynomialCell{2}(i) * newtonPolynomial.differenceQuotientTable(i, i);
            end

            newtonPolynomial.polynomialCell{1} = newtonPolynomial.polynomialCell{1} * simplify(sum(newtonPolynomial.polynomialCell{2}));
            newtonPolynomial.polynomial = newtonPolynomial.polynomialCell{1};
            newtonPolynomial.xSingleSeparatePolynomial = simplify(newtonPolynomial.xSingleSeparatePolynomial);
            newtonPolynomial = newtonPolynomial.getInSeparatePolynomial();
            newtonPolynomial = newtonPolynomial.getIndifferenceQuotienMatrix();
            newtonPolynomial.singleSeparatePolynomial = newtonPolynomial.xSingleSeparatePolynomial .* newtonPolynomial.differenceQuotientMatrix;
        end
        % getX - Get input x-coordinates
        function X = getX(newtonPolynomial)
            X = newtonPolynomial.X;
        end
        % getY - Get input y-coordinates
        function Y = getY(newtonPolynomial)
            Y = newtonPolynomial.Y;
        end
        % getN - Get order of the polynomial
        function N = getN(newtonPolynomial)
            N = newtonPolynomial.N;
        end
        % getPolynomial - Get the calculated polynomial
        function polynomial = getPolynomial(newtonPolynomial)
            polynomial = newtonPolynomial.polynomial;
        end
        % getdifferenceQuotientMatrix - Get the difference quotient matrix
        function differenceQuotientMatrix = getdifferenceQuotientMatrix(newtonPolynomial)
            differenceQuotientMatrix = newtonPolynomial.differenceQuotientMatrix;
        end
        % getdifferenceQuotientTable - Get the difference quotient table
        function differenceQuotientTable = getdifferenceQuotientTable(newtonPolynomial)
            differenceQuotientTable = newtonPolynomial.differenceQuotientTable;
        end
        % getsingleSeparatePolynomial - Get the single separate polynomial
        function singleSeparatePolynomial = getsingleSeparatePolynomial(newtonPolynomial)
            singleSeparatePolynomial = newtonPolynomial.singleSeparatePolynomial;
        end
        % getxSingleSeparatePolynomial - Get x times single separate polynomial
        function xSingleSeparatePolynomial = getxSingleSeparatePolynomial(newtonPolynomial)
            xSingleSeparatePolynomial = newtonPolynomial.xSingleSeparatePolynomial;
        end
        % getseparatePolynomial - Get the separate polynomial
        function separatePolynomial = getseparatePolynomial(newtonPolynomial)
            separatePolynomial  = newtonPolynomial.separatePolynomial;
        end
        % getVariableError - Get the error between the polynomial and a given x-value
        function E = getVariableError(newtonPolynomial,t)
            syms x ;
            E = subs(newtonPolynomial.polynomial,x,t);
        end
        % getFunctionError - Get the error between the polynomial and a given function at a specific x-value
        function E = getFunctionError(newtonPolynomial,fun,t)
            syms x;
            E = subs(newtonPolynomial.polynomial,x,t) - subs(fun,symvar(fun),t);
        end
        % %
        % function E = getError(newtonPolynomial)
        %     syms x;
        %
        % end
        % %
        function sum = factorial(~,n)
            sum = 1;

            if n == 0
                return
            end

            for i = 1:n
                sum = sum * i;
            end
        end
    end
    methods (Access = private)
        % getIndifferenceQuotienMatrix - Create the difference quotient matrix
        function newtonPolynomial = getIndifferenceQuotienMatrix(newtonPolynomial)
            newtonPolynomial.differenceQuotientMatrix = ones(length(newtonPolynomial.differenceQuotientTable), 1);

            for i = 1:length(newtonPolynomial.differenceQuotientMatrix)
                newtonPolynomial.differenceQuotientMatrix(i) = newtonPolynomial.differenceQuotientMatrix(i) * newtonPolynomial.differenceQuotientTable(i, i);
            end
        end
        % newtonInterpolationMethod - Perform Newton's Interpolation
        function newtonPolynomial = newtonInterpolationMethod(newtonPolynomial)
            len = length(newtonPolynomial.X);
            newtonPolynomial.differenceQuotientTable = zeros(len, len);

            for i = 1:len
                newtonPolynomial.differenceQuotientTable(i, 1) = newtonPolynomial.Y(i);
            end

            for i = 2:len
                for j = 2:i
                    newtonPolynomial.differenceQuotientTable(i, j) = (newtonPolynomial.differenceQuotientTable(i, j - 1) - newtonPolynomial.differenceQuotientTable(i - 1, j - 1)) / (newtonPolynomial.X(i) - newtonPolynomial.X(i + 1 - j));
                end
            end
        end
        % getInSeparatePolynomial - Get the separate polynomial
        function newtonPolynomial = getInSeparatePolynomial(newtonPolynomial)
            for i = 1:length(newtonPolynomial.polynomialCell{2})
                for j = 1:i
                    newtonPolynomial.polynomialCell{3}(i) = newtonPolynomial.polynomialCell{3}(i) + newtonPolynomial.polynomialCell{2}(j);
                end
            end
            newtonPolynomial.polynomialCell{3} = simplify(newtonPolynomial.polynomialCell{3});
            newtonPolynomial.separatePolynomial = newtonPolynomial.polynomialCell{3};
        end
    end
end