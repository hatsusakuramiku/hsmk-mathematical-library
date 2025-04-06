function newWeight = updateWeight(oldWeight, currentLayerE, beforeLayerOutput, learnRate)
    % updateWeight - Update weights of the connection from the previous layer to the current layer
    %
    % Inputs:
    %   oldWeight - Old weights of the connection from the previous layer to the current layer
    %   currentLayerE - Gradient of the cost function with respect to the output of the current layer
    %   beforeLayerOutput - Output of the previous layer
    %   learnRate - Learning rate
    %
    % Outputs:
    %   newWeight - New weights of the connection from the previous layer to the current layer
    [inputDataNum, ~] = size(currentLayerE); % 输入数据个数
    newWeight = cell(1, inputDataNum);

    for i = 1:inputDataNum
        % Compute the error of the current layer times the output of the previous layer
        % and add it to the old weights to get the new weights
        newWeight{i} = oldWeight{i} + learnRate * transpose(currentLayerE(i, :)) * beforeLayerOutput(i, :); % 更新权重
    end

end
