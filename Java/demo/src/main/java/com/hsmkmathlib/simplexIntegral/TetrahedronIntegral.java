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
package com.hsmkmathlib.simplexIntegral;

import java.util.HashMap;

import com.hsmkmathlib.simplexIntegral.function.TriFunction;
import com.hsmkmathlib.simplexIntegral.polygon.Polygon;
import com.hsmkmathlib.simplexIntegral.polygon.Tetrahedron;
import com.hsmkmathlib.tools.ArrayTools;

public class TetrahedronIntegral extends IntegralBase {

    @Override
    protected HashMap<String, Double[][]> initalIntegralFormulas() {
        HashMap<String, Double[][]> formulas = new HashMap<>();
        formulas.put("ORDER1POINT4", new Double[][]{
            {0.0000000000000000, 0.0000000000000000, 0.0000000000000000, 0.0416666666666667},
            {1.0000000000000000, 0.0000000000000000, 0.0000000000000000, 0.0416666666666667},
            {0.0000000000000000, 1.0000000000000000, 0.0000000000000000, 0.0416666666666667},
            {0.0000000000000000, 0.0000000000000000, 1.0000000000000000, 0.0416666666666667}
        });

        formulas.put("ORDER4POINT23", new Double[][]{
            {0.0000000000000000, 0.0000000000000000, 0.0000000000000000, 0.0002166018029373},
            {1.0000000000000000, 0.0000000000000000, 0.0000000000000000, 0.0002166018029373},
            {0.0000000000000000, 1.0000000000000000, 0.0000000000000000, 0.0002166018029373},
            {0.0000000000000000, 0.0000000000000000, 1.0000000000000000, 0.0002166018029373},
            {0.0000000000000000, 0.5000000000000000, 0.0000000000000000, 0.0012522181731302},
            {0.5000000000000000, 0.5000000000000000, 0.0000000000000000, 0.0012522181731302},
            {0.5000000000000000, 0.0000000000000000, 0.0000000000000000, 0.0012522181731302},
            {0.0000000000000000, 0.0000000000000000, 0.5000000000000000, 0.0012522181731302},
            {0.5000000000000000, 0.0000000000000000, 0.5000000000000000, 0.0012522181731302},
            {0.0000000000000000, 0.5000000000000000, 0.5000000000000000, 0.0012522181731302},
            {0.2500000000000000, 0.2500000000000000, 0.2500000000000000, 0.0507936507936508},
            {0.1885804846964451, 0.1885804846964451, 0.0000000000000000, 0.0089577749685405},
            {0.0000000000000000, 0.1885804846964451, 0.1885804846964451, 0.0089577749685405},
            {0.1885804846964451, 0.0000000000000000, 0.1885804846964451, 0.0089577749685405},
            {0.1885804846964451, 0.1885804846964451, 0.6228390306071099, 0.0089577749685405},
            {0.6228390306071099, 0.1885804846964451, 0.1885804846964451, 0.0089577749685405},
            {0.1885804846964451, 0.6228390306071099, 0.1885804846964451, 0.0089577749685405},
            {0.6228390306071099, 0.1885804846964451, 0.0000000000000000, 0.0089577749685405},
            {0.1885804846964451, 0.6228390306071099, 0.0000000000000000, 0.0089577749685405},
            {0.0000000000000000, 0.6228390306071099, 0.1885804846964451, 0.0089577749685405},
            {0.0000000000000000, 0.1885804846964451, 0.6228390306071099, 0.0089577749685405},
            {0.6228390306071099, 0.0000000000000000, 0.1885804846964451, 0.0089577749685405},
            {0.1885804846964451, 0.0000000000000000, 0.6228390306071099, 0.0089577749685405}
        });

        formulas.put("ORDER7POINT50_v1", new Double[][]{
            {0.0000000000000000, 0.0000000000000000, 0.0000000000000000, 0.0002143608668050},
            {1.0000000000000000, 0.0000000000000000, 0.0000000000000000, 0.0002143608668050},
            {0.0000000000000000, 1.0000000000000000, 0.0000000000000000, 0.0002143608668050},
            {0.0000000000000000, 0.0000000000000000, 1.0000000000000000, 0.0002143608668050},
            {0.2928294047674109, 0.0000000000000000, 0.0000000000000000, 0.0008268179517797},
            {0.7071705952325891, 0.0000000000000000, 0.0000000000000000, 0.0008268179517797},
            {0.0000000000000000, 0.7071705952325891, 0.0000000000000000, 0.0008268179517797},
            {0.0000000000000000, 0.2928294047674109, 0.0000000000000000, 0.0008268179517797},
            {0.0000000000000000, 0.0000000000000000, 0.2928294047674109, 0.0008268179517797},
            {0.0000000000000000, 0.0000000000000000, 0.7071705952325891, 0.0008268179517797},
            {0.2928294047674109, 0.0000000000000000, 0.7071705952325891, 0.0008268179517797},
            {0.7071705952325891, 0.0000000000000000, 0.2928294047674109, 0.0008268179517797},
            {0.0000000000000000, 0.2928294047674109, 0.7071705952325891, 0.0008268179517797},
            {0.0000000000000000, 0.7071705952325891, 0.2928294047674109, 0.0008268179517797},
            {0.2928294047674109, 0.7071705952325891, 0.0000000000000000, 0.0008268179517797},
            {0.7071705952325891, 0.2928294047674109, 0.0000000000000000, 0.0008268179517797},
            {0.1972862280257976, 0.1972862280257976, 0.0000000000000000, 0.0018401779041919},
            {0.0000000000000000, 0.1972862280257976, 0.1972862280257976, 0.0018401779041919},
            {0.1972862280257976, 0.0000000000000000, 0.1972862280257976, 0.0018401779041919},
            {0.1972862280257976, 0.1972862280257976, 0.6054275439484048, 0.0018401779041919},
            {0.6054275439484048, 0.1972862280257976, 0.1972862280257976, 0.0018401779041919},
            {0.1972862280257976, 0.6054275439484048, 0.1972862280257976, 0.0018401779041919},
            {0.6054275439484048, 0.1972862280257976, 0.0000000000000000, 0.0018401779041919},
            {0.1972862280257976, 0.6054275439484048, 0.0000000000000000, 0.0018401779041919},
            {0.0000000000000000, 0.6054275439484048, 0.1972862280257976, 0.0018401779041919},
            {0.0000000000000000, 0.1972862280257976, 0.6054275439484048, 0.0018401779041919},
            {0.6054275439484048, 0.0000000000000000, 0.1972862280257976, 0.0018401779041919},
            {0.1972862280257976, 0.0000000000000000, 0.6054275439484048, 0.0018401779041919},
            {0.4256461243139345, 0.4256461243139345, 0.0000000000000000, 0.0018313243292456},
            {0.0000000000000000, 0.4256461243139345, 0.4256461243139345, 0.0018313243292456},
            {0.4256461243139345, 0.0000000000000000, 0.4256461243139345, 0.0018313243292456},
            {0.4256461243139345, 0.4256461243139345, 0.1487077513721310, 0.0018313243292456},
            {0.1487077513721310, 0.4256461243139345, 0.4256461243139345, 0.0018313243292456},
            {0.4256461243139345, 0.1487077513721310, 0.4256461243139345, 0.0018313243292456},
            {0.1487077513721310, 0.4256461243139345, 0.0000000000000000, 0.0018313243292456},
            {0.4256461243139345, 0.1487077513721310, 0.0000000000000000, 0.0018313243292456},
            {0.0000000000000000, 0.1487077513721310, 0.4256461243139345, 0.0018313243292456},
            {0.0000000000000000, 0.4256461243139345, 0.1487077513721310, 0.0018313243292456},
            {0.1487077513721310, 0.0000000000000000, 0.4256461243139345, 0.0018313243292456},
            {0.4256461243139345, 0.0000000000000000, 0.1487077513721310, 0.0018313243292456},
            {0.0950377585839411, 0.0950377585839411, 0.0950377585839411, 0.0075424689046481},
            {0.7148867242481768, 0.0950377585839411, 0.0950377585839411, 0.0075424689046481},
            {0.0950377585839411, 0.7148867242481768, 0.0950377585839411, 0.0075424689046481},
            {0.0950377585839411, 0.0950377585839411, 0.7148867242481768, 0.0075424689046481},
            {0.1252462362578136, 0.1252462362578136, 0.3747537637421864, 0.0136099175597079},
            {0.1252462362578136, 0.3747537637421864, 0.1252462362578136, 0.0136099175597079},
            {0.3747537637421864, 0.1252462362578136, 0.1252462362578136, 0.0136099175597079},
            {0.1252462362578136, 0.3747537637421864, 0.3747537637421864, 0.0136099175597079},
            {0.3747537637421864, 0.1252462362578136, 0.3747537637421864, 0.0136099175597079},
            {0.3747537637421864, 0.3747537637421864, 0.1252462362578136, 0.0136099175597079}
        });

        formulas.put("ORDER7POINT50_v2", new Double[][]{
            {0.0000000000000000, 0.0000000000000000, 0.0000000000000000, 0.0002321968872349},
            {1.0000000000000000, 0.0000000000000000, 0.0000000000000000, 0.0002321968872349},
            {0.0000000000000000, 1.0000000000000000, 0.0000000000000000, 0.0002321968872349},
            {0.0000000000000000, 0.0000000000000000, 1.0000000000000000, 0.0002321968872349},
            {0.3052598756695660, 0.0000000000000000, 0.0000000000000000, 0.0007328680241632},
            {0.6947401243304340, 0.0000000000000000, 0.0000000000000000, 0.0007328680241632},
            {0.0000000000000000, 0.6947401243304340, 0.0000000000000000, 0.0007328680241632},
            {0.0000000000000000, 0.3052598756695660, 0.0000000000000000, 0.0007328680241632},
            {0.0000000000000000, 0.0000000000000000, 0.3052598756695660, 0.0007328680241632},
            {0.0000000000000000, 0.0000000000000000, 0.6947401243304340, 0.0007328680241632},
            {0.3052598756695660, 0.0000000000000000, 0.6947401243304340, 0.0007328680241632},
            {0.6947401243304340, 0.0000000000000000, 0.3052598756695660, 0.0007328680241632},
            {0.0000000000000000, 0.3052598756695660, 0.6947401243304340, 0.0007328680241632},
            {0.0000000000000000, 0.6947401243304340, 0.3052598756695660, 0.0007328680241632},
            {0.3052598756695660, 0.6947401243304340, 0.0000000000000000, 0.0007328680241632},
            {0.6947401243304340, 0.3052598756695660, 0.0000000000000000, 0.0007328680241632},
            {0.4204599755540437, 0.4204599755540437, 0.0000000000000000, 0.0025297925981447},
            {0.0000000000000000, 0.4204599755540437, 0.4204599755540437, 0.0025297925981447},
            {0.4204599755540437, 0.0000000000000000, 0.4204599755540437, 0.0025297925981447},
            {0.4204599755540437, 0.4204599755540437, 0.1590800488919126, 0.0025297925981447},
            {0.1590800488919126, 0.4204599755540437, 0.4204599755540437, 0.0025297925981447},
            {0.4204599755540437, 0.1590800488919126, 0.4204599755540437, 0.0025297925981447},
            {0.1590800488919126, 0.4204599755540437, 0.0000000000000000, 0.0025297925981447},
            {0.4204599755540437, 0.1590800488919126, 0.0000000000000000, 0.0025297925981447},
            {0.0000000000000000, 0.1590800488919126, 0.4204599755540437, 0.0025297925981447},
            {0.0000000000000000, 0.4204599755540437, 0.1590800488919126, 0.0025297925981447},
            {0.1590800488919126, 0.0000000000000000, 0.4204599755540437, 0.0025297925981447},
            {0.4204599755540437, 0.0000000000000000, 0.1590800488919126, 0.0025297925981447},
            {0.1480462980008327, 0.1480462980008327, 0.0000000000000000, 0.0015644619233784},
            {0.0000000000000000, 0.1480462980008327, 0.1480462980008327, 0.0015644619233784},
            {0.1480462980008327, 0.0000000000000000, 0.1480462980008327, 0.0015644619233784},
            {0.1480462980008327, 0.1480462980008327, 0.7039074039983346, 0.0015644619233784},
            {0.7039074039983346, 0.1480462980008327, 0.1480462980008327, 0.0015644619233784},
            {0.1480462980008327, 0.7039074039983346, 0.1480462980008327, 0.0015644619233784},
            {0.7039074039983346, 0.1480462980008327, 0.0000000000000000, 0.0015644619233784},
            {0.1480462980008327, 0.7039074039983346, 0.0000000000000000, 0.0015644619233784},
            {0.0000000000000000, 0.7039074039983346, 0.1480462980008327, 0.0015644619233784},
            {0.0000000000000000, 0.1480462980008327, 0.7039074039983346, 0.0015644619233784},
            {0.7039074039983346, 0.0000000000000000, 0.1480462980008327, 0.0015644619233784},
            {0.1480462980008327, 0.0000000000000000, 0.7039074039983346, 0.0015644619233784},
            {0.1048645248917035, 0.1048645248917035, 0.1048645248917035, 0.0071279114465646},
            {0.6854064253248895, 0.1048645248917035, 0.1048645248917035, 0.0071279114465646},
            {0.1048645248917035, 0.6854064253248895, 0.1048645248917035, 0.0071279114465646},
            {0.1048645248917035, 0.1048645248917035, 0.6854064253248895, 0.0071279114465646},
            {0.1258796196682507, 0.1258796196682507, 0.3741203803317493, 0.0132167937972054},
            {0.1258796196682507, 0.3741203803317493, 0.1258796196682507, 0.0132167937972054},
            {0.3741203803317493, 0.1258796196682507, 0.1258796196682507, 0.0132167937972054},
            {0.1258796196682507, 0.3741203803317493, 0.3741203803317493, 0.0132167937972054},
            {0.3741203803317493, 0.1258796196682507, 0.3741203803317493, 0.0132167937972054},
            {0.3741203803317493, 0.3741203803317493, 0.1258796196682507, 0.0132167937972054}
        });
        return formulas;
    }

