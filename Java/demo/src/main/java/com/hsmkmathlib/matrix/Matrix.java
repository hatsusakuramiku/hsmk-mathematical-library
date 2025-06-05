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
 * A class representing a matrix with double precision values.
 * <p>
 * This class provides functionality for:
 * <ul>
 * <li>Matrix creation and initialization</li>
 * <li>Basic matrix operations (addition, subtraction, multiplication)</li>
 * <li>Element-wise operations</li>
 * <li>Matrix properties (square, symmetric, diagonal)</li>
 * <li>Matrix transposition</li>
 * <li>Accessing rows, columns, and individual elements</li>
 * </ul>
 */
final public class Matrix {

    private int rows;
    private int cols;
    private double[][] data;

    /**
     * Creates a new matrix with specified dimensions.
     *
     * @param rows the number of rows
     * @param cols the number of columns
     * @throws IllegalArgumentException if rows or cols are not positive
     */
    public Matrix(int rows, int cols) {
        if (!isRowAndColValid(rows, cols)) {
            throw new IllegalArgumentException("Invalid matrix dimensions");
        }
        this.rows = rows;
        this.cols = cols;
        this.data = new double[rows][cols];
    }

    /**
     * Creates a new matrix from a 2D array of doubles.
     *
     * @param data the 2D array containing matrix elements
     * @throws IllegalArgumentException if data is null or contains null rows
     */
    public Matrix(double[][] data) {
        if (!isDataAndElementNotNull(data)) {
            throw new IllegalArgumentException("Data and elements are null");
        }
        this.rows = data.length;
        this.cols = data[0].length;
        this.data = ArrayTools.copyArray(data);
    }

    /**
     * Creates a new matrix from a 2D array of doubles with option to copy data.
     *
     * @param data the 2D array containing matrix elements
     * @param isCopy if true, creates a deep copy of the data; if false, uses
     * the provided array directly
     * @throws IllegalArgumentException if data is null or contains null rows
     */
    public Matrix(double[][] data, boolean isCopy) {
        if (!isDataAndElementNotNull(data)) {
            throw new IllegalArgumentException("Data and elements are null");
        }
        this.rows = data.length;
        this.cols = data[0].length;
        if (isCopy) {
            this.data = ArrayTools.copyArray(data);
        } else {
            this.data = data;
        }
    }

    /**
     * Creates a new matrix as a copy of another matrix.
     *
     * @param other the matrix to copy
     * @throws IllegalArgumentException if other is null or contains invalid
     * data
     */
    public Matrix(Matrix other) {
        if (other == null) {
            throw new IllegalArgumentException("Other matrix is null");
        }
        if (!isDataAndElementNotNull(other.data)) {
            throw new IllegalArgumentException("Other matrix data and elements are null");
        }
        this.rows = other.rows;
        this.cols = other.cols;
        this.data = ArrayTools.copyArray(other.data);
    }

    /**
     * Checks if the matrix has the same dimensions as another matrix.
     *
     * @param other the matrix to compare with
     * @return true if the matrices have the same dimensions, false otherwise
     */
    public boolean isSameSize(Matrix other) {
        if (other == null) {
            return false;
        }
        return rows == other.rows && cols == other.cols;
    }

    /**
     * Gets the number of rows in the matrix.
     *
     * @return the number of rows
     */
    public int getRows() {
        return rows;
    }

    /**
     * Gets the number of columns in the matrix.
     *
     * @return the number of columns
     */
    public int getCols() {
        return cols;
    }

    /**
     * Gets a deep copy of the matrix data.
     *
     * @return a copy of the matrix data
     */
    public double[][] getData() {
        return ArrayTools.copyArray(data);
    }

    /**
     * Gets the element at the specified position.
     *
     * @param row the row index
     * @param col the column index
     * @return the element at the specified position
     * @throws IllegalArgumentException if the indices are out of bounds
     */
    public double get(int row, int col) {
        if (!isRowAndColIndexValid(row, col)) {
            throw new IllegalArgumentException("Invalid matrix element index");
        }
        return data[row][col];
    }

    /**
     * Gets a copy of the specified row.
     *
     * @param row the row index
     * @return a copy of the specified row
     * @throws IllegalArgumentException if the row index is out of bounds
     */
    public double[] getRow(int row) {
        if (!isRowIndexValid(row)) {
            throw new IllegalArgumentException("Invalid matrix row index");
        }
        return ArrayTools.copyArray(data[row]);
    }

