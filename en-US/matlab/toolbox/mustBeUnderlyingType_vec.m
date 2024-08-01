function mustBeUnderlyingType_vec(obj, typename)
%mustBeUnderlyingType  Validate value has specified underlying type.
%
%   mustBeUnderlyingType(VALUE,{"TypeName"}) issues an error if VALUE does
%   not is member of the specified underlying type cell. TypeName must be a
%   string scalar cell.
%
%   Examples:
%   x = zeros(2,2,"single");
%   mustBeUnderlyingType(x,"single")   % OK - underlyingType is single
%
%   x = gpuArray(eye(3,"uint8"));
%   mustBeUnderlyingType(x,"single")   % Error - underlyingType is uint8
%
%   x = dlarray(gpuArray(rand(3)));
%   mustBeUnderlyingType(x,"gpuArray") % Error - underlyingType is double
%
%   x = {1,2,3};
%   mustBeUnderlyingType(x,"double")   % Error - underlyingType is cell
%
%   x = table([1;2],[3;4]);
%   mustBeUnderlyingType(x,"table")    % OK - underlyingType is table
%
%   See also: underlyingType, isUnderlyingType, mustBeUnderlyingType, class.

%   Copyright 2024 HSMK.

isValid = any(cellfun(@(t) isUnderlyingType(obj, t), typename));
if ~isValid
    throwAsCaller(MException('METoolbox:mustBeUnderlyingType_vec', 'TypeName must be one of {%s}', celltostr(typename)));
end

end