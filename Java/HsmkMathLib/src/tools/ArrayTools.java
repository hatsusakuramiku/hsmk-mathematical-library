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
package tools;

import java.util.StringJoiner;

/**
 * A utility class that provides static methods for working with arrays.
 * <p>
 * 
 * Such as
 * <p>
 * - Convert an array to a string
 * <p>
 * - Check if an array is sorted
 * <p>
 * - Reverse an array
 * <p>
 * - Converts an array of base types to an array of its wrapping classes
 * <p>
 * - Converts an array of wrapping classes to an array of its base types
 * <p>
 *
 */
final public class ArrayTools {

    private ArrayTools() {

    }

    /// Convert an array to a string
    /**
     * Converts an array of objects into a string with specified delimiter, prefix,
     * and suffix.
     *
     * @param array     the array of objects to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @param prefix    the sequence of characters to be added at the beginning of
     *                  the resulting string
     * @param suffix    the sequence of characters to be added at the end of the
     *                  resulting string
     * @return a string representation of the array with elements separated by the
     *         specified delimiter
     *         and enclosed in the specified prefix and suffix, or null if the array
     *         is null
     */

    public static String arrayToString(Object[] array, CharSequence delimiter, CharSequence prefix,
            CharSequence suffix) {
        if (array == null) {
            return null;
        }
        StringJoiner sj = new StringJoiner(delimiter, prefix, suffix);
        for (Object i : array) {
            sj.add(i.toString());
        }
        return sj.toString();
    }

    /**
     * Converts an array of objects into a string with the elements separated by
     * commas, enclosed
     * in square brackets. calls
     * {@link #arrayToString(Object[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array the array of objects to be converted into a string
     * @return a string representation of the array with elements separated by
     *         commas(`,`) and enclosed(`[` and `]`)
     *         in square brackets, or null if the array is null
     */
    public static String arrayToString(Object[] array) {
        return arrayToString(array, ", ", "[", "]");
    }

    /**
     * Converts an array of objects into a string with the elements separated by the
     * specified delimiter,
     * enclosed in square brackets. calls
     * {@link #arrayToString(Object[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array     the array of objects to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @return a string representation of the array with elements separated by the
     *         specified delimiter
     *         and enclosed(`[` and `]`), or null if the array is null
     */
    public static String arrayToString(Object[] array, CharSequence delimiter) {
        return arrayToString(array, delimiter, "[", "]");
    }

    /**
     * Converts an array of int into a string with the elements separated by the
     * specified delimiter, enclosed in the specified prefix and suffix.
     *
     * @param array     the array of int to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @param prefix    the sequence of characters to be added at the beginning of
     *                  the resulting string
     * @param suffix    the sequence of characters to be added at the end of the
     *                  resulting string
     * @return a string representation of the array with elements separated by the
     *         specified delimiter
     *         and enclosed in the specified prefix and suffix, or null if the array
     *         is null
     */
    public static String arrayToString(int[] array, CharSequence delimiter, CharSequence prefix,
            CharSequence suffix) {
        if (array == null) {
            return null;
        }
        StringJoiner sj = new StringJoiner(delimiter, prefix, suffix);
        for (Object i : array) {
            sj.add(i.toString());
        }
        return sj.toString();
    }

    /**
     * Converts an array of int into a string with the elements separated by commas,
     * enclosed in square brackets. calls
     * {@link #arrayToString(int[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array the array of int to be converted into a string
     * @return a string representation of the array with elements separated by
     *         commas
     *         and enclosed in square brackets, or null if the array is null
     */
    public static String arrayToString(int[] array) {
        return arrayToString(array, ", ", "[", "]");
    }

    /**
     * Converts an array of int into a string with the elements separated by the
     * specified delimiter, enclosed in square brackets. calls
     * {@link #arrayToString(int[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array     the array of int to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @return a string representation of the array with elements separated by the
     *         specified delimiter
     *         and enclosed in square brackets, or null if the array is null
     */
    public static String arrayToString(int[] array, CharSequence delimiter) {
        return arrayToString(array, delimiter, "[", "]");
    }

    /**
     * Converts an array of long into a string with the elements separated by the
     * specified delimiter, enclosed in the specified prefix and suffix.
     *
     * @param array     the array of long to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @param prefix    the sequence of characters to be added at the beginning of
     *                  the resulting string
     * @param suffix    the sequence of characters to be added at the end of the
     *                  resulting string
     * @return a string representation of the array with elements separated by the
     *         specified delimiter
     *         and enclosed in the specified prefix and suffix, or null if the array
     *         is null
     */
    public static String arrayToString(long[] array, CharSequence delimiter, CharSequence prefix,
            CharSequence suffix) {
        if (array == null) {
            return null;
        }
        StringJoiner sj = new StringJoiner(delimiter, prefix, suffix);
        for (Object i : array) {
            sj.add(i.toString());
        }
        return sj.toString();
    }

    /**
     * Converts an array of long into a string with the elements separated by
     * commas,
     * enclosed in square brackets. calls
     * {@link #arrayToString(long[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array the array of long to be converted into a string
     * @return a string representation of the array with elements separated by
     *         commas
     *         and enclosed in square brackets, or null if the array is null
     */
    public static String arrayToString(long[] array) {
        return arrayToString(array, ", ", "[", "]");
    }

    /**
     * Converts an array of long into a string with the elements separated by the
     * specified delimiter, enclosed in square brackets. calls
     * {@link #arrayToString(long[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array     the array of long to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @return a string representation of the array with elements separated by the
     *         specified delimiter
     *         and enclosed in square brackets, or null if the array is null
     */
    public static String arrayToString(long[] array, CharSequence delimiter) {
        return arrayToString(array, delimiter, "[", "]");
    }

