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

import java.lang.reflect.Method;

import sort.utils.SortAlgorithm;

/**
 * This class implements the Selection Sort algorithm, which is a simple sorting
 * algorithm that
 * works by repeatedly finding the minimum element from the unsorted part of the
 * array and swapping
 * it with the first unsorted element.
 */
public final class SelectionSort implements SortAlgorithm {
  /** Static instance of the Selection Sort algorithm. */
  public static final SelectionSort INSTANCE = new SelectionSort();

  /** Default constructor for the SelectionSort class. */
  public SelectionSort() {
  }

  /**
   * Sorts the given array in the given range, using the given axis value. The
   * axis value is used to control the sorting order, and 0 represents ascending
   * order and 1 represents descending order.
   *
   * @param array      The input array to be sorted.
   * @param startIndex The starting index of the array to sort.
   * @param endIndex   The ending index of the array to sort.
   * @param aix        The axis value to control the sorting order.
   * @throws IllegalArgumentException If the array is null, if the array is empty,
   *                                  if the range is invalid, if the axis value
   *                                  is invalid, or if the array
   *                                  contains null elements.
   */
  @Override
  @Deprecated
  public void sort(Object[] array, int startIndex, int endIndex, int aix) {
    if (array == null) {
      throw new IllegalArgumentException("Array cannot be null");
    }
    if (array.length == 0) {
      throw new IllegalArgumentException("Array cannot be empty");
    }
    if (!checkRange(array.length, startIndex, endIndex)) {
      throw new IllegalArgumentException("Invalid range");
    }
    if (!checkAix(aix)) {
      throw new IllegalArgumentException("Invalid axis value");
    }
    if (array.length == 1) {
      return;
    }
    if (checkArrayHasNull(array)) {
      throw new IllegalArgumentException("Array cannot contain null elements");
    }
    try {
      Method compareMethod = getCompareToMethod(array[0]);
      for (int i = startIndex; i < endIndex; ++i) {
        int minIndex = i;
        for (int j = i + 1; j < endIndex; ++j) {
          if (aix == ASCENDING ? (int) compareMethod.invoke(array[j], array[minIndex]) < 0
              : (int) compareMethod.invoke(array[j], array[minIndex]) > 0) {
            minIndex = j;
          }
        }
        if (minIndex != i) {
          swap(array, i, minIndex);
        }
      }
    } catch (Exception e) {
      throw new IllegalArgumentException(e.getMessage());
    }
  }

  /**
   * Sorts the given float array using the Selection Sort algorithm.
   *
   * <p>
   * This implementation takes a float array, a starting index, an ending index,
   * and an axis value as parameters. It first checks if the array is null or if
   * the range given is invalid. If the array is valid, it implements the
   * Selection
   * Sort algorithm. The algorithm works by repeatedly finding the minimum element
   * (considering ascending order) or maximum element (considering descending
   * order)
   * from unsorted part and putting it at the beginning of the sorted part.
   *
   * @param array      the float array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid
   *                                  range, or invalid axis value
   */
  @Override
  public void sort(float[] array, int startIndex, int endIndex, int aix) {
    if (array == null) {
      throw new IllegalArgumentException("Array cannot be null");
    }
    if (array.length == 0) {
      throw new IllegalArgumentException("Array cannot be empty");
    }
    if (!checkRange(array.length, startIndex, endIndex)) {
      throw new IllegalArgumentException("Invalid range");
    }
    if (!checkAix(aix)) {
      throw new IllegalArgumentException("Invalid axis value");
    }
    if (array.length == 1) {
      return;
    }
    for (int i = startIndex; i < endIndex; ++i) {
      int minIndex = i;
      for (int j = i + 1; j < endIndex; ++j) {
        if (aix == ASCENDING ? array[j] < array[minIndex]
            : array[j] > array[minIndex]) {
          minIndex = j;
        }
      }
      if (minIndex != i) {
        swap(array, i, minIndex);
      }
    }
  }

  /**
   * Sorts the given double array using the Selection Sort algorithm.
   *
   * <p>
   * This implementation takes a double array, a starting index, an ending index,
   * and an axis value as parameters. It first checks if the array is null or if
   * the range given is invalid. If the array is valid, it implements the
   * Selection
   * Sort algorithm. The algorithm works by repeatedly finding the minimum element
   * (considering ascending order) or maximum element (considering descending
   * order)
   * from unsorted part and putting it at the beginning of the sorted part.
   *
   * @param array      the double array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid
   *                                  range, or invalid axis value
   */
  @Override
  public void sort(double[] array, int startIndex, int endIndex, int aix) {
    if (array == null) {
      throw new IllegalArgumentException("Array cannot be null");
    }
    if (array.length == 0) {
      throw new IllegalArgumentException("Array cannot be empty");
    }
    if (!checkRange(array.length, startIndex, endIndex)) {
      throw new IllegalArgumentException("Invalid range");
    }
    if (!checkAix(aix)) {
      throw new IllegalArgumentException("Invalid axis value");
    }
    if (array.length == 1) {
      return;
    }
    for (int i = startIndex; i < endIndex; ++i) {
      int minIndex = i;
      for (int j = i + 1; j < endIndex; ++j) {
        if (aix == ASCENDING ? array[j] < array[minIndex]
            : array[j] > array[minIndex]) {
          minIndex = j;
        }
      }
      if (minIndex != i) {
        swap(array, i, minIndex);
      }
    }
  }

