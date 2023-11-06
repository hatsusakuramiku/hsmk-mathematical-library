classdef Coordinates
properties(Access = protected)
    xCoordinate; % x坐标
    yCoordinate; % y坐标
end

methods(Access = public)
    function coordinates = Coordinates(xCoordinate,yCoordinate)
        arguments
            xCoordinate {mustBeVector,mustBeReal} = 0
            yCoordinate {mustBeVector,mustBeReal} = 0
        end
        if ~isequal(numel(xCoordinate),numel(yCoordinate))
            error("输入参数错误！输入坐标不匹配！")
        end
        coordinates.xCoordinate = xCoordinate;
        coordinates.yCoordinate = yCoordinate;
    end

    function xCoordinate = getXCoordinate(coordinates)
        xCoordinate = coordinates.xCoordinate;
    end

    function yCoordinate = getYCoordinate(coordinates)
        yCoordinate = coordinates.yCoordinate;
    end
end
end