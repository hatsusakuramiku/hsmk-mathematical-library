classdef Coordinates

    properties (Access = protected)
        xCoordinate; % x坐标
        yCoordinate; % y坐标
    end

    methods (Access = public)

        function coordinates = Coordinates(xCoordinate, yCoordinate)

            arguments
                xCoordinate {mustBeVector, mustBeReal} % x坐标,必须为实数
                yCoordinate {mustBeVector, mustBeReal} % y坐标,必须为实数
            end

            % 判断坐标向量长度是否相等
            if ~isequal(numel(xCoordinate), numel(yCoordinate))
                error("输入参数错误！输入坐标不匹配！")
            end

            coordinates.xCoordinate = xCoordinate;
            coordinates.yCoordinate = yCoordinate;
        end

        function xCoordinate = getXCoordinate(coordinates)
            % 获取x坐标
            xCoordinate = coordinates.xCoordinate;
        end

        function yCoordinate = getYCoordinate(coordinates)
            % 获取y坐标
            yCoordinate = coordinates.yCoordinate;
        end

    end

end
