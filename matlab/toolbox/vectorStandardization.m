% Vector standardization function
%
% This function standardizes a given vector of arbitrary length to a fixed
% length, lens, by padding or truncating the original vector. If the vector
% is longer than the desired length, it is truncated from the end. If it is
% shorter, it is padded with zeros at the end.
%
% @param inputVector Input vector to be standardized
% @param lens Desired length of the output vector
%
function result = vectorStandardization(inputVector, lens)
    % Initialize output vector
    result = zeros(1, max(lens, length(inputVector)));  
    % Copy input vector to the appropriate portion of the output vector
    result(1:length(inputVector)) = inputVector;
end
