classdef Tool

    methods (Access = public)

        function x = lenConvert(~, x)
            % LENCONVERT 将输入的cell数组的每个子矩阵的行数统一为最大行数
            arguments
                ~
                x {mustBeUnderlyingType(x, 'cell')}
            end

            narginchk(2, 2);
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
            % DERIVATIVECHECK 检查输入的公式的导数是否存在
            %% 可选
            % arguments
            %     ~
            %     fun (1,1) {mustBeUnderlyingType(fun,'sym')}
            %     center(1,1) double {mustBeReal}
            %     order (1,1) {mustBeInteger} = 1
            %% end
            syms x
            narginchk(1, 4);

            for i = 1:length(fun)
                temp = limit(diff(fun(i), x, order(i)), x, center(i));

                if isinf(temp) || isnan(temp)
                    throw(MException('MATLAB:derivCheck:InvalidInput', sprintf('输入公式 %s 在 %s 处 %d 阶导数不存在！', fun(i), num2str(center(i)), order(i))));
                end

            end

        end

        function valueCheck(~, fun, center)
            % VALUECHECK 检查输入的公式的值是否存在
            %% 可选
            % arguments
            %     ~
            %     fun (1, 1) {mustBeUnderlyingType(fun, 'sym')}
            %     center (1, 1) double {mustBeReal}
            %% end
            syms x

            for i = 1:length(fun)
                value = subs(fun(i), x, center(i));

                if ~isAlways(value) || ~isfinite(value)
                    throw(MException('MATLAB:valueCheck:InvalidInput', sprintf('输入公式 %s 在 %s 处无定义！', fun(i), num2str(center(i)))));
                end

            end

        end

        function maxLen = maxMatrixLen(~, matrix)
            % MAXMATRIXLEN 获取矩阵的最大行数
            %   max = MAXMATRIXLEN(matrix) 获取矩阵的最大行数
            arguments
                ~
                matrix {mustBeUnderlyingType(matrix, 'cell')}
            end

            [height, len] = size(matrix);

            if height ~= 1
                throw(MException('MATLAB:lenCheck:InvalidInput', '输入Cell数组不符合要求'));
            end

            result = zeros(1, len);

            for i = 1:len
                result(i) = numel(matrix{i});
            end

            maxLen = max(result);
        end

        function dV = derivativeVector(~, fun,order)
            % DERIVATIVEVECTOR 计算导数
            %% 可选
            % arguments
            %     ~
            %     fun (1,1) {mustBeUnderlyingType(fun,'sym')}
            %     order (1,1) {mustBeInteger} = 1
            %% end
            syms x
            dV = sym(zeros(1, order + 1));
            for i = 1:order + 1
                dV(i) = diff(fun, x, i);
            end
        end

        function xVector = xVectorProd(~, xCoordinate)
            % XVECTORPROD 计算向量
            %   xVector = XVECTORPROD(xCoordinate) 计算向量
            syms x
            vector = x - xCoordinate;
            xVector = cumprod(vector);
        end

    end

end
