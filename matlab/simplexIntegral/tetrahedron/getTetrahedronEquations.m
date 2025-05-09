%GETTETRAHEDRONEQUATIONS Generates equations for a tetrahedron based on a symmetric class vector.
% This function calculates a set of equations for a tetrahedron given a symmetric class vector
% and a degree. It uses lambda functions and pre-stored symmetric class data.
%
% Inputs:
%   tetrahedronSymmetricClassVector - A vector with 11 elements, each element must be >= 0.
%   degree - An integer representing the degree, must be >= 1.
%
% Outputs:
%   equationCell - A cell array containing pairs of symmetric class index and calculated equations.
%   equationsBvec - A vector of B values corresponding to lambda order values.
%
% Outputs format:
%   equationCell = {[class_index, class_repeat_num];[the equation]}
%   equationsBvec = [B values]

function [equationCell, equationsBvec, lambdaOrderValues] = getTetrahedronEquations(tetrahedronSymmetricClassVector, degree)

    arguments
        tetrahedronSymmetricClassVector {mustBeVector, mustBeGreaterThanOrEqual(tetrahedronSymmetricClassVector, 0)}
        degree {mustBeInteger, mustBeGreaterThanOrEqual(degree, 1)}
    end

    % Validate the length of the input vector
    if length(tetrahedronSymmetricClassVector) ~= 11
        throw(MException('getTetrahedronEquations:invalidInput', 'tetrahedronSymmetricClassVector must have 11 elements'))
    end

    % Load the symmetric class data
    loadData = load('TetrahedronSymmetricClass.mat', 'tetrahedron_symmetric_class_cell');

    % Check if the loaded data contains the required field
    if ~isfield(loadData, 'tetrahedron_symmetric_class_cell')
        throw(MException('getTetrahedronEquations:invalidInput', 'triangleEquations.mat must contain tetrahedron_symmetric_class_cell'))
    end

    % Generate lambda order values and B vector
    lambdaOrderValues = getEnableLambdaOrderValues(degree, 4);
    equationsBvec = generateEquationsBVec(lambdaOrderValues);

    % Initialize the cell array to store equations
    equationCell = cell(2, 6);

    % Generate lambda functions based on order values
    lambdaFunctions = generateLambdaEquations(lambdaOrderValues);

    % Counter for equations added
    count = 1;

    % Iterate over the symmetric class vector
    for i = 1:11

        if tetrahedronSymmetricClassVector(i) > 0
            % Get the corresponding symmetric class
            tetrahedron_symmetric_class = loadData.tetrahedron_symmetric_class_cell{i};

            % Initialize the equation using the first element
            temp = lambdaFunctions(tetrahedron_symmetric_class(1, 1), tetrahedron_symmetric_class(1, 2), tetrahedron_symmetric_class(1, 3), tetrahedron_symmetric_class(1, 4));

            % Sum the lambda functions for the rest of the elements
            for j = 2:size(tetrahedron_symmetric_class, 1)
                temp = temp + lambdaFunctions(tetrahedron_symmetric_class(j, 1), tetrahedron_symmetric_class(j, 2), tetrahedron_symmetric_class(j, 3), tetrahedron_symmetric_class(j, 4));
            end

            % Store the index and the calculated equation
            equationCell(:, count) = {[i, tetrahedronSymmetricClassVector(i)]; temp};
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
