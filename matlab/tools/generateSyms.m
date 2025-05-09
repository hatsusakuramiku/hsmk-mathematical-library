function sysmsLambda = generateSyms(lambda_num, charcter)
    % Generate an array of symbolic variables.
    %
    % SYMSLAMBDA = GENERATESYMS(LAMBDA_NUM) generates an array of symbolic
    % variables with the same size as LAMBDA_NUM. The symbolic variables are
    % named 'l1', 'l2', ..., 'ln', where 'n' is the total number of elements
    % in LAMBDA_NUM.
    %
    % SYMSLAMBDA = GENERATESYMS(LAMBDA_NUM, CHARCTER) generates an array of
    % symbolic variables with the same size as LAMBDA_NUM, and the symbolic
    % variables are named 'CHARCTER1', 'CHARCTER2', ..., 'CHARCTERN', where
    % 'n' is the total number of elements in LAMBDA_NUM.
    %
    % Example:
    %   lambda_num = [3, 2];
    %   symsLambda = generateSyms(lambda_num);
    %   symsLambda = generateSyms(lambda_num, 'x');

    % Set default character if not provided
    if nargin < 2
        charcter = 'l';
    elseif nargin < 1
        error('lambda_num must be specified');
    end

    % Quick return for scalar input
    if isscalar(lambda_num)
        % Generate sequence and convert to symbolic variables
        lambda = charcter + string(1:lambda_num);
        sysmsLambda = sym(lambda);
        return;
    end

    % Get dimensions
    [lambda_num_rows, lambda_num_cols] = size(lambda_num);

    % Validate character input
    if ~isscalar(charcter) && any(size(charcter) ~= size(lambda_num))
        error('charcter must be a string of the same size as lambda_num');
    end

    % Pre-allocate cell array
    sysmsLambda = cell(lambda_num_rows, lambda_num_cols);

    % Replicate character if scalar
    if isscalar(charcter)
        charcter = repmat(charcter, size(lambda_num));
    end

    % Vectorized approach using arrayfun
    % This avoids explicit nested loops for better performance
    arrayfun(@processElement, 1:numel(lambda_num), 'UniformOutput', false);

    % Nested function for processing each element
    function processElement(idx)
        [i, j] = ind2sub(size(lambda_num), idx);
        num = lambda_num(i, j);
        ch = charcter(i, j);
        lambda = ch + string(1:num);
        sysmsLambda{i, j} = sym(lambda);
    end

end
