function sortedSolutions = sortTheSolutionByTheSumOfNodesAndDegree(solutions, ascending)
    %SORTTHESOLUTIONSBYTHESUMOFNODESANDDEGREE Sorts the solutions by the sum of
    %nodes and degree in ascending or descending order.
    %
    % Inputs:
    %   solutions - A cell array of solutions, each solution is a cell array
    %               containing the degree, node count, and matrix of solutions
    %   ascending - A boolean indicating whether to sort in ascending or
    %               descending order
    %
    % Outputs:
    %   sortedSolutions - The sorted solutions

    % Calculate the sum of nodes and degree for each solution
    keys = cellfun(@(x) sum(x(:)), solutions(1, :));

    % Sort the solutions based on the sum of nodes and degree
    if ascending
        [~, sortedIndex] = sort(keys, 'ascend');
    else
        [~, sortedIndex] = sort(keys, 'descend');
    end

    % Sort the solutions based on the sorted index
    sortedSolutions = solutions(:, sortedIndex);

end
