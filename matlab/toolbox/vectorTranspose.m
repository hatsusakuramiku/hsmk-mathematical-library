% vectorTranspose.m
%
% This function takes an input vector and transposes it based on the value
% provided. If value is 1, then the function will transpose the input vector
% from a row vector to a column vector, and vice versa if value is 2. If the
% input vector is already a matrix, the function will simply return the input
% vector without doing anything.
%
% The function first checks if the input vector is indeed a vector by checking
% that the length of the first row (if value is 1) or first column (if value is
% 2) is equal to 1. If so, the function performs the transpose operation
% (input_vector.') and stores the result in output_vector. If the input vector
% is not a vector, the function simply copies the input vector to output_vector
% without doing anything.
%
function output_vector = vectorTranspose(input_vector, value)

    arguments
        input_vector {mustBeVector}
        value {mustBeMember(value, [1, 2])}
    end

    % Check if input_vector is indeed a vector
    if (value == 1 && length(input_vector(1, :)) == 1) || (value == 2 && length(input_vector(:, 1)) == 1)

        % Transpose the input vector based on value
        output_vector = input_vector.';

        % If input_vector is not a vector, just copy it to output_vector
    else

        output_vector = input_vector;

    end

end
