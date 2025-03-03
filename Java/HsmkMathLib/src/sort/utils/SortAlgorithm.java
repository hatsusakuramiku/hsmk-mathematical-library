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

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * This interface provides a common API for sorting algorithms to sort the input
 * array. The
 * implementation should provide a concrete implementation of the sort method
 * that takes in the
 * input array, the starting index, the ending index, and the axis of the array
 * to sort. The
 * axis value is used to control the sorting order, and 0 represents ascending
 * order and 1
 * represents descending order.
 * <p>
 * The sort method should sort the given array in the given range, using the
 * given axis value.
 */
public interface SortAlgorithm {
    /**
     * The axis value to represent ascending order.
     */
    static final int ASCENDING = 0;

    /**
     * The axis value to represent descending order.
     */
    static final int DESCENDING = 1;

    /**
     * This method checks if the given range is valid.
     *
     * @param arrayLength the length of the array
     * @param startIndex  the starting index of the array
     * @param endIndex    the ending index of the array, doesn't include
     * @return true if the given range is valid, false otherwise
     */
    default boolean checkRange(int arrayLength, int startIndex, int endIndex) {
        return startIndex >= 0 && endIndex >= startIndex && endIndex <= arrayLength;
    }

    // /**
    // * This method checks if the given range is valid.
    // *
    // * @param array the input array
    // * @param startIndex the starting index of the array
    // * @param endIndex the ending index of the array, doesn't include
    // * @return true if the given range is valid, false otherwise
    // */
    // default boolean checkRange(int[] array, int startIndex, int endIndex) {
    // return startIndex >= 0 && endIndex >= startIndex && endIndex <= array.length;
    // }

    // /**
    // * This method checks if the given range is valid.
    // *
    // * @param array the input array
    // * @param startIndex the starting index of the array
    // * @param endIndex the ending index of the array, doesn't include
    // * @return true if the given range is valid, false otherwise
    // */
    // default boolean checkRange(double[] array, int startIndex, int endIndex) {
    // return startIndex >= 0 && endIndex >= startIndex && endIndex <= array.length;
    // }

    // /**
    // * This method checks if the given range is valid.
    // *
    // * @param array the input array
    // * @param startIndex the starting index of the array
    // * @param endIndex the ending index of the array, doesn't include
    // * @return true if the given range is valid, false otherwise
    // */
    // default boolean checkRange(float[] array, int startIndex, int endIndex) {
    // return startIndex >= 0 && endIndex >= startIndex && endIndex <= array.length;
    // }

    // /**
    // * This method checks if the given range is valid.
    // *
    // * @param array the input array
    // * @param startIndex the starting index of the array
    // * @param endIndex the ending index of the array, doesn't include
    // * @return true if the given range is valid, false otherwise
    // */
    // default boolean checkRange(long[] array, int startIndex, int endIndex) {
    // return startIndex >= 0 && endIndex >= startIndex && endIndex <= array.length;
    // }

    // /**
    // * This method checks if the given range is valid.
    // *
    // * @param array the input array
    // * @param startIndex the starting index of the array
    // * @param endIndex the ending index of the array, doesn't include
    // * @return true if the given range is valid, false otherwise
    // */
    // default boolean checkRange(short[] array, int startIndex, int endIndex) {
    // return startIndex >= 0 && endIndex >= startIndex && endIndex <= array.length;
    // }

    // /**
    // * This method checks if the given range is valid.
    // *
    // * @param array the input array
    // * @param startIndex the starting index of the array
    // * @param endIndex the ending index of the array, doesn't include
    // * @return true if the given range is valid, false otherwise
    // */
    // default boolean checkRange(byte[] array, int startIndex, int endIndex) {
    // return startIndex >= 0 && endIndex >= startIndex && endIndex <= array.length;
    // }

    // /**
    // * This method checks if the given range is valid.
    // *
    // * @param array the input array
    // * @param startIndex the starting index of the array
    // * @param endIndex the ending index of the array, doesn't include
    // * @return true if the given range is valid, false otherwise
    // */
    // default boolean checkRange(char[] array, int startIndex, int endIndex) {
    // return startIndex >= 0 && endIndex >= startIndex && endIndex <= array.length;
    // }

    // /**
    // * This method checks if the given range is valid.
    // *
    // * @param array the input array
    // * @param startIndex the starting index of the array
    // * @param endIndex the ending index of the array, doesn't include
    // * @return true if the given range is valid, false otherwise
    // */
    // default boolean checkRange(Object[] array, int startIndex, int endIndex) {
    // return startIndex >= 0 && endIndex >= startIndex && endIndex <= array.length;
    // }

    /**
     * This method checks if the given axis value is valid.
     *
     * @param aix the axis value
     * @return true if the axis value is valid, false otherwise
     */
    default boolean checkAix(int aix) {
        return aix == 0 || aix == 1;
    }

