classdef NewtonPolynomial < Interpolation & Coordinates
    properties (Access = private)
        differenceQuotientMatrix; 
        differenceQuotientTable; 
        singleSeparatePolynomial; 
        xSingleSeparatePolynomial;
        separatePolynomial; 
        polynomialCell; 
        derivativeFunction;
    end
    
    methods
        function newtonPolynomial = NewtonPolynomial(xCoordinate, yCoordinate)
            if any(length([xCoordinate, yCoordinate]) < 4 | isempty([xCoordinate, yCoordinate]) | ~isequal(length(xCoordinate), length(yCoordinate)))
                error("Invalid input arguments! Make sure the input coordinates correspond and the count is more than 2!")
            end
            newtonPolynomial@Interpolation([],length(xCoordinate) - 1,xCoordinate,yCoordinate)
            newtonPolynomial.polynomialCell = {sym(ones(1, 1)), sym(ones(length(newtonPolynomial.xCoordinate), 1)), sym(zeros(length(newtonPolynomial.xCoordinate), 1))};
            newtonPolynomial = newtonPolynomial.newtonInterpolationMethod();
        end
        function newtonPolynomial = generateNewtonInterpolation(newtonPolynomial)
            
            syms x;
            newtonPolynomial.polynomialCell{2} = sym(ones(length(newtonPolynomial.xCoordinate), 1));
            newtonPolynomial.xSingleSeparatePolynomial = sym(ones(length(newtonPolynomial.xCoordinate), 1));
            newtonPolynomial.polynomialCell{2}(1) = newtonPolynomial.polynomialCell{2}(1) * newtonPolynomial.yCoordinate(1);
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
        
        function differenceQuotientMatrix = getdifferenceQuotientMatrix(newtonPolynomial)
            differenceQuotientMatrix = newtonPolynomial.differenceQuotientMatrix;
        end
        
        function differenceQuotientTable = getdifferenceQuotientTable(newtonPolynomial)
            differenceQuotientTable = newtonPolynomial.differenceQuotientTable;
        end
        
        function singleSeparatePolynomial = getsingleSeparatePolynomial(newtonPolynomial)
            singleSeparatePolynomial = newtonPolynomial.singleSeparatePolynomial;
        end
        
        function xSingleSeparatePolynomial = getxSingleSeparatePolynomial(newtonPolynomial)
            xSingleSeparatePolynomial = newtonPolynomial.xSingleSeparatePolynomial;
        end
        
        function separatePolynomial = getseparatePolynomial(newtonPolynomial)
            separatePolynomial  = newtonPolynomial.separatePolynomial;
        end
        
        function E = getVariableError(newtonPolynomial,t)
            syms x ;
            E = subs(newtonPolynomial.polynomial,x,t);
        end
        
        function E = getFunctionError(newtonPolynomial,fun,t)
            syms x;
            E = subs(newtonPolynomial.polynomial,x,t) - subs(fun,symvar(fun),t);
        end
    end
    methods (Access = private)
        
        function newtonPolynomial = getIndifferenceQuotienMatrix(newtonPolynomial)
            newtonPolynomial.differenceQuotientMatrix = ones(length(newtonPolynomial.differenceQuotientTable), 1);
            
            for i = 1:length(newtonPolynomial.differenceQuotientMatrix)
                newtonPolynomial.differenceQuotientMatrix(i) = newtonPolynomial.differenceQuotientMatrix(i) * newtonPolynomial.differenceQuotientTable(i, i);
            end
        end
        
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