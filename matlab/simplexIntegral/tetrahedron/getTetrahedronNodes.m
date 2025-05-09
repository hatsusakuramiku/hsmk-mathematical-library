function solutions = getTetrahedronNodes(M, Mf, Mi)
    %GETTETRAHEDRONNODES Finds solutions for given M, Mf, and Mi parameters
    % This function calculates the degree based on M and Mf, checks if it
    % is within a supported range, and finds solutions using the helper
    % function solveIntegerProgram.
    %
    % Inputs:
    %   M  - An integer parameter related to the problem
    %   Mf - An integer parameter related to the problem
    %   Mi - An integer parameter related to the problem
    %
    % Outputs:
    %   solutions - A cell array where the first element is a vector
    %               containing the degree and node count, and the second
    %               element is a matrix of solutions if they exist,
    %               otherwise an empty cell array
    % Outputs example:
    %   result = {[degree, node_count];[M, Mf];[solution1; solution2; ...]}
    arguments
        M {mustBeScalarOrEmpty, mustBeInteger, mustBeNonnegative}
        Mf {mustBeScalarOrEmpty, mustBeInteger, mustBeNonnegative}
        Mi {mustBeScalarOrEmpty, mustBeInteger, mustBeNonnegative}
    end

    if M < 1 || M > Mf || Mf > Mi
        error('M must be greater than or equal to 1, less than or equal to Mf, and less than or equal to Mi!');
    end

    degree = M + Mi - 2;

    if degree == 0
        degree = 1;
    end

    if degree > 12
        error('This function only supports that M + M_i - 2 <= 12 !');
    end

    min_node_num = calcuateNodeNum(M, Mf, Mi);

    if degree ~= M
        max_node_num = calcuateNodeNum(M + 1, Mf + 1, Mi + 1);
    else
        max_node_num = calcuateNodeNum(M + 2, Mf + 2, Mi + 2);
    end

    temp_solutions = [];

    for i = min_node_num:max_node_num
        % Attempt to find solutions with the current number of nodes
        temp_solutions = solveIntegerProgram(M, Mf, Mi, i);

        % If solutions are found, exit the loop
        if ~isempty(temp_solutions)
            break;
        end

    end

    % Return the solutions if found, otherwise return an empty cell array
    if ~isempty(temp_solutions)
        solutions = {[degree, i]; [M, Mf, Mi]; temp_solutions};
    else
        solutions = {};
    end

end

