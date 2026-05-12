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
 * Merge Sort implementation.
 *
 * <p>Divides array into halves, recursively sorts them, then merges
 * the sorted halves.
 *
 * <p>Time complexity: O(n log n) all cases
 * <p>Space complexity: O(n)
 *
 * @param <T> the type of elements to sort, must implement Comparable
 */
public final class MergeSort<T extends Comparable<T>> implements SortAlgorithm<T> {

    public static final MergeSort<?> INSTANCE = new MergeSort<>();

    private MergeSort() {}

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

        mergeSort(array, startIndex, endIndex, order);
    }

    private void mergeSort(T[] array, int startIndex, int endIndex, int order) {
        if (endIndex - startIndex <= 1) {
            return;
        }

        int mid = startIndex + (endIndex - startIndex) / 2;
        mergeSort(array, startIndex, mid, order);
        mergeSort(array, mid, endIndex, order);
        merge(array, startIndex, mid, endIndex, order);
    }

    @SuppressWarnings("unchecked")
    private void merge(T[] array, int start, int mid, int end, int order) {
        Object[] temp = new Object[end - start];
        int i = start, j = mid, k = 0;

        while (i < mid && j < end) {
            if (compare(array[i], array[j], order) <= 0) {
                temp[k++] = array[i++];
            } else {
                temp[k++] = array[j++];
            }
        }

        while (i < mid) {
            temp[k++] = array[i++];
        }
        while (j < end) {
            temp[k++] = array[j++];
        }

        for (int t = 0; t < temp.length; t++) {
            array[start + t] = (T) temp[t];
        }
    }
}