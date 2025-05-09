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
package com.hsmkmathlib.simplexIntegral.polygon;

public class Tetrahedron extends ThreeDimPolygon {

    private double[] squres = new double[4]; // 存储每个面的面积

    public Tetrahedron(double[][] vertices) {
        super(vertices);
        caculateSqures();
    }

    public Tetrahedron() {
    }

    /**
     * Calculates the areas of the four triangular faces of the tetrahedron.
     * <p>
     * Each face is defined by three of the four vertices of the tetrahedron.
     * The areas are stored in the 'squres' array where each index corresponds
     * to a specific face:
     * <ul>
     * <li>squres[0]: Area of face formed by vertices A, B, and C</li>
     * <li>squres[1]: Area of face formed by vertices B, C, and D</li>
     * <li>squres[2]: Area of face formed by vertices C, D, and A</li>
     * <li>squres[3]: Area of face formed by vertices D, A, and B</li>
     * </ul>
     */
    private void caculateSqures() {
        double[] A = this.vertices[0];
        double[] B = this.vertices[1];
        double[] C = this.vertices[2];
        double[] D = this.vertices[3];
        this.squres[0] = faceArea(new double[][]{A, B, C});
        this.squres[1] = faceArea(new double[][]{B, C, D});
        this.squres[2] = faceArea(new double[][]{C, D, A});
        this.squres[3] = faceArea(new double[][]{D, A, B});
    }

    /**
     * Calculates the volume of the tetrahedron.
     * <p>
     * The volume of a tetrahedron can be calculated using the scalar triple
     * product of the three vectors formed by the four vertices of the
     * tetrahedron, divided by 6.
     * <p>
     * The formula is: volume = |(AB x AC) \* AD| / 6 where AB, AC, and AD are
     * the three vectors formed by the four vertices of the tetrahedron.
     * <p>
     *
     * @return the volume of the tetrahedron
     */
    @Override
    public double caculateMeasure() {

        double[] A = this.vertices[0];
        double[] B = this.vertices[1];
        double[] C = this.vertices[2];
        double[] D = this.vertices[3];

        double[] AB = vectorBetween(A, B);
        double[] AC = vectorBetween(A, C);
        double[] AD = vectorBetween(A, D);

        double[] cross = crossProduct(AC, AD);
        double scalarTripleProduct = dotProduct(AB, cross);

        return Math.abs(scalarTripleProduct) / 6.0;
    }

    // 计算从点from到点to的向量
    private double[] vectorBetween(double[] from, double[] to) {
        return new double[]{
            to[0] - from[0],
            to[1] - from[1],
            to[2] - from[2]
        };
    }

    /**
     * Computes the dot product of two 3-dimensional vectors.
     *
     * @param u the first vector
     * @param v the second vector
     * @return the dot product of vectors u and v
     */
    private double dotProduct(double[] u, double[] v) {
        return u[0] * v[0] + u[1] * v[1] + u[2] * v[2];
    }

