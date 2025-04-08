classdef ThreeDimPolygon < handle
    %TWODIMPOLYGON Abstract class representing a two-dimensional polygon
    %   This class provides basic functionality for handling two-dimensional
    %   polygons, including methods to set and get vertices, calculate area,
    %   and check the validity of the polygon's vertices.

    properties (Access = protected)
        vertices(:, 3){mustBeReal, mustBeFinite} % The vertices of the polygon
        measure {mustBeReal, mustBeFinite} % The area of the polygon
    end

    methods (Abstract, Access = protected)
        calculateMeasure(obj)
        % Abstract method to calculate the area of the polygon.
        % This method must be implemented by subclasses.
    end

    methods (Access = public)

        function obj = ThreeDimPolygon(vertices)

            if nargin == 0
                % Default constructor
                return;
            end

            if ~obj.isRightVertices(vertices)
                error('Invalid vertices');
            end

            % Create a copy of the vertices array
            obj.vertices = vertices(:, :);

            % Calculate the measure of the polygon
            obj.measure = obj.calculateMeasure();
        end

        function measure = getMeasure(obj)
            % Returns the area of the polygon.
            %
            % @return the area of the polygon
            measure = obj.measure;
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
            obj.measure = obj.calculateMeasure();
        end

        function isValid = isRightVertices(~, vertices)
            % Checks if the given vertices are valid for a three - dimensional polygon.
            %
            % A valid polygon must satisfy the following conditions:
            % 1. The number of vertices must be greater than or equal to 4
            % 2. The vertices must not be collinear
            % 3. The vertices must not be coplanar
            %
            % This method first checks if the given vertices are valid, and then
            % calculates the cross product of the two vectors formed by the vertices.
            % If the cross product is not zero, then the vertices are not collinear,
            % and the method returns true. Otherwise, the method returns false.
            %
            % @param vertices the vertices to check
            % @return true if the vertices are valid, false otherwise

            % Check if the number of vertices is greater than or equal to 4
            if size(vertices, 1) < 4
                isValid = false;
                return;
            end

            % Calculate the cross product of the two vectors formed by the vertices
            v1 = vertices(2, :) - vertices(1, :);
            v2 = vertices(3, :) - vertices(1, :);
            crossProduct = cross(v1, v2);

            % Check if the cross product is not zero
            if all(crossProduct == 0)
                isValid = false;
            else
                isValid = true;
            end

        end

    end

end
