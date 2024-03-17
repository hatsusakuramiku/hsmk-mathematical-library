function [result, intervalMatrix, t] = heunMethod(fun, orginX, orginY, height, maxStep)

    arguments
        fun {mustBeUnderlyingType(fun, 'sym')}
        orginX {mustBeReal}
        orginY {mustBeReal}
        height {mustBeGreaterThan(height, 0)}
        maxStep {mustBeInteger, mustBeGreaterThanOrEqual(maxStep, 1)} = 2
    end

    syms x y
    var = symvar(fun);

    if length(var) ~= 2
        error("函数必须是二元函数")
    end

    t = ismember(var, "y");

    if isAlways(t == 0)
        warning("函数中必须不包含 y ，无法确定迭代变量，或将导致计算错误，请考虑将迭代变量替换为 y")
        fun = subs(fun, var, [x, y]);
    else
        fun = subs(fun, var(t == 0), x);
    end

    xVector = [orginX, height .* (1:1:maxStep)];
    intervalMatrix = zeros(maxStep + 1, 2);
    t = zeros(maxStep, 1);
    intervalMatrix(1) = orginY;

    for i = 1:maxStep

        t(i) = intervalMatrix(i, 1) + height * subs(fun, [x, y], [xVector(i), intervalMatrix(i, 1)]);
        intervalMatrix(i + 1, 1) = intervalMatrix(i, 1) + (height / 2) * (subs(fun, [x, y], [xVector(i), intervalMatrix(i, 1)]) + subs(fun, [x, y], [xVector(i + 1), t(i)]));

    end

    intervalMatrix(:, 2) = xVector';
    result = intervalMatrix(end, 1);

end
