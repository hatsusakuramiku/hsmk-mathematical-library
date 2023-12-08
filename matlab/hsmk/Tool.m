classdef Tool
    % TOOL 工具类
    %   包含一些工具函数，为了提高运算速度工具类中所有函数均不会对输入进行校验，
    %   输入参数的校验由外部调用者进行，为避免用户误用将在注释中注释可接受的参数要求。
    %
    %   Author: HSMK
    %   Date: 2022-11-15
    %   Version: 1.0
    %   Required Matlab Version: 2019a or later and Symbolic Math Toolbox

    methods (Access = public)

        function vector = vector2Area(~, vector, n)
            %VECTOR2AREA 对输入向量按从小到大的顺序进行排序
            %
            % vector = VECTOR2AREA(vector, n)
            %   Inputs
            %       vector - 输入的向量 {mustBeVector, mustBeReal}
            %       n - 输入的向量长度   {mustBeInteger,mustBeGreaterThanOrEqual(n, 2)}
            %   Outputs
            %       vector - 转化后的区间
            % len = length(vector);
            % if len ~= n
            %     throw(MException('MATLAB:vector2Area:InvalidInput', sprintf("输入的向量长度必须与输入 n值 %d 相等！", n)));
            % elseif n == 2 && vector(1) == vector(2)
            %     throw(MException('MATLAB:vector2Area:InvalidInput', '输入区间两端点值不能相等！'));
            % end

            for i = 1:n % 快速冒泡排序，从小到大
                flag = false; % 添加flag变量

                for j = i + 1:n

                    if vector(i) > vector(j)
                        temp = vector(i);
                        vector(i) = vector(j);
                        vector(j) = temp;
                        flag = true; % 标记进行了交换
                    end

                end

                if ~flag % 如果没有进行交换，提前结束排序
                    break;
                end

            end

        end

        function p = spectralRadius(~, Matrix)
            %SPECTRALRADIUS 计算矩阵的谱半径
            %   p = SPECTRALRADIUS(Matrix)
            %   Inputs
            %       Matrix - 输入的矩阵 {mustBeMatrix, mustBeReal}
            %   Outputs
            %       p - 矩阵的谱半径

            % [height, len] = size(Matrix);
            % if height * len >= 100
            %     warning("输入矩阵的维度过大，请检查并修改条件以提高运算速度!");
            % end

            eigenvalues = eig(Matrix); % 调用MATLAB内置函数求矩阵的特征值
            p = max(abs(eigenvalues));
        end

        function matrixCell = rowVector2Col(~, inputCell)
            %ROWVECTOR2COL 将行向量转化为列向量并校验向量长度
            % 将输入的元胞数组中的所有元素从行向量转化为列向量并校验向量长度，
            % 如果转化后的向量的长度不一致，就抛出异常
            %
            %   matrixCell = ROWVECTOR2COL(inputCell)
            %   Inputs
            %       inputCell - 输入的Cell数组 {mustBeCell,mustBeReal}
            %   Outputs
            %       matrixCell - 转化后的Cell数组

            len = length(inputCell);

            % 对第一个元素进行处理
            if size(inputCell{1}, 1) == 1
                inputCell{1} = inputCell{1}';
            end

            row_num = size(inputCell{1}, 1);

            % 对后续元素进行处理
            for i = 2:len

                if size(inputCell{i}, 1) == 1
                    inputCell{i} = inputCell{i}';
                end

                if size(inputCell{i}, 1) ~= row_num
                    throw(MException('MATLAB:Tool:InvalidInput', '输入矩阵的维度不一致，请检查并修改条件'));
                end

            end

            matrixCell = inputCell;
        end

        function matrixCell = colVector2Row(~, inputCell)
            %COLVECTOR2ROW 将列向量转化为行向量并校验向量长度
            % 将输入的元胞数组中的所有元素从列向量转化为行向量并校验向量长度,
            % 如果转化后的向量的长度不一致，就抛出异常
            %
            %   matrixCell = COLVECTOR2ROW(inputCell)
            %   Inputs
            %       inputCell - 输入的Cell数组 {mustBeCell,mustBeReal}
            %   Outputs
            %       matrixCell - 转化后的Cell数组

            len = length(inputCell);

            % 对第一个元素进行处理
            if size(inputCell{1}, 1) ~= 1
                inputCell{1} = inputCell{1}';
            end

            col_num = length(inputCell{1});

            % 对后续元素进行处理
            for i = 2:len

                if size(inputCell{i}, 1) ~= 1
                    inputCell{i} = inputCell{i}';
                end

                if numel(inputCell{i}) ~= col_num
                    throw(MException('MATLAB:Tool:InvalidInput', '输入矩阵的维度不一致，请检查并修改条件'));
                end

            end

            matrixCell = inputCell;
        end

        function result = computeDifference(~, vector1, vector2, accuracy, p, option)
            % computeDifference - 根据指定的范数和精度，计算两个向量的差或者两个向量范数的差
            %
            % result = computeDifference(vector1, vector2, accuracy, p, option)
            %
            % Inputs:
            %    vector1 - 输入的实数向量1 {mustBeReal, mustBeVector}
            %    vector2 - 输入的实数向量2 {mustBeReal, mustBeVector}
            %    accuracy - 误差阈值 {mustBePositive}
            %    p - 范数的阶数 {mustBeScalarOrEmpty, mustBeInteger}
            %    option - 可选参数，决定计算方式 {mustBeScalarOrEmpty}
            %
            % Outputs:
            %    result - 计算结果，当计算值小于accuracy时返回true，否则返回false
            %
            % Example:
            %    vector1 = [1 2 3];
            %    vector2 = [2 3 4];
            %    accuracy = 0.1;
            %    p = 2;
            %    result = computeDifference(vector1, vector2, accuracy, p);
            %    result_with_option = computeDifference(vector1, vector2, accuracy, p, 'option');
            %

            narginchk(4, 6);

            % if ~isequal(length(vector1), length(vector2))
            %     throw(MException('MATLAB:computeDifference:InvalidInput', '输入向量的维度不一致，请检查并修改条件'));
            % end
            % % 检查p是否为有效的范数值
            % if ~(p > 0 || isinf(p))
            %     throw(MException('MATLAB:computeDifference:InvalidInput', '输入的范数阶数不合法，请检查并修改条件'));
            % end

            % 根据输入参数的数量，决定执行哪种计算
            if ~isempty(option) % 如果没有提供可选参数
                diff = norm(vector1 - vector2, p); % 调用MATLAB内置函数求范数
            else % 如果提供了可选参数
                diff = abs(norm(vector1, p) - norm(vector2, p));
            end

            % 根据计算结果和误差阈值，返回结果
            result = (diff < accuracy);
        end

        function x = lenConvert(~, x)
            % LENCONVERT 将输入的cell数组的每个子矩阵的行数统一为最大行数
            %
            %   x = LENCONVERT(x)
            %   Inputs
            %       x - 输入的Cell数组 {mustBeCell,mustBeReal}
            %   Outputs
            %       x - 转化后的Cell数组

            [height, len] = size(x);

            if height ~= 1
                throw(MException('MATLAB:lenCheck:InvalidInput', '输入Cell数组不符合要求'));
            end

            result = zeros(1, len);

            for i = 1:len
                result(i) = numel(x{i});
            end

            maxLen = max(result);

            if any(result(result ~= maxLen) ~= 1)
                throw(MException('MATLAB:lenCheck:InvalidInput', '输入Cell数组不符合要求'));
            end

            for i = 1:len

                if numel(x{i}) ~= maxLen
                    x{i} = padarray(x{i}, [0, maxLen - numel(x{i})], 'replicate', 'post');
                end

            end

        end

        function derivativeCheck(~, fun, center, order)
            % DERIVATIVECHECK 检查输入的公式的导数是否存在(支持向量)
            %
            % derivativeCheck(fun, center, order)
            %
            syms x

            for i = 1:length(fun)
                temp = limit(diff(fun(i), x, order(i)), x, center(i));

                if isinf(temp) || isnan(temp)
                    throw(MException('MATLAB:derivCheck:InvalidInput', sprintf('输入公式 %s 在 %s 处 %d 阶导数不存在！', fun(i), num2str(center(i)), order(i))));
                end

            end

        end

        function valueCheck(~, fun, center)
            % VALUECHECK 检查输入的公式的值是否存在(支持向量)
            %
            % valueCheck(fun, center)
            syms x

            for i = 1:length(fun)
                value = subs(fun(i), x, center(i));

                if ~isreal(value) || ~isfinite(value)
                    throw(MException('MATLAB:valueCheck:InvalidInput', sprintf('输入公式 %s 在 %s 处无定义！', fun(i), num2str(center(i)))));
                end

            end

        end

        function maxLen = maxMatrixLen(~, matrix)
            % MAXMATRIXLEN 获取矩阵的最大行数
            %   max = MAXMATRIXLEN(matrix) 获取矩阵的最大行数
            %   Inputs
            %       matrix - 输入的元胞数组 {mustBeCell}
            %   Outputs
            %       max - 矩阵的最大行数

            [height, len] = size(matrix);

            if height ~= 1 % 要求输入的元胞数组只有一行
                throw(MException('MATLAB:lenCheck:InvalidInput', '输入元胞数组不符合要求'));
            end

            result = zeros(1, len);

            for i = 1:len
                result(i) = numel(matrix{i});
            end

            maxLen = max(result);
        end

        function dV = derivativeVector(~, fun, order)
            % DERIVATIVEVECTOR 计算导数(支持向量)
            %   dV = DERIVATIVEVECTOR(fun, order)
            %   Inputs
            %       fun - 输入的公式 {mustBeUnderlyingType(fittingFunction, 'sym')}
            %       order - 计算导数的阶数 {mustBeInteger}
            %   Outputs
            %       dV - 计算的导数

            syms x
            dV = sym(zeros(1, order + 1));

            for i = 1:order + 1
                dV(i) = diff(fun, x, i);
            end

        end

        function result = vectorFactorial(~, x)
            % VECTORFACTORIAL 计算输入向量的累积
            %   result = VECTORFACTORIAL(x) 计算输入向量的累积
            %   Inputs
            %       x - 输入的向量 {mustBeVector}
            %   Outputs
            %       result - 计算的累积

            result = sym(1);

            for i = 1:length(x)
                result = result * x(i);
            end

        end

        function funCheck(obj, fun, area)
            narginchk(2, 3);
            var = symvar(fun);

            if length(var) > 1
                throw(MException('MATLAB:trapezoidalRule:InvalidInput', sprintf("输入的公式 %s 有多个变量不符合要求", char(fun))));
            end

            if nargin == 3
                obj.valueCheck(fun, area);
            end

        end

        function [fun, area] = varCheck(obj, fun, area, n)
            syms x
            len = length(area);

            if ~isequal(len, n) && ~ismember(len, n)
                error("区间长度必须为%s中的一个", char(n))
            end

            if area(1) == area(end)
                error("区间左端点不能等于右端点")
            end

            obj.vector2Area(area, len);
            obj.funCheck(fun, area);
            fun = subs(fun, symvar(fun), x);

        end

    end

end
