function str = celltostr(cell_array)
%CELLTOSTR Convert a cell array of strings to a single string
%   str = CELLTOSTR(cell) converts a cell array of strings to a single
%   string, with each element separated by a comma and a space(', ').
%
%   Examples:
%       celltostr({'a', 'b', 'c'}) returns 'a, b, c'
%       celltostr({'a', [], 'c'}) returns 'a, c'
%
%   Accepts the following property/value pairs.
%
%       Input       Value/{Default}           Description
%       -----------------------------------------------------------------------------------
%       cell_array  scalar cell {}            Cell array of strings
%                                                                                         .
%       Output      Value/(Size)              Description
%       -----------------------------------------------------------------------------------
%       result      string                    Single string
%
%   See also strjoin, cellstr.

%   Copyright 2024 HSMK.
arguments
    cell_array {mustBeUnderlyingType(cell_array, 'cell')}
end

% Check for empty cell array
if isempty(cell_array)
    str = '';
    return;
end

% Remove empty elements
cell_array = cell_array(~cellfun(@isempty, cell_array));

% Convert cell array to string array
strArray = cellstr(cell_array);

% Join the strings with a comma and a space
str = strjoin(strArray, ', ');

end