    /**
     * Gets a portion of the specified row.
     *
     * @param rowIndex the row index
     * @param startIndex the starting column index
     * @param endIndex the ending column index
     * @return a copy of the specified portion of the row
     * @throws IllegalArgumentException if any index is out of bounds
     */
    public double[] getRow(int rowIndex, int startIndex, int endIndex) {
        if (!isRowIndexValid(rowIndex)) {
            throw new IllegalArgumentException("Invalid matrix row index");
        }
        if (!isIntervalValid(this.cols, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid matrix row interval");
        }
        double[] result = new double[endIndex - startIndex];
        System.arraycopy(data[rowIndex], startIndex, result, 0, endIndex - startIndex);
        return result;
    }

    /**
     * Gets a copy of the specified column.
     *
     * @param col the column index
     * @return a copy of the specified column
     * @throws IllegalArgumentException if the column index is out of bounds
     */
    public double[] getCol(int col) {
        if (!isColIndexValid(col)) {
            throw new IllegalArgumentException("Invalid matrix column index");
        }
        double[] result = new double[rows];
        for (int i = 0; i < rows; i++) {
            result[i] = data[i][col];
        }
        return result;
    }

    /**
     * Gets a portion of the specified column.
     *
     * @param colIndex the column index
     * @param startIndex the starting row index
     * @param endIndex the ending row index
     * @return a copy of the specified portion of the column
     * @throws IllegalArgumentException if any index is out of bounds
     */
    public double[] getCol(int colIndex, int startIndex, int endIndex) {
        if (!isColIndexValid(colIndex)) {
            throw new IllegalArgumentException("Invalid matrix column index");
        }
        if (!isIntervalValid(this.rows, startIndex, endIndex)) {
            throw new IllegalArgumentException("Invalid matrix column interval");
        }
        double[] result = new double[endIndex - startIndex];
        for (int i = 0; i < endIndex - startIndex; i++) {
            result[i] = data[startIndex + i][colIndex];
        }
        return result;
    }

    /**
     * Adds another matrix to this matrix.
     *
     * @param other the matrix to add
     * @throws IllegalArgumentException if other is null or has different
     * dimensions
     */
    public void add(Matrix other) {
        if (other == null) {
            throw new IllegalArgumentException("Other matrix is null");
        }
        if (!isSameSize(other)) {
            throw new IllegalArgumentException("Matrix sizes are not the same");
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] += other.data[i][j];
            }
        }
    }

    /**
     * Adds a scalar value to all elements of the matrix.
     *
     * @param scalar the value to add
     */
    public void add(double scalar) {
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] += scalar;
            }
        }
    }

    /**
     * Subtracts another matrix from this matrix.
     *
     * @param other the matrix to subtract
     * @throws IllegalArgumentException if other is null or has different
     * dimensions
     */
    public void subtract(Matrix other) {
        if (other == null) {
            throw new IllegalArgumentException("Other matrix is null");
        }
        if (!isSameSize(other)) {
            throw new IllegalArgumentException("Matrix sizes are not the same");
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] -= other.data[i][j];
            }
        }
    }

    /**
     * Subtracts a scalar value from all elements of the matrix.
     *
     * @param scalar the value to subtract
     */
    public void subtract(double scalar) {
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] -= scalar;
            }
        }
    }

    /**
     * Multiplies this matrix by another matrix.
     *
     * @param other the matrix to multiply by
     * @throws IllegalArgumentException if other is null or dimensions are
     * incompatible
     */
    public void multiply(Matrix other) {
        if (other == null) {
            throw new IllegalArgumentException("Other matrix is null");
        }
        if (this.cols != other.rows) {
            throw new IllegalArgumentException("Matrix sizes are not the same");
        }
        double[][] result = new double[rows][other.cols];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < other.cols; j++) {
                for (int k = 0; k < this.cols; k++) {
                    result[i][j] += data[i][k] * other.data[k][j];
                }
            }
        }
        this.data = result;
    }

    /**
     * Performs element-wise multiplication with another matrix.
     *
     * @param other the matrix to multiply with
     * @throws IllegalArgumentException if other is null or has different
     * dimensions
     */
    public void cdotMultiply(Matrix other) {
        if (other == null) {
            throw new IllegalArgumentException("Other matrix is null");
        }
        if (!isSameSize(other)) {
            throw new IllegalArgumentException("Matrix sizes are not the same");
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] *= other.data[i][j];
            }
        }
    }

    /**
     * Multiplies all elements of the matrix by a scalar value.
     *
     * @param scalar the value to multiply by
     */
    public void multiply(double scalar) {
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] *= scalar;
            }
        }
    }

    /**
     * Divides all elements of the matrix by a scalar value.
     *
     * @param scalar the value to divide by
     * @throws IllegalArgumentException if scalar is zero
     */
    public void divide(double scalar) {
        if (scalar == 0) {
            throw new IllegalArgumentException("Scalar is 0");
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] /= scalar;
            }
        }
    }

    /**
     * Transposes the matrix in place.
     */
    public void transpose() {
        double[][] result = new double[cols][rows];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                result[j][i] = data[i][j];
            }
        }
        this.data = result;
    }

    /**
     * Checks if the matrix is square (number of rows equals number of columns).
     *
     * @return true if the matrix is square, false otherwise
     */
    public boolean isSquare() {
        return rows == cols;
    }

    /**
     * Checks if the matrix is symmetric.
     *
     * @return true if the matrix is symmetric, false otherwise
     */
    public boolean isSymmetric() {
        if (!isSquare()) {
            return false;
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (data[i][j] != data[j][i]) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Checks if the matrix is diagonal.
     *
     * @return true if the matrix is diagonal, false otherwise
     */
    public boolean isDiagonal() {
        if (!isSquare()) {
            return false;
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (i != j && data[i][j] != 0) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Returns a string representation of the matrix.
     *
     * @return a string representation of the matrix
     */
    @Override
    public String toString() {
        return ArrayTools.arrayToString(data);
    }

    private boolean isRowAndColValid(int row, int col) {
        return row > 0 && col > 0;
    }

    private boolean isRowIndexValid(int row) {
        return row >= 0 && row < rows;
    }

    private boolean isColIndexValid(int col) {
        return col >= 0 && col < cols;
    }

    private boolean isIntervalValid(int length, int start, int end) {
        return start >= 0 && end <= length && start <= end;
    }

    private boolean isRowAndColIndexValid(int row, int col) {
        return row >= 0 && col >= 0 && row < rows && col < cols;
    }

    private boolean isDataAndElementNotNull(double[][] data) {
        if (data == null) {
            return false;
        }
        for (double[] row : data) {
            if (row == null) {
                return false;
            }
        }
        return true;
    }

    /**
     * Performs an elementary row transformation on the matrix. This operation
     * adds a multiple of one row to another row. The transformation is:
     * targetRow = targetRow + scalar * selectRow
     *
     * @param selectRow the index of the source row to be multiplied by scalar
     * @param targetRow the index of the target row to be modified
     * @param scalar the multiplier for the source row
     * @throws IllegalArgumentException if row indices are invalid or if
     * selectRow equals targetRow
     */
    public void elementaryRowTransform(int selectRow, int targetRow, double scalar) {
        if (!isRowIndexValid(selectRow)) {
            throw new IllegalArgumentException("Invalid matrix row index");
        }
        if (!isRowIndexValid(targetRow)) {
            throw new IllegalArgumentException("Invalid matrix row index");
        }
        if (selectRow == targetRow) {
            throw new IllegalArgumentException("Select row and target row are the same");
        }
        for (int i = 0; i < cols; i++) {
            data[targetRow][i] += data[selectRow][i] * scalar;
        }
    }

    /**
     * Performs an elementary column transformation on the matrix. This
     * operation adds a multiple of one column to another column. The
     * transformation is: targetCol = targetCol + scalar * selectCol
     *
     * @param selectCol the index of the source column to be multiplied by
     * scalar
     * @param targetCol the index of the target column to be modified
     * @param scalar the multiplier for the source column
     * @throws IllegalArgumentException if column indices are invalid or if
     * selectCol equals targetCol
     */
    public void elementaryColTransform(int selectCol, int targetCol, double scalar) {
        if (!isColIndexValid(selectCol)) {
            throw new IllegalArgumentException("Invalid matrix column index");
        }
        if (!isColIndexValid(targetCol)) {
            throw new IllegalArgumentException("Invalid matrix column index");
        }
        if (selectCol == targetCol) {
            throw new IllegalArgumentException("Select column and target column are the same");
        }
        for (int i = 0; i < rows; i++) {
            data[i][targetCol] += data[i][selectCol] * scalar;
        }
    }

    /**
     * Swaps two rows in the matrix. This operation exchanges the contents of
     * row1 and row2.
     *
     * @param row1 the index of the first row to be swapped
     * @param row2 the index of the second row to be swapped
     * @throws IllegalArgumentException if row indices are invalid or if row1
     * equals row2
     */
    public void swapRows(int row1, int row2) {
        if (!isRowIndexValid(row1)) {
            throw new IllegalArgumentException("Invalid matrix row index");
        }
        if (!isRowIndexValid(row2)) {
            throw new IllegalArgumentException("Invalid matrix row index");
        }
        if (row1 == row2) {
            throw new IllegalArgumentException("Row1 and row2 are the same");
        }
        double[] temp = data[row1];
        data[row1] = data[row2];
        data[row2] = temp;
    }

    /**
     * Swaps two columns in the matrix. This operation exchanges the contents of
     * col1 and col2.
     *
     * @param col1 the index of the first column to be swapped
     * @param col2 the index of the second column to be swapped
     * @throws IllegalArgumentException if column indices are invalid or if col1
     * equals col2
     */
    public void swapCols(int col1, int col2) {
        if (!isColIndexValid(col1)) {
            throw new IllegalArgumentException("Invalid matrix column index");
        }
        if (!isColIndexValid(col2)) {
            throw new IllegalArgumentException("Invalid matrix column index");
        }
        if (col1 == col2) {
            throw new IllegalArgumentException("Col1 and col2 are the same");
        }
        for (int i = 0; i < rows; i++) {
            double temp = data[i][col1];
            data[i][col1] = data[i][col2];
            data[i][col2] = temp;
        }
    }
}
