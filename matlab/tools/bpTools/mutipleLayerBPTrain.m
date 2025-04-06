function [multipleBPFunc, lastErr, weights, threshold, iterNum] = mutipleLayerBPTrain(inputData, aimOutput, varargin) % BP神经网络训练函数
    %SINGLELAYERBPTRAIN 多隐层经典BP神经网络训练函数
    %   说明: 多隐层经典BP神经网络训练函数，使用梯度下降法训练，激活函数固定为sigmoid函数。为防止陷入局部极小值，加入早停机制，
    %   即每隔固定次迭代，计算误差，如果误差小于设定的早停精度，则停止迭代。
    %
    %   注意: 因使用sigmoid函数作为激活函数，故输入数据与目标输出需在[0, 1]之间，否则会导致训练出现异常。
    %
    %   [multipleBPFunc, lastErr, weights, threshold, iterNum] = SINGLELAYERBPTRAIN(inputData, aimOutput, varargin)
    %   输入参数：
    %       inputData (:, :) {mustBeReal, mustBeNonempty} % 输入数据，行数为样本数，列数为输入维度
    %       aimOutput (:, :) {mustBeReal, mustBeNonempty} % 目标输出，行数为样本数，列数为输出维度
    %       varargin  % 可选参数
    %   可选参数：
    %       learnRate  % 学习率， 默认为0.1
    %       maxIterNum  % 最大迭代次数， 默认为1e9
    %       accuracy  % 精度， 默认为1e-9
    %       hiddenNeuronNum  % 隐藏层神经元数量， 默认为ceil(sqrt(inputDataDim + aimOutputDim)) + 5，若不指定则所有隐藏层神经元数量相同且均为默认值，
    %       若需要指定不同的隐藏层的神经元数量，则必须同时指定所有隐藏层的神经元数量，需将隐藏层神经元数量以vector的形式传入，如hiddenNeuronNum = [10, 20, 30]，
    %       则表示第一层隐藏层有10个神经元，第二层隐藏层有20个神经元，第三层隐藏层有30个神经元；
    %       earlyStopAccuracy  % 早停精度， 默认为1e-9
    %       earlyStopIterNum  % 早停迭代间隔次数， 默认为100
    %       hiddenLayerNum  % 隐藏层数量， 默认为2
    %   输出参数：
    %       multipleBPFunc function_handle % 单隐层BP神经网络计算函数，格式为 output = multipleBPFunc(input)，input为输入数据，output为输出数据。
    %       输入数据的大小必须与训练数据一致，输出数据的大小与目标输出一致。
    %       lastErr   % 迭代完成时的最终误差
    %       weights {:, :}  % 权重矩阵的元胞数组，依次为输入层到隐藏层，隐藏层到输出层的权重矩阵。为提高可扩展性，权重矩阵以元胞数组的形式存储，其次序与输入参数的顺序一致。
    %       threshold {:, :}  % 阈值矩阵的元胞数组， 依次为输入层到隐藏层，隐藏层到输出层的阈值矩阵。为提高可扩展性，阈值矩阵以元胞数组的形式存储，其次序与输入参数的顺序一致。
    %       iterNum   % 迭代次数，停止迭代时的迭代次数
    %   示例：
    %       inputData = [1 2 3; 4 5 6; 7 8 9];
    %       aimOutput = [10 11 12; 13 14 15; 16 17 18];
    %       [multipleBPFunc, lastErr, weights, threshold, iterNum] = singleLayerBPTrain(inputData, aimOutput);
    %       [multipleBPFunc, lastErr, weights, threshold, iterNum] = singleLayerBPTrain(inputData, aimOutput, "learnRate", 0.01);% 设置学习率为0.01
    %       output = multipleBPFunc(inputData);
    arguments
        inputData (:, :) {mustBeReal, mustBeNonempty} % 输入数据
        aimOutput (:, :) {mustBeReal, mustBeNonempty} % 目标输出
    end

    arguments (Repeating)
        varargin
    end

    parames = inputParser; % 参数解析器

    [inputDataNum, inputDataDim] = size(inputData);
    [aimOutputNum, aimOutputDim] = size(aimOutput);

    addParameter(parames, 'learnRate', 0.1, @isreal); % 学习率
    addParameter(parames, 'maxIterNum', 1e9, @isreal); % 最大迭代次数
    addParameter(parames, 'accuracy', 1e-9, @isreal); % 精度
    addParameter(parames, 'hiddenNeuronNum', ceil(sqrt(inputDataDim + aimOutputDim)) + 5, @isreal); % 隐藏层神经元数量
    addParameter(parames, 'earlyStopAccuracy', 1e-9, @isreal); % 早停精度
    addParameter(parames, 'earlyStopIterNum', 100, @isreal); % 早停迭代间隔次数
    addParameter(parames, 'hiddenLayerNum', 2, @isreal); % 隐藏层数量

    parse(parames, varargin{:});

    % 注册参数
    learnRate = parames.Results.learnRate;
    maxIterNum = parames.Results.maxIterNum;
    accuracy = parames.Results.accuracy;
    hiddenNeuronNum = parames.Results.hiddenNeuronNum;
    earlyStopAccuracy = parames.Results.earlyStopAccuracy;
    earlyStopIterNum = parames.Results.earlyStopIterNum;
    hiddenLayerNum = parames.Results.hiddenLayerNum;

    % 参数检查

    if inputDataNum ~= aimOutputNum
        error('输入数据与目标输出数据数量不一致');
    end

    if any([learnRate, maxIterNum, accuracy, earlyStopAccuracy, earlyStopIterNum] <= 0)
        error('learnRate, maxIterNum, accuracy, earlyStopAccuracy, earlyStopIterNum 必须大于0');
    end

    if ceil(maxIterNum) ~= maxIterNum || ceil(earlyStopIterNum) ~= earlyStopIterNum
        error('maxIterNum 和 earlyStopIterNum 必须为整数');
    end

    if hiddenLayerNum < 1
        error('hiddenLayerNum 必须大于等于1');
    end

    if any(hiddenNeuronNum <= 0)
        error('hiddenNeuronNum 必须大于等于1');
    end

    if isscalar(hiddenNeuronNum)
        hiddenNeuronNum = repmat(hiddenNeuronNum, 1, hiddenLayerNum);
    elseif length(hiddenNeuronNum) ~= hiddenLayerNum
        error('hiddenNeuronNum 的长度必须等于 hiddenLayerNum');
    end

    % 初始化参数
    activateFunc = @(x) 1 ./ (1 + exp(-x)); % 激活函数
    input2HiddenWeights = cell(1, hiddenLayerNum); % 输入层到隐藏层的权重
    input2HiddenBias = cell(1, hiddenLayerNum); % 隐藏层的阈值
    input2HiddenWeights{1} = cellfun(@(x) rand(inputDataDim, hiddenNeuronNum(1)), cell(1, inputDataNum), 'UniformOutput', false);
    input2HiddenBias{1} = rand(inputDataNum, hiddenNeuronNum(1));

    for i = 2:hiddenLayerNum
        input2HiddenWeights{i} = cellfun(@(x) rand(hiddenNeuronNum(i - 1), hiddenNeuronNum(i)), cell(1, inputDataNum), 'UniformOutput', false);
        input2HiddenBias{i} = rand(inputDataNum, hiddenNeuronNum(i));
    end

    hidden2OutputWeight = cellfun(@(x) rand(hiddenNeuronNum(end), aimOutputDim), cell(1, inputDataNum), 'UniformOutput', false); % 隐藏层到输出层的权重
    hidden2OutputBias = rand(inputDataNum, aimOutputDim); % 输出层的阈值
    hiddenLayerOutput = cell(1, hiddenLayerNum); % 隐藏层的输出
    earlyStopDistanceErr = 1e9;

    iterNum = 0; % 迭代次数

    for iter = 1:maxIterNum
        % 前向传播
        hiddenLayerOutput{1} = activateFunc(caculateInputTimesWeight(inputData, input2HiddenWeights{1}) - input2HiddenBias{1}); % 隐藏层的输出

        for i = 2:hiddenLayerNum
            hiddenLayerOutput{i} = activateFunc(caculateInputTimesWeight(hiddenLayerOutput{i - 1}, input2HiddenWeights{i}) - input2HiddenBias{i}); % 隐藏层的输出
        end

        hiddenLayer2OutputLayer = activateFunc(caculateInputTimesWeight(hiddenLayerOutput{end}, hidden2OutputWeight) - hidden2OutputBias); % 输出层的输出

        % 计算误差
        averageErr = sum((aimOutput - hiddenLayer2OutputLayer) .^ 2, "all") / (2 * inputDataNum); % 计算误差
        lastErr = averageErr;
        disp(["迭代次数：", iter, " 误差：", num2str(averageErr)]);
        % 反向传播
        g = caculateG(aimOutput, hiddenLayer2OutputLayer); % 计算输出层梯度因子
        e = cell(1, hiddenLayerNum);
        e{end} = caculateE(hiddenLayerOutput{end}, g, hidden2OutputWeight);

        for i = hiddenLayerNum - 1:-1:1
            e{i} = caculateE(hiddenLayerOutput{i}, e{i + 1}, input2HiddenWeights{i + 1});
        end

        % 更新权重和阈值
        hidden2OutputWeight = updateWeight(hidden2OutputWeight, hiddenLayer2OutputLayer, g, learnRate); % 更新隐藏层到输出层的权重
        input2HiddenWeights{1} = updateWeight(input2HiddenWeights{1}, inputData, e{i}, learnRate);

        for i = 2:1:hiddenLayerNum
            input2HiddenWeights{i} = updateWeight(input2HiddenWeights{i}, hiddenLayerOutput{i - 1}, e{i}, learnRate); % 更新输入层到隐藏层的权重
        end

        hidden2OutputBias = hidden2OutputBias - learnRate * g; % 更新输出层的阈值

        for i = 1:hiddenLayerNum
            input2HiddenBias{i} = input2HiddenBias{i} - learnRate * e{i}; % 更新隐藏层的阈值
        end

        % 判断是否满足精度要求
        if averageErr <= accuracy
            break;
        end

        if mod(iter, earlyStopIterNum) == 0 && iter > 1

            if abs(earlyStopDistanceErr - averageErr) <= earlyStopAccuracy
                break;
            end

            earlyStopDistanceErr = averageErr;
        end

        iterNum = iterNum + 1; % 迭代次数加1
    end

    weights = cell(1, hiddenLayerNum + 1);
    threshold = cell(1, hiddenLayerNum + 1);

    for i = 1:hiddenLayerNum
        weights{i} = input2HiddenWeights{i};
        threshold{i} = input2HiddenBias{i};
    end

    weights{end} = hidden2OutputWeight;
    threshold{end} = hidden2OutputBias;
    multipleBPFunc = @(x) caculateBP(x, weights, threshold, activateFunc);
end
