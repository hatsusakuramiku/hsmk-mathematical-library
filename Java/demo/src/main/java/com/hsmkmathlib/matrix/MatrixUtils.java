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
package com.hsmkmathlib.matrix;

import com.hsmkmathlib.tools.ArrayTools;

/**
 * A utility class that provides static methods for matrix operations.
 * <p>
 * This class includes operations such as:
 * <ul>
 * <li>Matrix addition</li>
 * <li>Matrix subtraction</li>
 * <li>Matrix multiplication</li>
 * <li>Element-wise multiplication</li>
 * <li>Matrix transposition</li>
 * <li>Creating special matrices (ones, zeros)</li>
 * </ul>
 */
final public class MatrixUtils {

    private MatrixUtils() {
        throw new IllegalStateException("Utility class");
    }

    /**
     * Adds two matrices together.
     *
     * @param a the first matrix
     * @param b the second matrix
     * @return a new matrix containing the sum of the input matrices
     * @throws IllegalArgumentException if either matrix is null or if the
     * matrices have different dimensions
     */
    public static Matrix add(Matrix a, Matrix b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Matrix is null");
        }
        if (!a.isSameSize(b)) {
            throw new IllegalArgumentException("Matrix sizes are not the same");
        }

        double[][] result = new double[a.getRows()][a.getCols()];
        double[][] aData = a.getData();
        double[][] bData = b.getData();
        for (int i = 0; i < a.getRows(); i++) {
            for (int j = 0; j < a.getCols(); j++) {
                result[i][j] = aData[i][j] + bData[i][j];
            }
        }
        return new Matrix(result, false);
    }

    /**
     * Creates a deep copy of a matrix.
     *
     * @param a the matrix to be copied
     * @return a new matrix containing the same values as the input matrix
     * @throws IllegalArgumentException if the input matrix is null
     */
    public static Matrix copyMatrix(Matrix a) {
        if (a == null) {
            throw new IllegalArgumentException("Matrix is null");
        }
        return new Matrix(a.getData(), false);
    }

    /**
     * Subtracts the second matrix from the first matrix.
     *
     * @param a the first matrix (minuend)
     * @param b the second matrix (subtrahend)
     * @return a new matrix containing the difference of the input matrices
     * @throws IllegalArgumentException if either matrix is null or if the
     * matrices have different dimensions
     */
    public static Matrix subtract(Matrix a, Matrix b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Matrix is null");
        }
        if (!a.isSameSize(b)) {
            throw new IllegalArgumentException("Matrix sizes are not the same");
        }

        double[][] result = new double[a.getRows()][a.getCols()];
        double[][] aData = a.getData();
        double[][] bData = b.getData();
        for (int i = 0; i < a.getRows(); i++) {
            for (int j = 0; j < a.getCols(); j++) {
                result[i][j] = aData[i][j] - bData[i][j];
            }
        }
        return new Matrix(result, false);
    }

    /**
     * Multiplies two matrices together.
     *
     * @param a the first matrix
     * @param b the second matrix
     * @return a new matrix containing the product of the input matrices
     * @throws IllegalArgumentException if either matrix is null or if the
     * number of columns in the first matrix does not match the number of rows
     * in the second matrix
     */
    public static Matrix multiply(Matrix a, Matrix b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Matrix is null");
        }
        if (a.getCols() != b.getRows()) {
            throw new IllegalArgumentException("The number of columns of the first matrix must be equal to the number of rows of the second matrix");
        }

        double[][] result = new double[a.getRows()][b.getCols()];
        double[][] aData = a.getData();
        double[][] bData = b.getData();

        for (int i = 0; i < a.getRows(); i++) {
            for (int j = 0; j < b.getCols(); j++) {
                for (int k = 0; k < a.getCols(); k++) {
                    result[i][j] += aData[i][k] * bData[k][j];
                }
            }
        }
        return new Matrix(result, false);
    }

    /**
     * Performs element-wise multiplication (Hadamard product) of two matrices.
     *
     * @param a the first matrix
     * @param b the second matrix
     * @return a new matrix containing the element-wise product of the input
     * matrices
     * @throws IllegalArgumentException if either matrix is null or if the
     * matrices have different dimensions
     */
    public static Matrix cdotMultiply(Matrix a, Matrix b) {
        if (a == null || b == null) {
            throw new IllegalArgumentException("Matrix is null");
        }
        if (!a.isSameSize(b)) {
            throw new IllegalArgumentException("Matrix sizes are not the same");
        }

        double[][] result = new double[a.getRows()][a.getCols()];
        double[][] aData = a.getData();
        double[][] bData = b.getData();

        for (int i = 0; i < a.getRows(); i++) {
            for (int j = 0; j < a.getCols(); j++) {
                result[i][j] = aData[i][j] * bData[i][j];
            }
        }
        return new Matrix(result, false);
    }

    /**
     * Creates a matrix filled with ones.
     *
     * @param rows the number of rows in the matrix
     * @param cols the number of columns in the matrix
     * @return a new matrix filled with ones
     */
    public static Matrix onesMatrix(int rows, int cols) {
        return new Matrix(ArrayTools.onesArray(rows, cols), false);
    }

    /**
     * Creates a matrix filled with a specified scalar value.
     *
     * @param rows the number of rows in the matrix
     * @param cols the number of columns in the matrix
     * @param scalar the value to fill the matrix with
     * @return a new matrix filled with the specified scalar value
     */
    public static Matrix onesMatrix(int rows, int cols, int scalar) {
        return new Matrix(ArrayTools.onesArray(rows, cols, scalar), false);
    }

    /**
     * Creates a matrix filled with zeros.
     *
     * @param rows the number of rows in the matrix
     * @param cols the number of columns in the matrix
     * @return a new matrix filled with zeros
     */
    public static Matrix zerosMatrix(int rows, int cols) {
        return new Matrix(ArrayTools.zerosArray(rows, cols), false);
    }

    /**
     * Creates the transpose of a matrix.
     *
     * @param a the matrix to be transposed
     * @return a new matrix containing the transpose of the input matrix
     * @throws IllegalArgumentException if the input matrix is null
     */
    public static Matrix transpose(Matrix a) {
        if (a == null) {
            throw new IllegalArgumentException("Matrix is null");
        }
        Matrix result = copyMatrix(a);
        result.transpose();
        return result;
    }

}
