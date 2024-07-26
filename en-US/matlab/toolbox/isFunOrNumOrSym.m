% This function determines if the input is a function handle, a symbolic
% expression, or a numerical value. The function returns a logical value
% of 1 (true) if the input is any of these three types, and 0 (false)
% otherwise.
function result = isFunOrNumOrSym(input)

    % Check if input is a cell array
    if iscell(input)
        % If so, check if any input element is not a function handle or
        % symbolic expression or double
        result = all(cellfun(@(x) isa(x, 'function_handle') || isa(x, 'sym') || isa(x, 'double'), input));
    else
        % If input is not a cell array, check if any input element is not
        % a function handle or symbolic expression or double
        result = all(isa(input, 'function_handle') | isa(input, 'sym') | isa(input, 'double'));
    end

end
