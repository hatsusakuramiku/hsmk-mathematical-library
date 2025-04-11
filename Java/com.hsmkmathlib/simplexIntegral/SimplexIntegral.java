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

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.StringJoiner;
import java.util.function.BiFunction;
import simplexIntegral.function.TriFunction;
import simplexIntegral.polygon.Polygon;

public abstract class SimplexIntegral {
    protected final HashMap<String, IntegralPointWithWeight[]> INTEGRALFORMULAS = initalIntegralFormulas();

    abstract protected HashMap<String, IntegralPointWithWeight[]> initalIntegralFormulas();

    // 定义一个内部类IntegralPointWithWeight，用于存储积分点的类、权重和扩展参数
    protected static class IntegralPointWithWeight {
        // 积分点的类
        PointClass pointClass;
        // 权重
        double weight;
        // 扩展参数
        double[] extParams;

        // 构造函数，传入积分点的类、权重和扩展参数
        public IntegralPointWithWeight(PointClass pointClass, double weight, double[] extParams) {
            this.pointClass = pointClass;
            this.weight = weight;
            this.extParams = new double[extParams.length];
            // 将传入的扩展参数复制到新的数组中
            System.arraycopy(extParams, 0, this.extParams, 0, extParams.length);
        }

        // 构造函数，传入积分点的类和权重
        public IntegralPointWithWeight(PointClass pointClass, double weight) {
            this.pointClass = pointClass;
            this.weight = weight;
        }
    }

    // 定义一个内部类，用于存储积分点和权重
    protected static class IntegralPointsWithWeight {
        // 积分点数组
        double[][] points;
        // 权重
        double weight;

        // 构造函数，传入积分点和权重
        public IntegralPointsWithWeight(double[][] points, double weight) {
            this.points = points;
            this.weight = weight;
        }
    }

    /**
     * Returns an array of IntegralPointsWithWeight, which is a 2D array of double
     * and a double. The double array is the coordinates of the points in the
     * integral, and the double is the weight of the points in the integral.
     * <p>
     * The integral points are generated by calling the getIntegralPoints method
     * on the given array of IntegralPointWithWeight, and the weight is the weight
     * of the IntegralPointWithWeight.
     * <p>
     * This method is used to convert an array of IntegralPointWithWeight to an
     * array of IntegralPointsWithWeight, which is used to store the integral
     * points and their weights.
     * <p>
     * 
     * @param points the array of IntegralPointWithWeight to convert
     * @return the array of IntegralPointsWithWeight
     */
    protected IntegralPointsWithWeight[] getIntegralPointsWithWeightArray(IntegralPointWithWeight[] points) {
        IntegralPointsWithWeight[] result = new IntegralPointsWithWeight[points.length];
        for (int i = 0; i < points.length; i++) {
            result[i] = new IntegralPointsWithWeight(getIntegralPoints(points[i]), points[i].weight);
        }
        return result;
    }

    /**
     * Applies the given bi-function to each point in the given array of points, and
     * returns the sum of the results.
     * <p>
     * The bi-function is applied to the first two elements of each point in the
     * given
     * array of points, and the results are summed up.
     * <p>
     * This method is used to apply a function to each point in the integral, and
     * calculate the integral.
     * <p>
     * 
     * @param f      the bi-function to apply
     * @param points the array of points to apply the function to
     * @return the sum of the results
     */
    protected <T extends BiFunction<Double, Double, Double>> double applyArray(T f, double[][] points) {
        double result = 0.0;
        for (double[] point : points) {
            result += f.apply(point[0], point[1]);
        }
        return result;
    }

    /**
     * Applies the given tri-function to each point in the given array of points,
     * and
     * returns the sum of the results.
     * <p>
     * The tri-function is applied to the first three elements of each point in the
     * given array of points, and the results are summed up.
     * <p>
     * This method is used to apply a function to each point in the integral, and
     * calculate the integral.
     * <p>
     * 
     * @param f      the tri-function to apply
     * @param points the array of points to apply the function to
     * @return the sum of the results
     */
    protected <T extends TriFunction<Double, Double, Double, Double>> double applyArray(T f, double[][] points) {
        double result = 0.0;
        for (double[] point : points) {
            result += f.apply(point[0], point[1], point[2]);
        }
        return result;
    }

