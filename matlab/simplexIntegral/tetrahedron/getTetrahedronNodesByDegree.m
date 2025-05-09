function solutions = getTetrahedronNodesByDegree(degree)
    %GETTETRAHEDRONNODESBYDEGREE Finds tetrahedron nodes for a given degree
    % This function calculates all possible M, Mf, and Mi combinations for a
    % given degree and finds solutions using the getTetrahedronNodes function.
    %
    % Inputs:
    %   degree - The degree for which to find tetrahedron nodes
    %
    % Outputs:
    %   solutions - A cell array of solutions, each solution is a cell array
    %               containing the degree, node count, and matrix of solutions
    %
    % Outputs example:
    %   result = {[degree, node_count];[M, Mf];[solution1; solution2; ...]}
        
    if degree < 1
        error('Degree must be greater than or equal to 1');
    end

    % Calculate all possible M, Mf, and Mi combinations for the specified degree
    all_enable_M_and_Mf_and_Mi = calculateTetrahedronMAndMfAndMi(degree);
    len = size(all_enable_M_and_Mf_and_Mi, 1);
    solutions = {};

    % Iterate over all combinations of M, Mf, and Mi
    for i = 1:len
        % Get solutions for the current M, Mf, and Mi
        M_Mf_Mi = all_enable_M_and_Mf_and_Mi(i, :);
        solution = getTetrahedronNodes(M_Mf_Mi(1), M_Mf_Mi(2), M_Mf_Mi(3));

        % If solutions are found, add them to the result
        if ~isempty(solution)
            solutions = [solutions, solution]; %#ok<AGROW>
        end

    end

    if ~isempty(solutions)
        solutions = sortTheSolutionByTheSumOfNodesAndDegree(solutions, 1);
    end

end
