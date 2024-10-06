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
 * This class implements the Selection Sort algorithm, which is a simple sorting algorithm that
 * works by repeatedly finding the minimum element from the unsorted part of the array and swapping
 * it with the first unsorted element.
 */
public final class SelectionSort implements SortAlgorithm {
  /** Static instance of the Selection Sort algorithm. */
  public static final SelectionSort INSTANCE = new SelectionSort();

  /** Default constructor for the SelectionSort class. */
  public SelectionSort() {}

  /**
   * Sorts the given array using the provided compare and swap function.
   *
   * <p>This method implements the selection sort algorithm, which works by repeatedly finding the
   * minimum element from the unsorted part of the array and swapping it with the first unsorted
   * element.
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
    if (array.length <= 1) {
      return;
    }

    // Perform input validation on the array, start index, and sort element count
    checkRange(array, sortElementCount, array.length);
    checkAix(aix);

    // Calculate the end index of the array
    int end = startIndex + sortElementCount;

    // Calculate a temporary value used to determine the sorting order (ascending or descending)
    int temp = (int) Math.pow(-1, aix);

    // Iterate over the array, starting from the start index and ending at the end index
    for (int i = startIndex; i < end; i++) {
      // Initialize the minimum index to the current index
      int min = i;

      // Iterate over the remaining unsorted elements in the array
      for (int j = i + 1; j < end; j++) {
        // Compare the current element with the minimum element, using the provided compare and swap
        // function
        if (compareAndSwap.compare(array[j], array[min]) * temp < 0) {
          // If the current element is smaller than the minimum element, update the minimum index
          min = j;
        }
      }

      // Swap the minimum element with the current element
      compareAndSwap.swap(array, i, min);
    }
  }
}
