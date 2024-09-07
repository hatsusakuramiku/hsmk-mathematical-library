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


Interval newInterval(const double a, const double b) {
 if (a >= b) {
  PERROR(INTERVAL_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
 }
 return (Interval){a, b};
}

double trapzoid(const Interval interval, const unsigned int intervalNum, const __integral_func func) {
 if (intervalNum < 1) {
  PERROR(INTERVAL_SIZE_ERROR_002, 0, __FILE__, __FUNCTION__, __LINE__);
 }

 double h = (interval.b - interval.a) / intervalNum;
 double sum = 0.5 * (func(interval.a) + func(interval.b));

 for (unsigned int i = 1; i < intervalNum; i++) {
  sum += func(interval.a + i * h);
 }

 return h * sum;
}

double simpson(const Interval interval, const unsigned int intervalNum, const __integral_func func) {
 if (intervalNum < 2) {
  PERROR(INTERVAL_SIZE_ERROR_002, 1, __FILE__, __FUNCTION__, __LINE__);
 }

 double h = (interval.b - interval.a) / intervalNum;
 double sum = func(interval.a) + func(interval.b);

 for (unsigned int i = 1; i < intervalNum; i++) {
  if (i % 2 == 0) {
   sum += 2 * func(interval.a + i * h);
  } else {
   sum += 4 * func(interval.a + i * h);
  }
 }
 return (h / 3) * sum;
}

static inline double __simpson(double left, double right, const __integral_func func) {
 double mid = (left + right) / 2;
 return (right - left) * (func(left) + 4 * func(mid) + func(right)) / 6;
}

static inline double asr(const Interval interval, double eps, double ans, int step, const __integral_func func) {
 double mid = (interval.a + interval.b) / 2;
 double fl = __simpson(interval.a, mid, func), fr = __simpson(mid, interval.b, func);
 if (abs(fl + fr - ans) <= 15 * eps && step < 0) {
  return fl + fr + (fl + fr - ans) / 15;
 }
 return asr(newInterval(interval.a, mid), eps / 2, fl, step - 1, func) + asr(
         newInterval(mid, interval.b), eps / 2, fr, step - 1, func);
}

double adaptiveSimpson(const Interval interval, const __integral_func func) {
 return asr(interval, EPS, simpson(interval, 100, func), 15, func);
}

double gaussLegendreIntegral(const Interval interval, const unsigned int intervalNum, const __integral_func func) {
 return 0.0;
}

double rugge_kutta_2orde(const Interval interval, const unsigned int intervalNum, const __integral_func func) {
 return 0.0;
}

double ruggeKutta4OrderIntegral(const Interval interval, const unsigned int intervalNum, const __integral_func func) {
 return 0.0;
}
