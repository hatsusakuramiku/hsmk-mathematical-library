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

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Random;
import java.util.StringJoiner;
import java.util.function.Function;
import integral.algorithm.*;

public class Main {
  public static final int ASCENDING = 0;
  public static final int DESCENDING = 1;

  public static void main(String[] args) {

    Function<Double, Double> function = (x) -> x * x + 2 * x + 1;
    double leftEndpoint = 1.0;
    double rightEndpoint = 2.0;
    double result = Trapezoid.INSTANCE.integral(function, leftEndpoint, rightEndpoint);
    System.out.println(result);

    // Integer[] array = new Integer[10000];
    // int[] array1 = new int[10000];
    // for (int i = 0; i < array.length; i++) {
    // array[i] = new Random().nextInt(100000);
    // }
    // for (int i = 0; i < array1.length; i++) {
    // array1[i] = new Random().nextInt(10000);
    // }
    // // System.out.println("before sort: ");
    // Long startTime = System.currentTimeMillis();
    // MergeSort.INSTANCE.sort(array, ASCENDING);
    // Long endTime = System.currentTimeMillis();
    // System.out.println("time: " + (endTime - startTime) + "ms");
    // // System.out.println("after sort: ");
    // // System.out.println(intArrayToString(array1));
    // // System.out.println(arrayToString(array));
    // System.out.println(testSort(array, ASCENDING));
  }

  public static String intArrayToString(int[] array) {
    if (array == null) {
      return null;
    }
    if (array.length == 0) {
      return "[]";
    }
    StringJoiner sj = new StringJoiner(", ", "[", "]");
    for (int i : array) {
      sj.add(String.valueOf(i));
    }
    return sj.toString();
  }

  public static <T extends Number> String arrayToString(T[] array) {
    if (array == null) {
      return null;
    }
    if (array.length == 0) {
      return "[]";
    }
    StringJoiner sj = new StringJoiner(", ", "[", "]");
    for (T i : array) {
      sj.add(String.valueOf(i.toString()));
    }
    return sj.toString();
  }

  public static boolean testSort(int[] array, int aix) {
    if (aix == 0) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] > array[i + 1]) {
          return false;
        }
      }
    } else if (aix == 1) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] < array[i + 1]) {
          return false;
        }
      }
    }
    return true;
  }

  public static boolean testSort(byte[] array, int aix) {
    if (aix == 0) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] > array[i + 1]) {
          return false;
        }
      }
    } else if (aix == 1) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] < array[i + 1]) {
          return false;
        }
      }
    }
    return true;
  }

  public static boolean testSort(double[] array, int aix) {
    if (aix == 0) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] > array[i + 1]) {
          return false;
        }
      }
    } else if (aix == 1) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] < array[i + 1]) {
          return false;
        }
      }
    }
    return true;
  }

  public static boolean testSort(float[] array, int aix) {
    if (aix == 0) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] > array[i + 1]) {
          return false;
        }
      }
    } else if (aix == 1) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] < array[i + 1]) {
          return false;
        }
      }
    }
    return true;
  }

  public static boolean testSort(short[] array, int aix) {
    if (aix == 0) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] > array[i + 1]) {
          return false;
        }
      }
    } else if (aix == 1) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] < array[i + 1]) {
          return false;
        }
      }
    }
    return true;
  }

  public static boolean testSort(char[] array, int aix) {
    if (aix == 0) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] > array[i + 1]) {
          return false;
        }
      }
    } else if (aix == 1) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] < array[i + 1]) {
          return false;
        }
      }
    }
    return true;
  }

  public static boolean testSort(long[] array, int aix) {
    if (aix == 0) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] > array[i + 1]) {
          return false;
        }
      }
    } else if (aix == 1) {
      for (int i = 0; i < array.length - 1; i++) {
        if (array[i] < array[i + 1]) {
          return false;
        }
      }
    }
    return true;
  }

  public static boolean testSort(Object[] array, int aix) {
    try {
      if (aix == 0) {
        for (int i = 0; i < array.length - 1; i++) {
          if (compare(array[i], array[i + 1]) > 0) {
            return false;
          }
        }
      } else if (aix == 1) {
        for (int i = 0; i < array.length - 1; i++) {
          if (compare(array[i], array[i + 1]) < 0) {
            return false;
          }
        }
      }
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
    return true;
  }

  /**
   * Compares two objects using their compareTo method.
   *
   * @param o1 the first object to compare
   * @param o2 the second object to compare
   * @return a negative integer, zero, or a positive integer if the first object
   *         is less than,
   *         equal to, or greater than the second object, respectively
   * @throws IllegalAccessException    if the compareTo method is inaccessible
   * @throws InvocationTargetException if the compareTo method throws an exception
   * @throws NoSuchMethodException     if the compareTo method is not found
   * @throws SecurityException         if access to the compareTo method is denied
   */
  public static int compare(Object o1, Object o2)
      throws IllegalAccessException, InvocationTargetException, NoSuchMethodException, SecurityException {
    // Retrieve the compareTo method from the first object's class
    Method compareMethod = o1.getClass().getMethod("compareTo", Object.class);

    // Invoke the compareTo method on the first object with the second object as an
    // argument
    return (int) compareMethod.invoke(o1, o2);
  }
}
