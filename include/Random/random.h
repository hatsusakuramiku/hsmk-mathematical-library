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

#ifndef _HSMK_MATH_LIB_RANDOM_H
#define _HSMK_MATH_LIB_RANDOM_H
#include <stdbool.h>
#include <time.h>
// get random number
#define RAND(min, max, TYPE) ((TYPE)rand_double(min, max))

/**
 * Generates a random double-precision floating-point number within a specified range.
 *
 * This function uses the rand() function to generate a random integer, which is then
 * scaled to fit within the specified range. The range is inclusive, meaning that both
 * the minimum and maximum values are possible outcomes.
 *
 * @param min The minimum value of the range (inclusive).
 * @param max The maximum value of the range (inclusive).
 * @return A random double-precision floating-point number within the specified range.
 */
static inline double rand_double(const double min, const double max) {
    // Flag to track whether the random number generator has been seeded.
    static bool seeded = false;

    // Seed the random number generator if it hasn't been done already.
    if (!seeded) {
        // Use the current time as a seed value to ensure randomness.
        srand(time(NULL));
        seeded = true;
    }

    // Calculate the random double-precision floating-point number.
    // The formula scales the random integer to fit within the specified range.
    return min + (max - min) * ((double) rand()) / ((double) RAND_MAX + 1.0);
}

#endif //_HSMK_MATH_LIB_RANDOM_H
