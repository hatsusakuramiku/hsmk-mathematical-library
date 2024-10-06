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
 * This class implements the Insertion Sort algorithm, which is a simple sorting algorithm that
 * works by dividing the input into a sorted and an unsorted region. Each subsequent element from
 * the unsorted region is inserted into the sorted region in its correct position.
 */
public final class InsertionSort implements SortAlgorithm {
  /** Static instance of the Insertion Sort algorithm. */
  public static final InsertionSort INSTANCE = new InsertionSort();

  /** Default constructor for the InsertionSort class. */
  public InsertionSort() {}

  /**
   * Sorts the given array using the provided compare and swap function.
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
    // Check if the input array is null
    checkArray(array);

    // If the array is empty, return immediately
    if (array.length <= 0) {
      return;
    }

    // Validate the range of the array and the axis value
    checkRange(array, startIndex, sortElementCount);
    checkAix(aix);

    // Calculate the end index of the array and a temporary value for sorting order
    int endIndex = startIndex + sortElementCount;
    int temp = (int) pow(-1, aix);

    // Iterate over the array, starting from the second element
    for (int i = startIndex + 1; i < endIndex; ++i) {
      // Store the current element
      type current = array[i];

      // Initialize the index for the previous element
      int j = i - 1;

      // Shift elements to the right until the correct position for the current element is found
      while (j >= 0 && compareAndSwap.compare(array[j], current) * temp > 0) {
        // Swap the elements at indices j and j + 1
        compareAndSwap.swap(array, j, j + 1);
        j--;
      }

      // Insert the current element at its correct position
      array[j + 1] = current;
    }
  }
}