    /**
     * Converts an array of double into a string with the elements separated by the
     * specified delimiter, enclosed in the specified prefix and suffix. If the
     * array
     * is null, returns null.
     *
     * @param array     the array of double to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @param prefix    the prefix to be added to the start of the string
     * @param suffix    the suffix to be added to the end of the string
     * @return a string representation of the array with elements separated by the
     *         specified delimiter, enclosed in the specified prefix and suffix, or
     *         null if the array is null
     */
    public static String arrayToString(double[] array, CharSequence delimiter, CharSequence prefix,
            CharSequence suffix) {
        if (array == null) {
            return null;
        }
        StringJoiner sj = new StringJoiner(delimiter, prefix, suffix);
        for (Object i : array) {
            sj.add(i.toString());
        }
        return sj.toString();
    }

    /**
     * Converts an array of double into a string with the elements separated by
     * commas,
     * enclosed in square brackets. calls
     * {@link #arrayToString(double[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array the array of double to be converted into a string
     * @return a string representation of the array with elements separated by
     *         commas
     *         and enclosed in square brackets, or null if the array is null
     */
    public static String arrayToString(double[] array) {
        return arrayToString(array, ", ", "[", "]");
    }

    /**
     * Converts an array of double into a string with the elements separated by the
     * specified delimiter, enclosed in square brackets. calls
     * {@link #arrayToString(double[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array     the array of double to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @return a string representation of the array with elements separated by the
     *         specified delimiter
     *         and enclosed in square brackets, or null if the array is null
     */
    public static String arrayToString(double[] array, CharSequence delimiter) {
        return arrayToString(array, delimiter, "[", "]");
    }

    /**
     * Converts an array of char into a string with the elements separated by the
     * specified delimiter, enclosed in the specified prefix and suffix. If the
     * array
     * is null, returns null.
     *
     * @param array     the array of char to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @param prefix    the prefix to be added to the start of the string
     * @param suffix    the suffix to be added to the end of the string
     * @return a string representation of the array with elements separated by the
     *         specified delimiter, enclosed in the specified prefix and suffix, or
     *         null if the array is null
     */
    public static String arrayToString(char[] array, CharSequence delimiter, CharSequence prefix,
            CharSequence suffix) {
        if (array == null) {
            return null;
        }
        StringJoiner sj = new StringJoiner(delimiter, prefix, suffix);
        for (Object i : array) {
            sj.add(i.toString());
        }
        return sj.toString();
    }

    /**
     * Converts an array of char into a string with the elements separated by
     * commas,
     * enclosed in square brackets. calls
     * {@link #arrayToString(char[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array the array of char to be converted into a string
     * @return a string representation of the array with elements separated by
     *         commas
     *         and enclosed in square brackets, or null if the array is null
     */
    public static String arrayToString(char[] array) {
        return arrayToString(array, ", ", "[", "]");
    }

    /**
     * Converts an array of char into a string with the elements separated by the
     * specified delimiter, enclosed in square brackets. calls
     * {@link #arrayToString(char[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array     the array of char to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @return a string representation of the array with elements separated by the
     *         specified delimiter, enclosed in square brackets, or null if the
     *         array is
     *         null
     */
    public static String arrayToString(char[] array, CharSequence delimiter) {
        return arrayToString(array, delimiter, "[", "]");
    }

    /**
     * Converts an array of float into a string with the elements separated by the
     * specified delimiter, enclosed in the specified prefix and suffix.
     *
     * @param array     the array of float to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @param prefix    the sequence of characters to be added at the beginning of
     *                  the resulting string
     * @param suffix    the sequence of characters to be added at the end of the
     *                  resulting string
     * @return a string representation of the array with elements separated by the
     *         specified delimiter and enclosed in the specified prefix and suffix,
     *         or null if the array is null
     */

    public static String arrayToString(float[] array, CharSequence delimiter, CharSequence prefix,
            CharSequence suffix) {
        if (array == null) {
            return null;
        }
        StringJoiner sj = new StringJoiner(delimiter, prefix, suffix);
        for (Object i : array) {
            sj.add(i.toString());
        }
        return sj.toString();
    }

    /**
     * Converts an array of float into a string with the elements separated by
     * ", ", enclosed in square brackets.
     *
     * @param array the array of float to be converted into a string
     * @return a string representation of the array with elements separated by ", "
     *         and enclosed in square brackets, or null if the array is null
     */

    public static String arrayToString(float[] array) {
        return arrayToString(array, ", ", "[", "]");
    }

    /**
     * Converts an array of float into a string with the elements separated by the
     * specified delimiter, enclosed in square brackets.
     *
     * @param array     the array of float to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @return a string representation of the array with elements separated by the
     *         specified delimiter and enclosed in square brackets, or null if the
     *         array is null
     */

    public static String arrayToString(float[] array, CharSequence delimiter) {
        return arrayToString(array, delimiter, "[", "]");
    }

    /**
     * Converts an array of byte into a string with the elements separated by the
     * specified delimiter, enclosed in the specified prefix and suffix.
     *
     * @param array     the array of byte to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @param prefix    the sequence of characters to be added at the beginning of
     *                  the resulting string
     * @param suffix    the sequence of characters to be added at the end of the
     *                  resulting string
     * @return a string representation of the array with elements separated by the
     *         specified delimiter and enclosed in the specified prefix and suffix,
     *         or null if the array is null
     */
    public static String arrayToString(byte[] array, CharSequence delimiter, CharSequence prefix,
            CharSequence suffix) {
        if (array == null) {
            return null;
        }
        StringJoiner sj = new StringJoiner(delimiter, prefix, suffix);
        for (Object i : array) {
            sj.add(i.toString());
        }
        return sj.toString();
    }

