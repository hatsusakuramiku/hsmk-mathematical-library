function [P, R, F_1, F_beta] = mPRCalculation(confusionMatrixVector, varargin)
    %mPRCalculation  Compute macro/micro precision and recall from a vector of confusion matrices
    %   Inputs:
    %       confusionMatrixVector: A vector of confusion matrices, where each matrix is a 2x2
    %           matrix containing true positives, false negatives, false positives, and true
    %           negatives. The  format of each matrix is [TP, FN; FP, TN].
    %       varargin: Optional parameters, including:
    %           'beta': The beta value to use for the F_beta score (default: 1)
    %           'macro': A boolean indicating whether to compute macro averages (default: true)
    %           'micro': A boolean indicating whether to compute micro averages (default: false)
    %   Outputs:
    %       P: The macro/micro precision
    %       R: The macro/micro recall
    %       F_1: The macro/micro F1 score
    %       F_beta: The macro/micro F_beta score
    %
    %   If 'macro' is true and 'micro' is false, the function returns the macro averages.
    %   If 'micro' is true and 'macro' is false, the function returns the micro averages.
    %   If both 'macro' and 'micro' are true, the function returns both macro and micro
    %       averages in a 1x2 vector.
    %   If both 'macro' and 'micro' are false, the function returns the values for the first
    %       confusion matrix in the vector.
    %
    %mPRCalculation 从混淆矩阵向量计算宏/微查准率和查全率
    % Inputs:
    %   confusionMatrixVector: 一个包含混淆矩阵的向量，每个矩阵都是一个2x2矩阵，其中包含真正例，假反例，假正例，真反例。
    %       格式为 [TP, FN; FP, TN]
    %   varargin: 可选参数，包括：
    %       'beta': 用于F_beta得分的beta值（默认值：1）
    %       'macro': 一个布尔值，指示是否计算宏平均（默认值：true）
    %       'micro': 一个布尔值，指示是否计算微平均（默认值：false）
    %
    % Outputs:
    %   P: 宏/微查准率
    %   R: 宏/微查全率
    %   F_1: 宏/微F1
    %   F_beta: 宏/微F_beta
    %
    % 如果'macro'为true且'micro'为false，则函数返回宏平均值。
    % 如果'micro'为true且'macro'为false，则函数返回微平均值。
    % 如果'macro'和'micro'都为true，则函数返回宏和微平均值，以1x2向量的形式返回。
    % 如果'macro'和'micro'都为false，则函数返回向量中第一个混淆矩阵的值。
    arguments
        confusionMatrixVector (:, 2, 2) {mustBeInteger, mustBeNonnegative}
    end

    arguments (Repeating)
        varargin
    end

    p = inputParser;
    addParameter(p, 'beta', 1, @isreal);
    addParameter(p, 'macro', true, @islogical);
    addParameter(p, 'micro', false, @islogical);
    parse(p, varargin{:});
    beta = p.Results.beta;
    macro = p.Results.macro;
    micro = p.Results.micro;

    if beta <= 0
        error('beta must be positive');
    end

    [len, ~, ~] = size(confusionMatrixVector);

    if macro || micro
        temp_mat = zeros(2, 2);

        if macro && ~micro
            % Compute macro averages
            for i = 1:len
                temp_mat = temp_mat + squeeze(confusionMatrixVector(i, 1:2, 1:2));
            end

            [P, R, F_1, F_beta] = PRCalculation(temp_mat, 'beta', beta);
            return
        end

        temp = zeros(4, 2);

        if micro && ~macro
            % Compute micro averages
            for i = 1:len
                [P, R, F_1, F_beta] = PRCalculation(squeeze(confusionMatrixVector(i, 1:2, 1:2)), 'beta', beta);
                temp(1, 2) = temp(1, 2) + P;
                temp(2, 2) = temp(2, 2) + R;
                temp(3, 2) = temp(3, 2) + F_1;
                temp(4, 2) = temp(4, 2) + F_beta;
            end

            P = temp(1, 1) / len;
            R = temp(2, 1) / len;
            F_1 = temp(3, 1) / len;
            F_beta = temp(4, 1) / len;
            return
        end

        % Compute both macro and micro averages
        for i = 1:len
            temp_mat = temp_mat + squeeze(confusionMatrixVector(i, 1:2, 1:2));
            [P, R, F_1, F_beta] = PRCalculation(squeeze(confusionMatrixVector(i, 1:2, 1:2)), 'beta', beta);
            temp(1, 2) = temp(1, 2) + P;
            temp(2, 2) = temp(2, 2) + R;
            temp(3, 2) = temp(3, 2) + F_1;
            temp(4, 2) = temp(4, 2) + F_beta;
        end

        [temp(1, 1), temp(2, 1), temp(3, 1), temp(4, 1)] = PRCalculation(temp_mat, 'beta', beta);
        temp(:, 2) = temp(:, 2) / len;
        P = temp(1, :);
        R = temp(2, :);
        F_1 = temp(3, :);
        F_beta = temp(4, :);
        return
    else
        % Compute values for the first confusion matrix in the vector
        [P, R, F_1, F_beta] = PRCalculation(squeeze(confusionMatrixVector(1, 1:2, 1:2)), 'beta', beta);
        return
    end

end
