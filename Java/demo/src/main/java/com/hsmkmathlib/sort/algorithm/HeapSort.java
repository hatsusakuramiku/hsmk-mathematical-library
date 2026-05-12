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
 * Heap Sort implementation.
 *
 * <p>Builds a max heap from the array, then extracts the maximum
 * element repeatedly to achieve sorted order.
 *
 * <p>Time complexity: O(n log n) all cases
 * <p>Space complexity: O(1)
 *
 * @param <T> the type of elements to sort, must implement Comparable
 */
public final class HeapSort<T extends Comparable<T>> implements SortAlgorithm<T> {

    public static final HeapSort<?> INSTANCE = new HeapSort<>();

    private HeapSort() {}

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
        int n = endIndex - startIndex;
        if (n <= 1) {
            return;
        }

        buildHeap(array, startIndex, n, order);
        for (int i = endIndex - 1; i > startIndex; i--) {
            swap(array, startIndex, i);
            heapify(array, startIndex, 0, n - 1, order);
        }
    }

    private void buildHeap(T[] array, int start, int n, int order) {
        for (int i = n / 2 - 1; i >= 0; i--) {
            heapify(array, start, i, n - 1, order);
        }
    }

    private void heapify(T[] array, int start, int i, int size, int order) {
        int largest = i;
        int left = 2 * i + 1;
        int right = 2 * i + 2;

        if (left <= size && compare(array[start + left], array[start + largest], order) > 0) {
            largest = left;
        }
        if (right <= size && compare(array[start + right], array[start + largest], order) > 0) {
            largest = right;
        }

        if (largest != i) {
            swap(array, start + i, start + largest);
            heapify(array, start, largest, size, order);
        }
    }
}