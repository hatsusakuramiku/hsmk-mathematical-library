package integral.algorithm;

import java.util.function.Function;

import integral.utils.IntegralBase;

/**
 * This class provides an implementation of the trapezoidal rule for
 * approximating the definite integral of a function.
 */
public final class Trapezoid implements IntegralBase {

    /**
     * Singleton instance of the Trapezoid class.
     * <p>
     * This instance provides a single, shared access point to the trapezoidal
     * integration functionality offered by the Trapezoid class.
     */
    public static final Trapezoid INSTANCE = new Trapezoid();

    /**
     * Approximates the definite integral of a function using the trapezoidal rule.
     *
     * @param func          The function to integrate.
     * @param leftEndpoint  The left endpoint of the interval.
     * @param rightEndpoint The right endpoint of the interval.
     *
     * @return The approximate value of the definite integral.
     */
    private double trapezoid(Function<Double, Double> func, double leftEndpoint, double rightEndpoint) {
        return (func.apply(leftEndpoint) + func.apply(rightEndpoint)) * 0.5;
    }

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval
     * using an adaptive integration method.
     *
     * @param func          The function to integrate, represented as a
     *                      Function<Double, Double>.
     * @param leftEndpoint  The left endpoint of the integration interval.
     * @param rightEndpoint The right endpoint of the integration interval.
     * @param eps           The desired error tolerance for the integration.
     * 
     * @return The approximate value of the definite integral.
     *
     * @throws NullPointerException     If the function is null.
     * @throws IllegalArgumentException If the endpoints are not in the range of the
     *                                  function, or if any of the endpoints or
     *                                  eps are NaN, or if eps is negative.
     * @throws ArithmeticException      If an arithmetic error occurs during
     *                                  integration.
     */

    @Override
    public <T extends Function<Double, Double>> double integral(T func, double leftEndpoint, double rightEndpoint,
            double eps) {
        if (func == null) {
            throw new NullPointerException("Function cannot be null");
        }
        if (!checkRange(leftEndpoint, rightEndpoint)) {
            throw new IllegalArgumentException("Endpoints must be in the range of the function");
        }
        if (Double.isNaN(leftEndpoint) || Double.isNaN(rightEndpoint) || Double.isNaN(eps)) {
            throw new IllegalArgumentException("Endpoints and epsilon cannot be NaN");
        }
        if (eps < 0) {
            throw new IllegalArgumentException("eps must be non-negative");
        }
        try {
            return adaptiveIntegrate(func, leftEndpoint, rightEndpoint, eps);
        } catch (ArithmeticException e) {
            throw e;
        }

    }

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval
     * using an adaptive integration method.
     * 
     * @param func          The function to integrate, represented as a
     *                      Function<Double, Double>.
     * @param leftEndpoint  The left endpoint of the integration interval.
     * @param rightEndpoint The right endpoint of the integration interval.
     * @param eps           The desired error tolerance for the integration.
     * 
     * @return The approximate value of the definite integral.
     * 
     * @throws NullPointerException If the function is null.
     * @throws ArithmeticException  If an arithmetic error occurs during
     *                              integration.
     */
    private <T extends Function<Double, Double>> double adaptiveIntegrate(T func, double leftEndpoint,
            double rightEndpoint, double eps) {
        int n = 1;
        double h = (rightEndpoint - leftEndpoint) / n;
        double I = 0;
        double half_h = h / 2, quarter_h = h / 4;
        while (true) {

            double whole = half_h * (func.apply(leftEndpoint) + func.apply(leftEndpoint + h));
            double left = quarter_h * (func.apply(leftEndpoint) + func.apply(leftEndpoint + half_h));
            double right = quarter_h * (func.apply(leftEndpoint + half_h) + func.apply(leftEndpoint + h));

            if (Math.abs(whole - left - right) <= 3 * eps) {
                I += left + right;
                leftEndpoint += h;
                n--;
                if (n == 0) {
                    break;
                }
            } else {
                n *= 2;
                h = half_h;
                half_h = quarter_h;
                quarter_h /= 2;
            }
        }

        return I;
    }

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval
     * using the trapezoidal rule with a fixed step size.
     *
     * @param func          The function to integrate, represented as a
     *                      Function<Double, Double>.
     * @param leftEndpoint  The left endpoint of the integration interval.
     * @param rightEndpoint The right endpoint of the integration interval.
     * @param step          The step size to use for the trapezoidal rule.
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
        if (func == null) {
            throw new NullPointerException("Function cannot be null");
        }
        if (!checkRange(leftEndpoint, rightEndpoint)) {
            throw new IllegalArgumentException("Endpoints must be in the range of the function");
        }
        if (Double.isNaN(leftEndpoint) || Double.isNaN(rightEndpoint) || Double.isNaN(step)) {
            throw new IllegalArgumentException("Endpoints and step cannot be NaN");
        }
        if (step == 0) {
            throw new ArithmeticException("Step cannot be zero");
        }
        int littleRangeNumber = (int) ((rightEndpoint - leftEndpoint) / step);
        if (littleRangeNumber < 1) {
            throw new ArithmeticException("The step is too large");
        }
        double sum = 0;
        for (int i = 0; i < littleRangeNumber; i++) {
            sum += trapezoid(func, leftEndpoint + i * step, leftEndpoint + (i + 1) * step);
        }
        sum += trapezoid(func, leftEndpoint + littleRangeNumber * step, rightEndpoint);
        return sum * step;
    }

    /**
     * Approximates the definite integral of a single-variable function over a
     * specified interval
     * using the trapezoidal rule with a fixed number of subintervals.
     *
     * @param func              The function to integrate, represented as a
     *                          Function<Double, Double>.
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
        try {
            return integralFixedStep(func, leftEndpoint, rightEndpoint,
                    (rightEndpoint - leftEndpoint) / littleRangeNumber);
        } catch (NullPointerException | IllegalArgumentException | ArithmeticException e) {
            throw e;
        }
    }

}
