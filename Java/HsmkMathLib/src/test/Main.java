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

import sort.algorithm.*;
import sort.utils.*;
import java.util.Random;

import java.lang.reflect.Type;

class cmpAndSwapFunc implements CompareAndSwapFunction<Integer> {
  @Override
  public void swap(Integer[] arr, int i, int j) {
    Integer temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }

  @Override
  public int apply(Integer a, Integer b) {
    return a.compareTo(b);
  }
}

class doubleCmpAndSwapFunc implements CompareAndSwapFunction<Double> {
  @Override
  public void swap(Double[] arr, int i, int j) {
    Double temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }

  @Override
  public int apply(Double a, Double b) {
    return a.compareTo(b);
  }
}

public class Main {
  public static void main(String[] args) {
    Integer[] arr = {1, 5, 3, 4, 7, 6, 4, 5, 2, 0};
    BubbleSort bubbleSort = new BubbleSort();
    InsertionSort insertionSort = new InsertionSort();
    Random random = new Random();
    RandomArrayGenerator randomArrayGenerator = new RandomArrayGenerator();
    int minLength = 10, maxLength = 1000;
    double min = 0.0, max = 10.0;
    while (true) {
      Double[] tempArr =
          randomArrayGenerator.generateDoubleRandomArray(minLength, maxLength, min, max);
      System.out.println("array length: " + tempArr.length);
      bubbleSort.sort(tempArr, 0, new doubleCmpAndSwapFunc());
      boolean flag = checkSorted(tempArr, 0, new doubleCmpAndSwapFunc());
      if (!flag) {
        System.out.println("error");
        break;
      }
    }
  }

  public static <type> boolean checkSorted(
      type[] arr, int aix, CompareAndSwapFunction<type> compareAndSwap) {
    int temp = (int) Math.pow(-1, aix);
    for (int i = 0; i < arr.length - 1; i++) {
      if (compareAndSwap.apply(arr[i], arr[i + 1]) * temp > 0) {
        return false;
      }
    }
    return true;
  }
}
