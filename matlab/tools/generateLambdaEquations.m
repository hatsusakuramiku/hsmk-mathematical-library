function lambdaEquations = generateLambdaEquations(lambdaOrderValues, suffix)
    %GENERATELAMBDAEQUATIONS Generate symbolic lambda equations
    %
    %   lambdaEquations = generateLambdaEquations(lambdaOrderValues) returns a
    %   function handle representing symbolic lambda equations. The equations
    %   are generated based on the provided lambda order values.
    %
    %   Parameters:
    %       lambdaOrderValues - a matrix where each row represents a combination
    %                           of lambda orders. Must be non-negative real values.
    %
    %   Returns:
    %       lambdaEquations - a function handle which calculates the product of
    %                         symbolic lambdas raised to the powers defined by
    %                         lambdaOrderValues.
    %
    %   Example:
    %       lambdaOrderValues = [1, 2; 0, 3];
    %       f = generateLambdaEquations(lambdaOrderValues);
    %       % f returns a function handle that can be evaluated with specific lambda values

    % Find the minimum value in the lambdaOrderValues matrix
    min_value = min(lambdaOrderValues);

    % Ensure all lambda order values are non-negative
    if min_value < 0
        error('Lambda order values must be non-negative');
    end

    % Determine the number of columns (lambda variables)
    [~, col] = size(lambdaOrderValues);

    if nargin == 1
        suffix = 'l';
    end

    % Generate symbolic lambda variables
    sysmsLambda = generateSyms(col, suffix);

    % Create a function handle for the product of symbolic lambdas
    lambdaEquations = matlabFunction(prod(sysmsLambda .^ lambdaOrderValues, 2), "Vars", sysmsLambda);
end
