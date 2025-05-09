function result = getTriangleNodesByDegree(degree)
    %GETTRIANGLENODESBYDEGREE Finds triangle nodes for a given degree
    % This function calculates all possible M and Mf combinations for a given
    % degree and finds solutions using the getTriangleNodes function.
    %
    % Inputs:
    %   degree - The degree for which to find triangle nodes
    %
    % Outputs:
    %   result - A cell array of solutions, each solution is a cell array
    %            containing the degree, node count, and matrix of solutions
    % Outputs example:
    %   result = {[degree, node_count];[M, Mf];[solution1; solution2; ...]}

    if degree < 1
        disp('Degree must be greater than or equal to 1');
        return;
    end

    % Calculate all possible M and Mf combinations for the specified degree
    all_enable_M_and_Mf = calculateTriangleMAndMf(degree);
    len = size(all_enable_M_and_Mf, 1);

    % Initialize result as an empty cell array
    result = {};

    % Iterate over all combinations of M and Mf
    for i = 1:len
        % Get solutions for the current M and Mf
        solutions = getTriangleNodes(all_enable_M_and_Mf(i, 1), all_enable_M_and_Mf(i, 2));

        % If solutions are found, add them to the result
        if ~isempty(solutions)
            result = [result, solutions]; %#ok<AGROW>
            % Sort the solutions by the sum of nodes and degree, ascending
            result = sortTheSolutionByTheSumOfNodesAndDegree(result, 1);
        end

    end

end
