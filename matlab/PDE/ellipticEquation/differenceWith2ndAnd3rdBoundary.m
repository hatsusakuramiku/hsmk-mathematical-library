function fval = differenceWith2ndAnd3rdBoundary(range, coefficients, fun, conditions, intervalNum)

    %% 参数检查
    arguments
        range {mustBeVector, mustBeReal}
        coefficients {mustBeUnderlyingType(coefficients, 'cell')}
        fun {mustBeScalarOrEmpty}
        conditions {mustBeUnderlyingType(conditions, 'cell')}
        intervalNum {mustBeInteger, mustBeGreaterThanOrEqual(intervalNum, 2)} = 100
    end

    range_check(range);

    if length(coefficients) > 3
        throw(MException('MATLAB:differenceWith1thBoundary:InvalidInput', 'coefficients must have at most 3 elements.'));
    end

    cellStandardization(coefficients, 3); % 标准化，确保长度为 3

    if ~isFunOrNumOrSym(coefficients) || ~isFunOrNumOrSym(fun) || ~isFunOrNumOrSym(conditions)
        throw(MException('MATLAB:differenceWith1thBoundary:InvalidInput', ''));
    end
end