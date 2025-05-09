clc
clear
close all;

% addpath('E:\\新建文件夹\\毕设\\code\\matlab\\toolboxs');
% addpath('E:\\新建文件夹\\毕设\\code\\matlab\\triangle');
% addpath('E:\\新建文件夹\\毕设\\code\\matlab\\tetrahedron');
% addpath('E:\\Github\hsmk-mathematical-library\\matlab')
% 例如，计算参数M=3,Mf=5的所有解
d = 3;
% M_and_Mf = calculateTriangleMAndMf(d);
% disp('的所有 M 和 Mf 组合: ');
% disp(M_and_Mf);

% for i = 1:size(M_and_Mf,1)
%,  solutions = getTriangleNodes(M_and_Mf(i,1),M_and_Mf(i,2));
%,  disp(['M = ',num2str(M_and_Mf(i,1)),',Mf = ',num2str(M_and_Mf(i,2)),' 的解:']);
%,  printTheSolutions(solutions);
% end
% printTheSolutions(getTriangleNodesByDegree(1));
% printTheSolutions(getTetrahedronNodesByDegree());

% 显示解的数量
% disp(['找到 ',num2str(size(solutions,2)),' 个解']);

% 显示所有解
% printTheSolutions(solutions);
% lambdaOrderValues = getEnableLambdaOrderValues(d,3);
% disp([lambdaOrderValues,generateEquationsBVec(lambdaOrderValues)]);
%% 生成三角形和四面体的等价类并保存在文件中
% syms a b c
% triangle_K1 = sym(generate_permutations_unique([0,0,1]));
% triangle_K2 = sym(generate_permutations_unique([1/2,0,1/2]));
% triangle_K3 = sym(generate_permutations_unique([a,0,1 - a]));
% triangle_K4 = sym([1/3,1/3,1/3]);
% triangle_K5 = sym(generate_permutations_unique([a,a,1 - 2 .* a]));
% triangle_K6 = sym(generate_permutations_unique([a,b,1 - a - b]));
% triangle_symmetric_class_cell = {triangle_K1,triangle_K2,triangle_K3,triangle_K4,triangle_K5,triangle_K6};
% save('./code/matlab/triangle/TriangleSymmetricClass.mat','triangle_symmetric_class_cell');

% tetrahedron_K1 = sym(generate_permutations_unique([0,0,0,1]));
% tetrahedron_K2 = sym(generate_permutations_unique([1/2,0,0,1/2]));
% tetrahedron_K3 = sym(generate_permutations_unique([a,0,0,1 - a]));
% tetrahedron_K4 = sym(generate_permutations_unique([1/3,1/3,0,1/3]));
% tetrahedron_K5 = sym(generate_permutations_unique([a,a,0,1 - 2 .* a]));
% tetrahedron_K6 = sym(generate_permutations_unique([a,b,0,1 - a - b]));
% tetrahedron_K7 = sym([1/4,1/4,1/4,1/4]);
% tetrahedron_K8 = sym(generate_permutations_unique([a,a,a,1 - 3 .* a]));
% tetrahedron_K9 = sym(generate_permutations_unique([a,a,1/2 - a,1/2 - a]));
% tetrahedron_K10 = sym(generate_permutations_unique([a,a,b,1 - 2 .* a - b]));
% tetrahedron_K11 = sym(generate_permutations_unique([a,b,c,1 - a - b - c]));

% tetrahedron_symmetric_class_cell = {tetrahedron_K1,tetrahedron_K2,tetrahedron_K3,tetrahedron_K4,tetrahedron_K5,tetrahedron_K6,tetrahedron_K7,tetrahedron_K8,tetrahedron_K9,tetrahedron_K10,tetrahedron_K11};
% save('./code/matlab/tetrahedron/TetrahedronSymmetricClass.mat','tetrahedron_symmetric_class_cell');

%% 测试
clc
clear
close all;
% degree = 7;
% syms a b c
% t = [a,b,c;
%,   2 .* a,5,6;
%,   7 .* b,8,9];
% lambdaEquation = generateLambdaEquations(getEnableLambdaOrderValues(degree,3));
% disp(lambdaEquation);
% result = lambdaEquation(t(:,1),t(:,2),t(:,3));
M = 3; Mf = 5; Mi = 6; degree = M + Mi - 2;
% M = 3; Mf = 5; Mi = 6;

% for i = 1:length(Mf)
%     printTheSolutions(getTetrahedronNodes(M, Mf(i), Mi(i)));
% end
% printTheSolutions(getTetrahedronNodesByDegree(7));

% tetrahedroNode = getTetrahedronNodes(M, Mf, Mi);
% K_vec = tetrahedroNode{3, 1}';
% % printTheSolutions(tetrahedroNode);
% [equationCell, equationsBvec, lambdaOrderValues] = getTetrahedronEquations(K_vec, degree);
% printEquations(equationCell);
% disp(equationsBvec);
% disp(lambdaOrderValues);
% a = sym((7 - sqrt(13))/18);
% w = sym((29 + 17.*sqrt(13))/1680);
% disp(3.*a.^2.*(1 - 2.*a).*w)
% d = 1:16;

% for i = 1:length(d)
%     lambdaOrderValues = getEnableLambdaOrderValues(d(i), 4);
%     disp(['d = ', num2str(d(i)), ' 的 lambdaOrderValues 的个数：', num2str(size(lambdaOrderValues, 1))]);
%     disp(lambdaOrderValues);
% end
% [1.0; zeta_1 .* zeta_2; zeta_1 .* zeta_2 .* zeta_3; zeta_1 .* zeta_2 .* zeta_3 .* zeta_4; zeta_1 .^ 2 .* zeta_2 .^ 2; zeta_1 .^ 2 .* zeta_2 .^ 2 .* zeta_3; zeta_1 .^ 2 .* zeta_2 .^ 2 .* zeta_3 .* zeta_4; zeta_1 .^ 2 .* zeta_2 .^ 2 .* zeta_3 .^ 2; zeta_1 .^ 2 .* zeta_2 .^ 2 .* zeta_3 .^ 2 .* zeta_4; zeta_1 .^ 3 .* zeta_2 .^ 3; zeta_1 .^ 3 .* zeta_2 .^ 3 .* zeta_3]

