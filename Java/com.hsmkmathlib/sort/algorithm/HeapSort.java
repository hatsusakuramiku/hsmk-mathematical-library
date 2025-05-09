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
import sort.utils.SortAlgorithm;

/**
 * Implementation of the Heap Sort algorithm.
 *
 * <p>
 * This class provides a static instance of the Heap Sort algorithm, which can
 * be used to sort
 * arrays.
 */
public final class HeapSort implements SortAlgorithm {

  /** Static instance of the Heap Sort algorithm. */
  public static final HeapSort INSTANCE = new HeapSort();

  public HeapSort() {
  }

  /**
   * Sorts the given array in the given range and axis.
   *
   * <p>
   * This method sorts the given array in the given range and axis. The sort
   * algorithm used is the Heap Sort algorithm. The axis value is used to control
   * the sorting order, and 0 represents ascending order and 1 represents
   * descending order.
   *
   * <p>
   * The given array should contain only comparable elements, and the elements
   * should not be null.
   *
   * @param array      the input array
   * @param startIndex the starting index of the array
   * @param endIndex   the ending index of the array, doesn't include
   * @param aix        the axis value for sorting order
   * @throws IllegalArgumentException if the array is null, the array is empty,
   *                                  the range is invalid, the axis value is
   *                                  invalid, or the array contains null
   *                                  elements
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
    int sortElementCount = endIndex - startIndex;
    try {
      Method compareMethod = getCompareToMethod(array[0]);
      buildHeap(array, startIndex, sortElementCount, aix, compareMethod);
      for (int i = endIndex - 1; i > startIndex; i--) {
        swap(array, startIndex, i);
        heapify(array, startIndex, startIndex, i - startIndex, aix, compareMethod);
      }
    } catch (IllegalAccessException | NoSuchMethodException | SecurityException | InvocationTargetException e) {
      throw new IllegalArgumentException(e.getMessage());
    }
  }

  /**
   * Builds a heap structure in the given array within the specified range and
   * axis.
   *
   * <p>
   * This method builds a heap structure in the given array within the specified
   * range and axis. The heap structure is a complete binary tree, where each
   * parent node is either greater than (in ascending order) or less than (in
   * descending order) its children. The heap structure is used as a step in the
   * Heap Sort algorithm.
   *
   * @param array            the array to build the heap structure
   * @param startIndex       the starting index of the array
   * @param sortElementCount the number of elements to build the heap
   * @param aix              the axis value for sorting order
   * @param compareMethod    the method used to compare two elements
   * @throws IllegalAccessException    if the comparison method is not accessible
   * @throws InvocationTargetException if the comparison method throws an
   *                                   exception
   */
  private void buildHeap(Object[] array, int startIndex, int sortElemCount, int aix, Method compareMethod)
      throws IllegalAccessException, InvocationTargetException {
    if (sortElemCount <= 1) {
      return;
    }
    int k = startIndex + sortElemCount / 2 - 1;

    do {
      heapify(array, startIndex, k, sortElemCount, aix, compareMethod);
    } while (k-- != startIndex);

  }

  /**
   * Heapifies a subtree rooted at index largestIndex in the given array.
   *
   * This function ensures that the heap property is maintained in the subtree,
   * i.e., the parent node is either greater than (in a max heap) or less than
   * (in a min heap) its child nodes.
   *
   * @param array            the array to heapify.
   * @param startIndex       the starting index of the array.
   * @param largestIndex     the index of the root of the subtree to heapify.
   * @param sortElementCount the number of elements in the array.
   * @param aix              the axis value for sorting order.
   * @param compareMethod    the method used to compare two elements.
   *
   * @throws IllegalAccessException    if the comparison method is not accessible
   * @throws InvocationTargetException if the comparison method throws an
   *                                   exception
   */
  private void heapify(
      Object[] array, int startIndex, int largestIndex, int sortElemCount,
      int aix, Method compareMethod) throws IllegalAccessException, InvocationTargetException {
    int left = 2 * largestIndex + 1 - startIndex;
    int right = 2 * largestIndex + 2 - startIndex;
    int largest = largestIndex;
    if (left < sortElemCount && (aix == ASCENDING ? (int) compareMethod.invoke(array[left], array[largest]) > 0
        : (int) compareMethod.invoke(array[left], array[largest]) < 0)) {
      largest = left;
    }
    if (right < sortElemCount && (aix == ASCENDING ? (int) compareMethod.invoke(array[left],
        array[largest]) > 0
        : (int) compareMethod.invoke(array[left], array[largest]) < 0)) {
      largest = right;
    }
    if (largest != largestIndex) {
      swap(array, largestIndex, largest);
      heapify(array, startIndex, largest, sortElemCount, aix, compareMethod);
    }

  }

