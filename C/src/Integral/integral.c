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

/**
 * @headerfile integral.h
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

int isCorrentInterval(const Interval interval) {
 if (interval.a >= interval.b) {
  return 0;
 }
 return 1;
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

/**
 * Calculates the 2-point Gauss-Legendre integral of a function over a given interval.
 *
 * This function uses the 2-point Gauss-Legendre quadrature rule to approximate the integral.
 *
 * @param interval The interval over which to integrate.
 * @param func The function to integrate.
 *
 * @return The 2-point Gauss-Legendre integral of the function.
 */
static inline double __gaussLegendre2PointIntegral(const Interval interval, const __integral_func func) {
 // Define the 2-point Gauss-Legendre nodes
 const double gaussLegendre2PointNodes[] = {0.7886751345948129, 0.2113248654051871};

 // Calculate the width of the interval
 const double bMinusA = (interval.b - interval.a) / 2;

 // Calculate the integral using the 2-point Gauss-Legendre quadrature rule
 return bMinusA * (func(interval.a * gaussLegendre2PointNodes[0] + interval.b * gaussLegendre2PointNodes[1]) +
                   func(interval.a * gaussLegendre2PointNodes[1] + interval.b * gaussLegendre2PointNodes[0]));
}

/**
 * Calculates the 2-point Gauss-Legendre integral of a function over a given interval,
 * divided into a specified number of subintervals.
 *
 * This function uses the 2-point Gauss-Legendre quadrature rule to approximate the integral
 * over each subinterval, and sums the results to obtain the final integral.
 *
 * @param interval The interval over which to integrate.
 * @param intervalNum The number of subintervals to divide the interval into.
 * @param func The function to integrate.
 *
 * @return The 2-point Gauss-Legendre integral of the function.
 */
double gaussLegendre2PointIntegral(const Interval interval, const unsigned int intervalNum,
                                   const __integral_func func) {
 // Check if the number of subintervals is valid
 if (intervalNum < 1) {
  // If not, throw an error with a descriptive message
  PERROR(INTERVAL_SIZE_ERROR_002, 2, __FILE__, __FUNCTION__, __LINE__);
 }

 // Check if the interval is valid
 if (interval.a >= interval.b) {
  PERROR(INTERVAL_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__)
 }

 // Calculate the width of each subinterval
 const double h = (interval.b - interval.a) / intervalNum;

 // Initialize the sum of the integrals over each subinterval
 double sum = 0.0;

 // Calculate the integral over each subinterval and sum the results
 for (int i = 0; i < intervalNum; i++) {
  sum += __gaussLegendre2PointIntegral(newInterval(interval.a + i * h, interval.a + (i + 1) * h), func);
 }

 // Return the final integral
 return sum;
}

/**
 * Calculates the 3-point Gauss-Legendre integral of a function over a given interval.
 *
 * This function uses the Gauss-Legendre quadrature formula to approximate the integral of a function
 * over a given interval. The formula uses three points to approximate the integral, which makes it
 * more accurate than the 2-point formula but less accurate than the 4-point formula.
 *
 * @param interval The interval over which to integrate the function.
 * @param func The function to integrate.
 * @return The approximate value of the integral.
 */
static inline double __gaussLegendre3PointIntegral(const Interval interval, const __integral_func func) {
 // Define the nodes and weights for the 3-point Gauss-Legendre quadrature formula
 const double gaussLegendre3PointNodes[] = {0.5555555555555556, 0.8888888888888888, 0.7745966692414834};

 // Calculate the midpoint and half-width of the interval
 const double bMinusAHalf = (interval.b - interval.a) / 2;
 const double aPlusAHalf = (interval.b + interval.a) / 2;

 // Calculate the integral using the Gauss-Legendre quadrature formula
 return bMinusAHalf * (gaussLegendre3PointNodes[0] * func(aPlusAHalf - gaussLegendre3PointNodes[2] * bMinusAHalf)
                       + gaussLegendre3PointNodes[1] * func(aPlusAHalf)
                       + gaussLegendre3PointNodes[0] * func(aPlusAHalf + gaussLegendre3PointNodes[2] * bMinusAHalf));
}

/**
 * Calculates the 3-point Gauss-Legendre integral of a function over a given interval, divided into a specified number of subintervals.
 *
 * This function uses the Gauss-Legendre quadrature formula to approximate the integral of a function
 * over a given interval, divided into a specified number of subintervals. The formula uses three points
 * to approximate the integral over each subinterval, which makes it more accurate than the 2-point formula
 * but less accurate than the 4-point formula.
 *
 * @param interval The interval over which to integrate the function.
 * @param intervalNum The number of subintervals to divide the interval into.
 * @param func The function to integrate.
 * @return The approximate value of the integral.
 */
double gaussLegendre3PointIntegral(const Interval interval, const unsigned int intervalNum,
                                   const __integral_func func) {
 // Check if the number of subintervals is valid
 if (intervalNum < 1) {
  // If not, throw an error with a descriptive message
  PERROR(INTERVAL_SIZE_ERROR_002, 2, __FILE__, __FUNCTION__, __LINE__);
 }

 // Check if the interval is valid
 if (interval.a >= interval.b) {
  PERROR(INTERVAL_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__)
 }

 // Calculate the width of each subinterval
 const double h = (interval.b - interval.a) / intervalNum;

 // Initialize the sum of the integrals over each subinterval
 double sum = 0.0;

 // Calculate the integral over each subinterval and sum the results
 for (int i = 0; i < intervalNum; i++) {
  sum += __gaussLegendre3PointIntegral(newInterval(interval.a + i * h, interval.a + (i + 1) * h), func);
 }

 // Return the final integral
 return sum;
}

