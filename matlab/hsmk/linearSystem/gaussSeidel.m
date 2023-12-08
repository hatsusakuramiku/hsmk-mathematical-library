function [iterativeX, iterativeXMatrix] = gaussSeidel(A, b, orginX, accuracy, maxNumber)
    %GAUSSSEIDEL 计算高斯-塞德尔迭代法求解线性方程组
    %   使用谱半径法判断迭代矩阵是否收敛
    % [iterativeX, iterativeXMatrix] = gaussSeidel(A, b, orginX, accuracy, maxNumber)
    %   A - 系数矩阵
    %   b - 常数项
    %   orginX - 初始迭代向量
    %   accuracy - 迭代精度 如不指定值，默认为 0.00001
    %   iterativeX - 迭代结果
    %   iterativeXMatrix - 迭代结果矩阵
    %   maxNumber - 最大迭代次数 如不指定值，则默认为 1500 注意：不收敛的迭代矩阵将在迭代十次后停止运算，此处无法指定其最大迭代次数
    %
    %   Example:
    %       A = [2 1 1; 1 2 1; 1 1 2];
    %       b = [1; 1; 1];
    %       orginX = [0; 0; 0];
    %       accuracy = 0.00001;
    %       [iterativeX, iterativeXMatrix] = gaussSeidel(A, b, orginX, accuracy)
    %
    %   Author: HSMK
    %   Date: 2022-11-01
    %   Version: 1.0
    %   Required Matlab Version: 2019a or later and Symbolic Math Toolbox and class Tool.m

    arguments
        A {mustBeReal}
        b {mustBeReal, mustBeVector}
        orginX {mustBeReal, mustBeVector} = zeros(length(b), 1)
        accuracy {mustBePositive} = 0.00001
        maxNumber {mustBePositive} = 1500
    end

    tool = Tool();
    len = length(orginX);
    narginchk(2, 5);
    nargoutchk(1, 2);
    outCell = tool.rowVector2Col({A, b, orginX}); % 对输入的矩阵进行归一化即将行向量转化为列向量并检查各向量与矩阵的行数是否一致
    A = outCell{1};
    b = outCell{2};
    orginX = outCell{3};
    dMatrix = diag(diag(A));
    lMatrix = tril(A, -1);
    uMatrix = triu(A, 1);
    bMatrix = -1 .* (dMatrix + lMatrix) \ uMatrix;
    fVector = (dMatrix + lMatrix) \ b;
    cutNumber = 0;
    iterativeXMatrix = zeros(len, maxNumber + 1); % 预分配内存
    iterativeXMatrix(:, 1) = orginX;
    iterativeX = orginX;

    spectralRadius = tool.spectralRadius(bMatrix);

    if spectralRadius >= 1 % 计算迭代矩阵的谱半径
        warning("由输入系数的矩阵得到的迭代矩阵的谱半径为 %d > 1，标志其高斯-塞德尔迭代法不收敛，请检查并修改条件，本函数将在迭代十次后停止运算", spectralRadius);
        cutNumber = 10;
    end

    k = 1;

    while (1)

        k = k + 1;
        iterativeX = fVector + bMatrix * iterativeX;
        iterativeXMatrix(:, k) = iterativeX;

        if any((cutNumber ~= 0 && k > cutNumber) | k > maxNumber + 1)
            break;
        end

        if norm(iterativeXMatrix(:, k) - iterativeXMatrix(:, k - 1), 2) < accuracy
            break;
        end

    end

    iterativeXMatrix = iterativeXMatrix(:, 1:k); % 删除预分配但未使用的内存
end
