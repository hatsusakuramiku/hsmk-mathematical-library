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
 * This class implements the Insertion Sort algorithm, which is a simple sorting
 * algorithm that works by dividing the input into a sorted and an unsorted
 * region. Each subsequent element from the unsorted region is inserted into the
 * sorted region in its correct position.
 */
public final class InsertionSort implements SortAlgorithm {

    /**
     * Static instance of the Insertion Sort algorithm.
     */
    public static final InsertionSort INSTANCE = new InsertionSort();

    /**
     * Default constructor for the InsertionSort class.
     */
    public InsertionSort() {
    }

    /**
     * Sorts the given array using the Insertion Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values, or null
     * elements in the array and throws an IllegalArgumentException if any of
     * these conditions are met. The sorting is done by dividing the array into
     * a sorted and unsorted region, and inserting each subsequent element from
     * the unsorted region into the correct position within the sorted region.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, empty, contains
     * invalid range, invalid axis value, or null elements
     */
    @Override
    @Deprecated
    public void sort(Object[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length == 1) {
            return;
        }
        if (checkArrayHasNull(array)) {
            throw new IllegalArgumentException("Array cannot contain null elements");
        }
        try {
            Method compareToMethod = getCompareToMethod(array[0]);
            for (int i = startIndex + 1; i < endIndex; i++) {
                Object current = array[i];
                int j = i - 1;
                while (j >= startIndex && (aix == 0 ? (int) compareToMethod.invoke(array[j], current) > 0
                        : (int) compareToMethod.invoke(array[j], current) < 0)) {
                    array[j + 1] = array[j];
                    j--;
                }
                array[j + 1] = current;
            }
        } catch (IllegalAccessException | NoSuchMethodException | SecurityException | InvocationTargetException e) {
            throw new IllegalArgumentException(e.getMessage());
        }
    }

    /**
     * Sorts the given array using the Insertion Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The sorting is done by dividing the array into a sorted and unsorted
     * region, and inserting each subsequent element from the unsorted region
     * into the correct position within the sorted region.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, empty, contains
     * invalid range, invalid axis value
     */
    @Override
    public void sort(float[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length == 1) {
            return;
        }

        for (int i = startIndex + 1; i < endIndex; i++) {
            float current = array[i];
            int j = i - 1;
            while (j >= startIndex && (aix == 0 ? array[j] > current : array[j] < current)) {
                array[j + 1] = array[j];
                j--;
            }
            array[j + 1] = current;
        }
    }

    /**
     * Sorts the given array using the Insertion Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The sorting is done by dividing the array into a sorted and unsorted
     * region, and inserting each subsequent element from the unsorted region
     * into the correct position within the sorted region.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, empty, contains
     * invalid range, invalid axis value
     */
    @Override
    public void sort(double[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length == 1) {
            return;
        }

        for (int i = startIndex + 1; i < endIndex; i++) {
            double current = array[i];
            int j = i - 1;
            while (j >= startIndex && (aix == 0 ? array[j] > current : array[j] < current)) {
                array[j + 1] = array[j];
                j--;
            }
            array[j + 1] = current;
        }
    }

    /**
     * Sorts the given array using the Insertion Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The sorting is done by dividing the array into a sorted and unsorted
     * region, and inserting each subsequent element from the unsorted region
     * into the correct position within the sorted region.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, empty, contains
     * invalid range, invalid axis value
     */
    @Override
    public void sort(long[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length == 1) {
            return;
        }

        for (int i = startIndex + 1; i < endIndex; i++) {
            long current = array[i];
            int j = i - 1;
            while (j >= startIndex && (aix == 0 ? array[j] > current : array[j] < current)) {
                array[j + 1] = array[j];
                j--;
            }
            array[j + 1] = current;
        }
    }

