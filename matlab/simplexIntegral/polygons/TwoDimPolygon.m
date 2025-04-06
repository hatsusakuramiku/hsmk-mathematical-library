classdef TwoDimPolygon < handle
    %TWODIMPOLYGON Abstract class representing a two-dimensional polygon
    %   This class provides basic functionality for handling two-dimensional
    %   polygons, including methods to set and get vertices, calculate area,
    %   and check the validity of the polygon's vertices.

    properties (Access = protected)
        vertices(:, 2){mustBeReal, mustBeFinite} % The vertices of the polygon
        area {mustBeReal, mustBeFinite} % The area of the polygon
    end

    methods (Abstract, Access = protected)
        calculateArea(obj)
        % Abstract method to calculate the area of the polygon.
        % This method must be implemented by subclasses.
    end

    methods (Access = public)

        function obj = TwoDimPolygon(vertices)
            % Construct a TwoDimPolygon from a set of vertices.
            %
            % @param vertices    the vertices of the polygon
            % @param verticesNum the number of vertices

            if nargin == 0
                % Default constructor
                return;
            end

            if ~obj.isRightVertices(vertices)
                error('Invalid vertices');
            end

            % Create a copy of the vertices array
            obj.vertices = vertices(:, :);

            % Calculate the area of the polygon
            obj.area = obj.calculateArea();
        end

        function area = getArea(obj)
            % Returns the area of the polygon.
            %
            % @return the area of the polygon
            area = obj.area;
        end

        function vertices = getVertices(obj)
            % Returns the vertices of the polygon.
            %
            % @return the vertices of the polygon
            vertices = obj.vertices;
        end

        function setVertices(obj, vertices)
            % Sets the vertices of the polygon and recalculates its area.
            %
            % The vertices must form a valid polygon. If the vertices are invalid, an
            % error is thrown.
            %
            % @param vertices the new vertices to set
            % @throws error if the vertices do not form a valid polygon
            if ~obj.isRightVertices(vertices)
                error('Invalid vertices');
            end

            obj.vertices = vertices;
            obj.area = obj.calculateArea();
        end

        function isValid = isRightVertices(obj, vertices)
            % Checks if the given vertices are valid for a two-dimensional polygon.
            %
            % A valid polygon must satisfy the following conditions:
            % 1. The number of vertices must be greater than or equal to 3
            % 2. The vertices must not be duplicate
            % 3. The edges must not intersect
            %
            % @param vertices the vertices to check
            % @return true if the vertices are valid, false otherwise
            isValid = true;

            if size(vertices, 1) < 3
                isValid = false;
                return;
            end

            if obj.hasDuplicateVertices(vertices)
                isValid = false;
                return;
            end

            if obj.hasIntersectingEdges(vertices)
                isValid = false;
                return;
            end

        end

    end

    methods (Access = protected)

        function hasDuplicate = hasDuplicateVertices(~, vertices)
            % Checks if the given vertices contain any duplicate points.
            %
            % @param vertices the vertices to check
            % @return true if any two points are the same, false otherwise
            hasDuplicate = false;

            for i = 1:size(vertices, 1)

                for j = i + 1:size(vertices, 1)

                    if vertices(i, 1) == vertices(j, 1) && vertices(i, 2) == vertices(j, 2)
                        hasDuplicate = true;
                        return;
                    end

                end

            end

        end

        function hasIntersect = hasIntersectingEdges(obj, vertices)
            % Checks if the polygon defined by the given vertices has any intersecting
            % edges.
            %
            % This method iterates over each pair of non-adjacent edges in the polygon and
            % checks if they intersect. An edge is defined by two consecutive vertices, and
            % non-adjacent edges are those that do not share a common endpoint.
            %
            % @param vertices the vertices defining the polygon
            % @return true if any non-adjacent edges intersect, false otherwise
            hasIntersect = false;
            numVertices = size(vertices, 1);

            for i = 1:numVertices

                for j = i + 2:numVertices % Avoid adjacent and same edge

                    if mod(i, numVertices) + 1 == mod(j, numVertices)
                        continue; % Avoid adjacent edges
                    end

                    if obj.areIntersecting(vertices(i, 1), vertices(i, 2), vertices(mod(i, numVertices) + 1, 1), vertices(mod(i, numVertices) + 1, 2), ...
                            vertices(j, 1), vertices(j, 2), vertices(mod(j, numVertices) + 1, 1), vertices(mod(j, numVertices) + 1, 2))
                        hasIntersect = true;
                        return;
                    end

                end

            end

        end

        function areIntersect = areIntersecting(obj, x1, y1, x2, y2, x3, y3, x4, y4)
            % Checks if the given line segments are intersecting.
            %
            % The given line segments are defined by the points (x1, y1), (x2, y2), (x3,
            % y3), and (x4, y4). The line segments are
            % intersecting if they have a common point that is not one of the
            % end points of the line segments.
            %
            % @param x1 the x-coordinate of the first end point of the first line segment
            % @param y1 the y-coordinate of the first end point of the first line segment
            % @param x2 the x-coordinate of the second end point of the first line segment
            % @param y2 the y-coordinate of the second end point of the first line segment
            % @param x3 the x-coordinate of the first end point of the second line segment
            % @param y3 the y-coordinate of the first end point of the second line segment
            % @param x4 the x-coordinate of the second end point of the second line segment
            % @param y4 the y-coordinate of the second end point of the second line segment
            % @return true if the line segments are intersecting, false otherwise
            % Determine if segments intersect using cross product
            d1 = obj.direction(x3, y3, x4, y4, x1, y1);
            d2 = obj.direction(x3, y3, x4, y4, x2, y2);
            d3 = obj.direction(x1, y1, x2, y2, x3, y3);
            d4 = obj.direction(x1, y1, x2, y2, x4, y4);

            if ((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) && ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))
                areIntersect = true;
            elseif (d1 == 0 && obj.onSegment(x3, y3, x4, y4, x1, y1))
                areIntersect = true;
            elseif (d2 == 0 && obj.onSegment(x3, y3, x4, y4, x2, y2))
                areIntersect = true;
            elseif (d3 == 0 && obj.onSegment(x1, y1, x2, y2, x3, y3))
                areIntersect = true;
            elseif (d4 == 0 && obj.onSegment(x1, y1, x2, y2, x4, y4))
                areIntersect = true;
            else
                areIntersect = false;
            end

        end

        function dir = direction(~, x1, y1, x2, y2, x3, y3)
            % Calculates the direction of the turn formed by three points.
            %
            % This method uses the cross product to determine the relative orientation of
            % the triplet (x1, y1), (x2, y2), (x3, y3). The result is positive if the
            % orientation is counterclockwise, negative if clockwise, and zero if the
            % points are collinear.
            %
            % @param x1 x-coordinate of the first point
            % @param y1 y-coordinate of the first point
            % @param x2 x-coordinate of the second point
            % @param y2 y-coordinate of the second point
            % @param x3 x-coordinate of the third point
            % @param y3 y-coordinate of the third point
            % @return a positive value if the orientation is counterclockwise, negative if
            %         clockwise, and zero if collinear
            dir = (x2 - x1) * (y3 - y2) - (x3 - x2) * (y2 - y1);
        end

        function isOn = onSegment(~, x1, y1, x2, y2, x3, y3)
            % Checks if the point (x3,y3) is on the line segment with endpoints (x1,y1) and
            % (x2,y2).
            %
            % @param x1 x-coordinate of the first endpoint
            % @param y1 y-coordinate of the first endpoint
            % @param x2 x-coordinate of the second endpoint
            % @param y2 y-coordinate of the second endpoint
            % @param x3 x-coordinate of the point to check
            % @param y3 y-coordinate of the point to check
            % @return true if the point is on the line segment, false otherwise
            isOn = (x3 <= max(x1, x2) && x3 >= min(x1, x2) && ...
                y3 <= max(y1, y2) && y3 >= min(y1, y2));
        end

    end

end
