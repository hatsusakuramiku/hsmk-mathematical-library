function lambdaValues = getEnableLambdaOrderValues(degree, lambda_num)
    %GETENABLELAMBDAORDERVALUES  Get all combinations of lambda values
    %
    %   lambdaValues = getEnableLambdaOrderValues(degree, lambda_num) returns all
    %   combinations of lambda values, where n = lambda_num, \sum^n_{l_i}{l_i} <=
    %   degree, l_n\leq l_{n-1}\leq \cdots \leq l_3\leq l_2 = l_1\geq 0.
    %
    %   The returned value is a matrix, where each row is a combination and
    %   each column is a lambda value, sorted from small to large.
    %
    %   Parameters:
    %       degree - a positive integer
    %       lambda_num - the number of lambda values, must be greater than or
    %                    equal to 3
    %
    %   Returns:
    %       lambdaValues - a matrix of all combinations, each row is a
    %                      combination and each column is a lambda value

    % Input validation
    if ~isscalar(degree) || degree < 0 || floor(degree) ~= degree
        error('degree must be a non-negative integer');
    end

    if ~isscalar(lambda_num) || lambda_num < 3 || floor(lambda_num) ~= lambda_num
        error('lambda_num must be an integer greater than or equal to 3');
    end

    % Initialize results list
    lambdaValues = [];

    % Find maximum possible value for l_1 = l_2
    max_l1 = floor(degree / 2);

    % Loop through possible values for l_1 = l_2
    for l1 = 0:max_l1
        % Remaining degree for other lambda values
        remaining_degree = degree - 2 * l1;

        % Find all combinations for remaining lambdas
        if lambda_num > 2
            remainingLambdas = findRemainingLambdas(l1, remaining_degree, lambda_num - 2);

            % For each combination of remaining lambdas
            for i = 1:size(remainingLambdas, 1)
                % Combine l1, l1, and the remaining lambdas
                row = [l1, l1, fliplr(remainingLambdas(i, :))];
                lambdaValues = [lambdaValues; row]; %#ok<AGROW>
            end

        end

    end

end

function combinations = findRemainingLambdas(max_value, remaining_sum, num_variables)
    % This function finds all combinations of num_variables values that:
    % 1. Sum to at most remaining_sum
    % 2. Each value is at most max_value
    % 3. Values are in non-decreasing order

    combinations = [];

    % Base case
    if num_variables == 1
        % Only one value, and it must be at most both max_value and remaining_sum
        max_possible = min(max_value, remaining_sum);
        combinations = (0:max_possible)';
        return;
    end

    % Recursive case
    for val = 0:min(max_value, remaining_sum)
        % Find combinations for remaining variables
        subCombinations = findRemainingLambdas(val, remaining_sum - val, num_variables - 1);

        % Add current value to each subcombination
        for i = 1:size(subCombinations, 1)
            row = [subCombinations(i, :), val];
            combinations = [combinations; row]; %#ok<AGROW>
        end

    end

end
