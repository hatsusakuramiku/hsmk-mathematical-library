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

import sort.utils.CompareAndSwapFunction;

/**
 * Implementation of the Heap Sort algorithm.
 *
 * <p>This class provides a static instance of the Heap Sort algorithm, which can be used to sort
 * arrays.
 */
public final class HeapSort implements SortAlgorithm {

  /** Static instance of the Heap Sort algorithm. */
  public static final HeapSort INSTANCE = new HeapSort();

  public HeapSort() {}

  /**
   * Sorts the given array using the provided compare and swap function.
   *
   * <p>This method implements the Heap Sort algorithm, which works by first building a heap from
   * the input array, and then repeatedly removing the largest element from the heap and placing it
   * at the end of the sorted array.
   *
   * @param array the array to be sorted
   * @param startIndex the starting index of the array
   * @param sortElementCount the number of elements to sort
   * @param aix the axis value (used for ascending or descending order)
   * @param compareAndSwap the CompareAndSwapFunction implementation for comparing and swapping
   *     elements
   */
  @Override
  public <type> void sort(
      type[] array,
      int startIndex,
      int sortElementCount,
      int aix,
      CompareAndSwapFunction<type> compareAndSwap) {
    // Check if the input array is valid
    checkArray(array);

    // If the array has one or zero elements, it is already sorted, so return immediately
    if (array.length <= 1 || sortElementCount <= 1) {
      return;
    }

    // Validate the range of the array and the axis value
    checkRange(array, startIndex, sortElementCount);
    checkAix(aix);

    // Build a heap from the input array
    buildHeap(array, startIndex, sortElementCount, compareAndSwap);

    // Repeatedly remove the largest element from the heap and place it at the end of the sorted
    // array
    int i = startIndex + sortElementCount - 1;
    for (; i > startIndex; i--) {
      // Swap the largest element with the last element in the heap
      compareAndSwap.swap(array, startIndex, i);

      // Heapify the reduced heap
      heapify(array, startIndex, startIndex, i - startIndex, compareAndSwap);
    }
  }

  /**
   * Builds a heap from the given array.
   *
   * <p>This method works by repeatedly heapifying the array, starting from the last non-leaf node
   * and moving backwards to the root node.
   *
   * @param array the array to build a heap from
   * @param startIndex the starting index of the array
   * @param sortElementCount the number of elements to build the heap from
   * @param compareAndSwap the CompareAndSwapFunction implementation for comparing and swapping
   *     elements
   */
  private <type> void buildHeap(
      type[] array,
      int startIndex,
      int sortElementCount,
      CompareAndSwapFunction<type> compareAndSwap) {
    // If the array has one or zero elements, it is already a heap, so return immediately
    if (sortElementCount <= 1) {
      return;
    }

    // Calculate the index of the last non-leaf node
    int k = startIndex + sortElementCount / 2 - 1;

    // Repeatedly heapify the array, starting from the last non-leaf node and moving backwards to
    // the root node
    do {
      heapify(array, startIndex, k, sortElementCount, compareAndSwap);
    } while (k-- != startIndex);
  }

  /**
   * Heapifies the given array.
   *
   * <p>This method works by repeatedly comparing the largest child node with the parent node, and
   * swapping them if necessary.
   *
   * @param array the array to heapify
   * @param startIndex the starting index of the array
   * @param largestIndex the index of the largest node in the heap
   * @param sortElementCount the number of elements in the heap
   * @param compareAndSwap the CompareAndSwapFunction implementation for comparing and swapping
   *     elements
   */
  private <type> void heapify(
      type[] array,
      int startIndex,
      int largestIndex,
      int sortElementCount,
      CompareAndSwapFunction<type> compareAndSwap) {
    // Calculate the indices of the left and right child nodes
    int left = largestIndex * 2 + 1 - startIndex;
    int right = largestIndex * 2 + 2 - startIndex;

    // Initialize the index of the largest node
    int tmp = largestIndex;

    // Compare the left child node with the largest node, and swap them if necessary
    if (left < sortElementCount && compareAndSwap.compare(array[left], array[tmp]) > 0) {
      tmp = left;
    }

    // Compare the right child node with the largest node, and swap them if necessary
    if (right < sortElementCount && compareAndSwap.compare(array[right], array[tmp]) > 0) {
      tmp = right;
    }

    // If the largest node has changed, swap it with the parent node and recursively heapify the
    // affected subtree
    if (tmp != largestIndex) {
      compareAndSwap.swap(array, tmp, largestIndex);
      heapify(array, startIndex, tmp, sortElementCount, compareAndSwap);
    }
  }
}
