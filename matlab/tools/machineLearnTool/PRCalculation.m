function [P, R, F_1, F_beta] = PRCalculation(confusionMatrix, varargin)
    %PRCALCULATION 根据传入的混淆矩阵计算查准率 P 与查全率 R
    %   输入参数:
    %   confusionMatrix:混淆矩阵，格式为 [TP, FN; FP, TN]
    %   beta: 可选参数，默认为 1
    %
    %   输出参数:
    %   P: 查准率
    %   R: 查全率
    %   F_1: F1-score
    %   F_beta: F-beta-score
    %
    %   使用示例:
    %   [P, R, F_1, F_beta] = PRCalculation(confusionMatrix)
    %   [P, R, F_1, F_beta] = PRCalculation(confusionMatrix,'beta',2)

    % 检查输入参数类型和范围，确保 confusionMatrix 是一个 2x2 矩阵，且其元素为非负整数。
    arguments
        confusionMatrix (2, 2) {mustBeInteger, mustBeNonnegative}
    end

    % 检查可变参数，确保 beta 参数为实数。
    arguments (Repeating)
        varargin
    end

    % 创建参数解析器并添加 beta 参数，默认值为 1。
    p = inputParser;
    addParameter(p, 'beta', 1, @isreal);
    parse(p, varargin{:});
    beta = p.Results.beta;

    % 检查 beta 参数是否为正数。
    if beta <= 0
        error('beta must be positive');
    end

    % 计算查准率 P，查全率 R，F1-score 和 F-beta-score。
    P = confusionMatrix(1, 1) / (confusionMatrix(1, 1) + confusionMatrix(2, 1));
    R = confusionMatrix(1, 1) / (confusionMatrix(1, 1) + confusionMatrix(1, 2));
    F_1 = 2 * P * R / (P + R);
    F_beta = (1 + beta ^ 2) * P * R / (beta ^ 2 * P + R);
end