  /**
   * Sorts the given long array using the Selection Sort algorithm.
   *
   * <p>
   * This implementation takes a long array, a starting index, an ending index,
   * and an axis value as parameters. It first checks if the array is null or if
   * the range given is invalid. If the array is valid, it implements the
   * Selection
   * Sort algorithm. The algorithm works by repeatedly finding the minimum element
   * (considering ascending order) or maximum element (considering descending
   * order)
   * from unsorted part and putting it at the beginning of the sorted part.
   *
   * @param array      the long array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid
   *                                  range, or invalid axis value
   */
  @Override
  public void sort(long[] array, int startIndex, int endIndex, int aix) {
    if (array == null) {
      throw new IllegalArgumentException("Array cannot be null");
    }
    if (array.length == 0) {
      throw new IllegalArgumentException("Array cannot be empty");
    }
    if (!checkRange(array.length, startIndex, endIndex)) {
      throw new IllegalArgumentException("Invalid range");
    }
    if (!checkAix(aix)) {
      throw new IllegalArgumentException("Invalid axis value");
    }
    if (array.length == 1) {
      return;
    }
    for (int i = startIndex; i < endIndex; ++i) {
      int minIndex = i;
      for (int j = i + 1; j < endIndex; ++j) {
        if (aix == ASCENDING ? array[j] < array[minIndex]
            : array[j] > array[minIndex]) {
          minIndex = j;
        }
      }
      if (minIndex != i) {
        swap(array, i, minIndex);
      }
    }
  }

  /**
   * Sorts the given short array using the Selection Sort algorithm.
   *
   * <p>
   * This implementation takes a short array, a starting index, an ending index,
   * and an axis value as parameters. It first checks if the array is null or if
   * the range given is invalid. If the array is valid, it implements the
   * Selection
   * Sort algorithm. The algorithm works by repeatedly finding the minimum element
   * (considering ascending order) or maximum element (considering descending
   * order)
   * from unsorted part and putting it at the beginning of the sorted part.
   *
   * @param array      the short array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid
   *                                  range, or invalid axis value
   */
  @Override
  public void sort(short[] array, int startIndex, int endIndex, int aix) {
    if (array == null) {
      throw new IllegalArgumentException("Array cannot be null");
    }
    if (array.length == 0) {
      throw new IllegalArgumentException("Array cannot be empty");
    }
    if (!checkRange(array.length, startIndex, endIndex)) {
      throw new IllegalArgumentException("Invalid range");
    }
    if (!checkAix(aix)) {
      throw new IllegalArgumentException("Invalid axis value");
    }
    if (array.length == 1) {
      return;
    }
    for (int i = startIndex; i < endIndex; ++i) {
      int minIndex = i;
      for (int j = i + 1; j < endIndex; ++j) {
        if (aix == ASCENDING ? array[j] < array[minIndex]
            : array[j] > array[minIndex]) {
          minIndex = j;
        }
      }
      if (minIndex != i) {
        swap(array, i, minIndex);
      }
    }
  }

  /**
   * Sorts the given byte array using the Selection Sort algorithm.
   *
   * <p>
   * This implementation takes a byte array, a starting index, an ending index,
   * and an axis value as parameters. It first checks if the array is null or if
   * the range given is invalid. If the array is valid, it implements the
   * Selection
   * Sort algorithm. The algorithm works by repeatedly finding the minimum element
   * (considering ascending order) or maximum element (considering descending
   * order)
   * from unsorted part and putting it at the beginning of the sorted part.
   *
   * @param array      the byte array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid
   *                                  range, or invalid axis value
   */
  @Override
  public void sort(byte[] array, int startIndex, int endIndex, int aix) {
    if (array == null) {
      throw new IllegalArgumentException("Array cannot be null");
    }
    if (array.length == 0) {
      throw new IllegalArgumentException("Array cannot be empty");
    }
    if (!checkRange(array.length, startIndex, endIndex)) {
      throw new IllegalArgumentException("Invalid range");
    }
    if (!checkAix(aix)) {
      throw new IllegalArgumentException("Invalid axis value");
    }
    if (array.length == 1) {
      return;
    }
    for (int i = startIndex; i < endIndex; ++i) {
      int minIndex = i;
      for (int j = i + 1; j < endIndex; ++j) {
        if (aix == ASCENDING ? array[j] < array[minIndex]
            : array[j] > array[minIndex]) {
          minIndex = j;
        }
      }
      if (minIndex != i) {
        swap(array, i, minIndex);
      }
    }
  }

