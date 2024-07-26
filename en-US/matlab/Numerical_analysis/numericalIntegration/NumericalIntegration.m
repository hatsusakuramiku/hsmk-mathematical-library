classdef NumericalIntegration

    methods (Access = public)

        function result = trapezoidalRule(obj, fun, area, option)

            arguments
                obj
                fun {mustBeUnderlyingType(fun, 'sym')}
                area {mustBeVector, mustBeReal}
                option {mustBeMember(option, [1, 2])} = 1
            end

            syms x
            [fun, area] = obj.varCheck(fun, area, 2);
            height = area(2) - area(1);
            result = (height / 2) * (subs(fun, x, area(1)) + subs(fun, x, area(2)));

            if option == 2
                result = double(result);
            end

        end

        function result = simpsonRule(obj, fun, area, option)

            arguments
                obj
                fun {mustBeUnderlyingType(fun, 'sym')}
                area {mustBeVector, mustBeReal}
                option {mustBeMember(option, [1, 2])} = 1
            end

            syms x

            [fun, area] = obj.varCheck(fun, area, [2, 3]);

            if length(area) == 2
                area = [area(1), (area(1) + area(2)) / 2, area(2)];
            end

            if abs(area(2) - area(1)) ~= abs(area(3) - area(2))
                error("区间间隔必须相等")
            end

            height = abs(area(2) - area(1));
            result = (height / 3) * (subs(fun, x, area(1)) + 4 * subs(fun, x, area(2)) + subs(fun, x, area(3)));

            if option == 2
                result = double(result);
            end

        end

        function result = compositeTrapRule(obj, fun, area, n, option)

            arguments
                obj
                fun {mustBeUnderlyingType(fun, 'sym')}
                area {mustBeVector, mustBeReal}
                n {mustBeInteger, mustBeGreaterThanOrEqual(n, 2)} = 2
                option {mustBeMember(option, [1, 2])} = 1
            end

            syms x

            obj.varCheck(fun, area, 2);
            height = (area(2) - area(1)) / n;
            result = height * sum(subs(fun, x, area(1):height:area(2))) - (height / 2) * (subs(fun, x, area(1)) + subs(fun, x, area(2)));

            if option == 2
                result = double(result);
            end

        end

        function result = compositeSimpRule(obj, fun, area, n, option)

            arguments
                obj
                fun {mustBeUnderlyingType(fun, 'sym')}
                area {mustBeVector, mustBeReal}
                n {mustBeInteger, mustBeGreaterThanOrEqual(n, 2)} = 2
                option {mustBeMember(option, [1, 2])} = 1
            end

            syms x
            obj.varCheck(fun, area, 2);
            height = (area(2) - area(1)) / (2 * n);
            vector = area(1):height:area(2);
            len = length(vector);
            odd = vector(2:2:len -1);
            even = vector(3:2:len -2);
            result = (height / 3) * (subs(fun, x, area(1)) + subs(fun, x, area(2)) + 4 * sum(subs(fun, x, odd)) + 2 * sum(subs(fun, x, even)));

            if option == 2
                result = double(result);
            end

        end

    end

    methods (Hidden)

        function [fun, area] = varCheck(~, fun, area, n)
            narginchk(3, 4);
            syms x
            tool = Tool();
            len = length(area);

            if ~isequal(len, n) && ~ismember(len, n)
                error("区间长度必须为%s中的一个", char(n))
            end

            if area(1) == area(end)
                error("区间左端点不能等于右端点")
            end

            tool.vector2Area(area, len);
            tool.funCheck(fun, area);
            fun = subs(fun, symvar(fun), x);

        end

    end

end
