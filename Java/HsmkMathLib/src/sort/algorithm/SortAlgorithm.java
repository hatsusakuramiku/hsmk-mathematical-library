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
 * This interface provides a basic implementation of a sort algorithm. It includes methods for
 * checking the range of an array and validating the axis (aix) value.
 */
public interface SortAlgorithm {

  int[] SORT_SAFE_VALUES = {0, 1}; // Default safe values for axis (aix) parameter

  /**
   * Checks if the specified range of the array is valid.
   *
   * @param array the array to check
   * @param start the starting index of the array
   * @param sortElementCount the number of elements to sort
   * @throws IllegalArgumentException if the range is invalid
   */
  default <type> void checkRange(type[] array, int start, int sortElementCount) {
    // Check if the start index is within the array bounds
    if (start < 0) {
      throw new IllegalArgumentException("Start index cannot be negative");
    }
    // Check if the end index is within the array bounds
    if (start + sortElementCount > array.length) {
      throw new IllegalArgumentException("End index exceeds array length");
    }
  }

  /**
   * Checks if the specified axis (aix) value is valid against a provided array of safe values.
   *
   * @param aix the axis value to check
   * @param safeValues the array of safe values to check against
   * @throws IllegalArgumentException if the aix value is invalid
   */
  default <type> void checkAix(int aix, int[] safeValues) {
    // Iterate over the safe values array
    for (int safeValue : safeValues) {
      // If the aix value matches a safe value, return immediately
      if (safeValue == aix) {
        return; // Aix value is valid
      }
    }
    // If the aix value does not match any safe value, throw an IllegalArgumentException
    throw new IllegalArgumentException("Invalid aix value");
  }

  /**
   * Checks if the specified axis (aix) value is valid using the default safe values.
   *
   * @param aix the axis value to check
   * @throws IllegalArgumentException if the aix value is invalid
   */
  default <type> void checkAix(int aix) {
    // Iterate over the default safe values array
    for (int i : SORT_SAFE_VALUES) {
      // If the aix value matches a safe value, return immediately
      if (i == aix) {
        return; // Aix value is valid
      }
    }
    // If the aix value does not match any safe value, throw an IllegalArgumentException
    throw new IllegalArgumentException("Invalid aix value");
  }

  /**
   * Checks if the array is null.
   *
   * @param array the array to check
   * @throws IllegalArgumentException if the array is null
   */
  default <type> void checkArray(type[] array) {
    // Check if the array is null
    if (array == null) {
      throw new IllegalArgumentException("Array cannot be null");
    }
  }

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
  <type> void sort(
      type[] array, // array to be sorted
      int startIndex, // starting index of the array
      int sortElementCount, // number of elements to sort
      int aix, // axis value for sorting order
      CompareAndSwapFunction<type> compareAndSwap // compare and swap function implementation
      );

  /**
   * Sorts the given array using the provided compare and swap function, with default start index
   * and axis value.
   *
   * @param array the array to be sorted
   * @param compareAndSwap the CompareAndSwapFunction implementation for comparing and swapping
   *     elements
   */
  default <type> void sort(type[] array, CompareAndSwapFunction<type> compareAndSwap) {
    // Use default start index (0) and axis value (0)
    this.sort(array, 0, array.length, 0, compareAndSwap);
  }

  /**
   * Sorts the given array using the Bubble Sort algorithm, with default start index and axis value.
   *
   * @param array the array to be sorted
   * @param sortElementCount the ending index of the array
   * @param aix the axis value (used for ascending or descending order)
   * @param compareAndSwap the CompareAndSwapFunction implementation for comparing and swapping
   *     elements
   */
  default <type> void sort(
      type[] array, int sortElementCount, int aix, CompareAndSwapFunction<type> compareAndSwap) {
    // Check if the sort element count is less than or equal to 1
    if (sortElementCount <= 1) {
      return; // No need to sort
    }
    // Use default start index (0)
    this.sort(array, 0, sortElementCount, aix, compareAndSwap);
  }

  /**
   * Sorts the given array using the Bubble Sort algorithm, with default start index and end index.
   *
   * @param array the array to be sorted
   * @param aix the axis value (used for ascending or descending order)
   * @param compareAndSwap the CompareAndSwapFunction implementation for comparing and swapping
   *     elements
   */
  default <type> void sort(type[] array, int aix, CompareAndSwapFunction<type> compareAndSwap) {
    // Check if the array length is less than or equal to 1
    if (array.length <= 1) {
      return; // No need to sort
    }
    // Use default start index (0) and end index (array length)
    this.sort(array, 0, array.length, aix, compareAndSwap);
  }
}
