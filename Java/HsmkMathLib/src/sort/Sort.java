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

package sort;

import sort.utils.CompareAndSwapFunction;

/**
 * This abstract class defines a contract for sorting arrays of generic types. Implementations of
 * this interface should provide logic for sorting arrays.
 *
 * @author [Your Name]
 * @version [Current Version]
 */
public abstract class Sort {

  /**
   * Sorts a subarray of elements using a custom comparison function.
   *
   * <p>This method provides a flexible way to sort a portion of an array by specifying the start
   * and end indices. The comparison function is used to determine the order of elements.
   *
   * @param array the array to be sorted
   * @param startIndex the starting index of the subarray to be sorted (inclusive)
   * @param endIndex the ending index of the subarray to be sorted (exclusive)
   * @param aix the axis to sort on (0 for ascending, 1 for descending)
   * @param compareFunction the custom comparison function to use
   */
  abstract <Type> void sort(
      // The array to be sorted
      Type[] array,
      // The starting index of the subarray to be sorted
      int startIndex,
      // The ending index of the subarray to be sorted
      int endIndex,
      // The axis to sort on (0 for ascending, 1 for descending)
      int aix,
      // The custom comparison function to use
      CompareAndSwapFunction<Type> compareFunction);

  /**
   * Sorts an entire array using a custom comparison function and a specified axis.
   *
   * <p>This method is a convenience wrapper around the more flexible sort method. It sorts the
   * entire array by calling the more flexible sort method with the start index set to 0 and the end
   * index set to the array's length.
   *
   * @param array the array to be sorted
   * @param aix the axis to sort on (0 for ascending, 1 for descending)
   * @param compareFunction the custom comparison function to use
   */
  abstract <Type> void sort(
      // The array to be sorted
      Type[] array,
      // The axis to sort on (0 for ascending, 1 for descending)
      int aix,
      // The custom comparison function to use
      CompareAndSwapFunction<Type> compareFunction);

  /**
   * Sorts an entire array using a custom comparison function.
   *
   * <p>This method is a convenience wrapper around the more flexible sort method. It sorts the
   * entire array by calling the more flexible sort method with the start index set to 0, the end
   * index set to the array's length, and the axis set to 0 (ascending).
   *
   * @param array the array to be sorted
   * @param compareFunction the custom comparison function to use
   */
  abstract <Type> void sort(
      // The array to be sorted
      Type[] array,
      // The custom comparison function to use
      CompareAndSwapFunction<Type> compareFunction);
}