    abstract protected <T extends Polygon> double[][] transformPoints(T polygon, double[][] integralPoints);

    abstract protected double[][] getIntegralPoints(IntegralPointWithWeight points);

    /**
     * Saves the integral points and their weights of all integral formulas to a
     * file.
     * <p>
     * The method iterates over all integral formulas, retrieves their integral
     * points
     * and weights, formats them into a string, and writes the strings to a file.
     * The
     * file is specified by the parameter fileName.
     * <p>
     * The format of the output file is as follows: Each line contains the integral
     * points and their weights of an integral formula. The integral points and
     * their
     * weights are formatted as a string, where each point's coordinates are
     * followed
     * by its weight, separated by commas, and each point-weight pair is separated
     * by
     * a semicolon. The entire sequence is enclosed in square brackets and ends with
     * a
     * semicolon.
     * <p>
     * If an error occurs while writing to the file, the error is printed to the
     * standard error stream.
     * <p>
     * 
     * @param fileName the file name to save the integral points and their weights
     *                 to
     */
    public void saveIntegralPoints(String fileName) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(fileName))) {
            INTEGRALFORMULAS.forEach((formula, integralPoints) -> {
                try {
                    bw.write(formula + " = " + integralFormulaToString(integralPoints));
                    bw.newLine();
                } catch (IOException e) {
                    System.err.println("Error writing to file: " + e.getMessage());
                }
            });
        } catch (IOException e) {
            System.err.println("Error initializing file writer: " + e.getMessage());
        }
    }

    /**
     * Converts an array of IntegralPointWithWeight objects into a formatted string
     * representation.
     * <p>
     * This method takes an array of IntegralPointWithWeight, retrieves the integral
     * points and their weights, and formats them as a string. Each point's
     * coordinates are followed by its weight, separated by commas, and each
     * point-weight pair is separated by a semicolon. The entire sequence is
     * enclosed
     * in square brackets and ends with a semicolon.
     * <p>
     * This string representation is used to describe the integral formula in a
     * human-readable format.
     * <p>
     * 
     * @param points the array of IntegralPointWithWeight objects to convert
     * @return the formatted string representation of the integral points and
     *         weights
     */

    private String integralFormulaToString(IntegralPointWithWeight[] points) {
        IntegralPointsWithWeight[] pointsWithWeight = getIntegralPointsWithWeightArray(points);
        ArrayList<String> pointAndWeights = new ArrayList<>();
        for (IntegralPointsWithWeight pointWithWeight : pointsWithWeight) {
            for (double[] point : pointWithWeight.points) {
                pointAndWeights.add(point[0] + ", " + point[1] + ", " + pointWithWeight.weight + ";");
            }
        }
        StringJoiner sj = new StringJoiner("", "[", "];");
        Arrays.stream(pointAndWeights.toArray(String[]::new)).forEach(sj::add);
        return sj.toString();
    }

    /**
     * Retrieves the names of all integral formulas available in this instance.
     * <p>
     * This method returns an array of strings, where each string is the name of an
     * integral formula. The names correspond to the keys in the
     * INTEGRALFORMULAS map, which contains the integral formulas and their
     * associated data.
     * <p>
     * 
     * @return an array of strings representing the names of the integral formulas
     */

    public String[] getIntegralFormulas() {
        return INTEGRALFORMULAS.keySet().toArray(String[]::new);
    }

    /**
     * Retrieves the map of all integral formulas available in this instance.
     * <p>
     * This method returns the map of integral formulas, where each key is a string
     * representing the name of an integral formula, and the value is an array of
     * IntegralPointWithWeight objects, which contain the integral points and their
     * weights.
     * <p>
     * The map is the same as the INTEGRALFORMULAS map, which contains the integral
     * formulas and their associated data.
     * <p>
     * 
     * @return the map of integral formulas
     */
    public HashMap<String, IntegralPointWithWeight[]> getIntegralFormulasMap() {
        return INTEGRALFORMULAS;
    }

}
