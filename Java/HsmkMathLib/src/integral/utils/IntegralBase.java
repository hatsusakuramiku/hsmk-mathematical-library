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
package integral.utils;

import java.util.function.BiFunction;
import java.util.function.Function;

/**
 * This interface provides the base class for the Integral interface. It contains
 * methods for checking if a range is valid and for calculating the step size for
 * a given range.
 * 
 * @author hatsusakuramiku
 */
public interface IntegralBase {
    /**
     * The default error tolerance for the integral methods.
     */
    public final double EPS = 1e-6;
    /**
     * The value of pi.
     */
    public final double PI = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679;

    /**
     * Checks if the range is valid. The range is valid if the left endpoint is
     * less than the right endpoint.
     * 
     * @param leftEndpoint  The left endpoint of the range.
     * @param rightEndpoint The right endpoint of the range.
     * @return true If the range is valid, false otherwise.
     */
    default boolean checkRange(double leftEndpoint, double rightEndpoint) {
        return leftEndpoint < rightEndpoint;
    }

    /**
     * Calculates the step size for a given range.
     * 
     * @param leftEndpoint      The left endpoint of the range.
     * @param rightEndpoint     The right endpoint of the range.
     * @param littleRangeNumber The number of little ranges.
     * @return The step size.
     */
    default double getStep(double leftEndpoint, double rightEndpoint, int littleRangeNumber) {
        return (rightEndpoint - leftEndpoint) / littleRangeNumber;
    }

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval using an adaptive integration method.
     * 
     * 
     * 
     * @param func      The function to integrate, represented as a
     *                   Function&lt;Double, Double&gt;.
     * @param leftEndpoint The left endpoint of the integration interval.
     * @param rightEndpoint The right endpoint of the integration interval.
     * @param eps         The desired error tolerance for the integration.
     * @return The approximate value of the definite integral.
     * @throws NullPointerException If the function is null.
     * @throws ArithmeticException  If an arithmetic error occurs during
     *                              integration.
     */
    <T extends Function<Double, Double>> double integral(T func, double leftEndpoint, double rightEndpoint,
            double eps);

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval using an adaptive integration method.
     * 
     * @param func       The function to integrate, represented as a
     *                   Function&lt;Double, Double&gt;.
     * @param leftEndpoint The left endpoint of the integration interval.
     * @param rightEndpoint The right endpoint of the integration interval.
     * @return The approximate value of the definite integral.
     * @throws NullPointerException If the function is null.
     * @throws ArithmeticException  If an arithmetic error occurs during
     *                              integration.
     */
    default <T extends Function<Double, Double>> double integral(T func, double leftEndpoint, double rightEndpoint) {
        return integral(func, leftEndpoint, rightEndpoint, EPS);
    }

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval using the trapezoidal rule with a fixed step size.
     * 
     * @param func       The function to integrate, represented as a
     *                   Function&lt;Double, Double&gt;.
     * @param leftEndpoint The left endpoint of the integration interval.
     * @param rightEndpoint The right endpoint of the integration interval.
     * @param step        The step size to use for the trapezoidal rule.
     * @return The approximate value of the definite integral.
     * @throws NullPointerException If the function is null.
     * @throws ArithmeticException  If an arithmetic error occurs during
     *                              integration.
     */
    <T extends Function<Double, Double>> double integralFixedStep(T func, double leftEndpoint,
            double rightEndpoint,
            double step);

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval using the trapezoidal rule with a fixed step size.
     * 
     * @param func       The function to integrate, represented as a
     *                   Function&lt;Double, Double&gt;.
     * @param leftEndpoint The left endpoint of the integration interval.
     * @param rightEndpoint The right endpoint of the integration interval.
     * @param littleRangeNumber The number of little ranges.
     * @return The approximate value of the definite integral.
     * @throws NullPointerException If the function is null.
     * @throws ArithmeticException  If an arithmetic error occurs during
     *                              integration.
     */
    <T extends Function<Double, Double>> double integralFixedStep(T func, double leftEndpoint,
            double rightEndpoint,
            int littleRangeNumber);

    /**
     * Approximates the definite integral of a double-variable function over a
     * specified interval using an adaptive integration method.
     * 
     * @param func       The function to integrate, represented as a
     *                   TriFunction&lt;Double, Double, Double, Double&gt;.
     * @param xleftEndpoint The left endpoint of the x integration interval.
     * @param xrightEndpoint The right endpoint of the x integration interval.
     * @param yleftEndpoint The left endpoint of the y integration interval.
     * @param yrightEndpoint The right endpoint of the y integration interval.
     * @param eps         The desired error tolerance for the integration.
     * @return The approximate value of the definite integral.
     * @throws NullPointerException If the function is null.
     * @throws ArithmeticException  If an arithmetic error occurs during
     *                              integration.
     */
    <T extends BiFunction<Double, Double, Double>> double iitegral(T func, double xleftEndpoint, double xrightEndpoint,
            double yleftEndpoint, double yrightEndpoint, double eps);
}
