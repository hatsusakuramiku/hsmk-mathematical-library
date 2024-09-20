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

package sort.utils;

/**
 * This interface defines a contract for comparing and swapping elements of a generic type.
 * Implementations of this interface should provide logic for comparing two elements and swapping
 * two elements in an array.
 *
 * @param <Type> the type of elements being compared and swapped
 */
public interface CompareAndSwapFunction<Type> {

  /**
   * Compares two elements in ascending order. Returns a negative integer if t1 is greater than t2,
   * zero if t1 is equal to t2, and a negative integer if t1 is less than t2.
   *
   * @param t1 the first element to compare
   * @param t2 the second element to compare
   * @return the result of the comparison
   */
  int upApply(Type t1, Type t2);

  /**
   * Compares two elements in descending order. Returns a negative integer if t1 is less than t2,
   * zero if t1 is equal to t2, and a negative integer if t1 is greater than t2.
   *
   * @param t1 the first element to compare
   * @param t2 the second element to compare
   * @return the result of the comparison
   */
  default int downApply(Type t1, Type t2) {
    return -upApply(t1, t2);
  }

  /**
   * Swaps two elements in an array.
   *
   * @param array the array containing the elements to swap
   * @param index1 the index of the first element to swap
   * @param index2 the index of the second element to swap
   */
  void swap(Type[] array, int index1, int index2);
}