    /**
     * Transforms the given points from the integral coordinates to the real
     * coordinates of the given tetrahedron.
     * <p>
     * The integral coordinates are the coordinates of the points in the
     * integral, and the real coordinates are the coordinates of the points in
     * the tetrahedron.
     * <p>
     * The transformation is done with the following formulas:
     * <p>
     * x = x1 * a + x2 * b + x3 * c + x4 * d y = y1 * a + y2 * b + y3 * c + y4 *
     * d z = z1 * a + z2 * b + z3 * c + z4 * d
     * <p>
     * where (x1, y1, z1), (x2, y2, z2), (x3, y3, z3), and (x4, y4, z4) are the
     * coordinates of the vertices of this tetrahedron, and (a, b, c) are the
     * coordinates of the point in the integral, and d is 1 - a - b - c.
     * <p>
     *
     * @param polygon the tetrahedron to transform the points to
     * @param integralPoints the points to transform
     * @return the transformed points
     */
    @Override
    protected <T extends Polygon> Double[][] transformPoints(T polygon, Double[][] integralPoints) {
        Double[][] vertices = ArrayTools.pacakageArray(polygon.getVertices());
        Double[][] transformedPoints = new Double[integralPoints.length][4];
        for (int i = 0; i < integralPoints.length; i++) {
            double a = integralPoints[i][0];
            double b = integralPoints[i][1];
            double c = integralPoints[i][2];
            double d = 1 - a - b - c;
            transformedPoints[i][0] = vertices[0][0] * a + vertices[1][0] * b + vertices[2][0] * c + vertices[3][0] * d;// x
            transformedPoints[i][1] = vertices[0][1] * a + vertices[1][1] * b + vertices[2][1] * c + vertices[3][1] * d;// y
            transformedPoints[i][2] = vertices[0][2] * a + vertices[1][2] * b + vertices[2][2] * c + vertices[3][2] * d;// z
            transformedPoints[i][3] = integralPoints[i][3];
        }
        return transformedPoints;
    }