    /**
     * This method sorts the given array in the given range and axis.
     *
     * @param array      the input array
     * @param startIndex the starting index of the array
     * @param endIndex   the ending index of the array, doesn't include
     * @param aix        the axis value
     */
    void sort(Object[] array, int startIndex, int endIndex, int aix);

    /**
     * Sorts a float array within the specified range and axis.
     *
     * @param array      the float array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex   the ending index of the sort range
     * @param aix        the axis value for sorting order
     */
    void sort(float[] array, int startIndex, int endIndex, int aix);

    /**
     * Sorts a double array within the specified range and axis.
     *
     * @param array      the double array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex   the ending index of the sort range
     * @param aix        the axis value for sorting order
     */
    void sort(double[] array, int startIndex, int endIndex, int aix);

    /**
     * Sorts a long array within the specified range and axis.
     *
     * @param array      the long array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex   the ending index of the sort range
     * @param aix        the axis value for sorting order
     */
    void sort(long[] array, int startIndex, int endIndex, int aix);

    /**
     * Sorts a short array within the specified range and axis.
     *
     * @param array      the short array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex   the ending index of the sort range
     * @param aix        the axis value for sorting order
     */
    void sort(short[] array, int startIndex, int endIndex, int aix);

    /**
     * Sorts a byte array within the specified range and axis.
     *
     * @param array      the byte array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex   the ending index of the sort range
     * @param aix        the axis value for sorting order
     */
    void sort(byte[] array, int startIndex, int endIndex, int aix);

    /**
     * Sorts a char array within the specified range and axis.
     *
     * @param array      the char array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex   the ending index of the sort range
     * @param aix        the axis value for sorting order
     */
    void sort(char[] array, int startIndex, int endIndex, int aix);

    /**
     * Sorts an int array within the specified range and axis.
     *
     * @param array      the int array to be sorted
     * @param startIndex the starting index of the sort range
     * @param endIndex   the ending index of the sort range
     * @param aix        the axis value for sorting order
     */
    void sort(int[] array, int startIndex, int endIndex, int aix);

    /**
     * Sorts an object array using the specified axis value.
     *
     * @param array the object array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(Object[] array, int aix) throws IllegalArgumentException, NullPointerException {
        sort(array, 0, array.length, aix);
    }

    /**
     * Sorts an object array using the specified axis value.
     *
     * @param array the object array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(Object[] array, int startIndex, int aix) throws IllegalArgumentException, NullPointerException {
        sort(array, startIndex, array.length, aix);
    }

    /**
     * Sorts an object array in ascending order.
     *
     * @param array the object array to be sorted
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(Object[] array) throws IllegalArgumentException, NullPointerException {
        sort(array, 0, array.length, ASCENDING);
    }

    /**
     * Sorts an int array using the specified axis value.
     *
     * @param array the int array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(int[] array, int aix) throws IllegalArgumentException {
        sort(array, 0, array.length, aix);
    }

    /**
     * Sorts an int array using the specified axis value.
     *
     * @param array the int array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(int[] array, int startIndex, int aix) throws IllegalArgumentException, NullPointerException {
        sort(array, startIndex, array.length, aix);
    }

    /**
     * Sorts an int array in ascending order.
     *
     * @param array the int array to be sorted
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(int[] array) throws IllegalArgumentException {
        sort(array, 0, array.length, ASCENDING);
    }

    /**
     * Sorts a double array using the specified axis value.
     *
     * @param array the double array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(double[] array, int aix) throws IllegalArgumentException {
        sort(array, 0, array.length, aix);
    }

    /**
     * Sorts a double array using the specified axis value.
     *
     * @param array the double array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(double[] array, int startIndex, int aix) throws IllegalArgumentException, NullPointerException {
        sort(array, startIndex, array.length, aix);
    }

    /**
     * Sorts a double array in ascending order.
     *
     * @param array the double array to be sorted
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(double[] array) throws IllegalArgumentException {
        sort(array, 0, array.length, ASCENDING);
    }

    /**
     * Sorts a float array using the specified axis value.
     *
     * @param array the float array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(float[] array, int aix) throws IllegalArgumentException {
        sort(array, 0, array.length, aix);
    }

    /**
     * Sorts a float array using the specified axis value.
     *
     * @param array the float array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(float[] array, int startIndex, int aix) throws IllegalArgumentException, NullPointerException {
        sort(array, startIndex, array.length, aix);
    }

    /**
     * Sorts a float array in ascending order.
     *
     * @param array the float array to be sorted
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(float[] array) throws IllegalArgumentException {
        sort(array, 0, array.length, ASCENDING);
    }

    /**
     * Sorts a long array using the specified axis value.
     *
     * @param array the long array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(long[] array, int aix) throws IllegalArgumentException {
        sort(array, 0, array.length, aix);
    }

    /**
     * Sorts a long array using the specified axis value.
     *
     * @param array the long array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(long[] array, int startIndex, int aix) throws IllegalArgumentException, NullPointerException {
        sort(array, startIndex, array.length, aix);
    }

    /**
     * Sorts a long array in ascending order.
     *
     * @param array the long array to be sorted
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(long[] array) throws IllegalArgumentException {
        sort(array, 0, array.length, ASCENDING);
    }

    /**
     * Sorts a short array using the specified axis value.
     *
     * @param array the short array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(short[] array, int aix) throws IllegalArgumentException {
        sort(array, 0, array.length, aix);
    }

    /**
     * Sorts a short array using the specified axis value.
     *
     * @param array the short array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(short[] array, int startIndex, int aix) throws IllegalArgumentException, NullPointerException {
        sort(array, startIndex, array.length, aix);
    }

    /**
     * Sorts a short array in ascending order.
     *
     * @param array the short array to be sorted
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(short[] array) throws IllegalArgumentException {
        sort(array, 0, array.length, ASCENDING);
    }

    /**
     * Sorts a byte array using the specified axis value.
     *
     * @param array the byte array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(byte[] array, int aix) throws IllegalArgumentException {
        sort(array, 0, array.length, aix);
    }

    /**
     * Sorts a byte array using the specified axis value.
     *
     * @param array the byte array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(byte[] array, int startIndex, int aix) throws IllegalArgumentException, NullPointerException {
        sort(array, startIndex, array.length, aix);
    }

    /**
     * Sorts a byte array in ascending order.
     *
     * @param array the byte array to be sorted
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(byte[] array) throws IllegalArgumentException {
        sort(array, 0, array.length, ASCENDING);
    }

    /**
     * Sorts a char array using the specified axis value.
     *
     * @param array the char array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(char[] array, int aix) throws IllegalArgumentException {
        sort(array, 0, array.length, aix);
    }

    /**
     * Sorts a char array using the specified axis value.
     *
     * @param array the char array to be sorted
     * @param aix   the axis value for sorting order
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(char[] array, int startIndex, int aix) throws IllegalArgumentException, NullPointerException {
        sort(array, startIndex, array.length, aix);
    }

    /**
     * Sorts a char array in ascending order.
     *
     * @param array the char array to be sorted
     * @throws IllegalArgumentException if the axis value is invalid
     */
    default void sort(char[] array) throws IllegalArgumentException {
        sort(array, 0, array.length, ASCENDING);
    }