  /**
   * Sorts the given array using the Heap Sort algorithm.
   *
   * <p>
   * This method sorts the given array in the given range and axis. The sort
   * algorithm used is the Heap Sort algorithm. The axis value is used to control
   * the sorting order, and 0 represents ascending order and 1 represents
   * descending order.
   *
   * <p>
   * The given array should contain only comparable elements, and the elements
   * should not be null.
   *
   * @param array      the input array
   * @param startIndex the starting index of the array
   * @param endIndex   the ending index of the array, doesn't include
   * @param aix        the axis value for sorting order
   * @throws IllegalArgumentException if the array is null, the array is empty,
   *                                  the range is invalid, the axis value is
   *                                  invalid, or the array contains null
   *                                  elements
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
    buildHeap(array, startIndex, sortElementCount, aix);
    for (int i = endIndex - 1; i > startIndex; i--) {
      swap(array, startIndex, i);
      heapify(array, startIndex, startIndex, i - startIndex, aix);
    }
  }

  /**
   * Builds a heap structure in the given array within the specified range and
   * axis.
   *
   * <p>
   * This method builds a heap structure in the given array within the specified
   * range and axis. The heap structure is a complete binary tree, where each
   * parent node is either greater than (in ascending order) or less than (in
   * descending order) its children. The heap structure is used as a step in the
   * Heap Sort algorithm.
   *
   * @param array            the array to build the heap structure
   * @param startIndex       the starting index of the array
   * @param sortElementCount the number of elements to build the heap
   * @param aix              the axis value for sorting order
   */
  private void buildHeap(float[] array, int startIndex, int sortElemCount, int aix) {
    if (sortElemCount <= 1) {
      return;
    }
    int k = startIndex + sortElemCount / 2 - 1;

    do {
      heapify(array, startIndex, k, sortElemCount, aix);
    } while (k-- != startIndex);

  }

  /**
   * Heapifies a subtree rooted at index largestIndex in the given array.
   *
   * <p>
   * This method ensures that the subtree rooted at largestIndex satisfies
   * the heap property. It compares the root with its left and right children
   * and swaps the largest value with the root to maintain the heap structure.
   * This operation is continued recursively for the affected subtree to ensure
   * the entire heap is properly structured.
   *
   * @param array         the array representing the heap
   * @param startIndex    the starting index of the heap
   * @param largestIndex  the index of the root of the subtree to heapify
   * @param sortElemCount the number of elements in the heap
   * @param aix           the axis value for sorting order, 0 for ascending,
   *                      1 for descending
   */

  private void heapify(float[] array, int startIndex, int largestIndex, int sortElemCount,
      int aix) {
    int left = 2 * largestIndex + 1 - startIndex;
    int right = 2 * largestIndex + 2 - startIndex;
    int largest = largestIndex;
    if (left < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = left;
    }
    if (right < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = right;
    }
    if (largest != largestIndex) {
      swap(array, largestIndex, largest);
      heapify(array, startIndex, largest, sortElemCount, aix);
    }

  }