    /**
     * Integrates a tri-variable function over a given tetrahedron using a
     * specified integral formula.
     * <p>
     * The method retrieves the integral formula by name and uses it to perform
     * numerical integration over the tetrahedron. It throws an exception if the
     * specified formula is not found.
     * <p>
     * The supported integral formulas can be found at
     * <a herf="https://hsmkhexo.s3.ap-northeast-1.amazonaws.com/other/%E7%A7%AF%E5%88%86%E5%85%AC%E5%BC%8F%E6%80%BB%E7%BB%93.pdf">online
     * documentation</a>.
     * <p>
     *
     * @param tetrahedron the tetrahedron over which the integration is
     * performed
     * @param func the tri-variable function to integrate
     * @param formulaName the name of the integral formula to use for
     * integration. The available formulas are: "ORDER1POINT4", "ORDER4POINT23",
     * "ORDER7POINT50_v1", "ORDER7POINT50_v2". Or use the method
     * {@link getEnableIntegralFormulaName()} to get all the available formulas.
     * @return the result of the integration
     * @throws IllegalArgumentException if the specified formula is not found
     */
    public double integrate(Tetrahedron tetrahedron, TriFunction<Double, Double, Double, Double> func,
            String formulaName) {
        return integrate(tetrahedron, func, INTEGRALFORMULAS.get(formulaName));
    }