% pointsWithwight = sym([0, 0, 0, 1/216;
%                        0, 0, 1/2, 1/54;
%                        0, 0, 1, 1/216;
%                        0, 1/2, 0, 1/108;
%                        0, 1/2, 1/4, 1/27;
%                        0, 1/2, 1/2, 1/108;
%                        1/2, 0, 0, 1/216;
%                        1/2, 0, 1/4, 1/54;
%                        1/2, 0, 1/2, 1/216;
%                        1/2, 1/4, 0, 1/108;
%                        1/2, 1/4, 1/8, 1/27;
%                        1/2, 1/4, 1/4, 1/108]);
% func = @(x, y, z)y;


% result1 = caiculate(func, pointsWithwight);

% function result = caiculate(func, pointsWithwight)
%     result = sum(func(pointsWithwight(:, 1), pointsWithwight(:, 2), pointsWithwight(:, 3) .* pointsWithwight(:, 4)));
% end

% tetrahedron = Tetrahedron([0, 0, 0; 1, 0, 0; 0, 0, 1; 0, 1, 0]);
% tetInt = TetrahedronSimplexIntegral();
% result2 = tetInt.integrate(tetrahedron, func, 'ORDER4POINT23');
% format longE
% disp(['result1 = ', num2str(double(result1)), ', result2 = ', num2str(result2), ', abs(result1 - result2) = ', num2str(abs(double(result1) - result2))])
% disp(tetInt.transformPoints(tetrahedron, Points));
% function order = verifyAlgebraicDegreeForTriangle(integerPointsWithWeight, triangle)
%     count = 0;
%     while true
%         orderMat = find_combinations_equal_optimized(count, 3);
%         lambdaOrderFunc = generateLambdaEquations(orderMat);
%         temp = 0;
%         for i = 1:size(orderMat, 1)
%             temp = temp + lambdaOrderFunc(orderMat(i, 1), orderMat(i, 2));
%         end
%         transedPointsWithWeight = triangle.transformPoints(integerPointsWithWeight);
%     end

% end

% function combinations = find_combinations(p, k)
%     % 找到所有满足 c1 + c2 + ... + ck <= p 的非负整数组合
%     combinations = generate_combinations(p, k);

%     % 填充一个额外的 0 维度以表示总和不足 p 的情况
%     combinations = [combinations, zeros(size(combinations, 1), 1)];
% end

% function res = generate_combinations(remaining_sum, num_remaining)

%     if num_remaining == 0
%         res = [];
%         return;
%     end

%     if num_remaining == 1
%         res = (0:remaining_sum)';
%         return;
%     end

%     res = {};

%     for i = 0:remaining_sum
%         sub = generate_combinations(remaining_sum - i, num_remaining - 1);

%         for s = 1:size(sub, 1)
%             res{end + 1, 1} = [i, sub(s, :)];
%         end

%     end

%     res = cell2mat(res);
% end

% function combinations = find_combinations_equal_optimized(p, k)

%     if p < 0 || k <= 0
%         error('p 必须是非负数，k 必须是正整数');
%     end

%     % 预估组合数量（组合数学：C(p + k - 1, k - 1)）
%     maxCombinations = nchoosek(p + k - 1, k - 1);
%     combinations = zeros(maxCombinations, k); % 预分配空间
%     count = 0;

%     stack = {struct('current', [], 'remain_sum', p, 'remain_k', k)};

%     while ~isempty(stack)
%         current = stack{end};
%         stack(end) = [];

%         if current.remain_k == 0

%             if current.remain_sum == 0
%                 count = count + 1;
%                 combinations(count, :) = current.current;
%             end

%             continue;
%         end

%         for i = 0:current.remain_sum
%             stack = [stack; struct('current', [current.current, i], ...
%                                            'remain_sum', current.remain_sum - i, ...
%                                            'remain_k', current.remain_k - 1)];
%         end

%     end

%     combinations = combinations(1:count, :); % 去除多余行
% end
% triangle = Triangle([0, 0; 1, 0; 0, 1]);
% triangleInt = TriangleSimplexIntegral();
% result2 = triangleInt.integrate(triangle, func, 'ORDER10POINT30');
% format longE
% disp(['result1 = ', num2str(double(result1)), ', result2 = ', num2str(result2), ', abs(result1 - result2) = ', num2str(abs(double(result1) - result2))])
format long
Points = [0.5773502692, 0.5773502692, 0.5773502692;
          0.5773502692, 0.5773502692, -0.5773502692;
          0.5773502692, -0.5773502692, 0.5773502692;
          0.5773502692, -0.5773502692, -0.5773502692;
          -0.5773502692, 0.5773502692, 0.5773502692;
          -0.5773502692, 0.5773502692, -0.5773502692;
          -0.5773502692, -0.5773502692, 0.5773502692;
          -0.5773502692, -0.5773502692, -0.5773502692];
x = (Points(:, 1) + 1)./2;
y = ( (1 - Points(:, 1)) .* (1 + Points(:, 2)))./4;
z = ((1 - Points(:, 1)).* (1 - Points(:, 2)).* (1 + Points(:, 3)))./8;
w = ((1 - Points(:,1)).^2.*(1 - Points(:,2)))./64;
disp([x, y, z, w])