classdef NewtonInterpolationMethod < Interpolation
    properties (Access = private)
        differenceQuotientMatrix; % Difference quotient matrix
        differenceQuotientTable; % Difference quotient table
        singleSeparatePolynomial; % Single separate polynomial
        xSingleSeparatePolynomial % x times single separate polynomial
        separatePolynomial; % Separate polynomial
        polynomialCell; % Polynomial matrix
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
            newtonPolynomial@Interpolation([],length(inputArg1) - 1,inputArg1,inputArg2)
            newtonPolynomial.polynomialCell = {sym(ones(1, 1)), sym(ones(length(newtonPolynomial.xCoordinate), 1)), sym(zeros(length(newtonPolynomial.xCoordinate), 1))};
            % Call Newton's Interpolation method
            newtonPolynomial = newtonPolynomial.newtonInterpolationMethod();
        end
        % getnewtonInterpolation - Get the result of Newton's Interpolation
        %   Calculates and returns the polynomial obtained from Newton's Interpolation.
        function newtonPolynomial = getnewtonInterpolation(newtonPolynomial)
            
            syms x;
            newtonPolynomial.polynomialCell{2} = sym(ones(length(newtonPolynomial.xCoordinate), 1));
            newtonPolynomial.xSingleSeparatePolynomial = sym(ones(length(newtonPolynomial.xCoordinate), 1));
            newtonPolynomial.polynomialCell{2}(1) = newtonPolynomial.polynomialCell{2}(1) * newtonPolynomial.yCoordinate(1);
            % Calculate each term of the polynomial
            for i = 2:length(newtonPolynomial.xCoordinate)
                
                for j = 1:i - 1
                    newtonPolynomial.polynomialCell{2}(i) = newtonPolynomial.polynomialCell{2}(i) * (x - newtonPolynomial.xCoordinate(j));
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
            X = newtonPolynomial.xCoordinate;
        end
        % getY - Get input y-coordinates
        function Y = getY(newtonPolynomial)
            Y = newtonPolynomial.yCoordinate;
        end
        % getN - Get order of the polynomial
        function N = getN(newtonPolynomial)
            N = newtonPolynomial.order;
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
            len = length(newtonPolynomial.xCoordinate);
            newtonPolynomial.differenceQuotientTable = zeros(len, len);
            
            for i = 1:len
                newtonPolynomial.differenceQuotientTable(i, 1) = newtonPolynomial.yCoordinate(i);
            end
            
            for i = 2:len
                for j = 2:i
                    newtonPolynomial.differenceQuotientTable(i, j) = (newtonPolynomial.differenceQuotientTable(i, j - 1) - newtonPolynomial.differenceQuotientTable(i - 1, j - 1)) / (newtonPolynomial.xCoordinate(i) - newtonPolynomial.xCoordinate(i + 1 - j));
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