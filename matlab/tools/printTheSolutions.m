function printTheSolutions(solutions)
    %PRINTTHESOLUTIONS  Print the solutions of the triangle problem
    %
    %   printTheSolutions(solutions) prints the solutions of the triangle
    %   problem. The input solutions is a cell array, where each element is a
    %   solution. Each solution is a cell array, where the first element is the
    %   times and nodes of the solution, and the second element is the matrix of
    %   the solution.
    %
    %   The function prints the number of solutions, and for each solution, the
    %   times and nodes of the solution, and the matrix of the solution.
    if isempty(solutions)
        disp('没有找到解');
    else
        disp(['找到 ', num2str(size(solutions, 2)), ' 个解集']);

        for i = 1:size(solutions, 2)
            order_and_nodes = solutions{1, i};
            M_and_Mf = solutions{2, i};
            solution = solutions{3, i};

            if length(M_and_Mf) == 2
                disp(['第 ', num2str(i), ' 个解集, ', '次数 d = ', num2str(order_and_nodes(1)), ', 节点数 N = ', ...
                          num2str(order_and_nodes(2)), ', M = ', num2str(M_and_Mf(1)), ', Mf = ', ...
                          num2str(M_and_Mf(2)), ', 所有满足条件的解共有 ', num2str(size(solution, 2)), ' 个, 解矩阵为: ']);
            elseif length(M_and_Mf) == 3
                disp(['第 ', num2str(i), ' 个解集, ', '次数 d = ', num2str(order_and_nodes(1)), ', 节点数 N = ', ...
                          num2str(order_and_nodes(2)), ', M = ', num2str(M_and_Mf(1)), ', Mf = ', ...
                          num2str(M_and_Mf(2)), ', Mi = ', num2str(M_and_Mf(3)), ', 所有满足条件的解共有 ', num2str(size(solution, 2)), ' 个, 解矩阵为: ']);
            else
                error('M_and_Mf 的长度应该为 2 或 3 !');
            end

            disp(solution);
        end

    end

end
