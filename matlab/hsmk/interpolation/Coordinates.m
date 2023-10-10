classdef Coordinates
properties(Access = protected)
    xCoordinate; % x坐标
    yCoordinate; % y坐标
end

methods(Access = public)
    function coordinates = Coordinates(xCoordinate,yCoordinate)
        if isempty([xCoordinate,yCoordinate]) || any(~isvector(xCoordinate) | ~isvector(yCoordinate)) || ~isequal(numel(xCoordinate),numel(yCoordinate))
            error("输入参数错误！输入坐标不匹配或格式错误！")
        end
        coordinates.xCoordinate = xCoordinate;
        coordinates.yCoordinate = yCoordinate;
    end

    function xCoordinate = getXCoordinate(coordinates)
        xCoordinate = coordinates.xCoordinate;
    end

    function yCoordinate = getYCoordinate(coordinates)
        yCoordinate = coordinates.xCoordinate;
    end
end
end