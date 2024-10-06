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

import java.util.Arrays;

/**
 * This class implements the Merge Sort algorithm, a divide-and-conquer algorithm that splits the
 * input array into two halves, recursively sorts them, and then merges them back together in sorted
 * order.
 */
public final class MergeSort implements SortAlgorithm {
  /** Static instance of the Merge Sort algorithm. */
  public static final MergeSort INSTANCE = new MergeSort();

  /** Default constructor for the MergeSort class. */
  public MergeSort() {}

  /**
   * Recursively splits the input array into two halves until each half has only one element, and
   * then merges them back together in sorted order.
   *
   * @param array the input array to be sorted
   * @param startIndex the starting index of the array
   * @param sortElementCount the number of elements to sort
   * @param compareAndSwap the CompareAndSwapFunction implementation for comparing and swapping
   *     elements
   */
  private <type> void merge_s(
      type[] array,
      int startIndex,
      int sortElementCount,
      CompareAndSwapFunction<type> compareAndSwap) {
    // Base case: if the array has only one element, it is already sorted
    if (sortElementCount <= 1) {
      return;
    }

    // Calculate the midpoint of the array
    int mid = sortElementCount / 2;

    // Recursively sort the left and right halves of the array
    merge_s(array, startIndex, mid, compareAndSwap);
    merge_s(array, startIndex + mid, sortElementCount - mid, compareAndSwap);

    // Merge the sorted left and right halves back together
    merge(array, startIndex, mid, sortElementCount, compareAndSwap);
  }

  /**
   * Merges two sorted arrays into a single sorted array.
   *
   * @param array the input array to be sorted
   * @param startIndex the starting index of the array
   * @param mid the midpoint of the array
   * @param sortElementCount the number of elements to sort
   * @param compareAndSwap the CompareAndSwapFunction implementation for comparing and swapping
   *     elements
   */
  private <type> void merge(
      type[] array,
      int startIndex,
      int mid,
      int sortElementCount,
      CompareAndSwapFunction<type> compareAndSwap) {
    // Create temporary arrays to hold the left and right halves of the array
    type[] left = Arrays.copyOfRange(array, startIndex, startIndex + mid);
    type[] right = Arrays.copyOfRange(array, startIndex + mid, startIndex + sortElementCount);

    // Initialize indices for the left and right halves, and the output array
    int i = 0, j = 0, k = startIndex;

    // Merge the left and right halves into the output array
    while (i < mid && j < sortElementCount - mid) {
      // Compare the current elements of the left and right halves, and copy the smaller one to the
      // output array
      if (compareAndSwap.compare(left[i], right[j]) <= 0) {
        array[k] = left[i];
        i++;
      } else {
        array[k] = right[j];
        j++;
      }
      k++;
    }

    // Copy any remaining elements from the left half to the output array
    while (i < mid) {
      array[k] = left[i];
      i++;
      k++;
    }

    // Copy any remaining elements from the right half to the output array
    while (j < sortElementCount - mid) {
      array[k] = right[j];
      j++;
      k++;
    }
  }

  /**
   * Sorts the input array using the Merge Sort algorithm.
   *
   * @param array the input array to be sorted
   * @param startIndex the starting index of the array
   * @param sortElementCount the number of elements to sort
   * @param aix the axis value for sorting order (not used in this implementation)
   * @param compareAndSwap the CompareAndSwapFunction implementation for comparing and swapping
   *     elements
   */
  @Override
  public <type> void sort(
      type[] array, // array to be sorted
      int startIndex, // starting index of the array
      int sortElementCount, // number of elements to sort
      int aix, // axis value for sorting order (not used in this implementation)
      CompareAndSwapFunction<type> compareAndSwap // compare and swap function implementation
      ) {
    // Base case: if the array has only one element, it is already sorted
    if (array.length <= 1) {
      return;
    }
    checkArray(array);
    checkRange(array, startIndex, sortElementCount);
    checkAix(aix);

    // Recursively sort the array using the merge_s method
    merge_s(array, startIndex, sortElementCount, compareAndSwap);
  }
}
