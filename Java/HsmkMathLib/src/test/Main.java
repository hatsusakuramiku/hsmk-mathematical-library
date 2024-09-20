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

package test;

import sort.Sort;
import sort.algorithm.BubbleSort;
import sort.utils.*;

class cmpAndSwapFunc implements CompareAndSwapFunction<Integer> {
  @Override
  public void swap(Integer[] arr, int i, int j) {
    Integer temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }

  @Override
  public int upApply(Integer t1, Integer t2) {
    return t1.compareTo(t2);
  }
}

public class Main {
  public static void main(String[] args) {
    Integer[] arr = {1, 5, 3, 4, 7, 6, 4, 5, 2, 0};
    BubbleSort.sort(arr, 0, new cmpAndSwapFunc());
    for (Integer i : arr) {
      System.out.println(i + " ");
    }
  }
}