    /**
     * Converts an array of byte into a string with the elements separated by
     * commas,
     * enclosed in square brackets. calls
     * {@link #arrayToString(byte[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array the array of byte to be converted into a string
     * @return a string representation of the array with elements separated by
     *         commas
     *         and enclosed in square brackets, or null if the array is null
     */
    public static String arrayToString(byte[] array) {
        return arrayToString(array, ", ", "[", "]");
    }

    /**
     * Converts an array of byte into a string with the elements separated by the
     * specified delimiter, enclosed in square brackets.
     *
     * @param array     the array of byte to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @return a string representation of the array with elements separated by the
     *         specified delimiter and enclosed in square brackets, or null if the
     *         array is null
     */
    public static String arrayToString(byte[] array, CharSequence delimiter) {
        return arrayToString(array, delimiter, "[", "]");
    }

    /**
     * Converts an array of short into a string with the elements separated by the
     * specified delimiter, enclosed in the specified prefix and suffix.
     *
     * @param array     the array of short to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @param prefix    the sequence of characters to be added at the beginning of
     *                  the resulting string
     * @param suffix    the sequence of characters to be added at the end of the
     *                  resulting string
     * @return a string representation of the array with elements separated by the
     *         specified delimiter and enclosed in the specified prefix and suffix,
     *         or null if the array is null
     */

    public static String arrayToString(short[] array, CharSequence delimiter, CharSequence prefix,
            CharSequence suffix) {
        if (array == null) {
            return null;
        }
        StringJoiner sj = new StringJoiner(delimiter, prefix, suffix);
        for (Object i : array) {
            sj.add(i.toString());
        }
        return sj.toString();
    }

    /**
     * Converts an array of short into a string with the elements separated by
     * commas,
     * enclosed in square brackets. calls
     * {@link #arrayToString(short[], CharSequence, CharSequence, CharSequence)}
     *
     * @param array the array of short to be converted into a string
     * @return a string representation of the array with elements separated by
     *         commas
     *         and enclosed in square brackets, or null if the array is null
     */
    public static String arrayToString(short[] array) {
        return arrayToString(array, ", ", "[", "]");
    }

    /**
     * Converts an array of short into a string with the elements separated by the
     * specified delimiter, enclosed in square brackets.
     *
     * @param array     the array of short to be converted into a string
     * @param delimiter the sequence of characters to separate each element
     * @return a string representation of the array with elements separated by the
     *         specified delimiter and enclosed in square brackets, or null if the
     *         array is null
     */

    public static String arrayToString(short[] array, CharSequence delimiter) {
        return arrayToString(array, delimiter, "[", "]");
    }

    /// Check the array is sorted or not

    /**
     * Constant representing ascending order.
     */
    public static final int ASCENDING = 0;

    /**
     * Constant representing descending order.
     */
    public static final int DESCENDING = 1;

