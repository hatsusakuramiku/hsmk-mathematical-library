classdef Interpolation

    properties (Access = protected)
        order; % 拟合多项式的阶数
        accuracy; % 计算精度
    end

    methods (Access = public)

        function interpolation = Interpolation(order, accuracy)
            % INTERPOLATION 构造函数
            %   interpolation = INTERPOLATION(fittingFunction, order, accuracy) 创建 Interpolation 对象。
            %   fittingFunction 是要拟合的函数，order 是拟合多项式的阶数，accuracy 是计算精度。
            %   如果没有提供 accuracy 参数，则使用默认值 0.0001。

            arguments
                order (1, :) {mustBeInteger} = 1
                accuracy (1, :) {mustBePositive} = 0.001
            end

            interpolation.order = order;
            interpolation.accuracy = accuracy;
        end

        function order = getOrder(interpolation)
            % 获取拟合阶数
            order = interpolation.order;
        end

        function accuracy = getAccuracy(interpolation)
            % 获取计算精度
            accuracy = interpolation.accuracy;
        end

    end

end
