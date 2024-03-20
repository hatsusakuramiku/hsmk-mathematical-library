% This function is used to check whether the input vector is a valid range.
% A valid range should have two elements and the left endpoint should be
% less than the right endpoint.
function range = range_check(vector)

    % Check the number of elements in the input vector
    % If the number of elements is not equal to 2, throw an error
    if numel(vector) ~= 2
        % Throw a specific error message for invalid input 
        % indicating that the number of elements in the input vector is not valid
        % for a range
        errorMessage = '输入区间端点数量不合法，请检查并修改条件';
        throw(MException('MATLAB:range_check:InvalidInput', errorMessage));
    end

    % Check if the left endpoint is equal to the right endpoint
    % If they are equal, throw an error indicating that the input range is invalid
    if vector(1) == vector(2)
        errorMessage = '输入区间左右端点值相等，请检查并修改条件';
        throw(MException('MATLAB:range_check:InvalidInput', errorMessage));
    end

    % Check if the left endpoint is greater than the right endpoint
    % If it is, flip the vector, otherwise just return the input vector
    if vector(1) > vector(2)
        range = filp(vector);
    else
        range = vector;
    end

end

