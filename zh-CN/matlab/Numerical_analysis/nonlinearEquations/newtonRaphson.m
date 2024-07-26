function [itePoint, iteMatrix] =  newTonRaphson(fun, symbolvar, beginPoint, accuracy, maxIter)
    arguments 
        fun {mustBeUnderlyingType(fun, 'sym')}
        symbolvar {mustBeUnderlyingType(symbolvar, 'sym')} = x
        beginPoint {mustBeNumeric} = 0
        accuracy {mustBeNumeric} = 10e-9
        maxIter {mustBeNumeric} = 1000
    end

    try
        double(subs(fun, symbolvar, beginPoint));
    catch(MException)
        throw(MException('newtonRaphson:invalidInput', 'Invalid input'));
    end
end