    /**
     * Sorts the given array using the Insertion Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The sorting is done by dividing the array into a sorted and unsorted
     * region, and inserting each subsequent element from the unsorted region
     * into the correct position within the sorted region.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, empty, contains
     * invalid range, invalid axis value
     */
    @Override
    public void sort(short[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length == 1) {
            return;
        }

        for (int i = startIndex + 1; i < endIndex; i++) {
            short current = array[i];
            int j = i - 1;
            while (j >= startIndex && (aix == 0 ? array[j] > current : array[j] < current)) {
                array[j + 1] = array[j];
                j--;
            }
            array[j + 1] = current;
        }
    }

    /**
     * Sorts the given array using the Insertion Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The sorting is done by dividing the array into a sorted and unsorted
     * region, and inserting each subsequent element from the unsorted region
     * into the correct position within the sorted region.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, empty, contains
     * invalid range, invalid axis value
     */
    @Override
    public void sort(byte[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length == 1) {
            return;
        }

        for (int i = startIndex + 1; i < endIndex; i++) {
            byte current = array[i];
            int j = i - 1;
            while (j >= startIndex && (aix == 0 ? array[j] > current : array[j] < current)) {
                array[j + 1] = array[j];
                j--;
            }
            array[j + 1] = current;
        }
    }

    /**
     * Sorts the given array using the Insertion Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The sorting is done by dividing the array into a sorted and unsorted
     * region, and inserting each subsequent element from the unsorted region
     * into the correct position within the sorted region.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, empty, contains
     * invalid range, invalid axis value
     */
    @Override
    public void sort(char[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length == 1) {
            return;
        }

        for (int i = startIndex + 1; i < endIndex; i++) {
            char current = array[i];
            int j = i - 1;
            while (j >= startIndex && (aix == 0 ? array[j] > current : array[j] < current)) {
                array[j + 1] = array[j];
                j--;
            }
            array[j + 1] = current;
        }
    }

    /**
     * Sorts the given array using the Insertion Sort algorithm.
     *
     * <p>
     * This method sorts the specified range of the array in either ascending or
     * descending order, depending on the axis value provided. It first checks
     * for null or empty arrays, invalid range, invalid axis values in the array
     * and throws an IllegalArgumentException if any of these conditions are
     * met. The sorting is done by dividing the array into a sorted and unsorted
     * region, and inserting each subsequent element from the unsorted region
     * into the correct position within the sorted region.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex the ending index of the sort range, doesn't include this
     * index
     * @param aix the axis value for sorting order, 0 for ascending, 1 for
     * descending
     * @throws IllegalArgumentException if the array is null, empty, contains
     * invalid range, invalid axis value
     */
    @Override
    public void sort(int[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length == 1) {
            return;
        }

        for (int i = startIndex + 1; i < endIndex; i++) {
            int current = array[i];
            int j = i - 1;
            while (j >= startIndex && (aix == 0 ? array[j] > current : array[j] < current)) {
                array[j + 1] = array[j];
                j--;
            }
            array[j + 1] = current;
        }
    }

    /**
     * Sorts the given generic array using the Insertion Sort algorithm.
     *
     * <p>
     * This implementation takes an array, a start index, an end index, and an
     * axis value as parameters. It first checks if the array is null, if the
     * array is empty, if the range given is invalid, or if the axis value is
     * invalid. If the array is valid, it implements the Insertion Sort
     * algorithm. The algorithm works by dividing the input into a sorted and an
     * unsorted region. Each subsequent element from the unsorted region is
     * inserted into the sorted region in its correct position.
     *
     * @param array the array to be sorted
     * @param startIndex the starting index of the array
     * @param endIndex the ending index of the array, doesn't include the end
     * @param aix the axis value for sorting order
     */
    @Override
    public <T extends Comparable<T>> void sort(T[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (array.length == 1) {
            return;
        }
        if (checkArrayHasNull(array)) {
            throw new IllegalArgumentException("Array cannot contain null elements");
        }
        for (int i = startIndex + 1; i < endIndex; i++) {
            T current = array[i];
            int j = i - 1;
            while (j >= startIndex && (aix == 0 ? array[j].compareTo(current) > 0 : array[j].compareTo(current) < 0)) {
                array[j + 1] = array[j];
                j--;
            }
            array[j + 1] = current;
        }
    }
}
