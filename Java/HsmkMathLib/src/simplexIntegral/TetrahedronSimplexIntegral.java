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
package simplexIntegral;

import simplexIntegral.function.TriFunction;
import simplexIntegral.polygon.Polygon;
import simplexIntegral.polygon.Tetrahedron;

final public class TetrahedronSimplexIntegral extends SimplexIntegral {
    public static enum IntegralFormula {
        ORDER1POINT4,
        ORDER4POINT23,
        ORDER7POINT50_v1,
        ORDER7POINT50_v2,
    }

    private static final IntegralPointWithWeight[] ORDER1POINT4 = new IntegralPointWithWeight[] {
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_1_VERTICE, 1.0 / 24.0)
    };

    private static final IntegralPointWithWeight[] ORDER4POINT23 = new IntegralPointWithWeight[] {
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_1_VERTICE, (13.0 - 3.0 * Math.sqrt(13)) / 10080.0),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_2_MIDOFEDGE, (4.0 - Math.sqrt(13)) / 315.0),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_4_CENTRE, 16.0 / 315.0),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_5_FACEINTERIOR,
                    (29.0 + 17.0 * Math.sqrt(13)) / 10080.0, new double[] { (7.0 - Math.sqrt(13)) / 18.0 })
    };

    private static final IntegralPointWithWeight[] ORDER7POINT50_v1 = new IntegralPointWithWeight[] {
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_1_VERTICE,
                    0.2143608668049743E-03),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_7_EDGEINTERIOR,
                    0.8268179517797114E-03, new double[] {
                            0.2928294047674109E-00 }),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_5_FACEINTERIOR,
                    0.1840177904191860E-02, new double[] {
                            0.1972862280257976E-00 }),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_5_FACEINTERIOR,
                    0.1831324329245650E-02, new double[] {
                            0.4256461243139345E-00 }),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_8_INTERIOR,
                    0.7542468904648131E-02, new double[] { 0.9503775858394107E-01

                    }),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_9_INTERIOR,
                    0.1360991755970793E-01, new double[] { 0.1252462362578136E-00 })
    };

    private static final IntegralPointWithWeight[] ORDER7POINT50_v2 = new IntegralPointWithWeight[] {
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_1_VERTICE,
                    0.2321968872348930E-03),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_7_EDGEINTERIOR,
                    0.7328680241632055E-03, new double[] {
                            0.3052598756695660E-00 }),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_5_FACEINTERIOR,
                    0.2529792598144742E-02, new double[] {
                            0.4204599755540437E-00 }),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_5_FACEINTERIOR,
                    0.1564461923378417E-02, new double[] {
                            0.1480462980008327E-00 }),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_8_INTERIOR,
                    0.7127911446564579E-02, new double[] { 0.1048645248917035E-00

                    }),
            new IntegralPointWithWeight(TetrahedronPointClass.CLASS_9_INTERIOR,
                    0.1321679379720540E-01, new double[] { 0.1258796196682507E-00 })
    };

    private static enum TetrahedronPointClass implements PointClass {
        CLASS_1_VERTICE, // 各顶点
        CLASS_2_MIDOFEDGE, // 各边的中点
        CLASS_3_FACECENTRE, // 各面的中心
        CLASS_4_CENTRE, // 中心
        CLASS_5_FACEINTERIOR, // 各面的内部点（三边中线上的点）
        CLASS_6_FACEINTERIOR, // 各面的内部点
        CLASS_7_EDGEINTERIOR, // 各边的内部点
        CLASS_8_INTERIOR, // 内部点
        CLASS_9_INTERIOR, // 内部点
        CLASS_10_INTERIOR, // 内部点
        CLASS_11_INTERIOR;// 内部点
    }

    /**
     * Returns the integral points in the tetrahedron for a given point class and
     * any extra parameters.
     * <p>
     * The integral points are represented as an array of double arrays, where each
     * double array contains
     * the coordinates of a point in the tetrahedron.
     * <p>
     * Supported point classes and their corresponding integral points and
     * parameters:
     * <ul>
     * <li>CLASS_1_VERTICE: Vertices of the tetrahedron, no extra parameters.</li>
     * <li>CLASS_2_MIDOFEDGE: Midpoints of the edges, no extra parameters.</li>
     * <li>CLASS_3_FACECENTRE: Centers of the faces, no extra parameters.</li>
     * <li>CLASS_4_CENTRE: The centroid of the tetrahedron, no extra
     * parameters.</li>
     * <li>CLASS_5_FACEINTERIOR: Interior points of faces with one extra
     * parameter.</li>
     * <li>CLASS_6_FACEINTERIOR: Interior points of faces with two extra
     * parameters.</li>
     * <li>CLASS_7_EDGEINTERIOR: Interior points of edges with one extra
     * parameter.</li>
     * <li>CLASS_8_INTERIOR: Interior points with one extra parameter.</li>
     * <li>CLASS_9_INTERIOR: Interior points with one extra parameter.</li>
     * <li>CLASS_10_INTERIOR: Interior points with two extra parameters.</li>
     * <li>CLASS_11_INTERIOR: Interior points with three extra parameters.</li>
     * </ul>
     * <p>
     * Throws an IllegalArgumentException if the point class is not supported.
     *
     * @param points the integral point class and extra parameters
     * @return the coordinates of the integral points within the tetrahedron
     * @throws IllegalArgumentException if the point class is not supported
     */

    @Override
    protected double[][] getIntegralPoints(IntegralPointWithWeight points) {
        switch (points.pointClass) {
            case TetrahedronPointClass.CLASS_1_VERTICE -> {
                return new double[][] {
                        { 0.0, 0.0, 0.0 },
                        { 1.0, 0.0, 0.0 },
                        { 0.0, 1.0, 0.0 },
                        { 0.0, 0.0, 1.0 }
                };
            }
            case TetrahedronPointClass.CLASS_2_MIDOFEDGE -> {
                return new double[][] {
                        { 0.0, 0.5, 0.0 },
                        { 0.5, 0.5, 0.0 },
                        { 0.5, 0.0, 0.0 },
                        { 0.0, 0.0, 0.5 },
                        { 0.5, 0.0, 0.5 },
                        { 0.0, 0.5, 0.5 },
                };
            }
            case TetrahedronPointClass.CLASS_3_FACECENTRE -> {
                double oneThird = 1.0 / 3.0;
                return new double[][] {
                        { oneThird, oneThird, 0.0 },
                        { oneThird, 0.0, oneThird },
                        { 0.0, oneThird, oneThird },
                        { oneThird, oneThird, oneThird }
                };
            }
            case TetrahedronPointClass.CLASS_4_CENTRE -> {
                return new double[][] {
                        { 0.25, 0.25, 0.25 }
                };
            }
            case TetrahedronPointClass.CLASS_5_FACEINTERIOR -> {
                double param = points.extParams[0];
                double param2 = 1.0 - 2.0 * param;
                return new double[][] {
                        { param, param, 0.0 },
                        { 0.0, param, param },
                        { param, 0.0, param },
                        { param, param, param2 },
                        { param2, param, param },
                        { param, param2, param },
                        { param2, param, 0.0 },
                        { param, param2, 0.0 },
                        { 0.0, param2, param },
                        { 0.0, param, param2 },
                        { param2, 0.0, param },
                        { param, 0.0, param2 }

                };
            }
            case TetrahedronPointClass.CLASS_6_FACEINTERIOR -> {
                double param1 = points.extParams[0];
                double param2 = points.extParams[1];
                double param3 = 1.0 - param1 - param2;
                return new double[][] {
                        { 0.0, param1, param2 },
                        { 0.0, param2, param1 },
                        { param1, 0.0, param2 },
                        { param2, 0.0, param1 },
                        { param1, param2, 0.0 },
                        { param2, param1, 0.0 },

                        { 0.0, param3, param1 },
                        { 0.0, param1, param3 },
                        { param1, 0.0, param3 },
                        { param3, 0.0, param1 },
                        { param3, param1, 0.0 },
                        { param1, param3, 0.0 },

                        { 0.0, param3, param2 },
                        { 0.0, param2, param3 },
                        { param2, 0.0, param3 },
                        { param3, 0.0, param2 },
                        { param3, param2, 0.0 },
                        { param2, param3, 0.0 },

                        { param1, param3, param2 },
                        { param1, param2, param3 },
                        { param2, param1, param3 },
                        { param3, param1, param2 },
                        { param3, param2, param1 },
                        { param2, param3, param1 }

                };
            }
            case TetrahedronPointClass.CLASS_7_EDGEINTERIOR -> {
                double param = points.extParams[0];
                double param2 = 1.0 - param;
                return new double[][] {
                        { param, 0.0, 0.0 },
                        { param2, 0.0, 0.0 },
                        { 0.0, param2, 0.0 },
                        { 0.0, param, 0.0 },
                        { 0.0, 0.0, param },
                        { 0.0, 0.0, param2 },
                        { param, 0.0, param2 },
                        { param2, 0.0, param },
                        { 0.0, param, param2 },
                        { 0.0, param2, param },
                        { param, param2, 0.0 },
                        { param2, param, 0.0 }
                };
            }
            case TetrahedronPointClass.CLASS_8_INTERIOR -> {
                double param = points.extParams[0];
                double param2 = 1.0 - 3.0 * param;
                return new double[][] {
                        { param, param, param },
                        { param2, param, param },
                        { param, param2, param },
                        { param, param, param2 }
                };
            }
            case TetrahedronPointClass.CLASS_9_INTERIOR -> {
                double param = points.extParams[0];
                double param2 = 0.5 - param;
                return new double[][] {
                        { param, param, param2 },
                        { param, param2, param },
                        { param2, param, param },
                        { param, param2, param2 },
                        { param2, param, param2 },
                        { param2, param2, param }
                };
            }
            case TetrahedronPointClass.CLASS_10_INTERIOR -> {
                double param1 = points.extParams[0];
                double param2 = points.extParams[1];
                double param3 = 1.0 - param1 - param2;
                return new double[][] {
                        { param1, param1, param2 },
                        { param1, param2, param1 },
                        { param2, param1, param1 },
                        { param1, param2, param3 },
                        { param3, param2, param1 },
                        { param2, param1, param3 },
                        { param3, param1, param2 },
                        { param2, param3, param1 },
                        { param3, param1, param2 },
                        { param1, param1, param3 },
                        { param2, param3, param1 },
                        { param3, param1, param1 }
                };
            }
            case TetrahedronPointClass.CLASS_11_INTERIOR -> {
                double param1 = points.extParams[0];
                double param2 = points.extParams[1];
                double param3 = points.extParams[2];
                double param4 = 1.0 - param1 - param2 - param3;
                return new double[][] {
                        { param1, param2, param3 },
                        { param3, param2, param1 },
                        { param2, param1, param3 },
                        { param3, param1, param2 },
                        { param2, param3, param1 },
                        { param1, param3, param2 },
                        { param1, param2, param4 },
                        { param4, param2, param1 },
                        { param2, param1, param4 },
                        { param4, param1, param2 },
                        { param2, param4, param1 },
                        { param1, param4, param2 },
                        { param3, param2, param4 },
                        { param4, param2, param3 },
                        { param2, param3, param4 },
                        { param4, param3, param2 },
                        { param2, param4, param3 },
                        { param3, param4, param2 },
                        { param1, param4, param3 },
                        { param3, param4, param1 },
                        { param4, param1, param3 },
                        { param3, param1, param4 },
                        { param4, param3, param1 },
                        { param1, param3, param4 }
                };
            }
            default -> {
                throw new IllegalArgumentException("pointClass is not supported");
            }
        }
    }

    /**
     * Transforms the given points from the integral coordinates to the real
     * coordinates of the given tetrahedron.
     * <p>
     * The integral coordinates are the coordinates of the points in the integral,
     * and the real coordinates
     * are the coordinates of the points in the tetrahedron.
     * <p>
     * The transformation is done with the following formulas:
     * <p>
     * x = x1 * a + x2 * b + x3 * c + x4 * d
     * y = y1 * a + y2 * b + y3 * c + y4 * d
     * z = z1 * a + z2 * b + z3 * c + z4 * d
     * <p>
     * where (x1, y1, z1), (x2, y2, z2), (x3, y3, z3), and (x4, y4, z4) are the
     * coordinates of the vertices of this tetrahedron, and (a, b, c) are the
     * coordinates of the point in the integral, and d is 1 - a - b - c.
     * <p>
     * 
     * @param polygon        the tetrahedron to transform the points to
     * @param integralPoints the points to transform
     * @return the transformed points
     */
    @Override
    protected <T extends Polygon> double[][] transformPoints(T polygon, double[][] integralPoints) {
        double[][] vertices = polygon.getVertices();
        double[][] transformedPoints = new double[integralPoints.length][3];
        for (int i = 0; i < integralPoints.length; i++) {
            double a = integralPoints[i][0];
            double b = integralPoints[i][1];
            double c = integralPoints[i][2];
            double d = 1 - a - b - c;
            transformedPoints[i][0] = vertices[0][0] * a + vertices[1][0] * b + vertices[2][0] * c + vertices[3][0] * d;// x
            transformedPoints[i][1] = vertices[0][1] * a + vertices[1][1] * b + vertices[2][1] * c + vertices[3][1] * d;// y
            transformedPoints[i][2] = vertices[0][2] * a + vertices[1][2] * b + vertices[2][2] * c + vertices[3][2] * d;// z
        }
        return transformedPoints;
    }

    /**
     * Retrieves the integral points and weights associated with a given integral
     * formula.
     * <p>
     * This method returns an array of {@link IntegralPointWithWeight} corresponding
     * to the specified
     * integral formula. Each entry in the array represents a point within the
     * tetrahedron and its
     * associated weight for integration.
     * <p>
     * Supported integral formulas:
     * <ul>
     * <li>{@code ORDER1POINT4}</li>
     * <li>{@code ORDER4POINT23}</li>
     * <li>{@code ORDER7POINT50_v1}</li>
     * <li>{@code ORDER7POINT50_v2}</li>
     * </ul>
     * <p>
     * If an unsupported formula is provided, an {@link IllegalArgumentException} is
     * thrown.
     * 
     * @param formula the integral formula specifying the desired points and weights
     * @return an array of {@link IntegralPointWithWeight} for the specified formula
     * @throws IllegalArgumentException if the formula is unknown
     */

    private IntegralPointWithWeight[] getFormulaIntegralPointWithWeights(IntegralFormula formula) {
        switch (formula) {
            case ORDER1POINT4 -> {
                return ORDER1POINT4;
            }
            case ORDER4POINT23 -> {
                return ORDER4POINT23;
            }

            case ORDER7POINT50_v1 -> {
                return ORDER7POINT50_v1;
            }

            case ORDER7POINT50_v2 -> {
                return ORDER7POINT50_v2;
            }
            default -> {
                throw new IllegalArgumentException("Unknown formula: " + formula);
            }
        }
    }

    /**
     * Evaluates the integral of the given function over the given tetrahedron using
     * the given integral points.
     * <p>
     * The given integral points are the coordinates of the points in the integral,
     * and the weights are the weights of the points in the integral.
     * <p>
     * The integral is calculated as the sum of the function values at the points
     * multiplied by the weights.
     * <p>
     * The integral is then multiplied by 6 times the tetrahedron's measure.
     * <p>
     * The integral points are transformed into the tetrahedron's coordinates
     * before being passed to the function.
     *
     * @param tetrahedron the tetrahedron to integrate over
     * @param f           the function to integrate
     * @param points      the integral points
     * @return the integral of the function over the tetrahedron
     */
    private <T extends TriFunction<Double, Double, Double, Double>> double integrate(Tetrahedron tetrahedron, T f,
            IntegralPointWithWeight[] points) {
        IntegralPointsWithWeight[] pointsWithWeights = getIntegralPointsWithWeightArray(points);
        double result = 0.0;
        for (IntegralPointsWithWeight point : pointsWithWeights) {
            result += point.weight * applyArray(f, transformPoints(tetrahedron, point.points));
        }
        return result * 6.0 * tetrahedron.getMeasure();
    }

    /**
     * Evaluates the integral of the given function over the given tetrahedron using
     * the given integral formula.
     * <p>
     * The integral formula is used to determine the points in the integral and
     * their weights.
     * <p>
     * The integral is calculated as the sum of the function values at the points
     * multiplied by the weights.
     * <p>
     * The integral is then multiplied by 6 times the tetrahedron's measure.
     * <p>
     * The integral points are transformed into the tetrahedron's coordinates
     * before being passed to the function.
     *
     * @param tetrahedron the tetrahedron to integrate over
     * @param f           the function to integrate
     * @param formula     the integral formula to use
     * @return the integral of the function over the tetrahedron
     */
    public <T extends TriFunction<Double, Double, Double, Double>> double integrate(
            Tetrahedron tetrahedron, T f, IntegralFormula formula) {
        return integrate(tetrahedron, f, getFormulaIntegralPointWithWeights(formula));
    }

}
