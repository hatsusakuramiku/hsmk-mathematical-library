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

#include <stdlib.h>
#include "constDef.h"
#include "integral.h"
#include <stdio.h>
// #include <tgmath.h>


/**
 * Creates a new Interval object with the given bounds.
 *
 * @param a The lower bound of the interval (inclusive).
 * @param b The upper bound of the interval (inclusive).
 *
 * @return A new Interval object with the given bounds.
 *
 * @throws INTERVAL_SIZE_ERROR_001 If the lower bound is greater than or equal to the upper bound.
 */
Interval newInterval(const double a, const double b) {
 // Check if the interval is valid (i.e., the lower bound is less than the upper bound)
 if (a >= b) {
  // If the interval is invalid, throw an error with a descriptive message
  PERROR(INTERVAL_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
 }
 // If the interval is valid, create and return a new Interval object with the given bounds
 return (Interval){a, b};
}

/**
 * Approximates the definite integral of a function using the trapezoidal rule.
 *
 * @param interval The interval over which to integrate.
 * @param intervalNum The number of subintervals to divide the interval into.
 * @param func The function to integrate.
 *
 * @return The approximate value of the definite integral.
 *
 * @throws INTERVAL_SIZE_ERROR_002 If the number of subintervals is less than 1.
 */
double trapzoid(const Interval interval, const unsigned int intervalNum, const __integral_func func) {
 // Check if the number of subintervals is valid
 if (intervalNum < 1) {
  // If not, throw an error with a descriptive message
  PERROR(INTERVAL_SIZE_ERROR_002, 0, __FILE__, __FUNCTION__, __LINE__);
 }

 // Calculate the width of each subinterval
 double h = (interval.b - interval.a) / intervalNum;

 // Initialize the sum of the function values at the interval endpoints
 double sum = 0.5 * (func(interval.a) + func(interval.b));

 // Iterate over the subintervals, adding the function values at each point
 for (unsigned int i = 1; i < intervalNum; i++) {
  // Add the function value at the current point to the sum
  sum += func(interval.a + i * h);
 }

 // Return the approximate value of the definite integral
 return h * sum;
}

/**
 * Approximates the definite integral of a function using Simpson's rule.
 *
 * @param interval The interval over which to integrate.
 * @param intervalNum The number of subintervals to divide the interval into.
 * @param func The function to integrate.
 *
 * @return The approximate value of the definite integral.
 *
 * @throws INTERVAL_SIZE_ERROR_002 If the number of subintervals is less than 2.
 */
double simpson(const Interval interval, const unsigned int intervalNum, const __integral_func func) {
 // Check if the number of subintervals is valid (must be at least 2)
 if (intervalNum < 2) {
  // If not, throw an error with a descriptive message
  PERROR(INTERVAL_SIZE_ERROR_002, 1, __FILE__, __FUNCTION__, __LINE__);
 }

 // Calculate the width of each subinterval
 double h = (interval.b - interval.a) / intervalNum;

 // Initialize the sum of the function values at the interval endpoints
 double sum = func(interval.a) + func(interval.b);

 // Iterate over the subintervals, adding the function values at each point
 for (unsigned int i = 1; i < intervalNum; i++) {
  // Alternate between adding 2 and 4 times the function value at each point
  if (i % 2 == 0) {
   // Add 2 times the function value at the current point to the sum
   sum += 2 * func(interval.a + i * h);
  } else {
   // Add 4 times the function value at the current point to the sum
   sum += 4 * func(interval.a + i * h);
  }
 }

 // Return the approximate value of the definite integral
 return (h / 3) * sum;
}

/**
 * Calculates the Simpson's rule approximation for a function.
 *
 * @param left The left endpoint of the interval.
 * @param right The right endpoint of the interval.
 * @param func The function to integrate.
 *
 * @return The Simpson's rule approximation of the function.
 */
static inline double __simpson(double left, double right, const __integral_func func) {
 // Calculate the midpoint of the interval
 double mid = (left + right) / 2;

 // Calculate the Simpson's rule approximation
 return (right - left) * (func(left) + 4 * func(mid) + func(right)) / 6;
}

/**
 * Calculates the adaptive Simpson's rule approximation for a function.
 *
 * @param interval The interval over which to integrate.
 * @param eps The desired error tolerance.
 * @param ans The current approximation.
 * @param step The current step.
 * @param func The function to integrate.
 *
 * @return The adaptive Simpson's rule approximation of the function.
 */
static inline double asr(const Interval interval, double eps, double ans, int step, const __integral_func func) {
 // Calculate the midpoint of the interval
 double mid = (interval.a + interval.b) / 2;

 // Calculate the Simpson's rule approximations for the left and right subintervals
 double fl = __simpson(interval.a, mid, func), fr = __simpson(mid, interval.b, func);

 // Check if the desired error tolerance is met
 if (abs(fl + fr - ans) <= 15 * eps && step < 0) {
  // If the desired error tolerance is met, return the approximation
  return fl + fr + (fl + fr - ans) / 15;
 }

 // Recursively calculate the adaptive Simpson's rule approximation for the left and right subintervals
 return asr(newInterval(interval.a, mid), eps / 2, fl, step - 1, func) + asr(
         newInterval(mid, interval.b), eps / 2, fr, step - 1, func);
}

/**
 * Calculates the adaptive Simpson's rule approximation for a function.
 *
 * @param interval The interval over which to integrate.
 * @param func The function to integrate.
 *
 * @return The adaptive Simpson's rule approximation of the function.
 *
 * @ref https://oi-wiki.org/math/numerical/integral/
 */
double adaptiveSimpson(const Interval interval, const __integral_func func) {
 // Set the desired error tolerance and initial approximation
 double eps = EPS;
 double ans = simpson(interval, 100, func);

 // Recursively calculate the adaptive Simpson's rule approximation
 return asr(interval, eps, ans, 15, func);
}

double gaussLegendreIntegral(const Interval interval, const unsigned int intervalNum, const __integral_func func) {
 return 0.0;
}

double ruggeKutta2OrderIntegral(const Interval interval, const unsigned int intervalNum, const __integral_func func) {
 return 0.0;
}

double ruggeKutta4OrderIntegral(const Interval interval, const unsigned int intervalNum, const __integral_func func) {
 return 0.0;
}