  /**
   * Sorts the given double array using the Heap Sort algorithm.
   *
   * <p>
   * This implementation takes an array, a start index, an end index, and an axis
   * value as parameters. It first checks if the array is null or empty, or if the
   * range given is invalid. If the array is valid, it builds a heap from the
   * array, then repeatedly swaps the root of the heap with the last element of
   * the heap, and heapifies the remaining elements to maintain the heap
   * property. At the end of the process, the array is sorted in the specified
   * order.
   *
   * @param array      the array to be sorted
   * @param startIndex the starting index of the array
   * @param endIndex   the ending index of the array, doesn't include the end
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null or empty, or if the
   *                                  range given is invalid
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
    buildHeap(array, startIndex, sortElementCount, aix);
    for (int i = endIndex - 1; i > startIndex; i--) {
      swap(array, startIndex, i);
      heapify(array, startIndex, startIndex, i - startIndex, aix);
    }
  }

  /**
   * Builds a heap structure in the given array within the specified range and
   * axis.
   *
   * <p>
   * This method builds a heap structure in the given array within the specified
   * range and axis. The heap structure is a complete binary tree, where each
   * parent node is either greater than (in ascending order) or less than (in
   * descending order) its children. The heap structure is used as a step in the
   * Heap Sort algorithm.
   *
   * @param array            the array to build the heap structure
   * @param startIndex       the starting index of the array
   * @param sortElementCount the number of elements to build the heap
   * @param aix              the axis value for sorting order
   */
  private void buildHeap(double[] array, int startIndex, int sortElemCount, int aix) {
    if (sortElemCount <= 1) {
      return;
    }
    int k = startIndex + sortElemCount / 2 - 1;

    do {
      heapify(array, startIndex, k, sortElemCount, aix);
    } while (k-- != startIndex);

  }

  /**
   * Heapifies a subtree rooted at index largestIndex in the given array.
   *
   * <p>
   * This method ensures that the subtree rooted at largestIndex satisfies
   * the heap property. It compares the root with its left and right children
   * and swaps the largest value with the root to maintain the heap structure.
   * This operation is continued recursively for the affected subtree to ensure
   * the entire heap is properly structured.
   *
   * @param array         the array representing the heap
   * @param startIndex    the starting index of the heap
   * @param largestIndex  the index of the root of the subtree to heapify
   * @param sortElemCount the number of elements in the heap
   * @param aix           the axis value for sorting order, 0 for ascending,
   *                      1 for descending
   */
  private void heapify(
      double[] array, int startIndex, int largestIndex, int sortElemCount,
      int aix) {
    int left = 2 * largestIndex + 1 - startIndex;
    int right = 2 * largestIndex + 2 - startIndex;
    int largest = largestIndex;
    if (left < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = left;
    }
    if (right < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = right;
    }
    if (largest != largestIndex) {
      swap(array, largestIndex, largest);
      heapify(array, startIndex, largest, sortElemCount, aix);
    }

  }

  /**
   * Sorts the given long array using the Heap Sort algorithm.
   *
   * <p>
   * This method sorts the specified range of the array in either ascending or
   * descending order, depending on the axis value provided. It first checks for
   * null or empty arrays, invalid range, and invalid axis values, throwing an
   * IllegalArgumentException if any of these conditions are met. The sorting is
   * performed by building a heap from the array elements and then repeatedly
   * extracting the maximum or minimum element, depending on the order specified.
   *
   * @param array      the long array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range, doesn't include this
   *                   index
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid range, or has an invalid axis value
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
    buildHeap(array, startIndex, sortElementCount, aix);
    for (int i = endIndex - 1; i > startIndex; i--) {
      swap(array, startIndex, i);
      heapify(array, startIndex, startIndex, i - startIndex, aix);
    }
  }

  /**
   * Builds a heap structure in the given array within the specified range and
   * axis.
   *
   * <p>
   * This method builds a heap structure in the given array within the specified
   * range and axis. The heap structure is a complete binary tree, where each
   * parent node is either greater than (in ascending order) or less than (in
   * descending order) its children. The heap structure is used as a step in the
   * Heap Sort algorithm.
   *
   * @param array            the array to build the heap structure
   * @param startIndex       the starting index of the array
   * @param sortElementCount the number of elements to build the heap
   * @param aix              the axis value for sorting order
   */
  private void buildHeap(long[] array, int startIndex, int sortElemCount, int aix) {
    if (sortElemCount <= 1) {
      return;
    }
    int k = startIndex + sortElemCount / 2 - 1;

    do {
      heapify(array, startIndex, k, sortElemCount, aix);
    } while (k-- != startIndex);

  }

