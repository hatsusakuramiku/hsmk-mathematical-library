% The function isdecimal(x) returns a logical array where true indicates
% that the corresponding element of x is a non-integer value (i.e., it is
% not equal to the integer part of x).
%
% The function accepts a single input argument x, which can be a scalar
% or any MATLAB array.
%
% The function computes the integer part of x using the floor function, and
% then compares it element-wise to x. If any element of x does not equal
% its integer part, the corresponding logical element of the output array
% is true. Otherwise, it is false.
function result = isdecimal(x)
    result = x ~= floor(x);
end