    /**
     * Checks if the given vertices form a valid tetrahedron.
     * <p>
     * A valid tetrahedron must satisfy the following conditions: 1. The number
     * of vertices must be exactly 4. 2. The vertices must not be identical. 3.
     * The vertices must not be coplanar.
     * <p>
     * This method first checks that the number of vertices is correct, then
     * verifies that not all vertices are the same. It calculates vectors
     * between vertices and uses the cross product to ensure that no three
     * vertices are collinear and that not all four vertices are coplanar.
     * <p>
     *
     * @param vertices the vertices to check
     * @return true if the vertices form a valid tetrahedron, false otherwise
     */
    @Override
    public boolean isRightVertices(double[][] vertices) {
        int n = vertices.length;
        if (n != 4 | vertices[0].length != 3) {
            return false;
        }

        // 检查所有点是否相同
        double[] A = vertices[0];
        boolean allSame = true;
        for (int i = 1; i < n; i++) {
            if (!equals(A, vertices[i])) {
                allSame = false;
                break;
            }
        }
        if (allSame) {
            return false;
        }

        // 找第一个不同的点B
        int bIndex = -1;
        for (int i = 1; i < n; i++) {
            if (!equals(A, vertices[i])) {
                bIndex = i;
                break;
            }
        }
        if (bIndex == -1) {
            return false;
        }
        double[] B = vertices[bIndex];

        // 计算AB向量
        double[] AB = vector(A, B);

        // 找第三个点C，使得AB和AC不共线
        int cIndex = -1;
        double[] cross = null;
        for (int i = 0; i < n; i++) {
            if (i == 0 || i == bIndex) {
                continue;
            }
            double[] AC = vector(A, vertices[i]);
            cross = crossProduct(AB, AC);
            double lenSq = cross[0] * cross[0] + cross[1] * cross[1] + cross[2] * cross[2];
            if (lenSq > EPSILON_SQ) {
                cIndex = i;
                break;
            }
        }
        if (cIndex == -1) {
            return false;
        }

        // 计算叉积的平方长度
        double lenSqN = cross[0] * cross[0] + cross[1] * cross[1] + cross[2] * cross[2];

        // 检查其他点是否在ABC平面上
        for (int i = 0; i < n; i++) {
            if (i == 0 || i == bIndex || i == cIndex) {
                continue;
            }
            double[] D = vertices[i];
            double dx = D[0] - A[0];
            double dy = D[1] - A[1];
            double dz = D[2] - A[2];
            double dot = cross[0] * dx + cross[1] * dy + cross[2] * dz;
            if (dot * dot > EPSILON_SQ * lenSqN) {
                return true;
            }
        }

        return false;
    }

    /**
     * Checks if two double arrays are equal, element by element. Two elements
     * are considered equal if their difference is less than EPSILON.
     *
     * @param a the first double array
     * @param b the second double array
     * @return true if the two arrays are equal, false otherwise
     */
    private boolean equals(double[] a, double[] b) {
        return Math.abs(a[0] - b[0]) < EPSILON
                && Math.abs(a[1] - b[1]) < EPSILON
                && Math.abs(a[2] - b[2]) < EPSILON;
    }

    /**
     * Calculates the vector from point a to point b.
     *
     * @param a the starting point
     * @param b the ending point
     * @return a new vector that is the difference of b and a
     */
    private double[] vector(double[] a, double[] b) {
        return new double[]{b[0] - a[0], b[1] - a[1], b[2] - a[2]};
    }

    /**
     * Calculates the cross product of two 3D vectors.
     *
     * <p>
     * The cross product of two vectors in 3D space results in a third vector
     * that is perpendicular to both of the input vectors. The magnitude of the
     * resulting vector is equal to the area of the parallelogram that the
     * vectors span.
     * </p>
     *
     * @param u the first vector
     * @param v the second vector
     * @return a new vector that is the cross product of u and v
     */
    private double[] crossProduct(double[] u, double[] v) {
        return new double[]{
            u[1] * v[2] - u[2] * v[1],
            u[2] * v[0] - u[0] * v[2],
            u[0] * v[1] - u[1] * v[0]
        };
    }

    /**
     * Calculates the area of a triangle given by three points in 3D space.
     *
     * <p>
     * The area of the triangle is calculated using the cross product of two
     * vectors formed by the points.
     * </p>
     *
     * @param points the three points of the triangle
     * @return the area of the triangle
     */
    private double faceArea(double[][] points) {
        double[] AB = {
            points[1][0] - points[0][0],
            points[1][1] - points[0][1],
            points[1][2] - points[0][2]
        };
        double[] AC = {
            points[2][0] - points[0][0],
            points[2][1] - points[0][1],
            points[2][2] - points[0][2]
        };

        // 计算叉乘
        double[] cross = {
            AB[1] * AC[2] - AB[2] * AC[1],
            AB[2] * AC[0] - AB[0] * AC[2],
            AB[0] * AC[1] - AB[1] * AC[0]
        };

        return Math.sqrt(cross[0] * cross[0] + cross[1] * cross[1] + cross[2] * cross[2]) / 2;
    }
}