  /**
   * Heapifies a subtree rooted at index largestIndex in the given array.
   *
   * <p>
   * This method ensures that the subtree rooted at largestIndex satisfies
   * the heap property. It compares the root with its left and right children
   * and swaps the largest value with the root to maintain the heap structure.
   * This operation is continued recursively for the affected subtree to ensure
   * the entire heap is properly structured.
   *
   * @param array         the array representing the heap
   * @param startIndex    the starting index of the heap
   * @param largestIndex  the index of the root of the subtree to heapify
   * @param sortElemCount the number of elements in the heap
   * @param aix           the axis value for sorting order, 0 for ascending,
   *                      1 for descending
   */
  private void heapify(
      long[] array, int startIndex, int largestIndex, int sortElemCount,
      int aix) {
    int left = 2 * largestIndex + 1 - startIndex;
    int right = 2 * largestIndex + 2 - startIndex;
    int largest = largestIndex;
    if (left < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = left;
    }
    if (right < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = right;
    }
    if (largest != largestIndex) {
      swap(array, largestIndex, largest);
      heapify(array, startIndex, largest, sortElemCount, aix);
    }

  }

  /**
   * Sorts the given array of shorts using the Heap Sort algorithm.
   *
   * <p>
   * This implementation takes an array, a start index, an end index, and an axis
   * value as parameters. It first checks if the array is null, empty, contains
   * invalid range, or invalid axis value. If the array is valid, it builds a
   * heap structure and then repeatedly extracts the largest (in ascending order)
   * or smallest (in descending order) element, and places it at the end of the
   * array. Finally, it heapifies the remaining elements to maintain the heap
   * structure.
   *
   * @param array      the array to be sorted
   * @param startIndex the starting index of the array
   * @param endIndex   the ending index of the array
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
    buildHeap(array, startIndex, sortElementCount, aix);
    for (int i = endIndex - 1; i > startIndex; i--) {
      swap(array, startIndex, i);
      heapify(array, startIndex, startIndex, i - startIndex, aix);
    }
  }

  /**
   * Builds a heap structure in the given array within the specified range and
   * axis.
   *
   * <p>
   * This method builds a heap structure in the given array within the specified
   * range and axis. The heap structure is a complete binary tree, where each
   * parent node is either greater than (in ascending order) or less than (in
   * descending order) its children. The heap structure is used as a step in the
   * Heap Sort algorithm.
   *
   * @param array            the array to build the heap structure
   * @param startIndex       the starting index of the array
   * @param sortElementCount the number of elements to build the heap
   * @param aix              the axis value for sorting order
   */
  private void buildHeap(short[] array, int startIndex, int sortElemCount, int aix) {
    if (sortElemCount <= 1) {
      return;
    }
    int k = startIndex + sortElemCount / 2 - 1;

    do {
      heapify(array, startIndex, k, sortElemCount, aix);
    } while (k-- != startIndex);

  }

  /**
   * Heapifies a subtree rooted at index largestIndex in the given array.
   *
   * <p>
   * This method ensures that the subtree rooted at largestIndex satisfies
   * the heap property. It compares the root with its left and right children
   * and swaps the largest value with the root to maintain the heap structure.
   * This operation is continued recursively for the affected subtree to ensure
   * the entire heap is properly structured.
   *
   * @param array         the array representing the heap
   * @param startIndex    the starting index of the heap
   * @param largestIndex  the index of the root of the subtree to heapify
   * @param sortElemCount the number of elements in the heap
   * @param aix           the axis value for sorting order, 0 for ascending,
   *                      1 for descending
   */
  private void heapify(
      short[] array, int startIndex, int largestIndex, int sortElemCount,
      int aix) {
    int left = 2 * largestIndex + 1 - startIndex;
    int right = 2 * largestIndex + 2 - startIndex;
    int largest = largestIndex;
    if (left < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = left;
    }
    if (right < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = right;
    }
    if (largest != largestIndex) {
      swap(array, largestIndex, largest);
      heapify(array, startIndex, largest, sortElemCount, aix);
    }

  }

