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

public abstract class ThreeDimPolygon extends Polygon {
    protected static final double EPSILON = 1e-8;
    protected static final double EPSILON_SQ = EPSILON * EPSILON;

    public ThreeDimPolygon(double[][] vertices) {
        super(vertices);
    }

    public ThreeDimPolygon() {
        
    }

    /**
     * Returns the volume of the polygon.
     * 
     * @return the volume of the polygon
     */
    public double getVolume() {
        return this.measure;
    }

    /**
     * Checks if the given vertices are valid for a three-dimensional polygon.
     * <p>
     * A valid polygon must satisfy the following conditions:
     * 1. The number of vertices must be greater than or equal to 4
     * 2. The vertices must not be collinear
     * 3. The vertices must not be coplanar
     * <p>
     * This method first checks if the given vertices are valid, and then
     * calculates the cross product of the two vectors formed by the vertices.
     * If the cross product is not zero, then the vertices are not collinear,
     * and the method returns true. Otherwise, the method returns false.
     * <p>
     *
     * @param vertices the vertices to check
     * @return true if the vertices are valid, false otherwise
     */
    @Override
    public boolean isRightVertices(double[][] vertices) {
        int n = vertices.length;
        if (n < 4) {
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
     * Checks if two double arrays are equal, element by element.
     * Two elements are considered equal if their difference is less than EPSILON.
     * @param a the first double array
     * @param b the second double array
     * @return true if the two arrays are equal, false otherwise
     */
    private boolean equals(double[] a, double[] b) {
        return Math.abs(a[0] - b[0]) < EPSILON &&
                Math.abs(a[1] - b[1]) < EPSILON &&
                Math.abs(a[2] - b[2]) < EPSILON;
    }

    /**
     * Calculates the vector from point a to point b.
     *
     * @param a the starting point
     * @param b the ending point
     * @return a new vector that is the difference of b and a
     */
    private double[] vector(double[] a, double[] b) {
        return new double[] { b[0] - a[0], b[1] - a[1], b[2] - a[2] };
    }

    /**
     * Calculates the cross product of two 3D vectors.
     *
     * <p>The cross product of two vectors in 3D space results in a third vector
     * that is perpendicular to both of the input vectors. The magnitude of the
     * resulting vector is equal to the area of the parallelogram that the vectors
     * span.</p>
     *
     * @param u the first vector
     * @param v the second vector
     * @return a new vector that is the cross product of u and v
     */

    private double[] crossProduct(double[] u, double[] v) {
        return new double[] {
                u[1] * v[2] - u[2] * v[1],
                u[2] * v[0] - u[0] * v[2],
                u[0] * v[1] - u[1] * v[0]
        };
    }

}