    /**
     * Checks if the given object's class has a valid compareTo function.
     *
     * @param obj the object to check
     * @return true if the object's class has a valid compareTo function, false
     * otherwise
     */
    default boolean hasCompareToFunction(Object obj) {
        Class<?> clazz = obj.getClass();
        try {
            // Check if the class has a method with the name "compareTo" and one parameter
            // of type Object
            clazz.getMethod("compareTo", Object.class);
            return true;
        } catch (NoSuchMethodException e) {
            // If the class does not have a "compareTo" method, return false
            return false;
        }
    }

    /**
     * Checks if the given array has a valid compareTo function.
     *
     * @param array the array to check
     * @return true if any of the elements in the array have a valid compareTo
     * function, false otherwise
     */
    default boolean hasCompareToFunction(Object[] array) {
        // If the array is empty, null, or any of its elements are null, return false
        return array.length != 0 && array[0] != null && hasCompareToFunction(array[0]);
    }

    /**
     * Checks if the given array has any null elements.
     *
     * @param array the array to check
     * @return true if any of the elements in the array are null, false otherwise
     */
    default boolean checkArrayHasNull(Object[] array) {
        for (Object obj : array) {
            if (obj == null) {
                // If any element is null, return true
                return true;
            }
        }
        // If no elements are null, return false
        return false;
    }

    /**
     * Checks if the given array has any null elements.
     *
     * @param array the array to check
     * @return true if any of the elements in the array are null, false otherwise
     */
    default <T extends Comparable<T>> boolean checkArrayHasNull(T[] array) {
        for (T obj : array) {
            if (obj == null) {
                // If any element is null, return true
                return true;
            }
        }
        // If no elements are null, return false
        return false;
    }