  /**
   * Sorts the given byte array using the Heap Sort algorithm.
   *
   * <p>
   * This method sorts the specified range of the array in either ascending or
   * descending order, depending on the axis value provided. It first checks for
   * null or empty arrays, invalid range, and invalid axis values, throwing an
   * IllegalArgumentException if any of these conditions are met. The sorting is
   * performed by building a heap from the array elements and then repeatedly
   * extracting the maximum or minimum element, depending on the order specified.
   *
   * @param array      the byte array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range, doesn't include this
   *                   index
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid range, or has an invalid axis value
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
    buildHeap(array, startIndex, sortElementCount, aix);
    for (int i = endIndex - 1; i > startIndex; i--) {
      swap(array, startIndex, i);
      heapify(array, startIndex, startIndex, i - startIndex, aix);
    }
  }

  /**
   * Builds a heap structure in the given array within the specified range and
   * axis.
   *
   * <p>
   * This method builds a heap structure in the given array within the specified
   * range and axis. The heap structure is a complete binary tree, where each
   * parent node is either greater than (in ascending order) or less than (in
   * descending order) its children. The heap structure is used as a step in the
   * Heap Sort algorithm.
   *
   * @param array            the array to build the heap structure
   * @param startIndex       the starting index of the array
   * @param sortElementCount the number of elements to build the heap
   * @param aix              the axis value for sorting order
   */
  private void buildHeap(byte[] array, int startIndex, int sortElemCount, int aix) {
    if (sortElemCount <= 1) {
      return;
    }
    int k = startIndex + sortElemCount / 2 - 1;

    do {
      heapify(array, startIndex, k, sortElemCount, aix);
    } while (k-- != startIndex);

  }

  /**
   * Heapifies a subtree rooted at index largestIndex in the given array.
   *
   * <p>
   * This method ensures that the subtree rooted at largestIndex satisfies
   * the heap property. It compares the root with its left and right children
   * and swaps the largest value with the root to maintain the heap structure.
   * This operation is continued recursively for the affected subtree to ensure
   * the entire heap is properly structured.
   *
   * @param array         the array representing the heap
   * @param startIndex    the starting index of the heap
   * @param largestIndex  the index of the root of the subtree to heapify
   * @param sortElemCount the number of elements in the heap
   * @param aix           the axis value for sorting order, 0 for ascending,
   *                      1 for descending
   */
  private void heapify(
      byte[] array, int startIndex, int largestIndex, int sortElemCount,
      int aix) {
    int left = 2 * largestIndex + 1 - startIndex;
    int right = 2 * largestIndex + 2 - startIndex;
    int largest = largestIndex;
    if (left < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = left;
    }
    if (right < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = right;
    }
    if (largest != largestIndex) {
      swap(array, largestIndex, largest);
      heapify(array, startIndex, largest, sortElemCount, aix);
    }

  }

  /**
   * Sorts the given char array using the Heap Sort algorithm.
   *
   * <p>
   * This method sorts the specified range of the array in either ascending or
   * descending order, based on the axis value provided. It first checks for
   * null or empty arrays, invalid range, and invalid axis values, throwing an
   * IllegalArgumentException if any of these conditions are met. The sorting
   * process involves building a heap from the array, then repeatedly swapping
   * the root of the heap with the last element, and heapifying the reduced heap
   * until the entire array is sorted.
   *
   * @param array      the char array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid range, or invalid axis value
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
    buildHeap(array, startIndex, sortElementCount, aix);
    for (int i = endIndex - 1; i > startIndex; i--) {
      swap(array, startIndex, i);
      heapify(array, startIndex, startIndex, i - startIndex, aix);
    }
  }

  /**
   * Builds a heap structure in the given array within the specified range and
   * axis.
   *
   * <p>
   * This method builds a heap structure in the given array within the specified
   * range and axis. The heap structure is a complete binary tree, where each
   * parent node is either greater than (in ascending order) or less than (in
   * descending order) its children. The heap structure is used as a step in the
   * Heap Sort algorithm.
   *
   * @param array            the array to build the heap structure
   * @param startIndex       the starting index of the array
   * @param sortElementCount the number of elements to build the heap
   * @param aix              the axis value for sorting order
   */
  private void buildHeap(char[] array, int startIndex, int sortElemCount, int aix) {
    if (sortElemCount <= 1) {
      return;
    }
    int k = startIndex + sortElemCount / 2 - 1;

    do {
      heapify(array, startIndex, k, sortElemCount, aix);
    } while (k-- != startIndex);

  }

