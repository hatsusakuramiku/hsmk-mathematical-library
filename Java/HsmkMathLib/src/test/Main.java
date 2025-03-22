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

// import sort.algorithm.BubbleSort;
import sort.algorithm.*;

import java.util.Random;
import java.util.function.Function;
import integral.algorithm.*;
import tools.ArrayTools;
import java.util.Arrays;

public class Main {
  public static final int ASCENDING = 0;
  public static final int DESCENDING = 1;

  public static void main(String[] args) {

    // Function<Double, Double> function = (x) -> x * x + 2 * x + 1;
    // double leftEndpoint = 1.0;
    // double rightEndpoint = 2.0;
    // double result = Simpson.INSTANCE.integralFixedStep(function, leftEndpoint,
    // rightEndpoint, 0.5);
    // System.out.println(result);

    Integer[] array = new Integer[10];
    int[] array1 = new int[10000];
    for (int i = 0; i < array.length; i++) {
      array[i] = new Random().nextInt(100000);
    }
    for (int i = 0; i < array1.length; i++) {
      array1[i] = new Random().nextInt(10000);
    }
    // System.out.println("before sort: ");
    Long startTime = System.currentTimeMillis();
    MergeSort.INSTANCE.sort(array, ASCENDING);
    Long endTime = System.currentTimeMillis();
    System.out.println("time: " + (endTime - startTime) + "ms");
    // System.out.println("after sort: ");
    // System.out.println(intArrayToString(array1));
    // System.out.println(arrayToString(array));
    // System.out.println(ArrayTools.isSorted(array, 0, array.length,
    // ArrayTools.ASCENDING));
    Arrays.stream(array).forEach(Main::test);
  }

  public static void test(Integer a) {
    System.out.println(a.toString().charAt(0));
  }

}
