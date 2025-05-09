%PRINT_EQUATIONS  Print the equations
%
%   printEquations(equations) prints the equations in a readable
%   format. The equations is a cell array of size 2xN, where N is the
%   number of symmetric classes. The first row of the cell array contains
%   vectors of length 2, where the first element is the symmetric class
%   number and the second element is the repeat times. The second row of
%   the cell array contains the part of equations for each symmetric
%   class. The part of equations is a matrix of size MxL, where M is the
%   number of equations, L is the number of variables.
%
%   The function will print the total number of equations, the number of
%   equations for each symmetric class, and the equations for each
%   symmetric class.

function printEquations(equations)
    % Check if the equations is empty
    if isempty(equations)
        disp('No equations to print')
        return
    end

    [~, col] = size(equations);
    [row, ~] = size(equations{2, 1});
    equation_part_num = 0;

    % Calculate the total number of equation parts
    for i = 1:col
        equation_part_num = equation_part_num + equations{1, i}(2);
    end

    % Print the total number of equation parts and the number of
    % equations
    disp("The number of equation's parts is " + num2str(equation_part_num) + ', the number of equations is ' + num2str(row) + '.');

    % Print the equations for each symmetric class
    for i = 1:col
        disp(['Symmetric class ', num2str(equations{1, i}(1)), ', repeat times ', num2str(equations{1, i}(2)), ', the part of equations are:']);
        disp(equations{2, i});
    end

end