  /**
   * Heapifies a subtree rooted at index largestIndex in the given array.
   *
   * <p>
   * This method ensures that the subtree rooted at largestIndex satisfies
   * the heap property. It compares the root with its left and right children
   * and swaps the largest value with the root to maintain the heap structure.
   * This operation is continued recursively for the affected subtree to ensure
   * the entire heap is properly structured.
   *
   * @param array         the array representing the heap
   * @param startIndex    the starting index of the heap
   * @param largestIndex  the index of the root of the subtree to heapify
   * @param sortElemCount the number of elements in the heap
   * @param aix           the axis value for sorting order, 0 for ascending,
   *                      1 for descending
   */
  private void heapify(
      char[] array, int startIndex, int largestIndex, int sortElemCount,
      int aix) {
    int left = 2 * largestIndex + 1 - startIndex;
    int right = 2 * largestIndex + 2 - startIndex;
    int largest = largestIndex;
    if (left < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = left;
    }
    if (right < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = right;
    }
    if (largest != largestIndex) {
      swap(array, largestIndex, largest);
      heapify(array, startIndex, largest, sortElemCount, aix);
    }

  }

  /**
   * Sorts the given int array using the Heap Sort algorithm.
   *
   * <p>
   * This method sorts the specified range of the array in either ascending or
   * descending order, based on the axis value provided. It first checks for
   * null or empty arrays, invalid range, and invalid axis values, throwing an
   * IllegalArgumentException if any of these conditions are met. The sorting
   * process involves building a heap from the array, then repeatedly swapping
   * the root of the heap with the last element, and heapifying the reduced heap
   * until the entire array is sorted.
   *
   * @param array      the int array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid range, or invalid axis value
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
    buildHeap(array, startIndex, sortElementCount, aix);
    for (int i = endIndex - 1; i > startIndex; i--) {
      swap(array, startIndex, i);
      heapify(array, startIndex, startIndex, i - startIndex, aix);
    }
  }

  /**
   * Builds a heap structure in the given array within the specified range and
   * axis.
   *
   * <p>
   * This method builds a heap structure in the given array within the specified
   * range and axis. The heap structure is a complete binary tree, where each
   * parent node is either greater than (in ascending order) or less than (in
   * descending order) its children. The heap structure is used as a step in the
   * Heap Sort algorithm.
   *
   * @param array            the array to build the heap structure
   * @param startIndex       the starting index of the array
   * @param sortElementCount the number of elements to build the heap
   * @param aix              the axis value for sorting order
   */
  private void buildHeap(int[] array, int startIndex, int sortElemCount, int aix) {
    if (sortElemCount <= 1) {
      return;
    }
    int k = startIndex + sortElemCount / 2 - 1;

    do {
      heapify(array, startIndex, k, sortElemCount, aix);
    } while (k-- != startIndex);

  }

  /**
   * Heapifies a subtree rooted at index largestIndex in the given array.
   *
   * <p>
   * This method ensures that the subtree rooted at largestIndex satisfies
   * the heap property. It compares the root with its left and right children
   * and swaps the largest value with the root to maintain the heap structure.
   * This operation is continued recursively for the affected subtree to ensure
   * the entire heap is properly structured.
   *
   * @param array         the array representing the heap
   * @param startIndex    the starting index of the heap
   * @param largestIndex  the index of the root of the subtree to heapify
   * @param sortElemCount the number of elements in the heap
   * @param aix           the axis value for sorting order, 0 for ascending,
   *                      1 for descending
   */
  private void heapify(
      int[] array, int startIndex, int largestIndex, int sortElemCount,
      int aix) {
    int left = 2 * largestIndex + 1 - startIndex;
    int right = 2 * largestIndex + 2 - startIndex;
    int largest = largestIndex;
    if (left < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = left;
    }
    if (right < sortElemCount && (aix == ASCENDING ? array[left] > array[largest]
        : array[left] < array[largest])) {
      largest = right;
    }
    if (largest != largestIndex) {
      swap(array, largestIndex, largest);
      heapify(array, startIndex, largest, sortElemCount, aix);
    }

  }

