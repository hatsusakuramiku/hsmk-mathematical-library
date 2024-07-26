clc
clear
close all

true_fun_1 = @(x, y)sin(pi .* x) .* sin(pi .* y);
true_fun_2 = @(x, y)cos(pi .* x) .* cos(pi .* y);
fun_1 = @(x, y)2 .* pi ^ 2 .* sin(pi .* x) .* sin(pi .* y);
fun_2 = @(x, y)2 .* pi ^ 2 .* cos(pi .* x) .* cos(pi .* y);
xRange = [0, 1];
yRange = [0, 1];
xNum = 100;
yNum = 100;
h_1 = (xRange(2) - xRange(1)) / xNum;
h_2 = (yRange(2) - yRange(1)) / yNum;
xVec = xRange(1):h_1:xRange(2);
yVec = yRange(1):h_2:yRange(2);
total = (xNum - 1) * (yNum - 1);
lenx = xNum - 1;
leny = yNum - 1;
[xMatrix, yMatrix] = meshgrid(xVec,yVec);
true_Matrix_1 = true_fun_1(xMatrix,yMatrix);
true_Matrix_2 = true_fun_2(xMatrix,yMatrix);
% 区间为[0, 1]x[0, 1] gamma_1(1) 为底边，gamma_1(2) 为右边，gamma_1(3) 为顶边，gamma_1(4) 为左边（即逆时针）
gamma_1 = {@(x, y)0, @(x, y)0, @(x, y)0, @(x, y)0}; % 问题1的边界
gamma_2 = {@(x, y)cos(pi .* x), @(x, y) - cos(pi .* y), @(x, y) - cos(pi .* x), @(x, y)cos(pi .* y)}; % 问题2的边界

u_1Vector = zeros(total, 1);
u_2Vector = zeros(total, 1);
pCell_1 = cell(5, total);
pCell_2 = cell(5, total);
fCell_1 = cell(1, total);
fCell_2 = cell(1, total);
aMatrix_1 = zeros(total, total);
aMatrix_2 = zeros(total, total);
fVector_1 = zeros(total, 1);
fVector_2 = zeros(total, 1);

for i = 1:lenx

    for j = 1:leny
        index = (j - 1) * lenx + i;
        fCell_1{index} = @(x, y)fun_1(xVec(i) + h_1 .* x, yVec(j) + h_2 .* y) .* h_1 .* h_2 .* x .* y;
        fVector_1(index) = integral2(fCell_1{index}, 0, 1, 0, 1);
    end

end

figure(1)
mesh(xMatrix,yMatrix,true_Matrix_1);
figure(2)
mesh(xMatrix,yMatrix,true_Matrix_2);