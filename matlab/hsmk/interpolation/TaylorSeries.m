classdef TaylorSeries < Interpolation
    properties(Access = private)
        center; % 展开式的中心
        remainder; % 余项
        accuracy; % 拟合精度，需为正数
        polynomiaVector;
    end
end

