/*
 * Copyright  2024 hatsusakuramiku
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package simplexIntegral.polygon;

abstract public class TwoDimPolygon extends Polygon {

    protected double area;

    /**
     * Constructs a two-dimensional polygon from the given vertices.
     * 
     * @param vertices the vertices of the polygon
     */
    public TwoDimPolygon(double[][] vertices) {
        super(vertices);
        this.area = calculateArea();
    }

    /**
     * Constructs a two-dimensional polygon with no vertices.
     * 
     * This constructor is intended to be used for testing or when the vertices of
     * the polygon are not known at construction time.
     */
    public TwoDimPolygon() {
    }

    /**
     * Returns the area of the polygon.
     * 
     * @return the area of the polygon
     */
    public double getArea() {
        return area;
    }

    /**
     * Sets the vertices of the polygon and recalculates its area.
     * 
     * <p>
     * The vertices must form a valid polygon. If the vertices are invalid, an
     * IllegalArgumentException is thrown.
     * 
     * @param vertices the new vertices to set
     * @throws IllegalArgumentException if the vertices do not form a valid polygon
     */

    public void setVertices(double[][] vertices) {
        if (!isRightVertices(vertices)) {
            throw new IllegalArgumentException("Invalid vertices");
        }
        this.vertices = vertices;
        this.area = calculateArea();
        this.measure = this.area;
    }

    /**
     * Calculates the measure of the polygon.
     * 
     * <p>
     * This method simply calls the calculateArea method, which is an abstract method
     * that must be implemented by subclasses.
     * 
     * @return the measure of the polygon
     */
    protected double caculateMeasure() {
        return calculateArea();
    }

    abstract protected double calculateArea();

    /**
     * Checks if the given vertices are valid for a two-dimensional polygon.
     * 
     * <p>
     * A valid polygon must satisfy the following conditions:
     * 1. The number of vertices must be greater than or equal to 3
     * 2. The vertices must not be duplicate
     * 3. The edges must not intersect
     * 
     * @param vertices the vertices to check
     * @return true if the vertices are valid, false otherwise
     */
    public boolean isRightVertices(double[][] vertices) {
        if (vertices == null || vertices.length < 3) {
            return false;
        }

        if (hasDuplicateVertices(vertices)) {
            return false;
        }

        if (hasIntersectingEdges(vertices)) {
            return false;
        }

        return true;
    }

    /**
     * Checks if the given vertices contain any duplicate points.
     *
     * @param vertices the vertices to check
     * @return true if any two points are the same, false otherwise
     */
    protected static boolean hasDuplicateVertices(double[][] vertices) {
        for (int i = 0; i < vertices.length; i++) {
            for (int j = i + 1; j < vertices.length; j++) {
                if (vertices[i][0] == vertices[j][0] && vertices[i][1] == vertices[j][1]) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Checks if the polygon defined by the given vertices has any intersecting
     * edges.
     * 
     * <p>
     * This method iterates over each pair of non-adjacent edges in the polygon and
     * checks if they intersect. An edge is defined by two consecutive vertices, and
     * non-adjacent edges are those that do not share a common endpoint.
     * 
     * @param vertices the vertices defining the polygon
     * @return true if any non-adjacent edges intersect, false otherwise
     */

    protected static boolean hasIntersectingEdges(double[][] vertices) {
        for (int i = 0; i < vertices.length; i++) {
            for (int j = i + 2; j < vertices.length; j++) { // 避免相邻边和同一条边
                if ((i + 1) % vertices.length == j % vertices.length)
                    continue; // 避免相邻边
                if (areIntersecting(vertices[i][0], vertices[i][1], vertices[(i + 1) % vertices.length][0],
                        vertices[(i + 1) % vertices.length][1],
                        vertices[j][0], vertices[j][1], vertices[(j + 1) % vertices.length][0],
                        vertices[(j + 1) % vertices.length][1])) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Checks if the given line segments are intersecting.
     * 
     * <p>
     * The given line segments are defined by the points (x1, y1), (x2, y2), (x3,
     * y3), and (x4, y4). The line segments are
     * intersecting if the line segments have a common point that is not one of the
     * end points of the line segments.
     * 
     * @param x1 the x-coordinate of the first end point of the first line segment
     * @param y1 the y-coordinate of the first end point of the first line segment
     * @param x2 the x-coordinate of the second end point of the first line segment
     * @param y2 the y-coordinate of the second end point of the first line segment
     * @param x3 the x-coordinate of the first end point of the second line segment
     * @param y3 the y-coordinate of the first end point of the second line segment
     * @param x4 the x-coordinate of the second end point of the second line segment
     * @param y4 the y-coordinate of the second end point of the second line segment
     * @return true if the line segments are intersecting, false otherwise
     */
    protected static boolean areIntersecting(double x1, double y1, double x2, double y2, double x3, double y3,
            double x4,
            double y4) {
        // 使用叉积判断线段是否相交
        double d1 = direction(x3, y3, x4, y4, x1, y1);
        double d2 = direction(x3, y3, x4, y4, x2, y2);
        double d3 = direction(x1, y1, x2, y2, x3, y3);
        double d4 = direction(x1, y1, x2, y2, x4, y4);

        if (((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) && ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))) {
            return true;
        } else if (d1 == 0 && onSegment(x3, y3, x4, y4, x1, y1)) {
            return true;
        } else if (d2 == 0 && onSegment(x3, y3, x4, y4, x2, y2)) {
            return true;
        } else if (d3 == 0 && onSegment(x1, y1, x2, y2, x3, y3)) {
            return true;
        } else if (d4 == 0 && onSegment(x1, y1, x2, y2, x4, y4)) {
            return true;
        }

        return false;
    }

    /**
     * Calculates the direction of the turn formed by three points.
     * 
     * <p>
     * This method uses the cross product to determine the relative orientation of
     * the triplet (x1, y1), (x2, y2), (x3, y3). The result is positive if the
     * orientation is counterclockwise, negative if clockwise, and zero if the
     * points
     * are collinear.
     * 
     * @param x1 x-coordinate of the first point
     * @param y1 y-coordinate of the first point
     * @param x2 x-coordinate of the second point
     * @param y2 y-coordinate of the second point
     * @param x3 x-coordinate of the third point
     * @param y3 y-coordinate of the third point
     * @return a positive value if the orientation is counterclockwise, negative if
     *         clockwise, and zero if collinear
     */

    protected static double direction(double x1, double y1, double x2, double y2, double x3, double y3) {
        return (x2 - x1) * (y3 - y2) - (x3 - x2) * (y2 - y1);
    }

    /**
     * Checks if the point (x3,y3) is on the line segment with endpoints (x1,y1) and
     * (x2,y2).
     * 
     * @param x1 x-coordinate of the first endpoint
     * @param y1 y-coordinate of the first endpoint
     * @param x2 x-coordinate of the second endpoint
     * @param y2 y-coordinate of the second endpoint
     * @param x3 x-coordinate of the point to check
     * @param y3 y-coordinate of the point to check
     * @return true if the point is on the line segment, false otherwise
     */
    protected static boolean onSegment(double x1, double y1, double x2, double y2, double x3, double y3) {
        if (x3 <= Math.max(x1, x2) && x3 >= Math.min(x1, x2) &&
                y3 <= Math.max(y1, y2) && y3 >= Math.min(y1, y2)) {
            return true;
        }
        return false;
    }
}