function solutions = solveIntegerProgram(M, Mf, Mi, F)
    % 解决整数规划问题：
    % F = 4K_1 + 6K_2 + 12K_3 + 4K_4 + 12K_5 + 24K_6 + K_7 + 4K_8 + 6K_9 + 12K_10 + 24K_11
    % 约束条件：
    % AK <= -b
    % 4K1 + 6K_2 + 12K_3 = 4 + 6(M-1)
    % 4K_4 + 12K_5 + 24K_6 = 2(M_f - 2)(M_f - 1)
    % K_7 + 4K_8 + 6K_9 + 12K_10 + 24K_11 = (M_i-3)(M_i-2)(M_i-1)/6
    % K_1 = 1  (额外条件)
    %
    % 输入:
    % Mi, M, Mf - 问题参数
    % F - 目标函数的给定值
    %
    % 输出:
    % solutions - 11xn矩阵，每列代表一个解 [K_1; K_2; ...; K_11]
    %             如果没有满足条件的解，返回空矩阵

    unkown_num_vec = [1; 1; 2; 1; 2; 3; 1; 2; 2; 3; 4];
    degree = M + Mi - 2;

    if degree == 0
        degree = 1;
    end

    equation_num = degree + 1;
    % 定义约束矩阵A和向量b
    A = [
         1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
         0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
         0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0;
         -1, -1, -2, -1, -2, -3, -1, -2, -2, -3, -4;
         0, 0, 0, -1, -2, -3, -1, -2, -2, -3, -4;
         0, 0, -2, 0, 0, -3, -1, -2, -2, -3, -4;
         0, 0, 0, 0, 0, 0, -1, -2, -2, -3, -4;
         0, -1, -2, 0, -2, -3, 0, 0, -2, -3, -4;
         -1, 0, -2, -1, -2, -3, 0, -2, 0, -3, -4;
         0, 0, 0, 0, 0, -3, 0, 0, 0, 0, -4;
         0, 0, 0, 0, 0, -3, -1, -2, -2, -3, -4;
         0, 0, 0, 0, -2, -3, 0, 0, -2, -3, -4;
         0, 0, 0, -1, -2, -3, 0, -2, 0, -3, -4;
         0, 0, -2, 0, 0, -3, 0, 0, -2, -3, -4;
         0, 0, -2, 0, 0, -3, 0, -2, 0, -3, -4;
         0, 0, 0, 0, 0, 0, 0, 0, -2, -3, -4;
         0, 0, 0, 0, 0, 0, 0, -2, 0, -3, -4;
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -4;
         0, 0, -2, 0, -2, -3, 0, 0, 0, -3, -4;
         0, 0, 0, 0, 0, -3, 0, 0, -2, -3, -4;
         0, 0, 0, 0, 0, -3, 0, -2, 0, -3, -4;
         0, 0, 0, 0, -2, -3, 0, 0, 0, -3, -4;
         0, 0, -2, 0, 0, -3, 0, 0, 0, -3, -4;
         0, 0, 0, 0, 0, 0, 0, 0, 0, -3, -4;
         0, 0, 0, 0, 0, -3, 0, 0, 0, -3, -4
         ];

    B = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1;
         -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1;
         -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1;
         -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1;
         1, 2, 3, 5, 6, 9, 11, 15, 18, 23, 27, 34;
         0, 0, 1, 2, 3, 5, 7, 10, 13, 17, 21, 27;
         0, 0, 0, 1, 1, 3, 4, 7, 9, 13, 16, 22;
         0, 0, 0, 1, 1, 2, 3, 5, 6, 9, 11, 15;
         0, 0, 0, 1, 1, 3, 4, 7, 9, 13, 16, 22;
         0, 0, 1, 2, 3, 5, 7, 10, 13, 17, 21, 27;
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
         0, 0, 0, 1, 1, 2, 3, 5, 7, 10, 13, 18;
         0, 0, 0, 0, 0, 1, 2, 4, 6, 9, 12, 17;
         0, 0, 0, 0, 1, 2, 4, 6, 9, 12, 16, 21;
         0, 0, 0, 0, 0, 0, 0, 2, 3, 6, 8, 13;
         0, 0, 0, 0, 0, 1, 2, 4, 6, 9, 12, 17;
         0, 0, 0, 0, 0, 0, 0, 1, 1, 3, 4, 7;
         0, 0, 0, 0, 0, 0, 1, 2, 3, 5, 7, 10;
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 1, 2, 4, 6, 9, 12, 17;
         0, 0, 0, 0, 0, 0, 0, 1, 2, 4, 6, 10;
         0, 0, 0, 0, 0, 0, 1, 2, 4, 6, 9, 13;
         0, 0, 0, 0, 0, 0, 1, 2, 4, 6, 9, 13;
         0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 6, 10;
         0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 4;
         0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 4, 7];
    b = B(:, degree);
    % 检查输入参数的有效性
    if Mi < Mf || Mf < M || M < 1 || F <= 1
        warning('Invalid parameters: Mi>=Mf>=M>=1, F>1 must be satisfied.');
        solutions = zeros(11, 0);
        return;
    end

    % 计算方程组的右边常数值
    eq1_value = 4 + 6 * (M - 1);
    eq2_value = 2 * (Mf - 2) * (Mf - 1);
    eq3_value = (Mi - 3) * (Mi - 2) * (Mi - 1) / 6;

    % 由于K_1 = 1的限制，更新第一个方程
    % 4*1 + 6K_2 + 12K_3 = 4 + 6(M-1)
    % 6K_2 + 12K_3 = 4 + 6(M-1) - 4 = 6(M-1)
    % K_2 + 2K_3 = M-1
    modified_eq1_value = eq1_value - 4; % 减去K_1=1的贡献

    % 一个辅助函数来检查约束条件是否满足
    function valid = checkConstraints(K)
        % 确保K_1 = 1
        if K(1) ~= 1
            valid = false;
            return;
        end

        % 检查AK <= -b
        if any(A * K' > -b)
            valid = false;
            return;
        end

        % 检查4K1 + 6K_2 + 12K_3 = 4 + 6(M-1)
        if 4 * K(1) + 6 * K(2) + 12 * K(3) ~= eq1_value
            valid = false;
            return;
        end

        % 检查4K_4 + 12K_5 + 24K_6 = 2(M_f - 2)(M_f - 1)
        if 4 * K(4) + 12 * K(5) + 24 * K(6) ~= eq2_value
            valid = false;
            return;
        end

        % 检查K_7 + 4K_8 + 6K_9 + 12K_10 + 24K_11 = (M_i-3)(M_i-2)(M_i-1)/6
        if K(7) + 4 * K(8) + 6 * K(9) + 12 * K(10) + 24 * K(11) ~= eq3_value
            valid = false;
            return;
        end

        % 检查目标函数值是否等于给定的F
        obj_value = 4 * K(1) + 6 * K(2) + 12 * K(3) + 4 * K(4) + 12 * K(5) + 24 * K(6) + ...
            K(7) + 4 * K(8) + 6 * K(9) + 12 * K(10) + 24 * K(11);

        if obj_value ~= F
            valid = false;
            return;
        end

        valid = true;
    end

    % 计算各变量的可能范围以减少搜索空间

    % 第一个方程（已考虑K_1=1）：6K_2 + 12K_3 = 6(M-1)
    % 从这个方程推导K2, K3的上限
    K2_max = floor(modified_eq1_value / 6);
    K3_max = floor(modified_eq1_value / 12);

    % 第二个方程：4K_4 + 12K_5 + 24K_6 = 2(M_f - 2)(M_f - 1)
    % 从这个方程推导K4, K5, K6的上限
    K4_max = floor(eq2_value / 4);
    K5_max = floor(eq2_value / 12);
    K6_max = floor(eq2_value / 24);

    % 第三个方程：K_7 + 4K_8 + 6K_9 + 12K_10 + 24K_11 = (M_i-3)(M_i-2)(M_i-1)/6
    % 从这个方程推导K7, K8, K9, K10, K11的上限
    K7_max = floor(eq3_value);
    K8_max = floor(eq3_value / 4);
    K9_max = floor(eq3_value / 6);
    K10_max = floor(eq3_value / 12);
    K11_max = floor(eq3_value / 24);

    % 存储所有符合条件的解
    solutions = [];

    % 使用更高效的搜索策略
    % 寻找满足第一个方程的所有整数解（K_1=1固定）
    eq1_solutions = findEquationSolutions1(modified_eq1_value, [6, 12], [K2_max, K3_max]);

    % 寻找满足第二个方程的所有整数解
    eq2_solutions = findEquationSolutions(eq2_value, [4, 12, 24], [K4_max, K5_max, K6_max]);

    % 寻找满足第三个方程的所有整数解
    eq3_solutions = findEquationSolutions(eq3_value, [1, 4, 6, 12, 24], [K7_max, K8_max, K9_max, K10_max, K11_max]);

    % 遍历所有可能的解组合
    for i = 1:size(eq1_solutions, 2)

        for j = 1:size(eq2_solutions, 2)

            for k = 1:size(eq3_solutions, 2)
                % 构建完整的解向量，K_1=1
                K_test = [1, eq1_solutions(:, i)', eq2_solutions(:, j)', eq3_solutions(:, k)'];

                % 计算目标函数值
                obj_value = 4 * K_test(1) + 6 * K_test(2) + 12 * K_test(3) + 4 * K_test(4) + ...
                    12 * K_test(5) + 24 * K_test(6) + K_test(7) + 4 * K_test(8) + ...
                    6 * K_test(9) + 12 * K_test(10) + 24 * K_test(11);

                % 如果目标函数值不等于F，跳过此解
                if obj_value ~= F
                    continue;
                end

                % 检查所有约束条件
                if checkConstraints(K_test)
                    unkown_num = sum(unkown_num_vec .* K_test);

                    if unkown_num > equation_num
                        continue;
                    end

                    solutions = [solutions, K_test']; %#ok<AGROW>
                end

            end

        end

    end

    % 如果没有找到解，返回空矩阵
    if isempty(solutions)
        solutions = [];
    end

end

function solutions = findEquationSolutions1(target, coeffs, max_values)
    % 辅助函数：找到满足第一个线性方程的所有非负整数解（K_1=1已固定）
    solutions = findSolutionsRecursive(target, coeffs, max_values, [], 1);
end

function solutions = findEquationSolutions(target, coeffs, max_values)
    % 辅助函数：找到满足线性方程的所有非负整数解
    solutions = findSolutionsRecursive(target, coeffs, max_values, [], 1);
end

function solutions = findSolutionsRecursive(target, coeffs, max_values, current_solution, idx)
    % 递归查找满足线性方程的所有非负整数解

    % 初始化解矩阵
    solutions = [];

    % 基础情况：已处理所有变量
    if idx > length(coeffs)

        if target == 0
            solutions = current_solution';
        end

        return;
    end

    % 当前变量的系数
    coeff = coeffs(idx);

    % 确定当前变量的上限
    max_val = min(floor(target / coeff), max_values(idx));

    % 遍历当前变量的所有可能值
    for val = 0:max_val
        % 更新剩余目标值
        new_target = target - coeff * val;

        % 更新当前解
        new_solution = [current_solution, val];

        % 递归处理下一个变量
        sub_solutions = findSolutionsRecursive(new_target, coeffs, max_values, new_solution, idx + 1);

        % 合并解
        if ~isempty(sub_solutions)
            solutions = [solutions, sub_solutions]; %#ok<AGROW>
        end

    end

end

function node_num = calcuateNodeNum(M, Mf, Mi)
    node_num = ceil(6 .* M - 2 + 2 .* (Mf - 2) .* (Mf - 1) + (Mi - 3) .* (Mi - 2) .* (Mi - 1) ./ 6);
end