  /**
   * Sorts the given char array using the Selection Sort algorithm.
   *
   * <p>
   * This implementation takes a char array, a starting index, an ending index,
   * and an axis value as parameters. It first checks if the array is null or if
   * the range given is invalid. If the array is valid, it implements the
   * Selection
   * Sort algorithm. The algorithm works by repeatedly finding the minimum element
   * (considering ascending order) or maximum element (considering descending
   * order)
   * from unsorted part and putting it at the beginning of the sorted part.
   *
   * @param array      the char array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid
   *                                  range, or invalid axis value
   */
  @Override
  public void sort(char[] array, int startIndex, int endIndex, int aix) {
    if (array == null) {
      throw new IllegalArgumentException("Array cannot be null");
    }
    if (array.length == 0) {
      throw new IllegalArgumentException("Array cannot be empty");
    }
    if (!checkRange(array.length, startIndex, endIndex)) {
      throw new IllegalArgumentException("Invalid range");
    }
    if (!checkAix(aix)) {
      throw new IllegalArgumentException("Invalid axis value");
    }
    if (array.length == 1) {
      return;
    }
    for (int i = startIndex; i < endIndex; ++i) {
      int minIndex = i;
      for (int j = i + 1; j < endIndex; ++j) {
        if (aix == ASCENDING ? array[j] < array[minIndex]
            : array[j] > array[minIndex]) {
          minIndex = j;
        }
      }
      if (minIndex != i) {
        swap(array, i, minIndex);
      }
    }
  }

  /**
   * Sorts the given int array using the Selection Sort algorithm.
   *
   * <p>
   * This implementation takes a int array, a starting index, an ending index,
   * and an axis value as parameters. It first checks if the array is null or if
   * the range given is invalid. If the array is valid, it implements the
   * Selection
   * Sort algorithm. The algorithm works by repeatedly finding the minimum element
   * (considering ascending order) or maximum element (considering descending
   * order)
   * from unsorted part and putting it at the beginning of the sorted part.
   *
   * @param array      the int array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid
   *                                  range, or invalid axis value
   */
  @Override
  public void sort(int[] array, int startIndex, int endIndex, int aix) {
    if (array == null) {
      throw new IllegalArgumentException("Array cannot be null");
    }
    if (array.length == 0) {
      throw new IllegalArgumentException("Array cannot be empty");
    }
    if (!checkRange(array.length, startIndex, endIndex)) {
      throw new IllegalArgumentException("Invalid range");
    }
    if (!checkAix(aix)) {
      throw new IllegalArgumentException("Invalid axis value");
    }
    if (array.length == 1) {
      return;
    }
    for (int i = startIndex; i < endIndex; ++i) {
      int minIndex = i;
      for (int j = i + 1; j < endIndex; ++j) {
        if (aix == ASCENDING ? array[j] < array[minIndex]
            : array[j] > array[minIndex]) {
          minIndex = j;
        }
      }
      if (minIndex != i) {
        swap(array, i, minIndex);
      }
    }
  }

  /**
   * Sorts the given array of objects using the Selection Sort algorithm.
   *
   * <p>
   * This implementation takes an array, a start index, an end index, and an axis
   * value as
   * parameters. It first checks if the array is null or if the range given is
   * invalid. If the
   * array is valid, it implements the Selection Sort algorithm. The algorithm
   * works
   * by repeatedly
   * finding the minimum element (considering ascending order) or maximum element
   * (considering descending
   * order)
   * from unsorted part and putting it at the beginning of the sorted part.
   *
   * @param array      the array to be sorted
   * @param startIndex the starting index of the array
   * @param endIndex   the ending index of the array
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid
   *                                  range, or invalid axis value, or if the
   *                                  array contains null elements
   */
  @Override
  public <T extends Comparable<T>> void sort(T[] array, int startIndex, int endIndex, int aix) {
    if (array == null) {
      throw new IllegalArgumentException("Array cannot be null");
    }
    if (array.length == 0) {
      throw new IllegalArgumentException("Array cannot be empty");
    }
    if (!checkRange(array.length, startIndex, endIndex)) {
      throw new IllegalArgumentException("Invalid range");
    }
    if (!checkAix(aix)) {
      throw new IllegalArgumentException("Invalid axis value");
    }
    if (array.length == 1) {
      return;
    }
    if (checkArrayHasNull(array)) {
      throw new IllegalArgumentException("Array cannot contain null elements");
    }
    for (int i = startIndex; i < endIndex; ++i) {
      int minIndex = i;
      for (int j = i + 1; j < endIndex; ++j) {
        if (aix == ASCENDING ? array[j].compareTo(array[minIndex]) < 0 : array[j].compareTo(array[minIndex]) > 0) {
          minIndex = j;
        }
      }
      if (minIndex != i) {
        swap(array, i, minIndex);
      }
    }
  }
}
