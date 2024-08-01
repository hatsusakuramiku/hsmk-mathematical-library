function result = caculate_func(fun, x)
%CALCULATE_FUNC Summary of this function goes here
%   RESULT = CALCULATE_FUNC(FUN, X) calculates the value of FUN at X
%
%   Example:
%   fun = @(x)sin(x); x = linspace(0, 10, 100);
%   result = caculate_func(fun, x);
%
%   syms x; fun = sin(x); xVec = linspace(0, 10, 100);
%   result = caculate_func(fun, xVec);
%
%   Accepts the following property/value pairs.
%
%       Input       Value/{Default}           Description
%       -----------------------------------------------------------------------------------
%       fun         function_handle/sym {}    Function to be evaluated
%       x           scalar/vector/matrix {}   Vector of inputs
%                                                                                         .
%       Output      Value/(Size)              Description
%       -----------------------------------------------------------------------------------
%       result      scalar/vector/matrix      Calculated values
%
%   See also: function_handle, sym, subs.

%   Copyright 2024 HSMK
%   Requires: MATLAB Symbolic and Calculus Toolbox
%             MATLAB 2019b or later

arguments
    fun {mustBeUnderlyingType_vec(fun, {'function_handle', 'sym', 'numeric'})}
    x {mustBeUnderlyingType(x, 'numeric')}
end

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
    result = fun .* ones(size(x));
end

end