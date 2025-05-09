% GENERATEEQUATIONSBVEC  Generate the B vector in the equation system
%
%   b = generateEquationsBVec(lambdaOrderValues) returns the B vector in the
%   equation system, where lambdaOrderValues is a matrix of lambda orders.
%
%   The returned value is a column vector, where each element is the right
%   hand side of the corresponding equation.
%
%   Parameters:
%       lambdaOrderValues - a matrix of lambda orders, where each row
%                           represents a combination of lambda orders
%
%   Returns:
%       b - a column vector, where each element is the right hand side of the
%           corresponding equation
%
%   Example:
%       lambdaOrderValues = [0, 0, 1; 1, 0, 1; 0, 1, 1];
%       b = generateEquationsBVec(lambdaOrderValues);
%       % b is [2; 2; 2]

function b = generateEquationsBVec(lambdaOrderValues)
    % Input validation
    if isscalar(lambdaOrderValues) || size(lambdaOrderValues, 2) < 3 || size(lambdaOrderValues, 2) > 4
        error('lambdaOrderValues must have 3 or 4 columns');
    end

    % Calculate the B vector
    col = size(lambdaOrderValues, 2);
    lambdaOrderValues = sym(lambdaOrderValues);

    if col == 3
        % B vector for 3D case
        b = 2 .* (prod(factorial(lambdaOrderValues), 2) ./ factorial(sum(lambdaOrderValues, 2) + 2));
    elseif col == 4
        % B vector for 4D case
        b = 6 .* (prod(factorial(lambdaOrderValues), 2) ./ factorial(sum(lambdaOrderValues, 2) + 3));
    end

end
