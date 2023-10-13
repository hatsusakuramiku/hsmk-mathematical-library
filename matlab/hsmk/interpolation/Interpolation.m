classdef Interpolation
    properties(Access = protected)
        fittingFunction; % 拟合函数
        order; % 拟合阶次
        polynomial; % 拟合多项式
        fittingError; % 拟合误差
        accuracy; % 拟合精度，需为正数，若不指定则默认未0.0001
    end

    properties (Constant,Access = protected)
        x = sym('x'); % 常量
    end

    properties(Dependent,Access = protected)
        tempFittingFunction; % 临时拟合函数
    end

    methods
        function tempFittingFunction = get.tempFittingFunction(interpolation)
            % 修改输入的公式的符号以方便计算
            % @Attribute #tempFittingFunction 的值依赖于 @Attribute #fittingFunction
            % 类中调用 @Attribute #tempFittingFunction 时检查 @Attribute #fittingFunction 的值，如果 @Attribute #fittingFunction 为空则 @Attribute #tempFittingFunction 为空
            % 如果 @Attribute #fittingFunction 不为空则 使用"sym('x')"替换 @Attribute #fittingFunction 中的符号并赋值给 @Attribute #tempFittingFunction
            if ~isempty(interpolation.fittingFunction)
                tempFittingFunction = subs(interpolation.fittingFunction,symvar(interpolation.fittingFunction),interpolation.x);
            else
                tempFittingFunction = [];
            end
        end
    end

    methods(Access = public)
        function interpolation = Interpolation(fittingFunction, order, accuracy)
            % @Class #Interpolation 的构造函数
            interpolation.fittingFunction = [];
            interpolation.order = [];
            interpolation.accuracy = [];
            if abs(nargin) == 1
                interpolation.fittingFunction = fittingFunction;
            elseif abs(nargin) == 2
                if isempty(order) || numel(order) ~= 1 || fix(order) ~= order
                    error("输入参数错误！ 请确保输入阶数是非负整数！")
                end
                interpolation.fittingFunction =fittingFunction;
                interpolation.order = order;
            elseif abs(nargin) == 0
            elseif abs(nargin) == 3
                interpolation.fittingFunction =fittingFunction;
                interpolation.order = order;
                interpolation.accuracy = accuracy;
            else
                error("输入参数过多！")
            end
        end
    end

    methods(Access = protected)
        function sum = factorial(n, xCoordinate, varargin)
            syms x;
            % 类内部函数,用于计算连乘或阶乘
            numArgs = abs(nargin);
            sum = sym(1);
            switch numArgs
                case 0
                    % 使用"interpolation.factorial"会至少输入一个参数"@Param #interpolation"
                    % 如果仅有一个输入参数就输出一个空的矩阵或数组
                    waring("无额外参数输入，未进行计算，将返回一个空的矩阵或数组！")
                    sum = [];
                case 1
                    % 调用MATLAB中"factorial(n)"计算"n"的阶乘，其函数已有检错功能，此处不再另加
                    sum = sum .* factorial(n);
                case 2
                    % 此处"n"为输入的 @Param #xCoordinate 的长度 - 1，即输入的x坐标向量中元素个数 - 1，"k"为输入参数 @Param #n，其中$ x_{i} $ 是@Param #xCoordinate 中的元素
                    % 如果@Param #n为空，则计算 $  \prod_{ i = 0 }^{n} (x-x_{i})  $
                    % 如果@Param #n不为空，则计算 $ \prod_{\begin{matrix} i = 0\\ i\ne k \end{matrix}}^{n} (x-x_{i}) $
                    judgement = prejudgeN(n,xCoordinate);
                    if judgement == 0
                        for i = 1:length(xCoordinate)
                            sum = sum * (x - xCoordinate(i));
                        end
                        sum = simplify(sum);
                        return
                    else
                        for i = setdiff(1:length(xCoordinate), n)
                            sum = sum * (x - xCoordinate(i));
                        end
                    end
                case 3
                    % 此处"n"为输入的 @Param #xCoordinate 的长度 - 1，即输入的x坐标向量中元素个数 - 1，"k"为输入参数 @Param #n ,其中$ x_{i} $ 是@Param #xCoordinate 中的元素
                    % 可输入 1 个可选参数
                    % 可选参数及用法
                    % ExceptN 计算 $ \prod_{\begin{matrix} i = 0\\ i\ne k \end{matrix}}^{n} (x_{k}-x_{i}) $
                    % SerialProd 依次计算输入数组的前 n 项之积 ，即输入数组"A = [arg1,arg2,arg3], n = 3 ",返回值就为"sum = arg1 * arg 2 * arg 3"，如输入 n 值为空默认输出第一个
                    % SerialProdAll 依次计算输入数组的前 n 项之积组成的数组 ，即输入数组"A = [arg1,arg2,arg3], n = 3 ",返回值就为"sum = [arg1, arg1 * arg 2, arg1 * arg 2 * arg 3]",如输入 n 值为空就计算全部
                    option = {'ExceptN','SerialProd','SerialProdAll'}; % 暂时仅 2 个可选参数，后续可能会添加其他可选参数
                    judgement = prejudgeN(n,xCoordinate);
                    if isempty(varargin)
                        warning("输入可选参数为空，将使用输入的 前三个参数进行计算！")
                        sum = factorial(n, xCoordinate);
                    else
                        if ~length(varargin) == 1
                            error("输入可选参数过多，只能接受一个可选参数！");
                        elseif ismember(varargin{1},option)
                            index = find(A == varargin{1});
                            switch(index)
                                case 1
                                    if judgement == 0
                                        error("输入数组索引为空！")
                                    else
                                        for i = setdiff(1:length(xCoordinate), n)
                                            sum = sum * (xCoordinate(n) - xCoordinate(i));
                                        end
                                    end

                                case 2
                                    if judgement == 0
                                        sum = xCoordinate(1);
                                    else
                                        sum = pord(xCoordinate(1:n));
                                    end

                                case 3
                                    if judgement == 0
                                        len = length(xCoordinate);
                                    else
                                        len = n;
                                    end
                                    sumVector = sym(ones(1,len));
                                    for i = 1:1:length(sumVector)
                                        sumVector(i) = pord(xCoordinate(1:i));
                                    end
                                    sum = sum .* sumVector;

                                otherwise
                                    sum  = [];
                            end
                        else
                            error("可选参数输入错误！");
                        end
                    end
                otherwise
                    error("输入的参数数目不正确！");
            end
        end

        function judgement = prejudgeN(n,xCoordinate)
            judgement = 1;
            if isempty(n)
                judgement = 0;
            elseif numel(n) ~= 1 || n <= 0 || fix(n) ~= n || n > length(xCoordinate)
                error("输入参数错误或超出数组索引！ 请确保输入参数为非负整数且小于数组长度！")
            else
                if length(unique(xCoordinate)) ~= length(xCoordinate)
                    warning("数组中存在两个或多个相同元素，可能导致返回值为0！")
                end
            end
        end
    end
end