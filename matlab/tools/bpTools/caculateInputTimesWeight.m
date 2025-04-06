% caculateInputTimesWeight - Compute the product of the input data and the weights of the next layer
%
% Inputs:
%   inputData - Input data
%   input2NextLayerWeight - Weights of the next layer
%
% Outputs:
%   result - Product of the input data and the weights of the next layer
function result = caculateInputTimesWeight(inputData, input2NextLayerWeight)
    % Get the number of input data and the number of neurons in the next layer
    [inputDataNum, ~] = size(inputData);
    [~, nextLayerNeuronNum] = size(input2NextLayerWeight{1});

    % Initialize the result matrix
    result = zeros(inputDataNum, nextLayerNeuronNum);

    % Compute the product of the input data and the weights of the next layer
    for i = 1:inputDataNum
        result(i, :) = inputData(i, :) * input2NextLayerWeight{i};
    end

end
