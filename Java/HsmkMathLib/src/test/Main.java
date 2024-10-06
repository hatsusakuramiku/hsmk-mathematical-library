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
import sort.utils.CompareAndSwapFunction;
import sort.utils.defaultNumCmpAndSwapFunc.*;
import java.util.Random;

public class Main {
  public static void main(String[] args) {
    Random random = new Random();
    RandomArrayGenerator randomArrayGenerator = new RandomArrayGenerator();
    PrintArray<Double> printArray = new PrintArray<Double>();
    int minLength = 10, maxLength = 200000;
    double min = 0.0, max = 10.0;
    while (true) {
      Double[] tempArr =
          randomArrayGenerator.generateDoubleRandomArray(minLength, maxLength, min, max);
      System.out.println("array length: " + tempArr.length);
      HeapSort.INSTANCE.sort(tempArr, 0, new DoubleCmpAndSwapFunc());
      boolean flag = checkSorted(tempArr, 0, new DoubleCmpAndSwapFunc());
      if (!flag) {
        System.out.println("error");
        for (Double d : tempArr) {
          System.out.print(d + " \n");
        }
        break;
      }
    }
  }

  public static <type> boolean checkSorted(
      type[] arr, int aix, CompareAndSwapFunction<type> compareAndSwap) {
    int temp = (int) Math.pow(-1, aix);
    for (int i = 0; i < arr.length - 1; i++) {
      if (compareAndSwap.compare(arr[i], arr[i + 1]) * temp > 0) {
        return false;
      }
    }
    return true;
  }
}
