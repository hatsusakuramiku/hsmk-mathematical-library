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

package sort.algorithm;

import java.lang.reflect.Method;

/**
 * This class implements the Bubble Sort algorithm, a simple sorting algorithm
 * that repeatedly steps
 * through the list, compares adjacent elements and swaps them if they are in
 * the wrong order. The
 * pass through the list is repeated until the list is sorted.
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
     * This implementation takes an array, a start index, an end index, and an axis
     * value as
     * parameters. It first checks if the array is null or if the range given is
     * invalid. If the
     * array is valid, it implements the Bubble Sort algorithm. The algorithm works
     * by repeatedly
     * stepping through the list, compares adjacent elements and swaps them if they
     * are in the wrong
     * order. The pass through the list is repeated until the list is sorted.
     *
     * @param array      the array to be sorted
     * @param startIndex the starting index of the array
     * @param endIndex   the ending index of the array
     * @param aix        the axis value for sorting order
     */
    @Override
    public void sort(int[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (array.length == 1) {
            return;
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
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
                    lastIndex = j;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given int array using the Bubble Sort algorithm.
     *
     * <p>
     * This implementation takes an array, a start index, an end index, and an axis
     * value as
     * parameters. It first checks if the array is null or if the range given is
     * invalid. If the
     * array is valid, it implements the Bubble Sort algorithm. The algorithm works
     * by repeatedly
     * stepping through the list, compares adjacent elements and swaps them if they
     * are in the wrong
     * order. The pass through the list is repeated until the list is sorted.
     *
     * @param array      the array to be sorted
     * @param startIndex the starting index of the array
     * @param endIndex   the ending index of the array
     * @param aix        the axis value for sorting order
     */
    @Override
    public void sort(double[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (array.length == 1) {
            return;
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
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
                    lastIndex = j;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given int array using the Bubble Sort algorithm.
     *
     * <p>
     * This implementation takes an array, a start index, an end index, and an axis
     * value as
     * parameters. It first checks if the array is null or if the range given is
     * invalid. If the
     * array is valid, it implements the Bubble Sort algorithm. The algorithm works
     * by repeatedly
     * stepping through the list, compares adjacent elements and swaps them if they
     * are in the wrong
     * order. The pass through the list is repeated until the list is sorted.
     *
     * @param array      the array to be sorted
     * @param startIndex the starting index of the array
     * @param endIndex   the ending index of the array
     * @param aix        the axis value for sorting order
     */
    @Override
    public void sort(float[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (array.length == 1) {
            return;
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
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
                    lastIndex = j;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given int array using the Bubble Sort algorithm.
     *
     * <p>
     * This implementation takes an array, a start index, an end index, and an axis
     * value as
     * parameters. It first checks if the array is null or if the range given is
     * invalid. If the
     * array is valid, it implements the Bubble Sort algorithm. The algorithm works
     * by repeatedly
     * stepping through the list, compares adjacent elements and swaps them if they
     * are in the wrong
     * order. The pass through the list is repeated until the list is sorted.
     *
     * @param array      the array to be sorted
     * @param startIndex the starting index of the array
     * @param endIndex   the ending index of the array
     * @param aix        the axis value for sorting order
     */
    @Override
    public void sort(long[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (array.length == 1) {
            return;
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
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
                    lastIndex = j;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given int array using the Bubble Sort algorithm.
     *
     * <p>
     * This implementation takes an array, a start index, an end index, and an axis
     * value as
     * parameters. It first checks if the array is null or if the range given is
     * invalid. If the
     * array is valid, it implements the Bubble Sort algorithm. The algorithm works
     * by repeatedly
     * stepping through the list, compares adjacent elements and swaps them if they
     * are in the wrong
     * order. The pass through the list is repeated until the list is sorted.
     *
     * @param array      the array to be sorted
     * @param startIndex the starting index of the array
     * @param endIndex   the ending index of the array
     * @param aix        the axis value for sorting order
     */
    @Override
    public void sort(short[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (array.length == 1) {
            return;
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
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
                    lastIndex = j;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given int array using the Bubble Sort algorithm.
     *
     * <p>
     * This implementation takes an array, a start index, an end index, and an axis
     * value as
     * parameters. It first checks if the array is null or if the range given is
     * invalid. If the
     * array is valid, it implements the Bubble Sort algorithm. The algorithm works
     * by repeatedly
     * stepping through the list, compares adjacent elements and swaps them if they
     * are in the wrong
     * order. The pass through the list is repeated until the list is sorted.
     *
     * @param array      the array to be sorted
     * @param startIndex the starting index of the array
     * @param endIndex   the ending index of the array
     * @param aix        the axis value for sorting order
     */
    @Override
    public void sort(byte[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (array.length == 1) {
            return;
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
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
                    lastIndex = j;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given int array using the Bubble Sort algorithm.
     *
     * <p>
     * This implementation takes an array, a start index, an end index, and an axis
     * value as
     * parameters. It first checks if the array is null or if the range given is
     * invalid. If the
     * array is valid, it implements the Bubble Sort algorithm. The algorithm works
     * by repeatedly
     * stepping through the list, compares adjacent elements and swaps them if they
     * are in the wrong
     * order. The pass through the list is repeated until the list is sorted.
     *
     * @param array      the array to be sorted
     * @param startIndex the starting index of the array
     * @param endIndex   the ending index of the array
     * @param aix        the axis value for sorting order
     */
    @Override
    public void sort(char[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (array.length == 1) {
            return;
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
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
                    lastIndex = j;
                }
            }
        } while (swapped);
    }

    /**
     * Sorts the given array of objects using the Bubble Sort algorithm.
     *
     * <p>
     * This implementation takes an array, a start index, an end index, and an axis
     * value as
     * parameters. It first checks if the array is null or if the range given is
     * invalid. If the
     * array is valid, it implements the Bubble Sort algorithm. The algorithm works
     * by repeatedly
     * stepping through the list, compares adjacent elements and swaps them if they
     * are in the wrong
     * order. The pass through the list is repeated until the list is sorted.
     *
     * @param array      the array to be sorted
     * @param startIndex the starting index of the array
     * @param endIndex   the ending index of the array
     * @param aix        the axis value for sorting order
     */
    @Override
    public void sort(Object[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (array.length == 1) {
            return;
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
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
                        lastIndex = j;
                    }
                }
            } while (swapped);
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
        }
    }

    /**
     * Sorts the given array of objects using the Bubble Sort algorithm.
     *
     * <p>
     * This implementation takes an array, a start index, an end index, and an axis
     * value as
     * parameters. It first checks if the array is null or if the range given is
     * invalid. If the
     * array is valid, it implements the Bubble Sort algorithm. The algorithm works
     * by repeatedly
     * stepping through the list, compares adjacent elements and swaps them if they
     * are in the wrong
     * order. The pass through the list is repeated until the list is sorted.
     *
     * @param array      the array to be sorted
     * @param startIndex the starting index of the array
     * @param endIndex   the ending index of the array
     * @param aix        the axis value for sorting order
     */
    @Override
    public <T extends Comparable<T>> void sort(T[] array, int startIndex, int endIndex, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length == 0) {
            throw new IllegalArgumentException("Array cannot be empty");
        }
        if (array.length == 1) {
            return;
        }
        if (!checkRange(array.length, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid range");
        }
        if (!checkAix(aix)) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        boolean swapped;
        int lastIndex;
        do {
            swapped = false;
            lastIndex = startIndex;
            for (int j = lastIndex; j < endIndex - 1; j++) {
                if (aix == ASCENDING ? array[j].compareTo(array[j + 1]) > 0
                        : array[j].compareTo(array[j + 1]) < 0) {
                    swap(array, j, j + 1);
                    swapped = true;
                    lastIndex = j;
                }
            }
        } while (swapped);
    }
}
