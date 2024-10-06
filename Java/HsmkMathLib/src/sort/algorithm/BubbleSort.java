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

import static java.lang.Math.pow;

/**
 * This class implements the Bubble Sort algorithm, a simple sorting algorithm that repeatedly steps
 * through the list, compares adjacent elements and swaps them if they are in the wrong order. The
 * pass through the list is repeated until the list is sorted.
 */
public final class BubbleSort implements SortAlgorithm {
  /** Static instance of the Bubble Sort algorithm. */
  public static final BubbleSort INSTANCE = new BubbleSort();

  /** Default constructor for the BubbleSort class. */
  public BubbleSort() {}

  /**
   * Sorts the given array using the Bubble Sort algorithm.
   *
   * @param array the array to be sorted
   * @param startIndex the starting index of the array
   * @param sortElementCount the number of elements to sort
   * @param aix the axis value for sorting order (1 for ascending, -1 for descending)
   * @param compareAndSwap the CompareAndSwapFunction implementation for comparing and swapping
   *     elements
   */
  @Override
  public <type> void sort(
      type[] array, // array to be sorted
      int startIndex, // starting index of the array
      int sortElementCount, // number of elements to sort
      int aix, // axis value for sorting order
      CompareAndSwapFunction<type> compareAndSwap // compare and swap function implementation
      ) {
    // Check if the input array is null
    checkArray(array);

    // If the number of elements to sort is 0 or less, there's nothing to sort
    if (sortElementCount <= 0) {
      return;
    }

    // Check if the given range is valid for the array
    checkRange(array, startIndex, sortElementCount);

    // Check if the axis value is valid (1 for ascending, -1 for descending)
    checkAix(aix);

    // Calculate the temporary value based on the axis value
    // This is used to determine the sorting order
    int temp = (int) pow(-1, aix);

    // Calculate the end index of the array
    int endIndex = startIndex + sortElementCount;

    // Iterate through the array, comparing adjacent elements and swapping them if necessary
    for (int i = startIndex; i < endIndex; i++) {
      // Flag to track if any swaps were made in the current iteration
      boolean flag = false;

      // Compare each pair of adjacent elements and swap them if necessary
      for (int j = startIndex; j < endIndex - i - 1; j++) {
        // Compare the current element with the next element
        if (compareAndSwap.compare(array[j], array[j + 1]) * temp > 0) {
          // Swap the elements if they are in the wrong order
          compareAndSwap.swap(array, j, j + 1);
          flag = true;
        }
      }

      // If no swaps were made in the current iteration, the array is already sorted
      if (!flag) {
        break;
      }
    }
  }
}
