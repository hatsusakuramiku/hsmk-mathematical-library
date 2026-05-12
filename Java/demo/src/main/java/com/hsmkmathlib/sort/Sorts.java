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
package com.hsmkmathlib.sort;

import java.lang.reflect.InvocationTargetException;

import com.hsmkmathlib.sort.utils.SortAlgorithm;

/**
 * Utility class for sorting operations.
 *
 * <p>Provides convenient static methods to sort arrays using specified algorithms.
 * Accepts either a SortAlgorithm instance or a class type.
 *
 * <p>Example usage:
 * <pre>{@code
 * Integer[] arr = {5, 2, 8, 1, 9};
 *
 * // Using class type (creates new instance internally)
 * Sorts.sort(BubbleSort.class, arr);
 * Sorts.sort(HeapSort.class, arr, 0, arr.length, SortAlgorithm.DESCENDING);
 *
 * // Using instance
 * Sorts.sort(BubbleSort.INSTANCE, arr);
 * Sorts.sort(MergeSort.INSTANCE, arr, SortAlgorithm.ASCENDING);
 * }</pre>
 */
public final class Sorts {

    private Sorts() {}  // Prevent instantiation

    // ==================== Class type methods ====================

    /**
     * Sort array using specified algorithm class.
     *
     * @param algorithmClass the class of the sorting algorithm
     * @param array the array to sort
     */
    public static <T extends Comparable<T>> void sort(Class<? extends SortAlgorithm<T>> algorithmClass, T[] array) {
        sort(algorithmClass, array, 0, array.length, SortAlgorithm.ASCENDING);
    }

    /**
     * Sort array in specified order using algorithm class.
     *
     * @param algorithmClass the class of the sorting algorithm
     * @param array the array to sort
     * @param order ASCENDING or DESCENDING
     */
    public static <T extends Comparable<T>> void sort(Class<? extends SortAlgorithm<T>> algorithmClass, T[] array, int order) {
        sort(algorithmClass, array, 0, array.length, order);
    }

    /**
     * Sort array range using algorithm class.
     *
     * @param algorithmClass the class of the sorting algorithm
     * @param array the array to sort
     * @param startIndex the starting index (inclusive)
     * @param endIndex the ending index (exclusive)
     * @param order ASCENDING or DESCENDING
     */
    public static <T extends Comparable<T>> void sort(
            Class<? extends SortAlgorithm<T>> algorithmClass,
            T[] array,
            int startIndex,
            int endIndex,
            int order) {
        try {
            SortAlgorithm<T> instance = algorithmClass.getDeclaredConstructor().newInstance();
            instance.sort(array, startIndex, endIndex, order);
        } catch (IllegalAccessException | IllegalArgumentException | InstantiationException | NoSuchMethodException | InvocationTargetException e) {
            throw new RuntimeException("Failed to instantiate " + algorithmClass.getName(), e);
        }
    }

    // ==================== Instance methods ====================

    /**
     * Sort array using provided algorithm instance.
     *
     * @param algorithm the sorting algorithm instance
     * @param array the array to sort
     */
    public static <T extends Comparable<T>> void sort(SortAlgorithm<T> algorithm, T[] array) {
        algorithm.sort(array, 0, array.length, SortAlgorithm.ASCENDING);
    }

    /**
     * Sort array in specified order using algorithm instance.
     *
     * @param algorithm the sorting algorithm instance
     * @param array the array to sort
     * @param order ASCENDING or DESCENDING
     */
    public static <T extends Comparable<T>> void sort(SortAlgorithm<T> algorithm, T[] array, int order) {
        algorithm.sort(array, 0, array.length, order);
    }

    /**
     * Sort array range using algorithm instance.
     *
     * @param algorithm the sorting algorithm instance
     * @param array the array to sort
     * @param startIndex the starting index (inclusive)
     * @param endIndex the ending index (exclusive)
     * @param order ASCENDING or DESCENDING
     */
    public static <T extends Comparable<T>> void sort(
            SortAlgorithm<T> algorithm,
            T[] array,
            int startIndex,
            int endIndex,
            int order) {
        algorithm.sort(array, startIndex, endIndex, order);
    }
}