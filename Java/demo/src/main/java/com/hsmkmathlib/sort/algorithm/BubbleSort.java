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

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import com.hsmkmathlib.sort.utils.SortAlgorithm;

/**
 * This class implements the Bubble Sort algorithm, a simple sorting algorithm
 * that repeatedly steps through the list, compares adjacent elements and swaps
 * them if they are in the wrong order. The pass through the list is repeated
 * until the list is sorted.
 */
public final class BubbleSort implements SortAlgorithm {

    /**
     * Static instance of the Bubble Sort algorithm.
     */
    public static final BubbleSort INSTANCE = new BubbleSort();

    /**
     * Sorts the given int array using the Bubble Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The algorithm works by repeatedly stepping through the list,
     * compares adjacent elements and swaps them if they are in the wrong order.
     * The pass through the list is repeated until the list is sorted.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, contains invalid
     * range, or invalid axis value
     */
    @Override
    public void sort(int[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length <= 1) {
            return;
        }
        boolean swapped;
        int lastIndex;
        do {
            swapped = false;
            lastIndex = startIndex;
            for (int j = lastIndex; j < endIndex - 1; j++) {
                if (aix == ASCENDING ? array[j] > array[j + 1] : array[j] < array[j + 1]) {
                    swap(array, j, j + 1);
                    swapped = true;

                }
            }
        } while (swapped);
    }

    /**
     * /**
     * Sorts the given double array using the Bubble Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The algorithm works by repeatedly stepping through the list,
     * compares adjacent elements and swaps them if they are in the wrong order.
     * The pass through the list is repeated until the list is sorted.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, contains invalid
     * range, or invalid axis value
     */
    @Override
    public void sort(double[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length <= 1) {
            return;
        }
        boolean swapped;
        int lastIndex;
        do {
            swapped = false;
            lastIndex = startIndex;
            for (int j = lastIndex; j < endIndex - 1; j++) {
                if (aix == ASCENDING ? array[j] > array[j + 1] : array[j] < array[j + 1]) {
                    swap(array, j, j + 1);
                    swapped = true;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given float array using the Bubble Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The algorithm works by repeatedly stepping through the list,
     * compares adjacent elements and swaps them if they are in the wrong order.
     * The pass through the list is repeated until the list is sorted.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, contains invalid
     * range, or invalid axis value
     */
    @Override
    public void sort(float[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length <= 1) {
            return;
        }
        boolean swapped;
        int lastIndex;
        do {
            swapped = false;
            lastIndex = startIndex;
            for (int j = lastIndex; j < endIndex - 1; j++) {
                if (aix == ASCENDING ? array[j] > array[j + 1] : array[j] < array[j + 1]) {
                    swap(array, j, j + 1);
                    swapped = true;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given long array using the Bubble Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The algorithm works by repeatedly stepping through the list,
     * compares adjacent elements and swaps them if they are in the wrong order.
     * The pass through the list is repeated until the list is sorted.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, contains invalid
     * range, or invalid axis value
     */
    @Override
    public void sort(long[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length <= 1) {
            return;
        }
        boolean swapped;
        int lastIndex;
        do {
            swapped = false;
            lastIndex = startIndex;
            for (int j = lastIndex; j < endIndex - 1; j++) {
                if (aix == ASCENDING ? array[j] > array[j + 1] : array[j] < array[j + 1]) {
                    swap(array, j, j + 1);
                    swapped = true;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given short array using the Bubble Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The algorithm works by repeatedly stepping through the list,
     * compares adjacent elements and swaps them if they are in the wrong order.
     * The pass through the list is repeated until the list is sorted.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, contains invalid
     * range, or invalid axis value
     */
    @Override
    public void sort(short[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length <= 1) {
            return;
        }
        boolean swapped;
        int lastIndex;
        do {
            swapped = false;
            lastIndex = startIndex;
            for (int j = lastIndex; j < endIndex - 1; j++) {
                if (aix == ASCENDING ? array[j] > array[j + 1] : array[j] < array[j + 1]) {
                    swap(array, j, j + 1);
                    swapped = true;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given byte array using the Bubble Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The algorithm works by repeatedly stepping through the list,
     * compares adjacent elements and swaps them if they are in the wrong order.
     * The pass through the list is repeated until the list is sorted.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, contains invalid
     * range, or invalid axis value
     */
    @Override
    public void sort(byte[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length <= 1) {
            return;
        }
        boolean swapped;
        int lastIndex;
        do {
            swapped = false;
            lastIndex = startIndex;
            for (int j = lastIndex; j < endIndex - 1; j++) {
                if (aix == ASCENDING ? array[j] > array[j + 1] : array[j] < array[j + 1]) {
                    swap(array, j, j + 1);
                    swapped = true;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given char array using the Bubble Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The algorithm works by repeatedly stepping through the list,
     * compares adjacent elements and swaps them if they are in the wrong order.
     * The pass through the list is repeated until the list is sorted.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, contains invalid
     * range, or invalid axis value
     */
    @Override
    public void sort(char[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length <= 1) {
            return;
        }
        boolean swapped;
        int lastIndex;
        do {
            swapped = false;
            lastIndex = startIndex;
            for (int j = lastIndex; j < endIndex - 1; j++) {
                if (aix == ASCENDING ? array[j] > array[j + 1] : array[j] < array[j + 1]) {
                    swap(array, j, j + 1);
                    swapped = true;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given Object array using the Bubble Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The algorithm works by repeatedly stepping through the list,
     * compares adjacent elements and swaps them if they are in the wrong order.
     * The pass through the list is repeated until the list is sorted.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, contains invalid
     * range, or invalid axis value, or if the array contains non-comparable
     * elements
     */
    @Override
    @Deprecated
    public void sort(Object[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length <= 1) {
            return;
        }
        boolean swapped;
        int lastIndex;
        try {
            Method compareMethod = getCompareToMethod(array[0]);
            do {
                swapped = false;
                lastIndex = startIndex;
                for (int j = lastIndex; j < endIndex - 1; j++) {
                    if (aix == ASCENDING ? (int) compareMethod.invoke(array[j], array[j + 1]) > 0
                            : (int) compareMethod
                                    .invoke(array[j], array[j + 1]) < 0) {
                        swap(array, j, j + 1);
                        swapped = true;

                    }
                }
            } while (swapped);
        } catch (IllegalAccessException | NoSuchMethodException | SecurityException | InvocationTargetException e) {
            throw new IllegalArgumentException(e.getMessage());
        }
    }

    /**
     * Sorts the given array of objects using the Bubble Sort algorithm.
     *
     * <p>
     * This implementation takes an array of objects, a starting index, an
     * ending index, and an axis value as parameters. It first checks if the
     * array is null or if the range given is invalid. If the array is valid, it
     * implements the Bubble Sort algorithm. The algorithm works by repeatedly
     * stepping through the list, compares adjacent elements and swaps them if
     * they are in the wrong order. The pass through the list is repeated until
     * the list is sorted.
     *
     * @param array the array of objects to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, contains invalid
     * range, or invalid axis value
     */
    @Override
    public <T extends Comparable<T>> void sort(T[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length <= 1) {
            return;
        }
        boolean swapped;
        int lastIndex = startIndex;
        do {
            swapped = false;
            for (int j = lastIndex; j < endIndex - 1; j++) {
                if (aix == ASCENDING ? array[j].compareTo(array[j + 1]) > 0
                        : array[j].compareTo(array[j + 1]) < 0) {
                    swap(array, j, j + 1);
                    swapped = true;

                }
            }
        } while (swapped);
    }
}
