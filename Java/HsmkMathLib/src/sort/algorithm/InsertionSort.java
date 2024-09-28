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

public final class InsertionSort implements SortAlgorithm {
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
    if (array.length <= 0) {
      return;
    }
    checkArray(array);
    checkRange(array, startIndex, sortElementCount);
    checkAix(aix);
    int endIndex = startIndex + sortElementCount, temp = (int) pow(-1, aix);
    for (int i = startIndex + 1; i < endIndex; ++i) {
      type current = array[i];
      int j = i - 1;
      while (j >= 0 && compareAndSwap.apply(array[j], current) * temp > 0) {
        compareAndSwap.swap(array, j, j + 1);
        j--;
      }
      array[j + 1] = current;
    }
  }
}
