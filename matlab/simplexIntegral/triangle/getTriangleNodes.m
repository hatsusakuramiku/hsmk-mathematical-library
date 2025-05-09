function solutions = getTriangleNodes(M, Mf)
    %GETTRIANGLENODES Finds solutions for given M and Mf parameters
    % This function calculates the degree based on M and Mf, checks if it
    % is within a supported range, and finds solutions using the helper
    % function getTriangleNodes_base.
    %
    % Inputs:
    %   M  - An integer parameter related to the problem
    %   Mf - An integer parameter related to the problem
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
    end

    if M > Mf
        error("M must be less than or equal to Mf!");
    end

    % Calculate the degree based on M and Mf
    degree = M + Mf - 2;

    if degree == 0
        degree = 1;
    end

    % Check if the degree is within the supported range
    if degree > 12
        error("This function only supports that M + M_f - 2 <= 12 !");
    end

    % Calculate the minimum and maximum number of nodes
    min_node_num = (M + 1) * (M + 2) / 2;

    if degree ~= M
        max_node_num = (degree + 1) * (degree + 1) / 2;
    else
        max_node_num = (degree + 2) * (degree + 2) / 2;
    end

    temp_solutions = [];

    % Iterate over the possible number of nodes
    for i = min_node_num:max_node_num
        % Attempt to find solutions with the current number of nodes
        temp_solutions = getTriangleNodes_base(M, Mf, i, degree);

        % If solutions are found, exit the loop
        if ~isempty(temp_solutions)
            break;
        end

    end

    % Return the solutions if found, otherwise return an empty cell array
    if ~isempty(temp_solutions)
        solutions = {[degree, i]; [M, Mf]; temp_solutions};
    else
        solutions = {};
    end

end

function solutions = getTriangleNodes_base(M, Mf, F, d)
    % 解决整数规划问题：
    % F = 3K_1 + 3K_2 + 6K_3 + K_4 + 3K_5 + 6K_6
    % 约束条件：
    % AK <= -b
    % 3K_1 + 3K_2 + 6K_3 = 3M
    % K_4 + 3K_5 + 6K_6 = (M_f - 2)(M_f - 1)/2
    % K_1 = 1
    %
    % 输入:
    % M, Mf - 问题参数
    % F - 目标函数的给定值
    %
    % 输出:
    % solutions - 6xn矩阵，每列代表一个解 [K_1; K_2; K_3; K_4; K_5; K_6]
    %             如果没有满足条件的解，返回空矩阵

    if d == 0
        solutions = [];
        return;
    end

    equation_num = d + 1;
    unkown_num_vec = [1; 2; 1; 2; 3];

    % 定义约束矩阵A和向量b
    A = [1, 0, 0, 0, 0, 0;
         0, 1, 0, 0, 0, 0;
         0, 0, 0, 1, 0, 0;
         -1, -1, -2, -1, -2, -3;
         0, 0, 0, -1, -2, -3;
         0, 0, -2, 0, 0, -3;
         0, 0, 0, 0, 0, -3];

    B = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1;
         -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1;
         -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1;
         1, 2, 3, 4, 5, 7, 8, 10, 12, 14, 16, 19, 21, 24;
         0, 0, 1, 1, 2, 3, 4, 5, 7, 8, 10, 12, 14, 16;
         0, 0, 0, 0, 0, 1, 1, 2, 3, 4, 5, 7, 8, 10;
         0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 3, 4, 5; ];

    b = B(:, d);
    % 根据条件K_1 = 1，计算其他变量需要满足的范围
    K1 = 1;

    % 一个辅助函数来检查约束条件是否满足
    function valid = checkConstraints(K)
        % 检查AK <= -b
        if any(A * K' > -b)
            valid = false;
            return;
        end

        % 检查3K_1 + 3K_2 + 6K_3 = 3M
        if 3 * K(1) + 3 * K(2) + 6 * K(3) ~= 3 * M
            valid = false;
            return;
        end

        % 检查K_4 + 3K_5 + 6K_6 = (M_f - 2)(M_f - 1)/2
        if K(4) + 3 * K(5) + 6 * K(6) ~= (Mf - 2) * (Mf - 1) / 2
            valid = false;
            return;
        end

        % 检查K_1 = 1
        if K(1) ~= 1
            valid = false;
            return;
        end

        % 检查目标函数值是否等于给定的F
        if 3 * K(1) + 3 * K(2) + 6 * K(3) + K(4) + 3 * K(5) + 6 * K(6) ~= F
            valid = false;
            return;
        end

        valid = true;
    end

    % 根据约束条件计算可能的解的范围

    % 从K_1 = 1开始
    K = zeros(1, 6);
    K(1) = 1;

    % 根据3K_1 + 3K_2 + 6K_3 = 3M，计算K_2和K_3的范围
    % 3 + 3K_2 + 6K_3 = 3M
    % K_2 + 2K_3 = M - 1

    % 根据K_4 + 3K_5 + 6K_6 = (M_f - 2)(M_f - 1)/2，计算K_4，K_5，K_6的范围

    % 设置变量范围
    % K_1已经固定为1
    K2_max = M - 1; % 当K_3 = 0时，K_2最大值
    K3_max = floor((M - 1) / 2); % 当K_2 = 0时，K_3最大值，需要向下取整确保是整数

    second_constraint_value = (Mf - 2) * (Mf - 1) / 2;
    K4_max = floor(second_constraint_value); % 当K_5 = K_6 = 0时，K_4最大值
    K5_max = floor(second_constraint_value / 3); % 当K_4 = K_6 = 0时，K_5最大值
    K6_max = floor(second_constraint_value / 6); % 当K_4 = K_5 = 0时，K_6最大值

    % 存储所有符合条件的解
    solutions = [];

    % 穷举所有可能的解
    for K2 = 0:K2_max

        for K3 = 0:K3_max
            % 检查第一个方程是否满足
            if 3 * K(1) + 3 * K2 + 6 * K3 ~= 3 * M
                continue;
            end

            for K4 = 0:K4_max

                for K5 = 0:K5_max

                    for K6 = 0:K6_max
                        % 检查第二个方程是否满足
                        if K4 + 3 * K5 + 6 * K6 ~= second_constraint_value
                            continue;
                        end

                        % 创建完整的解向量
                        K_test = [K1, K2, K3, K4, K5, K6];

                        % 检查所有约束，包括目标函数值是否等于F
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

        end

    end

end
