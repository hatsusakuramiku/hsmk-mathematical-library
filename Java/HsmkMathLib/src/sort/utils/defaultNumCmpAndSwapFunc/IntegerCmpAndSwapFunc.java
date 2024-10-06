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

package sort.utils.defaultNumCmpAndSwapFunc;

import sort.utils.CompareAndSwapFunction;

/**
 * This class implements the CompareAndSwapFunction interface for Integer type. It provides a way to
 * compare and swap two Integer elements in an array.
 */
public final class IntegerCmpAndSwapFunc implements CompareAndSwapFunction<Integer> {

  /**
   * Compares two elements in ascending order. Returns a positive integer if t1 is greater than t2,
   * zero if t1 is equal to t2, and a negative integer if t1 is less than t2.
   *
   * @param t1 the first element to compare
   * @param t2 the second element to compare
   * @return the result of the comparison
   */
  @Override
  public int compare(Integer t1, Integer t2) {
    // Use the built-in compareTo method of Integer to compare the two elements
    return t1.compareTo(t2);
  }

  /**
   * Swaps two elements in an array.
   *
   * @param array the array containing the elements to swap
   * @param index1 the index of the first element to swap
   * @param index2 the index of the second element to swap
   */
  @Override
  public void swap(Integer[] array, int index1, int index2) {
    // Store the value of the element at index1 in a temporary variable
    int temp = array[index1];

    // Replace the element at index1 with the element at index2
    array[index1] = array[index2];

    // Replace the element at index2 with the value stored in the temporary variable
    array[index2] = temp;
  }
}
