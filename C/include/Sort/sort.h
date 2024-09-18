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
 * @file sort.c
 */

#ifndef _HSMK_MATH_LIB_SORT_H
#define _HSMK_MATH_LIB_SORT_H

/**
 * @brief Function pointer type for a comparison function with an additional argument.
 *
 * This type represents a function that takes three arguments:
 *   - A void pointer to an additional argument (e.g., user data)
 *   - Two const void pointers to the elements to be compared
 * The function returns an integer indicating the result of the comparison.
 *
 * The return value is expected to be:
 *   - Negative if the first element is less than the second element
 *   - Zero if the elements are equal
 *   - Positive if the first element is greater than the second element
 */
typedef int (*default_compare_s)(const void *, const void *, void *);

/**
 * @brief Function pointer type for a comparison function.
 *
 * This type represents a function that takes two const void pointers to the elements to be compared.
 * The function returns an integer indicating the result of the comparison.
 *
 * The return value is expected to be:
 *   - Negative if the first element is less than the second element
 *   - Zero if the elements are equal
 *   - Positive if the first element is greater than the second element
 */
typedef int (*default_compare)(const void *, const void *);

int default_compare_example(const void *a, const void *b);

int default_compare_example_s(const void *a, const void *b, const void *arg);

void quickSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);

void quickSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);

void bubbleSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);

void bubbleSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);

void insertionSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);

void insertionSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);

void selectionSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);

void selectionSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);

void mergeSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);

void mergeSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);

void heapSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);

void heapSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);

#endif //_HSMK_MATH_LIB_SORT_H