    /**
     * Checks if the given array is sorted within the specified range and
     * axis.
     *
     * <p>
     * This method verifies whether the elements in the specified range of the array
     * are sorted in either ascending or descending order, based on the axis value.
     * It throws an IllegalArgumentException if the array is null, if the start or
     * end indices are invalid, or if the axis value is neither ASCENDING nor
     * DESCENDING.
     *
     * @param array the array to be checked
     * @param start the starting index of the check range
     * @param end   the ending index of the check range
     * @param aix   the axis value for the sorting order, either ASCENDING or
     *              DESCENDING
     * @return true if the array is sorted within the specified range and axis,
     *         false otherwise
     * @throws IllegalArgumentException if the array is null, the start or end index
     *                                  is invalid,
     *                                  or the axis value is invalid
     */
    public static <T extends Comparable<T>> boolean isSorted(T[] array, int start, int end, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (start < 0 || end > array.length || start > end) {
            throw new IllegalArgumentException("Invalid start or end index");
        }
        if (aix != ASCENDING && aix != DESCENDING) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (end - start < 2) {
            return true;
        }
        if (aix == ASCENDING) {
            for (int i = start; i < end - 1; i++) {
                if (array[i].compareTo(array[i + 1]) > 0) {
                    return false;
                }
            }
        } else {
            for (int i = start; i < end - 1; i++) {
                if (array[i].compareTo(array[i + 1]) < 0) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Checks if the given array is sorted in ascending order.
     *
     * <p>
     * This method verifies whether the elements in the array are sorted in
     * ascending order. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the array to be checked
     * @return true if the array is sorted in ascending order, false otherwise
     * @throws IllegalArgumentException if the array is null
     */
    public static <T extends Comparable<T>> boolean isSorted(T[] array) throws IllegalArgumentException {
        return isSorted(array, 0, array.length, ASCENDING);
    }

    /**
     * Checks if the given int array is sorted within the specified range and
     * axis.
     *
     * <p>
     * This method verifies whether the elements in the specified range of the array
     * are sorted in either ascending or descending order, based on the axis value.
     * It throws an IllegalArgumentException if the array is null, if the start or
     * end indices are invalid, or if the axis value is neither ASCENDING nor
     * DESCENDING.
     *
     * @param array the int array to be checked
     * @param start the starting index of the check range
     * @param end   the ending index of the check range
     * @param aix   the axis value for the sorting order, either ASCENDING or
     *              DESCENDING
     * @return true if the array is sorted within the specified range and axis,
     *         false otherwise
     * @throws IllegalArgumentException if the array is null, the start or end index
     *                                  is invalid,
     *                                  or the axis value is invalid
     */
    public static boolean isSorted(int[] array, int start, int end, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (start < 0 || end > array.length || start > end) {
            throw new IllegalArgumentException("Invalid start or end index");
        }
        if (aix != ASCENDING && aix != DESCENDING) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (end - start < 2) {
            return true;
        }
        if (aix == ASCENDING) {
            for (int i = start; i < end - 1; i++) {
                if (array[i] > array[i + 1]) {
                    return false;
                }
            }
        } else {
            for (int i = start; i < end - 1; i++) {
                if (array[i] < array[i + 1]) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Checks if the given int array is sorted in ascending order.
     *
     * <p>
     * This method verifies whether the elements in the array are sorted in
     * ascending order. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the int array to be checked
     * @return true if the array is sorted in ascending order, false otherwise
     * @throws IllegalArgumentException if the array is null
     */
    public static boolean isSorted(int[] array) throws IllegalArgumentException {
        return isSorted(array, 0, array.length, ASCENDING);
    }

    /**
     * Checks if the given long array is sorted within the specified range and
     * axis.
     *
     * <p>
     * This method verifies whether the elements in the specified range of the array
     * are sorted in either ascending or descending order, based on the axis value.
     * It throws an IllegalArgumentException if the array is null, if the start or
     * end indices are invalid, or if the axis value is neither ASCENDING nor
     * DESCENDING.
     *
     * @param array the long array to be checked
     * @param start the starting index of the check range
     * @param end   the ending index of the check range
     * @param aix   the axis value for the sorting order, either ASCENDING or
     *              DESCENDING
     * @return true if the array is sorted within the specified range and axis,
     *         false otherwise
     * @throws IllegalArgumentException if the array is null, the start or end index
     *                                  is invalid,
     *                                  or the axis value is invalid
     */

    public static boolean isSorted(long[] array, int start, int end, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (start < 0 || end > array.length || start > end) {
            throw new IllegalArgumentException("Invalid start or end index");
        }
        if (aix != ASCENDING && aix != DESCENDING) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (end - start < 2) {
            return true;
        }
        if (aix == ASCENDING) {
            for (int i = start; i < end - 1; i++) {
                if (array[i] > array[i + 1]) {
                    return false;
                }
            }
        } else {
            for (int i = start; i < end - 1; i++) {
                if (array[i] < array[i + 1]) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Checks if the given long array is sorted in ascending order.
     *
     * <p>
     * This method verifies whether the elements in the array are sorted in
     * ascending order. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the long array to be checked
     * @return true if the array is sorted in ascending order, false otherwise
     * @throws IllegalArgumentException if the array is null
     */
    public static boolean isSorted(long[] array) throws IllegalArgumentException {
        return isSorted(array, 0, array.length, ASCENDING);
    }

    /**
     * Checks if the given double array is sorted within the specified range and
     * axis.
     *
     * <p>
     * This method verifies whether the elements in the specified range of the array
     * are sorted in either ascending or descending order, based on the axis value.
     * It throws an IllegalArgumentException if the array is null, if the start or
     * end indices are invalid, or if the axis value is neither ASCENDING nor
     * DESCENDING.
     *
     * @param array the double array to be checked
     * @param start the starting index of the check range
     * @param end   the ending index of the check range
     * @param aix   the axis value for the sorting order, either ASCENDING or
     *              DESCENDING
     * @return true if the array is sorted within the specified range and axis,
     *         false otherwise
     * @throws IllegalArgumentException if the array is null, the start or end index
     *                                  is invalid,
     *                                  or the axis value is invalid
     */

    public static boolean isSorted(double[] array, int start, int end, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (start < 0 || end > array.length || start > end) {
            throw new IllegalArgumentException("Invalid start or end index");
        }
        if (aix != ASCENDING && aix != DESCENDING) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (end - start < 2) {
            return true;
        }
        if (aix == ASCENDING) {
            for (int i = start; i < end - 1; i++) {
                if (array[i] > array[i + 1]) {
                    return false;
                }
            }
        } else {
            for (int i = start; i < end - 1; i++) {
                if (array[i] < array[i + 1]) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Checks if the given double array is sorted in ascending order.
     *
     * <p>
     * This method verifies whether the elements in the array are sorted in
     * ascending order. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the double array to be checked
     * @return true if the array is sorted in ascending order, false otherwise
     * @throws IllegalArgumentException if the array is null
     */
    public static boolean isSorted(double[] array) throws IllegalArgumentException {
        return isSorted(array, 0, array.length, ASCENDING);
    }

    /**
     * Checks if the given float array is sorted within the specified range and
     * axis.
     *
     * <p>
     * This method verifies whether the elements in the specified range of the array
     * are sorted in either ascending or descending order, based on the axis value.
     * It throws an IllegalArgumentException if the array is null, if the start or
     * end indices are invalid, or if the axis value is neither ASCENDING nor
     * DESCENDING.
     *
     * @param array the float array to be checked
     * @param start the starting index of the check range
     * @param end   the ending index of the check range
     * @param aix   the axis value for the sorting order, either ASCENDING or
     *              DESCENDING
     * @return true if the array is sorted within the specified range and axis,
     *         false otherwise
     * @throws IllegalArgumentException if the array is null, the start or end index
     *                                  is invalid,
     *                                  or the axis value is invalid
     */
    public static boolean isSorted(float[] array, int start, int end, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (start < 0 || end > array.length || start > end) {
            throw new IllegalArgumentException("Invalid start or end index");
        }
        if (aix != ASCENDING && aix != DESCENDING) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (end - start < 2) {
            return true;
        }
        if (aix == ASCENDING) {
            for (int i = start; i < end - 1; i++) {
                if (array[i] > array[i + 1]) {
                    return false;
                }
            }
        } else {
            for (int i = start; i < end - 1; i++) {
                if (array[i] < array[i + 1]) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Checks if the given float array is sorted in ascending order.
     *
     * <p>
     * This method verifies whether the elements in the array are sorted in
     * ascending order. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the float array to be checked
     * @return true if the array is sorted in ascending order, false otherwise
     * @throws IllegalArgumentException if the array is null
     */
    public static boolean isSorted(float[] array) throws IllegalArgumentException {
        return isSorted(array, 0, array.length, ASCENDING);
    }

    /**
     * Checks if the given char array is sorted within the specified range and
     * axis.
     *
     * <p>
     * This method verifies whether the elements in the specified range of the array
     * are sorted in either ascending or descending order, based on the axis value.
     * It throws an IllegalArgumentException if the array is null, if the start or
     * end indices are invalid, or if the axis value is neither ASCENDING nor
     * DESCENDING.
     *
     * @param array the char array to be checked
     * @param start the starting index of the check range
     * @param end   the ending index of the check range
     * @param aix   the axis value for the sorting order, either ASCENDING or
     *              DESCENDING
     * @return true if the array is sorted within the specified range and axis,
     *         false otherwise
     * @throws IllegalArgumentException if the array is null, the start or end index
     *                                  is invalid,
     *                                  or the axis value is invalid
     */
    public static boolean isSorted(char[] array, int start, int end, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (start < 0 || end > array.length || start > end) {
            throw new IllegalArgumentException("Invalid start or end index");
        }
        if (aix != ASCENDING && aix != DESCENDING) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (end - start < 2) {
            return true;
        }
        if (aix == ASCENDING) {
            for (int i = start; i < end - 1; i++) {
                if (array[i] > array[i + 1]) {
                    return false;
                }
            }
        } else {
            for (int i = start; i < end - 1; i++) {
                if (array[i] < array[i + 1]) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Checks if the given char array is sorted in ascending order.
     *
     * <p>
     * This method verifies whether the elements in the array are sorted in
     * ascending order. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the char array to be checked
     * @return true if the array is sorted in ascending order, false otherwise
     * @throws IllegalArgumentException if the array is null
     */
    public static boolean isSorted(char[] array) throws IllegalArgumentException {
        return isSorted(array, 0, array.length, ASCENDING);
    }

    /**
     * Checks if the given short array is sorted within the specified range and
     * axis.
     *
     * <p>
     * This method verifies whether the elements in the specified range of the array
     * are sorted in either ascending or descending order, based on the axis value.
     * It throws an IllegalArgumentException if the array is null, if the start or
     * end indices are invalid, or if the axis value is neither ASCENDING nor
     * DESCENDING.
     *
     * @param array the short array to be checked
     * @param start the starting index of the check range
     * @param end   the ending index of the check range
     * @param aix   the axis value for the sorting order, either ASCENDING or
     *              DESCENDING
     * @return true if the array is sorted within the specified range and axis,
     *         false otherwise
     * @throws IllegalArgumentException if the array is null, the start or end index
     *                                  is invalid,
     *                                  or the axis value is invalid
     */
    public static boolean isSorted(short[] array, int start, int end, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (start < 0 || end > array.length || start > end) {
            throw new IllegalArgumentException("Invalid start or end index");
        }
        if (aix != ASCENDING && aix != DESCENDING) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (end - start < 2) {
            return true;
        }
        if (aix == ASCENDING) {
            for (int i = start; i < end - 1; i++) {
                if (array[i] > array[i + 1]) {
                    return false;
                }
            }
        } else {
            for (int i = start; i < end - 1; i++) {
                if (array[i] < array[i + 1]) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Checks if the given short array is sorted in ascending order.
     *
     * <p>
     * This method verifies whether the elements in the array are sorted in
     * ascending order. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the short array to be checked
     * @return true if the array is sorted in ascending order, false otherwise
     * @throws IllegalArgumentException if the array is null
     */
    public static boolean isSorted(short[] array) throws IllegalArgumentException {
        return isSorted(array, 0, array.length, ASCENDING);
    }

    /**
     * Checks if the given byte array is sorted within the specified range and
     * axis.
     *
     * <p>
     * This method verifies whether the elements in the specified range of the array
     * are sorted in either ascending or descending order, based on the axis value.
     * It throws an IllegalArgumentException if the array is null, if the start or
     * end indices are invalid, or if the axis value is neither ASCENDING nor
     * DESCENDING.
     *
     * @param array the byte array to be checked
     * @param start the starting index of the check range
     * @param end   the ending index of the check range
     * @param aix   the axis value for the sorting order, either ASCENDING or
     *              DESCENDING
     * @return true if the array is sorted within the specified range and axis,
     *         false otherwise
     * @throws IllegalArgumentException if the array is null, the start or end index
     *                                  is invalid,
     *                                  or the axis value is invalid
     */
    public static boolean isSorted(byte[] array, int start, int end, int aix) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (start < 0 || end > array.length || start > end) {
            throw new IllegalArgumentException("Invalid start or end index");
        }
        if (aix != ASCENDING && aix != DESCENDING) {
            throw new IllegalArgumentException("Invalid axis value");
        }
        if (end - start < 2) {
            return true;
        }
        if (aix == ASCENDING) {
            for (int i = start; i < end - 1; i++) {
                if (array[i] > array[i + 1]) {
                    return false;
                }
            }
        } else {
            for (int i = start; i < end - 1; i++) {
                if (array[i] < array[i + 1]) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Checks if the given byte array is sorted in ascending order.
     *
     * <p>
     * This method verifies whether the elements in the array are sorted in
     * ascending order. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the byte array to be checked
     * @return true if the array is sorted in ascending order, false otherwise
     * @throws IllegalArgumentException if the array is null
     */
    public static boolean isSorted(byte[] array) throws IllegalArgumentException {
        return isSorted(array, 0, array.length, ASCENDING);
    }

    /// Array reversal

    /**
     * Reverses the elements of the given array in place.
     *
     * @param array the array to be reversed
     * @throws IllegalArgumentException if the array is null
     */
    public static void reverse(Object[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length < 2) {
            return;
        }
        int mid = array.length / 2;
        for (int i = 0; i < mid; i++) {
            Object temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
    }

    /**
     * Reverses the elements of the given short array in place.
     *
     * <p>
     * This method reverses the elements of the given array in place. It throws an
     * IllegalArgumentException if the array is null.
     *
     * @param array the short array to be reversed
     * @throws IllegalArgumentException if the array is null
     */
    public static void reverse(short[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length < 2) {
            return;
        }
        int mid = array.length / 2;
        for (int i = 0; i < mid; i++) {
            short temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
    }

    /**
     * Reverses the elements of the given byte array in place.
     *
     * <p>
     * This method reverses the elements of the given array in place. It throws an
     * IllegalArgumentException if the array is null.
     *
     * @param array the byte array to be reversed
     * @throws IllegalArgumentException if the array is null
     */
    public static void reverse(byte[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length < 2) {
            return;
        }
        int mid = array.length / 2;
        for (int i = 0; i < mid; i++) {
            byte temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
    }

    /**
     * Reverses the elements of the given char array in place.
     *
     * <p>
     * This method reverses the elements of the given array in place. It throws an
     * IllegalArgumentException if the array is null.
     *
     * @param array the char array to be reversed
     * @throws IllegalArgumentException if the array is null
     */
    public static void reverse(char[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length < 2) {
            return;
        }
        int mid = array.length / 2;
        for (int i = 0; i < mid; i++) {
            char temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
    }

    /**
     * Reverses the elements of the given int array in place.
     *
     * <p>
     * This method reverses the elements of the given array in place. It throws an
     * IllegalArgumentException if the array is null.
     *
     * @param array the int array to be reversed
     * @throws IllegalArgumentException if the array is null
     */
    public static void reverse(int[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length < 2) {
            return;
        }
        int mid = array.length / 2;
        for (int i = 0; i < mid; i++) {
            int temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
    }

    /**
     * Reverses the elements of the given long array in place.
     *
     * <p>
     * This method reverses the elements of the given array in place. It throws an
     * IllegalArgumentException if the array is null.
     *
     * @param array the long array to be reversed
     * @throws IllegalArgumentException if the array is null
     */
    public static void reverse(long[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length < 2) {
            return;
        }
        int mid = array.length / 2;
        for (int i = 0; i < mid; i++) {
            long temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
    }

    /**
     * Reverses the elements of the given double array in place.
     *
     * <p>
     * This method reverses the elements of the given array in place. It throws an
     * IllegalArgumentException if the array is null.
     *
     * @param array the double array to be reversed
     * @throws IllegalArgumentException if the array is null
     */
    public static void reverse(double[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length < 2) {
            return;
        }
        int mid = array.length / 2;
        for (int i = 0; i < mid; i++) {
            double temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
    }

    /**
     * Reverses the elements of the given float array in place.
     *
     * <p>
     * This method reverses the elements of the given array in place. It throws an
     * IllegalArgumentException if the array is null.
     *
     * @param array the flaot array to be reversed
     * @throws IllegalArgumentException if the array is null
     */
    public static void reverse(float[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length < 2) {
            return;
        }
        int mid = array.length / 2;
        for (int i = 0; i < mid; i++) {
            float temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
    }

    /**
     * Reverses the elements of the given boolean array in place.
     *
     * <p>
     * This method reverses the elements of the given array in place. It throws an
     * IllegalArgumentException if the array is null.
     *
     * @param array the boolean array to be reversed
     * @throws IllegalArgumentException if the array is null
     */
    public static void reverse(boolean[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        if (array.length < 2) {
            return;
        }
        int mid = array.length / 2;
        for (int i = 0; i < mid; i++) {
            boolean temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
    }

    /// Converts an array of base types to an array of its wrapping classes

    /**
     * Converts an array of base types to an array of its wrapping classes.
     *
     * <p>
     * This method takes an array of int as an argument and returns an array of
     * Integer. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the int array to be converted
     * @return the Integer array
     * @throws IllegalArgumentException if the array is null
     */
    public static Integer[] packageArray(int[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        Integer[] result = new Integer[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i];
        }
        return result;
    }

    /**
     * Converts an array of base types to an array of its wrapping classes.
     *
     * <p>
     * This method takes an array of long as an argument and returns an array of
     * Long. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the long array to be converted
     * @return the Long array
     * @throws IllegalArgumentException if the array is null
     */
    public static Long[] packageArray(long[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        Long[] result = new Long[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i];
        }
        return result;
    }

    /**
     * Converts an array of base types to an array of its wrapping classes.
     *
     * <p>
     * This method takes an array of double as an argument and returns an array of
     * Double. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the double array to be converted
     * @return the Double array
     * @throws IllegalArgumentException if the array is null
     */
    public static Double[] packageArray(double[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        Double[] result = new Double[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i];
        }
        return result;
    }

    /**
     * Converts an array of base types to an array of its wrapping classes.
     *
     * <p>
     * This method takes an array of float as an argument and returns an array of
     * Float. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the float array to be converted
     * @return the Float array
     * @throws IllegalArgumentException if the array is null
     */
    public static Float[] packageArray(float[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        Float[] result = new Float[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i];
        }
        return result;
    }

    /**
     * Converts an array of base types to an array of its wrapping classes.
     *
     * <p>
     * This method takes an array of boolean as an argument and returns an array of
     * Boolean. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the boolean array to be converted
     * @return the Boolean array
     * @throws IllegalArgumentException if the array is null
     */
    public static Boolean[] packageArray(boolean[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        Boolean[] result = new Boolean[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i];
        }
        return result;
    }

    /**
     * Converts an array of base types to an array of its wrapping classes.
     *
     * <p>
     * This method takes an array of char as an argument and returns an array of
     * Character. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the char array to be converted
     * @return the Character array
     * @throws IllegalArgumentException if the array is null
     */
    public static String[] packageArray(char[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        String[] result = new String[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = String.valueOf(array[i]);
        }
        return result;
    }

    /**
     * Converts an array of base types to an array of its wrapping classes.
     *
     * <p>
     * This method takes an array of byte as an argument and returns an array of
     * Byte. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the byte array to be converted
     * @return the Byte array
     * @throws IllegalArgumentException if the array is null
     */
    public static Byte[] packageArray(byte[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        Byte[] result = new Byte[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i];
        }
        return result;
    }

    /**
     * Converts an array of base types to an array of its wrapping classes.
     *
     * <p>
     * This method takes an array of short as an argument and returns an array of
     * Short. It throws an IllegalArgumentException if the array is null.
     *
     * @param array the short array to be converted
     * @return the Short array
     * @throws IllegalArgumentException if the array is null
     */
    public static Short[] packageArray(short[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        Short[] result = new Short[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i];
        }
        return result;
    }

    /// Converts an array of wrapping classes to an array of its base types

    /**
     * Converts an array of wrapping classes to an array of its base types.
     *
     * <p>
     * This method takes an array of Integer objects as input and returns a new
     * array
     * containing the equivalent primitive int values. It throws an
     * IllegalArgumentException
     * if the input array is null.
     *
     * @param array the Integer array to be converted
     * @return the primitive int array
     * @throws IllegalArgumentException if the array is null
     */

    public static int[] unpackageArray(Integer[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        int[] result = new int[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i].intValue();
        }
        return result;
    }

    /**
     * Converts an array of wrapping classes to an array of its base types.
     *
     * <p>
     * This method takes an array of Long objects as input and returns a new
     * array
     * containing the equivalent primitive long values. It throws an
     * IllegalArgumentException
     * if the input array is null.
     *
     * @param array the Long array to be converted
     * @return the primitive long array
     * @throws IllegalArgumentException if the array is null
     */
    public static long[] unpackageArray(Long[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        long[] result = new long[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i].longValue();
        }
        return result;
    }

    /**
     * Converts an array of wrapping classes to an array of its base types.
     *
     * <p>
     * This method takes an array of Double objects as input and returns a new
     * array
     * containing the equivalent primitive double values. It throws an
     * IllegalArgumentException
     * if the input array is null.
     *
     * @param array the Double array to be converted
     * @return the primitive double array
     * @throws IllegalArgumentException if the array is null
     */
    public static double[] unpackageArray(Double[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        double[] result = new double[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i].doubleValue();
        }
        return result;
    }

    /**
     * Converts an array of wrapping classes to an array of its base types.
     *
     * <p>
     * This method takes an array of Float objects as input and returns a new
     * array
     * containing the equivalent primitive float values. It throws an
     * IllegalArgumentException
     * if the input array is null.
     *
     * @param array the Float array to be converted
     * @return the primitive float array
     * @throws IllegalArgumentException if the array is null
     */
    public static float[] unpackageArray(Float[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        float[] result = new float[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i].floatValue();
        }
        return result;
    }

    /**
     * Converts an array of wrapping classes to an array of its base types.
     *
     * <p>
     * This method takes an array of Boolean objects as input and returns a new
     * array
     * containing the equivalent primitive boolean values. It throws an
     * IllegalArgumentException
     * if the input array is null.
     *
     * @param array the Boolean array to be converted
     * @return the primitive boolean array
     * @throws IllegalArgumentException if the array is null
     */
    public static boolean[] unpackageArray(Boolean[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        boolean[] result = new boolean[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i].booleanValue();
        }
        return result;
    }

    /**
     * Converts an array of wrapping classes to an array of its base types.
     *
     * <p>
     * This method takes an array of Character objects as input and returns a new
     * array
     * containing the equivalent primitive char values. It throws an
     * IllegalArgumentException
     * if the input array is null.
     *
     * @param array the Character array to be converted
     * @return the primitive char array
     * @throws IllegalArgumentException if the array is null
     */
    public static char[] unpackageArray(Character[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        char[] result = new char[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i].charValue();
        }
        return result;
    }

    /**
     * Converts an array of wrapping classes to an array of its base types.
     *
     * <p>
     * This method takes an array of Short objects as input and returns a new
     * array
     * containing the equivalent primitive short values. It throws an
     * IllegalArgumentException
     * if the input array is null.
     *
     * @param array the Short array to be converted
     * @return the primitive short array
     * @throws IllegalArgumentException if the array is null
     */
    public static short[] unpackageArray(Short[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        short[] result = new short[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i].shortValue();
        }
        return result;
    }

    /**
     * Converts an array of wrapping classes to an array of its base types.
     *
     * <p>
     * This method takes an array of Byte objects as input and returns a new
     * array
     * containing the equivalent primitive byte values. It throws an
     * IllegalArgumentException
     * if the input array is null.
     *
     * @param array the Byte array to be converted
     * @return the primitive byte array
     * @throws IllegalArgumentException if the array is null
     */
    public static byte[] unpackageArray(Byte[] array) {
        if (array == null) {
            throw new IllegalArgumentException("Array cannot be null");
        }
        byte[] result = new byte[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i].byteValue();
        }
        return result;
    }

    /**
     * Concatenates two arrays into one.
     *
     * <p>
     * This method takes two arrays as input and returns a new array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first array to be concatenated
     * @param b the second array to be concatenated
     * @return a new array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static double[] constructArray(double[] a, double[] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        double[] result = new double[a.length + b.length];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two arrays into one.
     *
     * <p>
     * This method takes two arrays as input and returns a new array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first array to be concatenated
     * @param b the second array to be concatenated
     * @return a new array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static int[] constructArray(int[] a, int[] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        int[] result = new int[a.length + b.length];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two arrays into one.
     *
     * <p>
     * This method takes two arrays as input and returns a new array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first array to be concatenated
     * @param b the second array to be concatenated
     * @return a new array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static boolean[] constructArray(boolean[] a, boolean[] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        boolean[] result = new boolean[a.length + b.length];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two arrays into one.
     *
     * <p>
     * This method takes two arrays as input and returns a new array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first array to be concatenated
     * @param b the second array to be concatenated
     * @return a new array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static char[] constructArray(char[] a, char[] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        char[] result = new char[a.length + b.length];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two arrays into one.
     *
     * <p>
     * This method takes two arrays as input and returns a new array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first array to be concatenated
     * @param b the second array to be concatenated
     * @return a new array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static long[] constructArray(long[] a, long[] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        long[] result = new long[a.length + b.length];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two arrays into one.
     *
     * <p>
     * This method takes two arrays as input and returns a new array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first array to be concatenated
     * @param b the second array to be concatenated
     * @return a new array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static float[] constructArray(float[] a, float[] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        float[] result = new float[a.length + b.length];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two arrays into one.
     *
     * <p>
     * This method takes two arrays as input and returns a new array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first array to be concatenated
     * @param b the second array to be concatenated
     * @return a new array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static short[] constructArray(short[] a, short[] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        short[] result = new short[a.length + b.length];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two arrays into one.
     *
     * <p>
     * This method takes two arrays as input and returns a new array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first array to be concatenated
     * @param b the second array to be concatenated
     * @return a new array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static byte[] constructArray(byte[] a, byte[] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        byte[] result = new byte[a.length + b.length];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two arrays into one.
     *
     * <p>
     * This method takes two arrays as input and returns a new array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first array to be concatenated
     * @param b the second array to be concatenated
     * @return a new array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static Object[] constructArray(Object[] a, Object[] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        Object[] result = new Object[a.length + b.length];
        System.arraycopy(a, 0, result, 0, a.length);
        System.arraycopy(b, 0, result, a.length, b.length);
        return result;
    }

    /**
     * Concatenates two 2D arrays into one.
     *
     * <p>
     * This method takes two 2D arrays as input and returns a new 2D array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first 2D array to be concatenated
     * @param b the second 2D array to be concatenated
     * @return a new 2D array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */

    public static Object[][] constructArray(Object[][] a, Object[][] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        Object[][] result = new Object[a.length + b.length][];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two 2D arrays into one.
     *
     * <p>
     * This method takes two 2D arrays as input and returns a new 2D array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first 2D array to be concatenated
     * @param b the second 2D array to be concatenated
     * @return a new 2D array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static double[][] constructArray(double[][] a, double[][] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        double[][] result = new double[a.length + b.length][];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two 2D arrays into one.
     *
     * <p>
     * This method takes two 2D arrays as input and returns a new 2D array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first 2D array to be concatenated
     * @param b the second 2D array to be concatenated
     * @return a new 2D array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static int[][] constructArray(int[][] a, int[][] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        int[][] result = new int[a.length + b.length][];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two 2D arrays into one.
     *
     * <p>
     * This method takes two 2D arrays as input and returns a new 2D array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first 2D array to be concatenated
     * @param b the second 2D array to be concatenated
     * @return a new 2D array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static long[][] constructArray(long[][] a, long[][] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        long[][] result = new long[a.length + b.length][];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two 2D arrays into one.
     *
     * <p>
     * This method takes two 2D arrays as input and returns a new 2D array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first 2D array to be concatenated
     * @param b the second 2D array to be concatenated
     * @return a new 2D array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static float[][] constructArray(float[][] a, float[][] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        float[][] result = new float[a.length + b.length][];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two 2D arrays into one.
     *
     * <p>
     * This method takes two 2D arrays as input and returns a new 2D array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first 2D array to be concatenated
     * @param b the second 2D array to be concatenated
     * @return a new 2D array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static boolean[][] constructArray(boolean[][] a, boolean[][] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        boolean[][] result = new boolean[a.length + b.length][];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two 2D arrays into one.
     *
     * <p>
     * This method takes two 2D arrays as input and returns a new 2D array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first 2D array to be concatenated
     * @param b the second 2D array to be concatenated
     * @return a new 2D array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static char[][] constructArray(char[][] a, char[][] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        char[][] result = new char[a.length + b.length][];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }

    /**
     * Concatenates two 2D arrays into one.
     *
     * <p>
     * This method takes two 2D arrays as input and returns a new 2D array
     * containing all the elements of the two arrays. It throws an
     * IllegalArgumentException if either of the input arrays is null.
     *
     * @param a the first 2D array to be concatenated
     * @param b the second 2D array to be concatenated
     * @return a new 2D array containing all the elements of the two arrays
     * @throws IllegalArgumentException if either of the arrays is null
     */
    public static byte[][] constructArray(byte[][] a, byte[][] b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Array cannot be null");
        } else if (a.length == 0) {
            return b;
        } else if (b.length == 0) {
            return a;
        }
        byte[][] result = new byte[a.length + b.length][];
        for (int i = 0; i < a.length; i++) {
            result[i] = a[i];
        }
        for (int i = 0; i < b.length; i++) {
            result[i + a.length] = b[i];
        }
        return result;
    }
}
