function permutations_matrix = generate_permutations_unique(input_vector)
    % GENERATE_PERMUTATIONS_UNIQUE - Generate all unique permutations of the input vector
    %
    % Syntax: permutations_matrix = generate_permutations_unique(input_vector)
    %
    % Inputs:
    %    input_vector - A vector of elements
    %
    % Outputs:
    %    permutations_matrix - A matrix of all unique permutations of the input vector
    %
    % Example:
    %    input_vector = [1, 2, 3];
    %    permutations_matrix = generate_permutations_unique(input_vector);
    %    % permutations_matrix = [1, 2, 3; 1, 3, 2; 2, 1, 3; 2, 3, 1; 3, 1, 2; 3, 2, 1]
    %
    % See also: perms, unique

    if isempty(input_vector) || isscalar(input_vector)
        return;
    end

    if ~isvector(input_vector)
        error('input_vector must be a vector');
    end

    permutations_matrix = unique(perms(input_vector), 'rows');

end
