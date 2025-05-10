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

import com.google.gson.Gson;
import java.io.FileWriter;
import java.io.IOException;
import java.io.BufferedWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.StringJoiner;
import java.util.function.BiFunction;

import com.hsmkmathlib.simplexIntegral.function.TriFunction;
import com.hsmkmathlib.simplexIntegral.polygon.Polygon;

public abstract class IntegralBase {

    protected final HashMap<String, Double[][]> INTEGRALFORMULAS = initalIntegralFormulas();

    abstract protected HashMap<String, Double[][]> initalIntegralFormulas();

    /**
     * Applies the given bi-function to each point in the given array of points,
     * and returns the sum of the results.
     * <p>
     * The bi-function is applied to the first two elements of each point in the
     * given array of points, and the results are summed up.
     * <p>
     * This method is used to apply a function to each point in the integral,
     * and calculate the integral.
     * <p>
     *
     * @param f the bi-function to apply
     * @param points the array of points to apply the function to
     * @return the sum of the results
     */
    protected <T extends BiFunction<Double, Double, Double>> double applyArray(T func, Double[][] points) {
        double result = 0.0;
        for (Double[] point : points) {
            result += func.apply(point[0], point[1]);
        }
        return result;
    }

    /**
     * Applies the given tri-function to each point in the given array of
     * points, and returns the sum of the results.
     * <p>
     * The tri-function is applied to the first three elements of each point in
     * the given array of points, and the results are summed up.
     * <p>
     * This method is used to apply a function to each point in the integral,
     * and calculate the integral.
     * <p>
     *
     * @param f the tri-function to apply
     * @param points the array of points to apply the function to
     * @return the sum of the results
     */
    protected <T extends TriFunction<Double, Double, Double, Double>> double applyArray(T f, Double[][] points) {
        double result = 0.0;
        for (Double[] point : points) {
            result += f.apply(point[0], point[1], point[2]);
        }
        return result;
    }

    abstract protected <T extends Polygon> Double[][] transformPoints(T polygon, Double[][] integralPoints);

    /**
     * Saves the integral points and their weights of all integral formulas to a
     * file.
     * <p>
     * The method iterates over all integral formulas, retrieves their integral
     * points and weights, formats them into a string, and writes the strings to
     * a file. The file is specified by the parameter fileName.
     * <p>
     * The format of the output file is as follows: Each line contains the
     * integral points and their weights of an integral formula. The integral
     * points and their weights are formatted as a string, where each point's
     * coordinates are followed by its weight, separated by commas, and each
     * point-weight pair is separated by a semicolon. The entire sequence is
     * enclosed in square brackets and ends with a semicolon.
     * <p>
     * If an error occurs while writing to the file, the error is printed to the
     * standard error stream.
     * <p>
     *
     * @param fileName the file name to save the integral points and their
     * weights to
     */
    public void saveIntegralPoints(String fileName) {
        String[] outSj_Strings = {"", "[", "];"};
        String[] inerSj_Strings = {", ", "", ";\n"};
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(fileName))) {
            INTEGRALFORMULAS.forEach((formula, integralPoints) -> {
                try {
                    bw.write(formula + " = " + integralFormulaToString(integralPoints, outSj_Strings, inerSj_Strings));
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
     * Converts an array of IntegralPointWithWeight objects into a formatted
     * string representation specific to the integral formula.
     * <p>
     * The method takes an array of IntegralPointWithWeight, retrieves the
     * integral points and their weights, and formats them as a string. Each
     * point's coordinates are followed by its weight, separated by commas, and
     * each point-weight pair is separated by a semicolon. The entire sequence
     * is enclosed in square brackets and ends with a semicolon.
     * <p>
     * This string representation is used to describe the integral formula in a
     * human-readable format.
     * <p>
     *
     * @param points the array of IntegralPointWithWeight objects to convert
     * @param outSj_Strings the outer StringJoiner's delimiter strings
     * @param inerSj_Strings the inner StringJoiner's delimiter strings
     * @return the formatted string representation of the integral points and
     * weights
     */
    protected String integralFormulaToString(Double[][] points, String[] outSj_Strings, String[] inerSj_Strings) {
        StringJoiner outSj = new StringJoiner(outSj_Strings[0], outSj_Strings[1], outSj_Strings[2]);

        for (Double[] point : points) {
            StringJoiner inerSj = new StringJoiner(inerSj_Strings[0], inerSj_Strings[1], inerSj_Strings[2]);
            for (Double p : point) {
                inerSj.add(String.valueOf(p));
            }
            outSj.add(inerSj.toString());
        }
        return outSj.toString();
    }

    /**
     * Retrieves the names of all integral formulas available in this instance.
     * <p>
     * This method returns an array of strings, where each string is the name of
     * an integral formula. The names correspond to the keys in the
     * INTEGRALFORMULAS map, which contains the integral formulas and their
     * associated data.
     * <p>
     *
     * @return an array of strings representing the names of the integral
     * formulas
     */
    public String[] getEnableIntegralFormulaName() {
        return INTEGRALFORMULAS.keySet().toArray(String[]::new);
    }

    /**
     * Adds an integral formula to the map of integral formulas available in
     * this instance.
     * <p>
     * This method adds a new integral formula to the map of integral formulas,
     * with the given name and array of integral points and weights. If the map
     * is empty, the method adds the integral formula without further checks. If
     * the map is not empty, the method checks if the integral formula already
     * exists in the map, and if not, adds it. If the integral formula already
     * exists, the method returns false.
     * <p>
     * The method also checks if the length of the first element of the given
     * array of integral points and weights is the same as the length of the
     * first element of any integral formula already in the map. If the lengths
     * are different, the method returns false.
     * <p>
     *
     * @param formulaName the name of the integral formula to add
     * @param pointWithWeights the array of integral points and weights of the
     * integral formula
     * @return true if the integral formula was added successfully, false
     * otherwise
     */
    public boolean addIntegralFormula(String formulaName, Double[][] pointWithWeights) {
        if (INTEGRALFORMULAS.isEmpty()) {
            INTEGRALFORMULAS.put(formulaName, pointWithWeights);
            return true;
        }
        if (!INTEGRALFORMULAS.containsKey(formulaName)) {
            Double[][] examplePointWithWeight = INTEGRALFORMULAS.values().iterator().next();
            if (examplePointWithWeight[0].length != pointWithWeights[0].length) {
                return false;
            }
            INTEGRALFORMULAS.put(formulaName, pointWithWeights);
        }
        return false;
    }

    /**
     * Clears the map of integral formulas and reinitializes it with the
     * integral formulas returned by the initalIntegralFormulas method.
     * <p>
     * This method can be used to reset the map of integral formulas to its
     * initial state.
     */
    public void initalIntegralFormulaHashMap() {
        INTEGRALFORMULAS.clear();
        initalIntegralFormulas().forEach((formulaName, pointWithWeights) -> {
            INTEGRALFORMULAS.put(formulaName, pointWithWeights);
        });
    }

    public void saveIntegralPointsToJson(String filename) {
        if (filename == null || filename.isEmpty()) {
            filename = "integralFormula";
        }
        filename += ".json";

        Gson gson = new Gson();
        String json = gson.toJson(INTEGRALFORMULAS);
        try (FileWriter writer = new FileWriter(filename)) {
            writer.write(json);
            System.out.println("JSON 文件已成功生成: " + filename);
        } catch (IOException e) {
            
        }
    }
}
