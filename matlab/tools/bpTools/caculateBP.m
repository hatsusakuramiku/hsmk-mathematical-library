function result = caculateBP(inputdata, weights, thresholds, activationFunc)
    % caculateBP - Calculate the output of the BP neural network
    %
    % Inputs:
    %   inputdata - Input data
    %   weights - Weights of the connections from the previous layer to the current layer
    %   thresholds - Thresholds of the current layer
    %   activationFunc - Activation function of the current layer
    %
    % Outputs:
    %   result - Output of the BP neural network
    len = length(weights);
    result = activationFunc(caculateInputTimesWeight(inputdata, weights{1}) - thresholds{1});

    % Loop through the layers of the BP neural network
    for i = 2:len
        result = activationFunc(caculateInputTimesWeight(result, weights{i}) - thresholds{i});
    end

end
