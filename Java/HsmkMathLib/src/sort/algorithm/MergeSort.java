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

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Arrays;

/**
 * This class implements the Merge Sort algorithm, a divide-and-conquer
 * algorithm that splits the
 * input array into two halves, recursively sorts them, and then merges them
 * back together in sorted
 * order.
 */
public final class MergeSort implements SortAlgorithm {
  /**
   * Static instance of the Merge Sort algorithm.
   */
  public static final MergeSort INSTANCE = new MergeSort();

  /**
   * Default constructor for the MergeSort class.
   */
  public MergeSort() {
  }

  /**
   * Sorts the given generic array using the Merge Sort algorithm.
   *
   * <p>
   * This implementation takes an array, a start index, an end index, and an axis
   * value as parameters. It first checks if the array is null, if the array is
   * empty, if the range given is invalid, or if the axis value is invalid. If the
   * array is valid, it implements the Merge Sort algorithm. The algorithm works
   * by dividing the input into two halves, recursively sorts them, and then
   * merges them back together in sorted order.
   *
   * @param array      the array to be sorted
   * @param startIndex the starting index of the array
   * @param endIndex   the ending index of the array, doesn't include the end
   * @param aix        the axis value for sorting order
   */
  @Override
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
    int sortElementCount = endIndex - startIndex;
    try {
      mergeBase(array, startIndex, sortElementCount, aix, getCompareToMethod(aix));
    } catch (Exception e) {
      throw new IllegalArgumentException(e.getMessage());
    }
  }

  /**
   * Recursively divides and merges a section of an array.
   *
   * <p>
   * This method divides the specified section of an array into two halves,
   * recursively sorts each half, and then merges the sorted halves back together.
   * It uses a provided comparison method to determine the order of elements based
   * on the specified axis value.
   *
   * @param array            the array containing the elements to be sorted
   * @param startIndex       the starting index of the section to sort
   * @param sortElementCount the number of elements in the section to sort
   * @param aix              the axis value for sorting order
   * @param compareMethod    the method used to compare two elements
   * @throws IllegalAccessException    if the comparison method is not accessible
   * @throws InvocationTargetException if the comparison method throws an
   *                                   exception
   */

  private void mergeBase(Object[] array, int startIndex, int sortElementCount, int aix, Method compareMethod)
      throws IllegalAccessException, InvocationTargetException {
    if (sortElementCount == 1)
      return;
    int mid = sortElementCount / 2;
    mergeBase(array, startIndex, mid, aix, compareMethod);
    mergeBase(array, startIndex + mid, sortElementCount - mid, aix, compareMethod);

    __mergeBase(array, startIndex, sortElementCount, mid, aix, compareMethod);
  }

  /**
   * Merges two sorted subarrays into a single sorted subarray.
   *
   * @param array            the array containing the subarrays
   * @param startIndex       the starting index of the first subarray
   * @param sortElementCount the total number of elements in both subarrays
   * @param mid              the midpoint dividing the subarrays
   * @param aix              the axis value for sorting order
   * @param compareMethod    the method to compare two elements
   * @throws IllegalAccessException    if the compare method is not accessible
   * @throws InvocationTargetException if the compare method throws an exception
   */
  private void __mergeBase(Object[] array, int startIndex, int sortElementCount, int mid,
      int aix, Method compareMethod) throws IllegalAccessException, InvocationTargetException {
    Object[] left = Arrays.copyOfRange(array, startIndex, startIndex + mid);
    Object[] right = Arrays.copyOfRange(array, startIndex + mid, startIndex + sortElementCount);

    int leftIndex = 0;
    int rightIndex = 0;
    int index = startIndex;
    while (leftIndex < left.length && rightIndex < right.length) {
      if (aix == ASCENDING ? (int) compareMethod.invoke(left[leftIndex], right[rightIndex]) < 0
          : (int) compareMethod.invoke(left[leftIndex], right[rightIndex]) > 0) {

        array[index] = left[leftIndex];
        leftIndex++;
      } else {
        array[index] = right[rightIndex];
        rightIndex++;
      }
      index++;
    }
    while (leftIndex < left.length) {
      array[index] = left[leftIndex];
      leftIndex++;
      index++;
    }
    while (rightIndex < right.length) {
      array[index] = right[rightIndex];
      rightIndex++;
      index++;
    }
  }

  /**
   * Sorts the given array using the Merge Sort algorithm.
   *
   * <p>
   * This implementation takes an array, a start index, an end index, and an axis
   * value as parameters. It first checks if the array is null, if the array is
   * empty, if the range given is invalid, or if the axis value is invalid. If the
   * array is valid, it implements the Merge Sort algorithm. The algorithm works
   * by dividing the input into two halves, recursively sorts them, and then
   * merges them back together in sorted order.
   *
   * @param array      the array to be sorted
   * @param startIndex the starting index of the array
   * @param endIndex   the ending index of the array, doesn't include the end
   * @param aix        the axis value for sorting order
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
    int sortElementCount = endIndex - startIndex;
    mergeBase(array, startIndex, sortElementCount, aix);
  }

  /**
   * Recursively divides the array into subarrays and merges them in order.
   *
   * @param array            the array to be sorted
   * @param startIndex       the starting index of the subarray
   * @param sortElementCount the number of elements to sort
   * @param aix              the axis value for sorting order
   */
  private void mergeBase(float[] array, int startIndex, int sortElementCount, int aix) {
    if (sortElementCount == 1)
      return;
    int mid = sortElementCount / 2;
    mergeBase(array, startIndex, mid, aix);
    mergeBase(array, startIndex + mid, sortElementCount - mid, aix);

    __mergeBase(array, startIndex, sortElementCount, mid, aix);
  }

  /**
   * Merges two sorted subarrays into a single sorted subarray.
   *
   * @param array            the array containing the subarrays
   * @param startIndex       the starting index of the first subarray
   * @param sortElementCount the total number of elements in both subarrays
   * @param mid              the midpoint dividing the subarrays
   * @param aix              the axis value for sorting order
   */
  private void __mergeBase(float[] array, int startIndex, int sortElementCount, int mid,
      int aix) {
    float[] left = Arrays.copyOfRange(array, startIndex, startIndex + mid);
    float[] right = Arrays.copyOfRange(array, startIndex + mid, startIndex + sortElementCount);

    int leftIndex = 0;
    int rightIndex = 0;
    int index = startIndex;
    while (leftIndex < left.length && rightIndex < right.length) {
      if (aix == ASCENDING ? left[leftIndex] < right[rightIndex] : left[leftIndex] > right[rightIndex]) {
        array[index] = left[leftIndex];
        leftIndex++;
      } else {
        array[index] = right[rightIndex];
        rightIndex++;
      }
      index++;
    }
    while (leftIndex < left.length) {
      array[index] = left[leftIndex];
      leftIndex++;
      index++;
    }
    while (rightIndex < right.length) {
      array[index] = right[rightIndex];
      rightIndex++;
      index++;
    }
  }

  /**
   * Sorts a portion of the specified double array using the Merge Sort algorithm.
   *
   * <p>
   * This method sorts the elements in the specified range of the array in
   * either ascending or descending order, based on the provided axis value.
   * It performs checks for null or empty arrays, invalid range, and invalid
   * axis values, throwing an IllegalArgumentException if any of these conditions
   * are met. The sorting process involves dividing the array into two halves,
   * recursively sorting them, and then merging them back together in sorted
   * order.
   *
   * @param array      the double array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range, exclusive
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains an
   *                                  invalid range, or has an invalid axis value
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
    int sortElementCount = endIndex - startIndex;
    mergeBase(array, startIndex, sortElementCount, aix);
  }

  /**
   * Recursively divides the array into subarrays and merges them in order.
   *
   * @param array            the array to be sorted
   * @param startIndex       the starting index of the subarray
   * @param sortElementCount the number of elements to sort
   * @param aix              the axis value for sorting order
   */
  private void mergeBase(double[] array, int startIndex, int sortElementCount, int aix) {
    if (sortElementCount == 1)
      return;
    int mid = sortElementCount / 2;
    mergeBase(array, startIndex, mid, aix);
    mergeBase(array, startIndex + mid, sortElementCount - mid, aix);

    __mergeBase(array, startIndex, sortElementCount, mid, aix);
  }

  /**
   * Merges two sorted subarrays into a single sorted subarray.
   *
   * @param array            the array containing the subarrays
   * @param startIndex       the starting index of the first subarray
   * @param sortElementCount the total number of elements in both subarrays
   * @param mid              the midpoint dividing the subarrays
   * @param aix              the axis value for sorting order
   */
  private void __mergeBase(double[] array, int startIndex, int sortElementCount, int mid,
      int aix) {
    double[] left = Arrays.copyOfRange(array, startIndex, startIndex + mid);
    double[] right = Arrays.copyOfRange(array, startIndex + mid, startIndex + sortElementCount);

    int leftIndex = 0;
    int rightIndex = 0;
    int index = startIndex;
    while (leftIndex < left.length && rightIndex < right.length) {
      if (aix == ASCENDING ? left[leftIndex] < right[rightIndex] : left[leftIndex] > right[rightIndex]) {
        array[index] = left[leftIndex];
        leftIndex++;
      } else {
        array[index] = right[rightIndex];
        rightIndex++;
      }
      index++;
    }
    while (leftIndex < left.length) {
      array[index] = left[leftIndex];
      leftIndex++;
      index++;
    }
    while (rightIndex < right.length) {
      array[index] = right[rightIndex];
      rightIndex++;
      index++;
    }
  }

  /**
   * Sorts a long array within the specified range and axis.
   *
   * @param array      the long array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid range,
   *                                  invalid axis value
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
    int sortElementCount = endIndex - startIndex;
    mergeBase(array, startIndex, sortElementCount, aix);
  }

  /**
   * Recursively divides the array into subarrays and merges them in order.
   *
   * @param array            the array to be sorted
   * @param startIndex       the starting index of the subarray
   * @param sortElementCount the number of elements to sort
   * @param aix              the axis value for sorting order
   */
  private void mergeBase(long[] array, int startIndex, int sortElementCount, int aix) {
    if (sortElementCount == 1)
      return;
    int mid = sortElementCount / 2;
    mergeBase(array, startIndex, mid, aix);
    mergeBase(array, startIndex + mid, sortElementCount - mid, aix);

    __mergeBase(array, startIndex, sortElementCount, mid, aix);
  }

  /**
   * Merges two sorted subarrays into a single sorted subarray.
   *
   * @param array            the array containing the subarrays
   * @param startIndex       the starting index of the first subarray
   * @param sortElementCount the total number of elements in both subarrays
   * @param mid              the midpoint dividing the subarrays
   * @param aix              the axis value for sorting order
   */
  private void __mergeBase(
      long[] array, int startIndex, int sortElementCount, int mid,
      int aix) {
    long[] left = Arrays.copyOfRange(array, startIndex, startIndex + mid);
    long[] right = Arrays.copyOfRange(array, startIndex + mid, startIndex + sortElementCount);

    int leftIndex = 0;
    int rightIndex = 0;
    int index = startIndex;
    while (leftIndex < left.length && rightIndex < right.length) {
      if (aix == ASCENDING ? left[leftIndex] < right[rightIndex] : left[leftIndex] > right[rightIndex]) {
        array[index] = left[leftIndex];
        leftIndex++;
      } else {
        array[index] = right[rightIndex];
        rightIndex++;
      }
      index++;
    }
    while (leftIndex < left.length) {
      array[index] = left[leftIndex];
      leftIndex++;
      index++;
    }
    while (rightIndex < right.length) {
      array[index] = right[rightIndex];
      rightIndex++;
      index++;
    }
  }

  /**
   * Sorts the given short array using the Merge Sort algorithm.
   *
   * <p>
   * This implementation takes a short array, a starting index, an ending index,
   * and an axis value as parameters. It first checks if the array is null or if
   * the range given is invalid. If the array is valid, it implements the Merge
   * Sort algorithm. The algorithm works by recursively dividing the array into
   * subarrays and merging them in order.
   *
   * @param array      the short array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid range, or invalid axis value
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
    int sortElementCount = endIndex - startIndex;
    mergeBase(array, startIndex, sortElementCount, aix);
  }

  /**
   * Recursively divides the array into subarrays and merges them in order.
   *
   * @param array            the array to be sorted
   * @param startIndex       the starting index of the subarray
   * @param sortElementCount the number of elements to sort
   * @param aix              the axis value for sorting order
   */
  private void mergeBase(short[] array, int startIndex, int sortElementCount, int aix) {
    if (sortElementCount == 1)
      return;
    int mid = sortElementCount / 2;
    mergeBase(array, startIndex, mid, aix);
    mergeBase(array, startIndex + mid, sortElementCount - mid, aix);

    __mergeBase(array, startIndex, sortElementCount, mid, aix);
  }

  /**
   * Merges two sorted subarrays into a single sorted subarray.
   *
   * @param array            the array containing the subarrays
   * @param startIndex       the starting index of the first subarray
   * @param sortElementCount the total number of elements in both subarrays
   * @param mid              the midpoint dividing the subarrays
   * @param aix              the axis value for sorting order
   */
  private void __mergeBase(
      short[] array, int startIndex, int sortElementCount, int mid,
      int aix) {
    short[] left = Arrays.copyOfRange(array, startIndex, startIndex + mid);
    short[] right = Arrays.copyOfRange(array, startIndex + mid, startIndex + sortElementCount);

    int leftIndex = 0;
    int rightIndex = 0;
    int index = startIndex;
    while (leftIndex < left.length && rightIndex < right.length) {
      if (aix == ASCENDING ? left[leftIndex] < right[rightIndex] : left[leftIndex] > right[rightIndex]) {
        array[index] = left[leftIndex];
        leftIndex++;
      } else {
        array[index] = right[rightIndex];
        rightIndex++;
      }
      index++;
    }
    while (leftIndex < left.length) {
      array[index] = left[leftIndex];
      leftIndex++;
      index++;
    }
    while (rightIndex < right.length) {
      array[index] = right[rightIndex];
      rightIndex++;
      index++;
    }
  }

  /**
   * Sorts the given byte array using the Merge Sort algorithm.
   *
   * <p>
   * This implementation takes a byte array, a starting index, an ending index,
   * and an axis value as parameters. It first checks if the array is null or if
   * the range given is invalid. If the array is valid, it implements the
   * Merge Sort algorithm. The algorithm works by recursively dividing the array
   * into subarrays and merging them in order.
   *
   * @param array      the byte array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid range, or invalid axis value
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
    int sortElementCount = endIndex - startIndex;
    mergeBase(array, startIndex, sortElementCount, aix);
  }

  /**
   * Recursively divides the array into subarrays and merges them in order.
   *
   * @param array            the array to be sorted
   * @param startIndex       the starting index of the subarray
   * @param sortElementCount the number of elements to sort
   * @param aix              the axis value for sorting order
   */
  private void mergeBase(byte[] array, int startIndex, int sortElementCount, int aix) {
    if (sortElementCount == 1)
      return;
    int mid = sortElementCount / 2;
    mergeBase(array, startIndex, mid, aix);
    mergeBase(array, startIndex + mid, sortElementCount - mid, aix);

    __mergeBase(array, startIndex, sortElementCount, mid, aix);
  }

  /**
   * Merges two sorted subarrays into a single sorted subarray.
   *
   * @param array            the array containing the subarrays
   * @param startIndex       the starting index of the first subarray
   * @param sortElementCount the total number of elements in both subarrays
   * @param mid              the midpoint dividing the subarrays
   * @param aix              the axis value for sorting order
   */
  private void __mergeBase(
      byte[] array, int startIndex, int sortElementCount, int mid,
      int aix) {
    byte[] left = Arrays.copyOfRange(array, startIndex, startIndex + mid);
    byte[] right = Arrays.copyOfRange(array, startIndex + mid, startIndex + sortElementCount);

    int leftIndex = 0;
    int rightIndex = 0;
    int index = startIndex;
    while (leftIndex < left.length && rightIndex < right.length) {
      if (aix == ASCENDING ? left[leftIndex] < right[rightIndex] : left[leftIndex] > right[rightIndex]) {
        array[index] = left[leftIndex];
        leftIndex++;
      } else {
        array[index] = right[rightIndex];
        rightIndex++;
      }
      index++;
    }
    while (leftIndex < left.length) {
      array[index] = left[leftIndex];
      leftIndex++;
      index++;
    }
    while (rightIndex < right.length) {
      array[index] = right[rightIndex];
      rightIndex++;
      index++;
    }
  }

  /**
   * Sorts the given array using the Merge Sort algorithm.
   *
   * <p>
   * This method sorts the specified range of the array in either ascending or
   * descending order,
   * depending on the axis value provided. It first checks for null or empty
   * arrays, invalid range,
   * invalid axis values in the array and throws an
   * IllegalArgumentException if
   * any of these conditions are met. The sorting is done by dividing the array
   * into a sorted and
   * unsorted region, and inserting each subsequent element from the unsorted
   * region into the
   * correct position within the sorted region.
   *
   * @param array      the array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range, doesn't include this
   *                   index
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid range,
   *                                  invalid axis value
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
    int sortElementCount = endIndex - startIndex;
    mergeBase(array, startIndex, sortElementCount, aix);
  }

  /**
   * Recursively divides the array into subarrays and merges them in order.
   *
   * @param array            the array to be sorted
   * @param startIndex       the starting index of the subarray
   * @param sortElementCount the number of elements to sort
   * @param aix              the axis value for sorting order
   */
  private void mergeBase(char[] array, int startIndex, int sortElementCount, int aix) {
    if (sortElementCount == 1)
      return;
    int mid = sortElementCount / 2;
    mergeBase(array, startIndex, mid, aix);
    mergeBase(array, startIndex + mid, sortElementCount - mid, aix);

    __mergeBase(array, startIndex, sortElementCount, mid, aix);
  }

  /**
   * Merges two sorted subarrays into a single sorted subarray.
   *
   * @param array            the array containing the subarrays
   * @param startIndex       the starting index of the first subarray
   * @param sortElementCount the total number of elements in both subarrays
   * @param mid              the midpoint dividing the subarrays
   * @param aix              the axis value for sorting order
   */
  private void __mergeBase(
      char[] array, int startIndex, int sortElementCount, int mid,
      int aix) {
    char[] left = Arrays.copyOfRange(array, startIndex, startIndex + mid);
    char[] right = Arrays.copyOfRange(array, startIndex + mid, startIndex + sortElementCount);

    int leftIndex = 0;
    int rightIndex = 0;
    int index = startIndex;
    while (leftIndex < left.length && rightIndex < right.length) {
      if (aix == ASCENDING ? left[leftIndex] < right[rightIndex] : left[leftIndex] > right[rightIndex]) {
        array[index] = left[leftIndex];
        leftIndex++;
      } else {
        array[index] = right[rightIndex];
        rightIndex++;
      }
      index++;
    }
    while (leftIndex < left.length) {
      array[index] = left[leftIndex];
      leftIndex++;
      index++;
    }
    while (rightIndex < right.length) {
      array[index] = right[rightIndex];
      rightIndex++;
      index++;
    }
  }

  /**
   * Sorts the given int array using the Merge Sort algorithm.
   *
   * <p>
   * This method sorts the specified range of the array in either ascending or
   * descending order, depending on the axis value provided. It first checks for
   * null or empty arrays, invalid range, and invalid axis values, throwing an
   * IllegalArgumentException if any of these conditions are met. The sorting is
   * performed via recursive division and merging of the array elements.
   *
   * @param array      the array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range, doesn't include this
   *                   index
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid range, or has an invalid axis value
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
    int sortElementCount = endIndex - startIndex;
    mergeBase(array, startIndex, sortElementCount, aix);
  }

  /**
   * Recursively divides the array into subarrays and merges them in order.
   *
   * @param array            the array to be sorted
   * @param startIndex       the starting index of the subarray
   * @param sortElementCount the number of elements to sort
   * @param aix              the axis value for sorting order
   */
  private void mergeBase(int[] array, int startIndex, int sortElementCount, int aix) {
    if (sortElementCount == 1)
      return;
    int mid = sortElementCount / 2;
    mergeBase(array, startIndex, mid, aix);
    mergeBase(array, startIndex + mid, sortElementCount - mid, aix);

    __mergeBase(array, startIndex, sortElementCount, mid, aix);
  }

  /**
   * Merges two sorted subarrays into a single sorted subarray.
   *
   * @param array            the array containing the subarrays
   * @param startIndex       the starting index of the first subarray
   * @param sortElementCount the total number of elements in both subarrays
   * @param mid              the midpoint dividing the subarrays
   * @param aix              the axis value for sorting order
   */
  private void __mergeBase(
      int[] array, int startIndex, int sortElementCount, int mid,
      int aix) {
    int[] left = Arrays.copyOfRange(array, startIndex, startIndex + mid);
    int[] right = Arrays.copyOfRange(array, startIndex + mid, startIndex + sortElementCount);

    int leftIndex = 0;
    int rightIndex = 0;
    int index = startIndex;
    while (leftIndex < left.length && rightIndex < right.length) {
      if (aix == ASCENDING ? left[leftIndex] < right[rightIndex] : left[leftIndex] > right[rightIndex]) {
        array[index] = left[leftIndex];
        leftIndex++;
      } else {
        array[index] = right[rightIndex];
        rightIndex++;
      }
      index++;
    }
    while (leftIndex < left.length) {
      array[index] = left[leftIndex];
      leftIndex++;
      index++;
    }
    while (rightIndex < right.length) {
      array[index] = right[rightIndex];
      rightIndex++;
      index++;
    }
  }

  @Override
  /**
   * Sorts the given array using the Merge Sort algorithm.
   *
   * <p>
   * This method sorts the specified range of the array in either ascending or
   * descending order, depending on the axis value provided. It first checks for
   * null or empty arrays, invalid range, invalid axis values, or null elements
   * in the array and throws an IllegalArgumentException if any of these
   * conditions are met. The sorting is done via recursive division and merging
   * of the array elements.
   *
   * @param array      the array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range, doesn't include this
   *                   index
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid range, invalid axis value, or null
   *                                  elements
   */
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
    int sortElementCount = endIndex - startIndex;
    mergeBase(array, startIndex, sortElementCount, aix);
  }

  /**
   * Recursively divides the array into subarrays and merges them in order.
   *
   * @param array            the array to be sorted
   * @param startIndex       the starting index of the subarray
   * @param sortElementCount the number of elements to sort
   * @param aix              the axis value for sorting order
   */
  private <T extends Comparable<T>> void mergeBase(T[] array, int startIndex, int sortElementCount, int aix) {
    if (sortElementCount == 1)
      return;
    int mid = sortElementCount / 2;
    mergeBase(array, startIndex, mid, aix);
    mergeBase(array, startIndex + mid, sortElementCount - mid, aix);

    __mergeBase(array, startIndex, sortElementCount, mid, aix);
  }

  /**
   * Merges two sorted subarrays into a single sorted subarray.
   *
   * @param array            the array containing the subarrays
   * @param startIndex       the starting index of the first subarray
   * @param sortElementCount the total number of elements in both subarrays
   * @param mid              the midpoint dividing the subarrays
   * @param aix              the axis value for sorting order
   */
  private <T extends Comparable<T>> void __mergeBase(T[] array, int startIndex, int sortElementCount, int mid,
      int aix) {
    T[] left = Arrays.copyOfRange(array, startIndex, startIndex + mid);
    T[] right = Arrays.copyOfRange(array, startIndex + mid, startIndex + sortElementCount);

    int leftIndex = 0;
    int rightIndex = 0;
    int index = startIndex;
    while (leftIndex < left.length && rightIndex < right.length) {
      if (aix == ASCENDING ? left[leftIndex].compareTo(right[rightIndex]) < 0
          : left[leftIndex].compareTo(right[rightIndex]) > 0) {
        array[index] = left[leftIndex];
        leftIndex++;
      } else {
        array[index] = right[rightIndex];
        rightIndex++;
      }
      index++;
    }
    while (leftIndex < left.length) {
      array[index] = left[leftIndex];
      leftIndex++;
      index++;
    }
    while (rightIndex < right.length) {
      array[index] = right[rightIndex];
      rightIndex++;
      index++;
    }
  }
}