    /**
     * Integrates a tri-variable function over a given tetrahedron using
     * provided integral points and weights.
     * <p>
     * This method applies the provided tri-variable function to each point in
     * the given array of points. The result is multiplied by the weight of each
     * point and the results are summed up to compute the integral.
     * <p>
     * The method checks for null inputs and ensures the pointWithWeights array
     * has the correct structure before proceeding with the integration.
     * <p>
     *
     * @param tetrahedron the tetrahedron over which the function is to be
     * integrated
     * @param func the tri-variable function to integrate
     * @param pointWithWeights an array of points and their weights used for
     * integration
     * @return the result of the integration
     * @throws IllegalArgumentException if the function, pointWithWeights is
     * null, or if pointWithWeights does not have the correct structure
     */
    public double integrate(Tetrahedron tetrahedron, TriFunction<Double, Double, Double, Double> func,
            Double[][] pointWithWeights) {
        if (func == null || pointWithWeights == null) {
            throw new IllegalArgumentException("The function and pointWithWeights cannot be null.");
        }
        if (pointWithWeights[0].length != 4) {
            throw new IllegalArgumentException("The pointWithWeights array must have 3 elements in each row.");
        }
        return applyArrayAndTimesWithWeightsAndSum(func, transformPoints(tetrahedron, pointWithWeights));
    }

    /**
     * Applies the given tri-function to each point in the given array of
     * points, multiplies the result by the weight of the point, and sums up the
     * results.
     * <p>
     * The given tri-function is applied to the first three elements of each
     * point in the given array of points, and the result is multiplied by the
     * fourth element of the point, which is the weight of the point. The
     * results are then summed up.
     * <p>
     * This method is used to apply a function to each point in the integral,
     * and calculate the integral.
     * <p>
     *
     * @param func the tri-function to apply
     * @param pointWithWeights the points and their weights to apply the
     * function to
     * @return the sum of the results
     */
    protected double applyArrayAndTimesWithWeightsAndSum(TriFunction<Double, Double, Double, Double> func,
            Double[][] pointWithWeights) {
        double result = 0.0;
        for (Double[] pointWithWeight : pointWithWeights) {
            result += func.apply(pointWithWeight[0], pointWithWeight[1], pointWithWeight[2]) * pointWithWeight[3];
        }
        return result;
    }
}
