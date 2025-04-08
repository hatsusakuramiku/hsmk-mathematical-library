classdef Tetrahedron < ThreeDimPolygon

    methods (Access = public)

        function obj = Tetrahedron(vertices)
            % TETRAHEDRON Construct a Tetrahedron object.
            %
            % OBJ = TETRAHEDRON(VERTICES) creates a new instance of the
            % Tetrahedron class using the provided VERTICES. The VERTICES
            % must be a 4x3 matrix representing the four vertices of the
            % tetrahedron in 3D space. If the vertices do not meet these
            % requirements, an error is thrown.
            %
            % @param vertices A 4x3 matrix containing the vertices.
            % @throws error if vertices are not a 4x3 matrix.

            if (size(vertices, 1) ~= 4 || size(vertices, 2) ~= 3)
                error('Invalid vertices');
            end

            % Call the superclass constructor
            obj = obj@ThreeDimPolygon(vertices);
        end

    end

    methods (Access = protected)

        function measure = calculateMeasure(obj)
            %CALCULATEMEASURE  Calculate the measure of the tetrahedron.
            %
            %   MEASURE = CALCULATEMEASURE(OBJ) calculates the measure of the
            %   tetrahedron represented by the instance OBJ. The measure is
            %   calculated as the absolute value of the scalar triple product of
            %   the vectors formed by the vertices of the tetrahedron divided
            %   by 6.
            %
            %   See also: THREE_DIM_POLYGON

            % Get the vertices of the tetrahedron
            vertices = obj.getVertices();

            % Calculate the vectors formed by the vertices
            v1 = vertices(2, :) - vertices(1, :);
            v2 = vertices(3, :) - vertices(1, :);
            v3 = vertices(4, :) - vertices(1, :);

            % Calculate the scalar triple product
            measure = abs(dot(v1, cross(v2, v3))) / 6;

        end

    end

end