    /**
     * Compares two objects using their compareTo method.
     *
     * <p>
     * This method retrieves the compareTo method from the first object's class and
     * invokes it with the second object as an argument. The result of the
     * comparison is returned as an integer.Typically, it is less efficient than
     * {@code #getCompareToMethod(Object)}.
     *
     * @param o1 the first object to compare
     * @param o2 the second object to compare
     * @return a negative integer, zero, or a positive integer if the first object
     * is less than,
     * equal to, or greater than the second object, respectively
     * @throws IllegalAccessException    if the compareTo method is inaccessible
     * @throws InvocationTargetException if the compareTo method throws an exception
     * @throws NoSuchMethodException     if the compareTo method is not found
     * @throws SecurityException         if access to the compareTo method is denied
     */
    default int compare(Object o1, Object o2)
            throws IllegalAccessException, InvocationTargetException, NoSuchMethodException, SecurityException {
        // Retrieve the compareTo method from the first object's class
        Method compareMethod = o1.getClass().getMethod("compareTo", Object.class);

        // Invoke the compareTo method on the first object with the second object as an
        // argument
        return (int) compareMethod.invoke(o1, o2);
    }

    /**
     * Retrieves the compareTo method from the class of the given object.
     *
     * @param o1 the object whose compareTo method is to be retrieved
     * @return the compareTo method of the object's class
     * @throws NoSuchMethodException if the compareTo method is not found
     * @throws SecurityException     if access to the compareTo method is denied
     */
    default Method getCompareToMethod(Object o1) throws NoSuchMethodException, SecurityException {
        // Get the compareTo method from the class of the provided object
        return o1.getClass().getMethod("compareTo", Object.class);
    }

    /**
     * Swaps two elements in an array of objects.
     *
     * @param array the array of objects
     * @param i     the index of the first element to swap
     * @param j     the index of the second element to swap
     */
    default void swap(Object[] array, int i, int j) {
        Object temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    /**
     * Swaps two elements in an array of comparable objects.
     *
     * @param <T>   the type of the array elements which must implement Comparable
     * @param array the array of comparable objects
     * @param i     the index of the first element to swap
     * @param j     the index of the second element to swap
     */
    default <T extends Comparable<T>> void swap(T[] array, int i, int j) {
        T temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    /**
     * Swaps two elements in an array of characters.
     *
     * @param array the array of characters
     * @param i     the index of the first element to swap
     * @param j     the index of the second element to swap
     */
    default void swap(char[] array, int i, int j) {
        char temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    /**
     * Swaps two elements in an array of integers.
     *
     * @param array the array of integers
     * @param i     the index of the first element to swap
     * @param j     the index of the second element to swap
     */
    default void swap(int[] array, int i, int j) {
        int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    /**
     * Swaps two elements in an array of doubles.
     *
     * @param array the array of doubles
     * @param i     the index of the first element to swap
     * @param j     the index of the second element to swap
     */
    default void swap(double[] array, int i, int j) {
        double temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    /**
     * Swaps two elements in an array of longs.
     *
     * @param array the array of longs
     * @param i     the index of the first element to swap
     * @param j     the index of the second element to swap
     */
    default void swap(long[] array, int i, int j) {
        long temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    /**
     * Swaps two elements in an array of floats.
     *
     * @param array the array of floats
     * @param i     the index of the first element to swap
     * @param j     the index of the second element to swap
     */
    default void swap(float[] array, int i, int j) {
        float temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    /**
     * Swaps two elements in an array of bytes.
     *
     * @param array the array of bytes
     * @param i     the index of the first element to swap
     * @param j     the index of the second element to swap
     */
    default void swap(byte[] array, int i, int j) {
        byte temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    /**
     * Swaps two elements in an array of shorts.
     *
     * @param array the array of shorts
     * @param i     the index of the first element to swap
     * @param j     the index of the second element to swap
     */
    default void swap(short[] array, int i, int j) {
        short temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    /**
     * Sorts the given array of objects from the start index to the end index.
     *
     * @param array      the array of objects to sort
     * @param startIndex the starting index of the array
     * @param endIndex   the ending index of the array
     * @param aix        the axis of the array, ASCENDING for ascending order and
     *                   DESCENDING for descending order
     */
    <T extends Comparable<T>> void sort(T[] array, int startIndex, int endIndex, int aix);

    /**
     * Sorts the given array of objects.
     *
     * @param array the array of objects to sort
     * @param aix   the axis of the array, ASCENDING for ascending order and
     *              DESCENDING for descending order
     */
    default <T extends Comparable<T>> void sort(T[] array, int aix) {
        sort(array, 0, array.length, aix);
    }

    /**
     * Sorts the given array of objects from the given start index.
     *
     * @param array      the array of objects to sort
     * @param startIndex the starting index of the array
     * @param aix        the axis of the array, ASCENDING for ascending order and
     *                   DESCENDING for descending order
     */
    default <T extends Comparable<T>> void sort(T[] array, int startIndex, int aix) {
        sort(array, startIndex, array.length, aix);
    }

    /**
     * Sorts the given array of objects in ascending order.
     *
     * @param array the array of objects to sort
     */
    default <T extends Comparable<T>> void sort(T[] array) {
        sort(array, 0, array.length, ASCENDING);
    }

}