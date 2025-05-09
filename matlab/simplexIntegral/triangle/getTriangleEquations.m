function [equationCell, equationsBvec] = getTriangleEquations(triangleSymmetricClassVector, degree)
    %GETTRIANGLEEQUATIONS Generates equations for a triangle based on a symmetric class vector.
    % This function calculates a set of equations for a triangle given a symmetric class vector
    % and a degree. It uses lambda functions and pre-stored symmetric class data.
    %
    % Inputs:
    %   triangleSymmetricClassVector - A vector with 6 elements, each element must be >= 0.
    %   degree - An integer representing the degree, must be >= 1.
    %
    % Outputs:
    %   equationCell - A cell array containing pairs of symmetric class index and calculated equations.
    %   equationsBvec - A vector of B values corresponding to lambda order values.
    %
    % Outputs format:
    %   equationCell = {[class_index, class_repeat_num];[the equation]}
    %   equationsBvec = [B values]

    arguments
        triangleSymmetricClassVector {mustBeVector, mustBeGreaterThanOrEqual(triangleSymmetricClassVector, 0)}
        degree {mustBeInteger, mustBeGreaterThanOrEqual(degree, 1)}
    end

    % Validate the length of the input vector
    if length(triangleSymmetricClassVector) ~= 6
        throw(MException('getTriangleEquations:invalidInput', 'triangleSymmetricClassVector must have 6 elements'))
    end

    % Load the symmetric class data
    loadData = load('TriangleSymmetricClass.mat', 'triangle_symmetric_class_cell');

    % Check if the loaded data contains the required field
    if ~isfield(loadData, 'triangle_symmetric_class_cell')
        throw(MException('getTriangleEquations:invalidInput', 'triangleEquations.mat must contain triangle_symmetric_class_cell'))
    end

    % Generate lambda order values and B vector
    lambdaOrderValues = getEnableLambdaOrderValues(degree, 3);
    equationsBvec = generateEquationsBVec(lambdaOrderValues);

    % Initialize the cell array to store equations
    equationCell = cell(2, 6);

    % Generate lambda functions based on order values
    lambdaFunctions = generateLambdaEquations(lambdaOrderValues);

    % Counter for equations added
    count = 1;

    % Iterate over the symmetric class vector
    for i = 1:6

        if triangleSymmetricClassVector(i) > 0
            % Get the corresponding symmetric class
            triangle_symmetric_class = loadData.triangle_symmetric_class_cell{i};

            % Initialize the equation using the first element
            temp = lambdaFunctions(triangle_symmetric_class(1, 1), triangle_symmetric_class(1, 2), triangle_symmetric_class(1, 3));

            % Sum the lambda functions for the rest of the elements
            for j = 2:size(triangle_symmetric_class, 1)
                temp = temp + lambdaFunctions(triangle_symmetric_class(j, 1), triangle_symmetric_class(j, 2), triangle_symmetric_class(j, 3));
            end

            % Store the index and the calculated equation
            equationCell(:, count) = {[i, triangleSymmetricClassVector(i)]; temp};
            count = count + 1;
        end

    end

    % Trim the cell array to the number of added equations
    if count > 1
        equationCell = equationCell(:, 1:count - 1);
    else
        equationCell = {};
    end

end
