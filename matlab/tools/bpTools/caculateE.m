function e = caculateE(currentLayerOutput, nextLayerG, nextLayerWeight)
    % caculateE - Compute the gradient of the cost function with respect to the
    %             output of the current layer
    %
    % Inputs:
    %   currentLayerOutput - Output of the current layer
    %   nextLayerG - Gradient of the cost function with respect to the output of
    %                the next layer
    %   nextLayerWeight - Weights of the next layer
    %
    % Outputs:
    %   e - Gradient of the cost function with respect to the output of the
    %       current layer
    sumNextLayerGTimesWeight = caculateSumNextLayerGTimesWeight(nextLayerG, nextLayerWeight); % Calculate the sum of the gradient of the next layer times the weights of the next layer
    e = currentLayerOutput .* (1 - currentLayerOutput) .* sumNextLayerGTimesWeight;
end
