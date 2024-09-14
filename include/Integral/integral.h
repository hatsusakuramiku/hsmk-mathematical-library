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
 * @file integral.c
 */

#ifndef _HSMK_MATH_LIB_INTEGRAL_H
#define _HSMK_MATH_LIB_INTEGRAL_H

typedef double (*__integral_func)(const double);

typedef double (*__iintegral_func)(const double, const double);

#define EPS 1e-8

typedef struct _Interval {
    double a;
    double b;
} Interval;

// Error Code
#define INTERVAL_SIZE_ERROR_001 "@ERROR: The left endpoint values of the interval must be less than the right endpoint values !\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INTERVAL_SIZE_ERROR_002 "@ERROR: The number of intervals must be greater than or equal to %d !\n@File: %s\n@Function: %s\n@Line: %d\n"

Interval newInterval(const double a, const double b);

int isCorrentInterval(const Interval interval);

double trapzoid(const Interval interval, const unsigned int intervalNum, const __integral_func func);

double adaptiveSimpson(const Interval interval, const __integral_func func);

double simpson(const Interval interval, const unsigned int intervalNum, const __integral_func func);

double gaussLegendre2PointIntegral(const Interval interval, const unsigned int intervalNum, const __integral_func func);

double gaussLegendre3PointIntegral(const Interval interval, const unsigned int intervalNum, const __integral_func func);

double ruggeKuttaIntegral(const Interval interval, const unsigned int intervalNum, const __integral_func func);

double ruggeKutta4OrderIntegral(const Interval interval, const unsigned int intervalNum, const __integral_func func);

double newtonRaphsonIntegral(const Interval interval, const unsigned int intervalNum, unsigned int order, const
                             __integral_func func);

double integral(const Interval interval, const unsigned int intervalNum, const __integral_func func);
#endif //_HSMK_MATH_LIB_INTEGRAL_H
