package integral.algorithm;

import integral.utils.IntegralBase;
import java.util.function.Function;

/**
 * This class provides an implementation of the Simpson rule for
 * approximating the definite integral of a function.
 */
public final class Simpson implements IntegralBase {
    /**
     * Returns an instance of this class.
     * 
     * @return an instance of this class
     */
    public final static Simpson INSTANCE = new Simpson();

    /**
     * Private constructor to prevent instantiation.
     */
    private Simpson() {
    }

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval using an adaptive integration method.
     *
     * @param func
     *                      The function to integrate, represented as a
     *                      Function&lt;Double, Double&gt;.
     * @param leftEndpoint
     *                      The left endpoint of the integration interval.
     * @param rightEndpoint
     *                      The right endpoint of the integration interval.
     * @param eps
     *                      The desired error tolerance for the integration.
     * @return The approximate value of the definite integral.
     * @throws NullPointerException
     *                                  If the function is null.
     * @throws IllegalArgumentException
     *                                  If the endpoints are not in the range of the
     *                                  function, or
     *                                  if any of the endpoints or step are NaN.
     * @throws ArithmeticException
     *                                  If an arithmetic error occurs during
     *                                  integration.
     */
    @Override
    public <T extends Function<Double, Double>> double integral(T func, double leftEndpoint, double rightEndpoint,
            double eps) {
        // Check if the function is null
        if (func == null)

        {
            throw new NullPointerException("Function cannot be null");
        }
        // Check if the endpoints are in the range of the function
        if (!checkRange(leftEndpoint, rightEndpoint)) {
            throw new IllegalArgumentException("Endpoints must be in the range of the function");
        }
        // Check if the endpoints or step are NaN
        if (Double.isNaN(leftEndpoint) || Double.isNaN(rightEndpoint) || Double.isNaN(eps)) {
            throw new IllegalArgumentException("Endpoints and eps cannot be NaN");
        }
        if (eps < 0) {
            throw new IllegalArgumentException("eps must be non-negative");
        }
        // Use adaptive Simpson's rule to approximate the integral
        return adaptiveSimpson(func, leftEndpoint, rightEndpoint, eps, baseSimpson(func, leftEndpoint, rightEndpoint));
    }

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval using Simpson's rule with a fixed step size.
     *
     * @param func          The function to integrate, represented as a
     *                      Function&lt;Double, Double&gt;.
     * @param leftEndpoint  The left endpoint of the integration interval.
     * @param rightEndpoint The right endpoint of the integration interval.
     * @param step          The step size to use for Simpson's rule.
     *
     * @return The approximate value of the definite integral.
     *
     * @throws NullPointerException     If the function is null.
     * @throws IllegalArgumentException If the endpoints are not in the range of the
     *                                  function, or
     *                                  if any of the endpoints or step are NaN.
     * @throws ArithmeticException      If an arithmetic error occurs during
     *                                  integration.
     */
    @Override
    public <T extends Function<Double, Double>> double integralFixedStep(T func, double leftEndpoint,
            double rightEndpoint, double step) {
        // Check if the function is null
        if (func == null) {
            throw new NullPointerException("Function cannot be null");
        }
        // Check if the endpoints are in the range of the function
        if (!checkRange(leftEndpoint, rightEndpoint)) {
            throw new IllegalArgumentException("Endpoints must be in the range of the function");
        }
        // Check if the endpoints or step are NaN
        if (Double.isNaN(leftEndpoint) || Double.isNaN(rightEndpoint) || Double.isNaN(step)) {
            throw new IllegalArgumentException("Endpoints and step cannot be NaN");
        }
        // Check if the step is zero
        if (step == 0) {
            throw new ArithmeticException("Step cannot be zero");
        }
        // Calculate the number of subintervals
        int littleRangeNumber = (int) ((rightEndpoint - leftEndpoint) / step);
        // Check if the step is too large
        if (littleRangeNumber < 1) {
            throw new ArithmeticException("The step is too large");
        }
        double sum = 0;
        // Use Simpson's rule to approximate the integral for each subinterval
        for (int i = 0; i < littleRangeNumber; i++) {
            sum += baseSimpson(func, leftEndpoint + i * step, leftEndpoint + (i + 1) * step);
        }
        // Use Simpson's rule to approximate the integral for the last subinterval
        sum += baseSimpson(func, leftEndpoint + littleRangeNumber * step, rightEndpoint);
        return sum;
    }

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval using Simpson's rule with a fixed number of
     * subintervals.
     *
     * @param func              The function to integrate, represented as a
     *                          Function&lt;Double, Double&gt;.
     * @param leftEndpoint      The left endpoint of the integration interval.
     * @param rightEndpoint     The right endpoint of the integration interval.
     * @param littleRangeNumber The number of subintervals to divide the interval
     *                          into.
     *
     * @return The approximate value of the definite integral.
     *
     * @throws NullPointerException     If the function is null.
     * @throws IllegalArgumentException If the endpoints are not in the range of the
     *                                  function, or
     *                                  if any of the endpoints or the number of
     *                                  subintervals are NaN.
     * @throws ArithmeticException      If an arithmetic error occurs during
     *                                  integration.
     */
    @Override
    public <T extends Function<Double, Double>> double integralFixedStep(T func, double leftEndpoint,
            double rightEndpoint, int littleRangeNumber) {
        // Use Simpson's rule with a fixed step size to approximate the integral
        return integralFixedStep(func, leftEndpoint, rightEndpoint, (rightEndpoint - leftEndpoint) / littleRangeNumber);
    }

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval using a single application of Simpson's rule.
     *
     * @param func          The function to integrate, represented as a
     *                      Function&lt;Double, Double&gt;.
     * @param leftEndpoint  The left endpoint of the integration interval.
     * @param rightEndpoint The right endpoint of the integration interval.
     *
     * @return The approximate value of the definite integral.
     *
     * @throws NullPointerException     If the function is null.
     * @throws IllegalArgumentException If the endpoints are not in the range of the
     *                                  function, or
     *                                  if any of the endpoints are NaN.
     * @throws ArithmeticException      If an arithmetic error occurs during
     *                                  integration.
     */
    private <T extends Function<Double, Double>> double baseSimpson(T func, double leftEndpoint, double rightEndpoint) {
        double h = (rightEndpoint - leftEndpoint) / 2;
        return (func.apply(leftEndpoint) + 4 * func.apply(leftEndpoint + h) + func.apply(rightEndpoint)) * h / 3;
    }

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval using an adaptive Simpson's rule algorithm.
     *
     * @param func          The function to integrate, represented as a
     *                      Function&lt;Double, Double&gt;.
     * @param leftEndpoint  The left endpoint of the integration interval.
     * @param rightEndpoint The right endpoint of the integration interval.
     * @param eps           The desired error tolerance for the integration.
     * @param ans           The result of the previous iteration of the algorithm.
     *
     * @return The approximate value of the definite integral.
     *
     * @throws NullPointerException     If the function is null.
     * @throws IllegalArgumentException If the endpoints are not in the range of the
     *                                  function, or
     *                                  if any of the endpoints or the desired error
     *                                  tolerance are NaN.
     * @throws ArithmeticException      If an arithmetic error occurs during
     *                                  integration.
     */
    private <T extends Function<Double, Double>> double adaptiveSimpson(T func, double leftEndpoint,
            double rightEndpoint, double eps, double ans) {
        double mid = (leftEndpoint + rightEndpoint) / 2;
        double fl = baseSimpson(func, leftEndpoint, mid), fr = baseSimpson(func, mid, rightEndpoint);
        if (Math.abs(fl + fr - ans) < eps * 15) {
            return fl + fr + (fl + fr - ans) / 15;
        }
        return adaptiveSimpson(func, leftEndpoint, mid, eps / 2, fl)
                + adaptiveSimpson(func, mid, rightEndpoint, eps / 2, fr);
    }
}
