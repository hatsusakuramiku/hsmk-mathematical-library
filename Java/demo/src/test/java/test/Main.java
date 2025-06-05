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
package test;

import com.hsmkmathlib.matrix.Matrix;
import com.hsmkmathlib.matrix.MatrixUtils;
import com.hsmkmathlib.tools.ArrayTools;

// import sort.algorithm.BubbleSort;
public class Main {

    public static final int ASCENDING = 0;
    public static final int DESCENDING = 1;

    public static void main(String[] args) {
        // double[][] ves = {{1, 0}, {0, 0}, {0, 1}};
        // double[][] ves2 = {{1, 5, 0}, {2, 0, 0}, {4, 3, 0}, {1, 5, 5}};
        // TriFunction<Double, Double, Double, Double> f = (x, y, z) -> x * y * z;
        // Tetrahedron tetrahedron = new Tetrahedron(ves2);
        // Triangle triangle = new Triangle(ves);
        // TetrahedronIntegral teI = new TetrahedronIntegral();
        // TriangleIntegral trI = new TriangleIntegral();
        // // trI.saveIntegralPoints("triangleFormula.m");
        // // teI.saveIntegralPoints("tetrahedronFormula.m");
        // trI.saveIntegralPointsToJson("./temp/triangle_formula");
        // teI.saveIntegralPointsToJson("./temp/tetrahendron_formula");
        // System.out.println("The area of the triangle is: " + triangle.getArea());
        // System.out.println("The measure of the tetrahedron is: " + tetrahedron.getMeasure());
        // System.out.println("The integral of the tetrahedron is: "
        //         + teI.integrate(tetrahedron, f, teI.getEnableIntegralFormulaName()[0]));
        // // System.out.println(triangle.isRightVertices(ves));
        // // System.out.println(triangle.getArea());
        // // TriangleSimplexIntegral.saveIntegralPoints("integralPoints.txt");
        // System.out.println(Arrays.toString(teI.getEnableIntegralFormulaName()));
        Matrix a = new Matrix(new double[][]{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}, false);
        Matrix b = new Matrix(new double[][]{{1, 2, 3, 0}, {4, 5, 6, 0}, {7, 8, 9, 0}}, false);
        Matrix c = MatrixUtils.multiply(a, b);
        System.out.println(ArrayTools.arrayToString(c.getRow(0, 3, 2)));
        // System.out.println(MatrixUtils.onesMatrix(1000, 10, 1));
    }
}
