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
package com.hsmkmathlib.sort.algorithm;

import com.hsmkmathlib.sort.utils.SortAlgorithm;

/**
 * Insertion Sort implementation.
 *
 * <p>Builds the sorted array one element at a time by inserting each element
 * into its correct position in the sorted portion.
 *
 * <p>Time complexity: O(n^2) worst/average, O(n) best (already sorted)
 * <p>Space complexity: O(1)
 *
 * @param <T> the type of elements to sort, must implement Comparable
 */
public final class InsertionSort<T extends Comparable<T>> implements SortAlgorithm<T> {

    public static final InsertionSort<?> INSTANCE = new InsertionSort<>();

    private InsertionSort() {}

    @Override
    public void sort(T[] array, int startIndex, int endIndex, int order) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (!isValidRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range: [" + startIndex + ", " + endIndex + ")");
        }
        if (!isValidOrder(order)) {
            throw new IllegalArgumentException("Invalid order: " + order + " (use 0 for ASC, 1 for DESC)");
        }
        if (endIndex - startIndex <= 1) {
            return;
        }

        for (int i = startIndex + 1; i < endIndex; i++) {
            T current = array[i];
            int j = i - 1;
            while (j >= startIndex && compare(array[j], current, order) > 0) {
                array[j + 1] = array[j];
                j--;
            }
            array[j + 1] = current;
        }
    }
}