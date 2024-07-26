% FUNCTION_HANDLE version
% Evaluates the function at x
%
% Syntax: result = func(fun, x)
% fun: function_handle or symbolic expression
% x: input to the function
% result: output of the function
function result = func(fun, x)
    
    % Evaluate the function handle
    if isa(fun, 'function_handle')
        result = fun(x);
    % Evaluate the symbolic expression
    elseif isa(fun, 'sym')
        % Evaluate symbolic expression at x by substituting the
        % symbols in fun with their corresponding values in x
        result = double(subs(fun, symvar(fun), x));
    % Evaluate constant function
    else
        % Multiply fun by a column vector of ones to make it the same size
        % as x
        result = fun .* ones(1, length(x));
    end
    
end
