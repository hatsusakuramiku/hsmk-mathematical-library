function g = caculateG(aimOutput, hiddenLayerOutput)
    % caculateG - Compute the gradient factor for the output layer
    %
    % Inputs:
    %   aimOutput - The expected output of the neural network
    %   hiddenLayerOutput - The actual output from the hidden layer
    %
    % Outputs:
    %   g - The gradient factor for the output layer

    % Calculate the gradient factor using the derivative of the sigmoid function
    % and the difference between expected and actual output
    g = hiddenLayerOutput .* (1 - hiddenLayerOutput) .* (aimOutput - hiddenLayerOutput);
end