  /**
   * Sorts the given array using the Heap Sort algorithm.
   *
   * <p>
   * This method sorts the specified range of the array in either ascending or
   * descending order, based on the axis value provided. It first checks for
   * null or empty arrays, invalid range, and invalid axis values, throwing an
   * IllegalArgumentException if any of these conditions are met. The sorting
   * process involves building a heap from the array, then repeatedly swapping
   * the root of the heap with the last element, and heapifying the reduced heap
   * until the entire array is sorted.
   *
   * @param array      the array to be sorted
   * @param startIndex the starting index of the sort range
   * @param endIndex   the ending index of the sort range
   * @param aix        the axis value for sorting order, 0 for ascending, 1 for
   *                   descending
   * @throws IllegalArgumentException if the array is null, empty, contains
   *                                  invalid range, or invalid axis value
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
    int sortElementCount = endIndex - startIndex;
    buildHeap(array, startIndex, sortElementCount, aix);
    for (int i = endIndex - 1; i > startIndex; i--) {
      swap(array, startIndex, i);
      heapify(array, startIndex, startIndex, i - startIndex, aix);
    }
  }

  /**
   * Builds a heap structure in the given array within the specified range and
   * axis.
   *
   * <p>
   * This method builds a heap structure in the given array within the specified
   * range and axis. The heap structure is a complete binary tree, where each
   * parent node is either greater than (in ascending order) or less than (in
   * descending order) its children. The heap structure is used as a step in the
   * Heap Sort algorithm.
   *
   * @param array            the array to build the heap structure
   * @param startIndex       the starting index of the array
   * @param sortElementCount the number of elements to build the heap
   * @param aix              the axis value for sorting order
   */
  private <T extends Comparable<T>> void buildHeap(T[] array, int startIndex, int sortElemCount, int aix) {
    if (sortElemCount <= 1) {
      return;
    }
    int k = startIndex + sortElemCount / 2 - 1;

    do {
      heapify(array, startIndex, k, sortElemCount, aix);
    } while (k-- != startIndex);

  }

  /**
   * Heapifies a subtree rooted at index largestIndex in the given array.
   *
   * <p>
   * This method ensures that the subtree rooted at largestIndex satisfies
   * the heap property. It compares the root with its left and right children
   * and swaps the largest value with the root to maintain the heap structure.
   * This operation is continued recursively for the affected subtree to ensure
   * the entire heap is properly structured.
   *
   * @param array         the array representing the heap
   * @param startIndex    the starting index of the heap
   * @param largestIndex  the index of the root of the subtree to heapify
   * @param sortElemCount the number of elements in the heap
   * @param aix           the axis value for sorting order, 0 for ascending,
   *                      1 for descending
   */
  private <T extends Comparable<T>> void heapify(T[] array, int startIndex, int largestIndex, int sortElemCount,
      int aix) {
    int left = 2 * largestIndex + 1 - startIndex;
    int right = 2 * largestIndex + 2 - startIndex;
    int largest = largestIndex;
    if (left < sortElemCount && (aix == ASCENDING ? array[left].compareTo(array[largest]) > 0
        : array[left].compareTo(array[largest]) < 0)) {
      largest = left;
    }
    if (right < sortElemCount && (aix == ASCENDING ? array[right].compareTo(array[largest]) > 0
        : array[right].compareTo(array[largest]) < 0)) {
      largest = right;
    }
    if (largest != largestIndex) {
      swap(array, largestIndex, largest);
      heapify(array, startIndex, largest, sortElemCount, aix);
    }

  }
}
