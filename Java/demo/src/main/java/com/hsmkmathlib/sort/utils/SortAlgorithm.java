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
package com.hsmkmathlib.sort.utils;

/**
 * Common interface for sorting algorithms.
 *
 * <p>All implementations should provide a singleton instance via {@code INSTANCE}
 * and implement the core {@link #sort(Comparable[], int, int, int)} method.
 *
 * <p>The sort method supports any type that implements {@link Comparable},
 * including all primitive wrapper types (Integer, Double, etc.).
 *
 * @param <T> the type of elements to be sorted, must extend Comparable
 */
public interface SortAlgorithm<T extends Comparable<T>> {

    int ASCENDING = 0;
    int DESCENDING = 1;

    /**
     * Sorts the array in the specified range.
     *
     * @param array the array to sort
     * @param startIndex the starting index (inclusive)
     * @param endIndex the ending index (exclusive)
     * @param order ASCENDING (0) or DESCENDING (1)
     * @throws IllegalArgumentException if array is null or range is invalid
     */
    void sort(T[] array, int startIndex, int endIndex, int order);

    // ==================== Default utility methods ====================

    /**
     * Checks if the given range is valid.
     */
    default boolean isValidRange(int arrayLength, int startIndex, int endIndex) {
        return startIndex >= 0 && endIndex >= startIndex && endIndex <= arrayLength;
    }

    /**
     * Checks if the order value is valid.
     */
    default boolean isValidOrder(int order) {
        return order == ASCENDING || order == DESCENDING;
    }

    /**
     * Swaps two elements in the array.
     */
    default void swap(T[] array, int i, int j) {
        T temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    /**
     * Compares two elements according to the order.
     *
     * @return negative if a < b, positive if a > b, zero if equal
     */
    default int compare(T a, T b, int order) {
        int cmp = a.compareTo(b);
        return order == DESCENDING ? -cmp : cmp;
    }

    // ==================== Convenience overloads ====================

    /**
     * Sort entire array in given order.
     */
    default void sort(T[] array, int order) {
        sort(array, 0, array.length, order);
    }

    /**
     * Sort entire array in ascending order.
     */
    default void sort(T[] array) {
        sort(array, 0, array.length, ASCENDING);
    }

    /**
     * Sort array from startIndex to end in given order.
     */
    default void sort(T[] array, int startIndex, int order) {
        sort(array, startIndex, array.length, order);
    }
}