double ruggeKutta2OrderIntegral(const Interval interval, const unsigned int intervalNum, const __iintegral_func func) {
 return 0.0;
}

double ruggeKutta4OrderIntegral(const Interval interval, const unsigned int intervalNum, const __iintegral_func func) {
 return 0.0;
}

/**
 * Returns an array of Newton-Cotes nodes for the given order.
 *
 * The Newton-Cotes nodes are used in the Newton-Raphson method for numerical integration.
 *
 * @param order The order of the Newton-Cotes nodes.
 * @return An array of Newton-Cotes nodes, or NULL if the order is invalid.
 */
static inline double *__getNCNodes(unsigned int order) {
 // Define the Newton-Cotes nodes for each order
 switch (order) {
  case 1:
   // Trapezoidal rule
   return (double []){1.0, 1.0, 2.0};
  case 2:
   // Simpson's rule
   return (double []){1.0, 4.0, 1.0, 6.0};
  case 3:
   // Simpson's 3/8 rule
   return (double []){1.0, 3.0, 3.0, 1.0, 8.0};
  case 4:
   // Boole's rule
   return (double []){7.0, 32.0, 12.0, 32.0, 7.0, 90.0};
  case 5:
   // Weddle's rule
   return (double []){19.0, 75.0, 50.0, 50.0, 75.0, 19.0, 288.0};
  case 6:
   // Sixth-order Newton-Cotes rule
   return (double []){41.0, 216.0, 27.0, 272.0, 27.0, 216.0, 41.0, 840.0};
  case 7:
   // Seventh-order Newton-Cotes rule
   return (double []){751.0, 3577.0, 1323.0, 2989.0, 2989.0, 1323.0, 3577.0, 751.0, 17280.0};
  case 8:
   // Eighth-order Newton-Cotes rule
   return (double[]){989.0, 5888.0, -928.0, 10496.0, -4540.0, 10496.0, -928.0, 5888.0, 989.0, 28350.0};
  default:
   // Invalid order
   return NULL;
 }
}

// /**
//  * Evaluates the Newton-Raphson integral for the given interval and order.
//  *
//  * The Newton-Raphson integral is a method for numerical integration.
//  *
//  * @param interval The interval to integrate over.
//  * @param order The order of the Newton-Raphson integral.
//  * @param nodes The Newton-Cotes nodes for the given order.
//  * @param func The function to integrate.
//  * @return The value of the Newton-Raphson integral.
//  */
// static inline double __newtonRaphsonIntegral(const Interval interval, const unsigned int order, const double *nodes,
//                                              const __integral_func func) {
//  // Calculate the width of the interval
//  const double bMinusA = (interval.b - interval.a);
//
//  // Calculate the step size
//  const double h = bMinusA / order;
//
//  // Calculate the coefficient for the integral
//  const double bMinusADivCoef = bMinusA / nodes[order + 1];
//
//  // Initialize the sum
//  double sum = 0.0;
//
//  // Evaluate the function at each point and add to the sum
//  for (int i = 0; i <= order; i++) {
//   sum += func(interval.a + i * h) * nodes[i];
//  }
//
//  // Return the value of the integral
//  return sum * bMinusADivCoef;
// }

/**
 * Evaluates the Newton-Raphson integral for the given interval, order, and function.
 *
 * This function divides the interval into subintervals and evaluates the Newton-Raphson integral for each subinterval.
 *
 * @param interval The interval to integrate over.
 * @param intervalNum The number of subintervals to divide the interval into.
 * @param order The order of the Newton-Raphson integral.
 * @param func The function to integrate.
 * @return The value of the Newton-Raphson integral.
 */
double newtonRaphsonIntegral(const Interval interval, const unsigned int intervalNum, unsigned int order, const
                             __integral_func func) {
 // Check if the interval is valid
 if (!isCorrentInterval(interval)) {
  PERROR(INTERVAL_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
 }

 // Check if the number of intervals is valid
 if (intervalNum < 1) {
  PERROR(INTERVAL_SIZE_ERROR_002, 1, __FILE__, __FUNCTION__, __LINE__);
 }

 // Check if the order is valid
 if (order < 1 || order > 8) {
  PERROR(INVALID_INPUT_001, VAR_NAME(order), 1, 8, __FILE__, __FUNCTION__, __LINE__);
 }

 // Get the Newton-Cotes nodes for the given order
 const double *nodes = __getNCNodes(order);

 // Calculate the step size
 const double h = (interval.b - interval.a) / intervalNum;
 const double perIntervalH = h / order;

 // Initialize the sum
 double sum = 0.0;

 // Evaluate the Newton-Raphson integral for each subinterval and add to the sum
 for (int i = 0; i < intervalNum; i++) {
  for (int j = 0; j <= order; j++) {
   sum += func(interval.a + i * h + j * perIntervalH) * nodes[j];
  }
 }

 // Return the value of the integral
 return sum * ((interval.b - interval.a) / nodes[order + 1]);
}
