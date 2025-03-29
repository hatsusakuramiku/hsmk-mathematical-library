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
package simplexIntegral.polygons;

public class Triangle extends TwoDimPolygon {

    public Triangle(double[][] vertices) {
        super(vertices, 3);
    }

    public Triangle() {
    }

    /**
     * Calculates the area of a triangle using Heron's formula.
     * <p>
     * The formula is: area = sqrt(s * (s - a) * (s - b) * (s - c))
     * where s = (a + b + c) / 2
     * and a, b, and c are the side lengths of the triangle.
     * <p>
     * 
     * @return the area of the triangle
     */
    @Override
    protected double calculateArea() {
        double x1 = this.vertices[0][0];
        double y1 = this.vertices[0][1];
        double x2 = this.vertices[1][0];
        double y2 = this.vertices[1][1];
        double x3 = this.vertices[2][0];
        double y3 = this.vertices[2][1];

        double a = Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
        double b = Math.sqrt(Math.pow(x3 - x2, 2) + Math.pow(y3 - y2, 2));
        double c = Math.sqrt(Math.pow(x1 - x3, 2) + Math.pow(y1 - y3, 2));

        double s = (a + b + c) / 2;

        return Math.sqrt(s * (s - a) * (s - b) * (s - c));
    }

    // 判断顶点是否能构成一个三角形，即1.顶点坐标不能重复，2.顶点坐标不能共线
    @Override
    public boolean isRightVertices(double[][] vertices) {
        if (vertices == null || vertices.length != 3) {
            return false;
        }

        double x1 = vertices[0][0];
        double y1 = vertices[0][1];
        double x2 = vertices[1][0];
        double y2 = vertices[1][1];
        double x3 = vertices[2][0];
        double y3 = vertices[2][1];

        if ((x1 == x2 && y1 == y2) || (x1 == x3 && y1 == y3) || (x2 == x3 && y2 == y3)) {
            return false;
        }

        double v1x = x2 - x1;
        double v1y = y2 - y1;
        double v2x = x3 - x1;
        double v2y = y3 - y1;
        return v1x * v2y != v1y * v2x;
    }

}
