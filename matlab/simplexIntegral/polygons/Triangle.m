classdef Triangle < TwoDimPolygon

    methods (Access = public)

        function obj = Triangle(vertices)
            % Construct a Triangle from a set of vertices.
            %
            % @param vertices    the vertices of the triangle
            % @throws error if the vertices do not form a valid triangle
            if (size(vertices, 1) ~= 3)
                error('The number of vertices must be 3');
            end

            obj = obj@TwoDimPolygon(vertices);
        end

        function isValid = isRightVertices(~, vertices)
            % Checks if the given vertices form a valid triangle.
            %
            % A valid triangle must satisfy the following conditions:
            % 1. The number of vertices must be 3
            % 2. The vertices must not be duplicate
            % 3. The vertices must not be collinear
            %
            % @param vertices    the vertices to check
            % @return true if the vertices form a valid triangle, false otherwise
            if isempty(vertices) || size(vertices, 1) ~= 3
                isValid = false;
                return;
            end

            x1 = vertices(1, 1);
            y1 = vertices(1, 2);
            x2 = vertices(2, 1);
            y2 = vertices(2, 2);
            x3 = vertices(3, 1);
            y3 = vertices(3, 2);

            % Check if the vertices are duplicate
            if (x1 == x2 && y1 == y2) || (x1 == x3 && y1 == y3) || (x2 == x3 && y2 == y3)
                isValid = false;
                return;
            end

            % Calculate the cross product of the two vectors formed by the vertices
            v1x = x2 - x1;
            v1y = y2 - y1;
            v2x = x3 - x1;
            v2y = y3 - y1;

            isValid = (v1x * v2y ~= v1y * v2x); % 判断是否共线
        end

    end

    methods (Access = protected)

        function area = calculateArea(obj)
            area = abs(det([1, 1, 1; obj.vertices'])) / 2.0;
        end

    end

end
