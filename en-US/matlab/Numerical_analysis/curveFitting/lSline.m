function [polynomial, coefficients] = lSline(xCoordinate, yCoordinate, option)
%LSLINE Uses least squares to fit a line
%   [POLY, COEFFICIENTS] = LSLINE(XCOORDINATE, YCOORDINATE, OPTION) use least squares to fit a line
%   with the given x and y coordinates.The option parameter specifies the line equation to fit.
%
%   Examples:
%
%   Accepts the following property/value pairs.
%
%       Input           Value/{Default}           Description
%       -----------------------------------------------------------------------------------
%       xCoordinate     vector {}                 Vector of x coordinates
%       yCoordinate     vector {}                 Vector of y coordinates
%       option          scalar integer {1}        Fit option mode
%                                       1         $y = Ax + B$
%                                       2         $y = \frac{A}{x} + B$
%                                       3         $y = \frac{A}{x + B}$
%                                       4         $y = \frac{1}{Ax + B}$
%                                       5         $y = Be^{Ax}$
%                                       6         $y = Bx^{A}$
%                                                                                         .
%       Output          Value/(Size)              Description
%       -----------------------------------------------------------------------------------
%       polynomial      sym scalar                Symbolic expression of the fitted line
%       coefficients    vector(2)                 Coefficients of the fitted line (A, B)
%
%   See also: polyfit, polyval.

%   Copyright 2024 HSMK.
%% 输入参数校验
arguments
    xCoordinate {mustBeVector, mustBeReal}
    yCoordinate {mustBeVector, mustBeReal}
    option {mustBeMember(option, [0, 1, 2, 3, 4, 5])} = 0
end

% 输入参数个数校验
narginchk(2, 3);

% x 和 y 坐标长度校验
if numel(unique(xCoordinate)) ~= numel(xCoordinate)
    throw(MException('MATLAB:LeastSquares:InvalidInput', '输入X坐标不唯一'));
elseif size(xCoordinate, 1) ~= size(yCoordinate, 1)
    throw(MException('MATLAB:LeastSquares:InvalidInput', '输入X和Y坐标维度不一致'));
elseif numel(xCoordinate) ~= numel(yCoordinate)
    throw(MException('MATLAB:LeastSquares:InvalidInput', '输入X和Y坐标长度不相等'));
end

try
    
    switch option
        case 1
            [xCoordinate, yCoordinate] = inv12Line(xCoordinate, yCoordinate);
        case 2
            [xCoordinate, yCoordinate] = inv22Line(xCoordinate, yCoordinate);
        case 3
            [xCoordinate, yCoordinate] = inv32Line(xCoordinate, yCoordinate);
        case 4
            [xCoordinate, yCoordinate] = ln12Line(xCoordinate, yCoordinate);
        case 5
            [xCoordinate, yCoordinate] = ln22Line(xCoordinate, yCoordinate);
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
polynomial = getPolynomial(result(1), result(2), option);

    function [xCoordinate, yCoordinate] = inv12Line(xCoordinate, yCoordinate)
        % y = A/x + B => y = A*(1/x) +B
        if ~isempty(xCoordinate(xCoordinate == 0))
            error('x不能等于0')
        end
        
        xCoordinate = 1 ./ xCoordinate;
    end

    function [xCoordinate, yCoordinate] = inv22Line(xCoordinate, yCoordinate)
        % y = D/(x+C) => y = (-1/C)*(xy) + D/C
        xCoordinate = xCoordinate .* yCoordinate;
    end

    function [xCoordinate, yCoordinate] = inv32Line(xCoordinate, yCoordinate)
        % y = 1(A*x + B) => y = 1/y = A*x + B
        if ~isempty(yCoordinate(yCoordinate == 0))
            error('y不能等于0')
        end
        
        yCoordinate = 1 ./ yCoordinate;
    end

    function [xCoordinate, yCoordinate] = ln12Line(xCoordinate, yCoordinate)
        % y = C*e^(A*x) => ln(y) = Ax + ln(C)
        if ~isempty(yCoordinate(yCoordinate <= 0))
            error('y不能小于0')
        end
        
        yCoordinate = log(yCoordinate);
    end

    function [xCoordinate, yCoordinate] = ln22Line(xCoordinate, yCoordinate)
        % y = C*x^A => ln(y) = A*ln(x) + ln(C)
        if ~isempty(yCoordinate(yCoordinate <= 0)) || ~isempty(xCoordinate(yCoordinate <= 0))
            error('y和x不能小于或等于0')
        end
        
        xCoordinate = log(xCoordinate);
        yCoordinate = log(yCoordinate);
    end

    function polynomial = getPolynomial(a, b, n)
        % 转换为符号表达式
        
        switch n
            case 0
                polynomial = @(x) a .* x + b;
            case 1
                polynomial = @(x) a .* (1 ./ x) +b;
            case 2
                polynomial = @(x) (-b ./ a) ./ (x - 1 ./ a);
            case 3
                polynomial = @(x) 1 ./ (a .* x + b);
            case 4
                polynomial = @(x) exp(b) .* exp(a .* x);
            case 5
                polynomial = @(x) exp(b) .* x .^ a;
        end
        
    end

end
