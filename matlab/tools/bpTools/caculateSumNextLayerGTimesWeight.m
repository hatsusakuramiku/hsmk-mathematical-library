function sumNextLayerGTimesWeight = caculateSumNextLayerGTimesWeight(nextLayerG, nextLayerWeight)
    % caculateSumNextLayerGTimesWeight - Compute the sum of the gradient of the next layer times the weights of the next layer
    %
    % Inputs:
    %   nextLayerG - Gradient of the cost function with respect to the output of the next layer
    %   nextLayerWeight - Weights of the next layer
    %
    % Outputs:
    %   sumNextLayerGTimesWeight - Sum of the gradient of the next layer times the weights of the next layer
    [inputDataNum, ~] = size(nextLayerG); % 输入数据个数
    [currentNeuronNum, ~] = size(nextLayerWeight{1});
    sumNextLayerGTimesWeight = zeros(inputDataNum, currentNeuronNum);

    for i = 1:inputDataNum
        % Compute the sum of the gradient of the next layer times the weights of the next layer
        sumNextLayerGTimesWeight(i, :) = nextLayerG(i, :) * transpose(nextLayerWeight{i});
    end

end
