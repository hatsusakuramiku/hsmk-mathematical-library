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

import sort.Sort;
import sort.utils.CompareAndSwapFunction;

/**
 * This abstract class provides a bubble sort implementation. It allows for sorting arrays of any
 * type, using a custom comparison function.
 */
public abstract class BubbleSort extends Sort {

  /**
   * Sorts an array of elements using the bubble sort algorithm.
   *
   * @param array the array to be sorted
   * @param startIndex the starting index of the array to be sorted
   * @param endIndex the ending index of the array to be sorted
   * @param axis the axis to sort on (0 for ascending, 1 for descending)
   * @param compareFunction the custom comparison function to use
   * @throws NullPointerException if the array or comparison function is null
   * @throws IllegalArgumentException if the start index is greater than or equal to the end index,
   *     or if axis is not 0 or 1
   * @throws ArrayIndexOutOfBoundsException if the start or end index is out of bounds
   */
  public static <Type> void sort(
      Type[] array,
      int startIndex,
      int endIndex,
      int axis,
      CompareAndSwapFunction<Type> compareFunction) {
    // Check for null array
    if (array == null) {
      throw new NullPointerException("Array cannot be null");
    }

    // Check for null comparison function
    if (compareFunction == null) {
      throw new NullPointerException("Compare function cannot be null");
    }

    // Check for valid start and end indices
    if (startIndex >= endIndex) {
      throw new IllegalArgumentException("Start index must be less than end index");
    }

    // Check for valid axis
    if (axis != 0 && axis != 1) {
      throw new IllegalArgumentException("Axis must be 0 or 1");
    }

    // Check for index out of bounds
    if (startIndex < 0 || endIndex >= array.length) {
      throw new ArrayIndexOutOfBoundsException("Index out of bounds");
    }

    // Perform bubble sort
    if (axis == 0) {
      // Ascending sort
      /*
       Iterate through the array, comparing adjacent elements and swapping if necessary.
       Repeat this process until the entire array is sorted.
      */
      for (int i = startIndex; i <= endIndex; i++) {
        boolean flag = false;
        for (int j = 0; j <= endIndex - 1 - i; j++) {
          try {
            // Compare adjacent elements and swap if necessary
            if (compareFunction.upApply(array[j], array[j + 1]) > 0) {
              compareFunction.swap(array, j, j + 1);
              flag = true;
            }
          } catch (Exception e) {
            // Handle exception during comparison or swap
            throw new RuntimeException("Error during comparison or swap", e);
          }
        }
        if (flag) {
          break;
        }
      }
    } else {
      // Descending sort
      /*
       Iterate through the array, comparing adjacent elements and swapping if necessary.
       Repeat this process until the entire array is sorted.
      */
      for (int i = startIndex; i <= endIndex; i++) {
        boolean flag = false;
        for (int j = 0; j <= endIndex - 1 - i; j++) {
          try {
            // Compare adjacent elements and swap if necessary
            if (compareFunction.downApply(array[j], array[j + 1]) > 0) {
              compareFunction.swap(array, j, j + 1);
              flag = true;
            }
          } catch (Exception e) {
            // Handle exception during comparison or swap
            throw new RuntimeException("Error during comparison or swap", e);
          }
        }
        if (flag) {
          break;
        }
      }
    }
  }

  /**
   * Sorts an array of elements using the bubble sort algorithm, starting from the beginning of the
   * array.
   *
   * @param array the array to be sorted
   * @param axis the axis to sort on (0 for ascending, 1 for descending)
   * @param compareFunction the custom comparison function to use
   */
  public static <Type> void sort(
      Type[] array, int axis, CompareAndSwapFunction<Type> compareFunction) {
    sort(array, 0, array.length - 1, axis, compareFunction);
  }

  /**
   * Sorts an array of elements using the bubble sort algorithm, starting from the beginning of the
   * array and sorting in ascending order.
   *
   * @param array the array to be sorted
   * @param compareFunction the custom comparison function to use
   */
  public static <Type> void sort(Type[] array, CompareAndSwapFunction<Type> compareFunction) {
    sort(array, 0, array.length - 1, 0, compareFunction);
  }
}
