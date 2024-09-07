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

#include <malloc.h>
#include "constDef.h"
#include "matrix.h"
#include "memswap.h"
#include "random.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include <math.h>

#include "list.h"
#include "stack.h"
#include "toolbox.h"


/**
 * Creates a new element position structure with the given row, column, and value.
 *
 * @param row The row index of the element.
 * @param col The column index of the element.
 * @param value The value of the element.
 *
 * @return An elem_pos structure containing the specified row, column, and value.
 */
elem_pos new_elem_pos(const unsigned int row, const unsigned int col, MATRIX_TYPE value) {
    elem_pos new_pos = {row, col, value};
    return new_pos;
}


/**
 * @brief Compare two arrays of integers or doubles.
 *
 * @param a Pointer to the first array.
 * @param b Pointer to the second array.
 * @param type The type of the arrays.
 *
 * @return 0 if the arrays are equal, 1 if they are not equal, and 1 if the type is neither _INT_ nor _DOUBLE_.
 */
static int array_cmp(const void *a, const void *b, enum ARRAY_CMP_TYPE type) {
    // Check if the type is _INT_
    if (type == _INT_) {
        // Cast the pointers to int pointers
        const int *pa = (int *) a;
        const int *pb = (int *) b;
        // Check if the lengths of the arrays are equal
        if (LENGTH(a) != LENGTH(b)) {
            return 1;
        }
        // Compare the arrays using memcmp
        return memcmp(pa, pb, LENGTH(a) * sizeof(int));
    }
    // Check if the type is _DOUBLE_
    if (type == _DOUBLE_) {
        // Cast the pointers to double pointers
        const double *pa = (double *) a;
        const double *pb = (double *) b;
        // Print the lengths of the arrays
        printf("a_len = %llu, b_len = %llu\n", LENGTH(a), LENGTH(b));
        // Check if the lengths of the arrays are equal
        if (LENGTH(a) != LENGTH(b)) {
            return 1;
        }
        // Compare the arrays using memcmp
        return memcmp(pa, pb, LENGTH(a) * sizeof(double));
    }
    // Return 1 if the type is neither _INT_ nor _DOUBLE_
    return 1;
}

/**
 * Creates a matrix filled with ones.
 *
 * This function generates a matrix with the specified number of rows and columns,
 * and fills it with the value 1.0. The number of arguments determines the number
 * of parameters to be set.
 *
 * @param num The number of arguments passed to the function.
 * @param ... Variable number of arguments. Can be 1, 2, or 3.
 *             - 1 argument: The number of rows, which is also used as the number of columns.
 *             - 2 arguments: The number of rows and columns.
 *             - 3 arguments: The number of rows, columns, and the value to fill the matrix with.
 * @return A pointer to the newly created matrix, or NULL on error.
 */
Matrix *__ones_matrix(const int num, ...) {
    unsigned int rows; ///< The number of rows in the matrix.
    unsigned int cols; ///< The number of columns in the matrix.
    MATRIX_TYPE value = 1.0; ///< The value to fill the matrix with.

    // Parse the variable number of arguments
    if (num == 1) {
        // One argument: rows = cols
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = rows;
        va_end(ap);
    } else if (num == 2) {
        // Two arguments: rows and cols
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = va_arg(ap, unsigned int);
        va_end(ap);
    } else if (num == 3) {
        // Three arguments: rows, cols, and value
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = va_arg(ap, unsigned int);
        value = va_arg(ap, MATRIX_TYPE);
        va_end(ap);
    } else {
        // Invalid number of arguments
        PERROR(PARAMETERS_NUM_ERROR_002, 1, 3, __FILE__, __FUNCTION__, __LINE__);
    }

    // Check for invalid input
    if (rows == 0 || cols == 0) {
        PWARNING_RETURN(INPUT_NULL_004, VAR_NAME(rows), VAR_NAME(cols), __FILE__, __FUNCTION__, __LINE__);
    }

    // Generate the matrix
    Matrix *mat = matrix_gen(rows, cols, NULL);

    // Check for memory allocation error
    if (mat == NULL) {
        PWARNING(PARAMETER_VALUE_ERROR_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
        return NULL;
    }

    // Check for invalid value
    if (DOUBLE_COMP_EQ2ZERO(value)) {
        PWARNING(VALUE_TYPE_WARNING_001, 0, __FILE__, __FUNCTION__, __LINE__);
    }

    // Fill the matrix with the specified value
    for (int i = 0; i < rows * cols; i++) {
        mat->data[i] = value;
    }

    return mat;
}

/**
 * Dynamically generates a matrix with the specified number of rows and columns.
 * If data is provided, it is copied into the matrix; otherwise, the matrix is initialized with zeros.
 *
 * @param rows The number of rows in the matrix.
 * @param cols The number of columns in the matrix.
 * @param data The data to be copied into the matrix (optional).
 *
 * @return A pointer to the generated matrix, or NULL if memory allocation fails.
 *
 * @throws INPUT_NULL_004 if rows or cols is zero.
 * @throws MALLOC_FAILURE_001 if memory allocation fails.
 */
inline Matrix *matrix_gen(const unsigned int rows, const unsigned int cols, const MATRIX_TYPE *data) {
    // Check for invalid input (zero rows or columns)
    if (rows == 0 || cols == 0) {
        // Log error and return NULL
        PWARNING_RETURN(INPUT_NULL_004, VAR_NAME(rows), VAR_NAME(cols), __FILE__, __FUNCTION__, __LINE__);
    }

    // Allocate memory for the matrix structure
    Matrix *mat = (Matrix *) malloc(sizeof(Matrix));

    // Check for memory allocation failure
    if (mat == NULL) {
        // Free any partially allocated memory and log error
        matrix_free(&mat);
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
    }

    // Initialize matrix properties
    mat->rows = rows;
    mat->cols = cols;
    // mat->size = new_matrix_size(rows, cols);

    // Allocate memory for the matrix data
    mat->data = (MATRIX_TYPE *) malloc(rows * cols * sizeof(MATRIX_TYPE));

    // Check for memory allocation failure
    if (mat->data == NULL) {
        // Free any partially allocated memory and log error
        matrix_free(&mat);
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Copy provided data into the matrix (if any)
    const int len = LENGTH(data);
    if (len > 0) {
        // Copy data into the matrix
        memcpy(mat->data, data, len * sizeof(MATRIX_TYPE));
    }

    // Initialize any remaining matrix elements to zero
    for (int i = len; i < rows * cols; i++) {
        mat->data[i] = 0;
    }

    // Return the generated matrix
    return mat;
}

/**
 * Creates an identity matrix with the specified number of rows and columns,
 * and fills it with ones or a specified value. It supports variable number of arguments.
 *
 * @param num The number of arguments passed to the function.
 * @param ... Variable number of arguments. If num is 1, a single argument specifying the size of the square identity matrix.
 *             If num is 2, two arguments specifying the number of rows and columns.
 *             If num is 3, three arguments specifying the number of rows, columns, and the fill value.
 *
 * @return A pointer to the generated identity matrix, or NULL if an error occurs.
 *
 * @throws PARAMETERS_NUM_ERROR_002 If the number of arguments is not 1, 2, or 3.
 * @throws INPUT_NULL_004 If the number of rows or columns is zero.
 * @throws PARAMETER_VALUE_ERROR_001 If the generated matrix is NULL.
 * @throws VALUE_TYPE_WARNING_001 If the fill value is zero.
 */
inline Matrix *__eye_matrix(const int num, ...) {
    // Initialize variables to store the number of rows and columns
    unsigned int rows;
    unsigned int cols;

    // Initialize the fill value to 1.0 by default
    MATRIX_TYPE value = 1.0;

    // Handle variable number of arguments
    if (num == 1) {
        // If only one argument is provided, create a square identity matrix
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = rows; // Set columns to equal rows for a square matrix
        va_end(ap);
    } else if (num == 2) {
        // If two arguments are provided, create a rectangular identity matrix
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = va_arg(ap, unsigned int);
        va_end(ap);
    } else if (num == 3) {
        // If three arguments are provided, create a rectangular identity matrix with a custom fill value
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = va_arg(ap, unsigned int);
        value = va_arg(ap, MATRIX_TYPE); // Set the fill value to the provided value
        va_end(ap);
    } else {
        // If an invalid number of arguments is provided, throw an error
        PERROR(PARAMETERS_NUM_ERROR_002, 1, 3, __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if the number of rows or columns is zero
    if (rows == 0 || cols == 0) {
        // If either is zero, throw an error
        PWARNING_RETURN(INPUT_NULL_004, VAR_NAME(rows), VAR_NAME(cols), __FILE__, __FUNCTION__, __LINE__);
    }

    // Generate a matrix with the specified number of rows and columns
    Matrix *mat = matrix_gen(rows, cols, NULL);

    // Check if the generated matrix is NULL
    if (mat == NULL) {
        // If the matrix is NULL, throw an error
        PWARNING(PARAMETER_VALUE_ERROR_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
        return NULL;
    }

    // Check if the fill value is zero
    if (DOUBLE_COMP_EQ2ZERO(value)) {
        // If the fill value is zero, throw a warning
        PWARNING(VALUE_TYPE_WARNING_001, 0, __FILE__, __FUNCTION__, __LINE__);
    }

    // Fill the diagonal of the matrix with the specified fill value
    for (int i = 0; i < MIN(rows, cols); i++) {
        mat->data[IDX(cols, i, i)] = value;
    }

    // Return the generated identity matrix
    return mat;
}

/**
 * Creates a matrix filled with ones.
 *
 * This function generates a matrix with the specified number of rows and columns,
 * and fills it with ones.
 *
 * @param rows The number of rows in the matrix.
 * @param cols The number of columns in the matrix.
 *
 * @return A pointer to the generated matrix, or NULL if an error occurs.
 *
 * @throws PARAMETERS_NUM_ERROR_002 If the number of arguments is not 1, 2, or 3.
 * @throws INPUT_NULL_004 If the number of rows or columns is zero.
 * @throws PARAMETER_VALUE_ERROR_001 If the generated matrix is NULL.
 * @throws VALUE_TYPE_WARNING_001 If the fill value is zero.
 */
Matrix *ones_matrix(const unsigned int rows, const unsigned int cols) {
    return ones_matrix_value(rows, cols);
}

/**
 * Prints the elements of a matrix to the console.
 *
 * This function takes a matrix as input and prints its elements in a formatted manner.
 * If the matrix has a large number of rows or columns, it omits some of the elements and prints an ellipsis instead.
 *
 * @param mat The matrix to be printed.
 *
 * @return None
 *
 * @throws PWARNING_RETURN_INPUT_NO_NULL If the input matrix is NULL.
 */
void matrix_print(const Matrix *mat) {
    // Check if the input matrix is NULL and return if so
    PWARNING_RETURN_INPUT_NO_NULL(mat);

    // Get the number of rows and columns in the matrix
    const int rows = mat->rows, cols = mat->cols;

    // Check if the matrix has a large number of rows or columns
    if (rows > MATRIX_ROWS_OMIT_PRINT_LIMIT || cols > MATRIX_COLS_OMIT_PRINT_LIMIT) {
        // Print the matrix with omitted elements
        print_matrix_with_omitted_elements(mat, rows, cols);
    } else {
        // Print the matrix without omitting any elements
        print_matrix_without_omitting_elements(mat, rows, cols);
    }

    // Print the number of rows and columns in the matrix
    printf("Matrix rows: %d, cols: %d\n", rows, cols);
}

/**
 * Prints the matrix with omitted elements.
 *
 * This function prints the matrix with omitted elements, replacing them with an ellipsis.
 *
 * @param mat The matrix to be printed.
 * @param rows The number of rows in the matrix.
 * @param cols The number of columns in the matrix.
 */
static void print_matrix_with_omitted_elements(const Matrix *mat, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        // Check if we need to print an ellipsis for the current row
        if (i == 2 && rows > MATRIX_ROWS_OMIT_PRINT_LIMIT) {
            // Print an ellipsis for the current row
            print_ellipsis_row(mat, cols);
            // Skip to the last row
            i = rows - 3;
            continue;
        } else {
            // Print a vertical line to separate the rows
            printf("%c\t", '|');
        }

        // Print the elements of the current row
        for (int j = 0; j < cols; j++) {
            // Check if we need to print an ellipsis for the current column
            if (j == 2 && cols > MATRIX_COLS_OMIT_PRINT_LIMIT) {
                // Print an ellipsis for the current column
                printf("%s\t", "...");
                // Skip to the last column
                j = cols - 2;
            }
            // Print the element at the current position
            printf(MATRIX_DEFAULT_PRECISION, mat->data[IDX(cols, i, j)]);
        }

        // Print a vertical line to separate the rows
        printf("%c\t", '|');
        // Print a newline to separate the rows
        printf("\n");
    }
}

/**
 * Prints the matrix without omitting any elements.
 *
 * This function prints the matrix without omitting any elements.
 *
 * @param mat The matrix to be printed.
 * @param rows The number of rows in the matrix.
 * @param cols The number of columns in the matrix.
 */
static void print_matrix_without_omitting_elements(const Matrix *mat, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        // Print a vertical line to separate the rows
        printf("%c\t", '|');

        // Print the elements of the current row
        for (int j = 0; j < cols; j++) {
            // Print the element at the current position
            printf(MATRIX_DEFAULT_PRECISION, mat->data[IDX(cols, i, j)]);
        }

        // Print a vertical line to separate the rows
        printf("%c\t", '|');
        // Print a newline to separate the rows
        printf("\n");
    }
}

/**
 * Prints an ellipsis row.
 *
 * This function prints an ellipsis row, replacing the elements with an ellipsis.
 *
 * @param mat The matrix to be printed.
 * @param cols The number of columns in the matrix.
 */
static void print_ellipsis_row(const Matrix *mat, int cols) {
    // Print an ellipsis for the current row
    printf("%-10s\t", "⋮");

    // Print an ellipsis for each column
    for (int j = 0; j < cols; j++) {
        // Print an ellipsis for the current column
        printf("%-10s\t", "⋮");
    }

    // Print a newline to separate the rows
    printf("\n");
}

/**
 * Dynamically generates a matrix with the specified number of rows and columns,
 * and populates it with data from a given array.
 *
 * @param rows The number of rows in the matrix.
 * @param cols The number of columns in the matrix.
 * @param data The data to be copied into the matrix.
 * @param data_rows The number of rows in the data array.
 * @param data_cols The number of columns in the data array.
 *
 * @return A pointer to the generated matrix, or NULL if memory allocation fails.
 *
 * @throws INVALID_INPUT_003 if the data array length does not match the product of data_rows and data_cols.
 * @throws INVALID_INPUT_002 if rows or cols is less than the corresponding dimension in the data array.
 */
Matrix *matrix_gen_r(const unsigned int rows, const unsigned int cols, const MATRIX_TYPE *data,
                     const unsigned int data_rows,
                     const unsigned int data_cols) {
    // Check if the data array length matches the product of data_rows and data_cols
    if (data_cols * data_rows != LENGTH(data)) {
        PERROR(INVALID_INPUT_003, VAR_NAME(data), data_rows * data_cols, __FILE__, __FUNCTION__,
               __LINE__);
    }

    // If the data array is NULL or its length matches the product of rows and cols,
    // return a matrix generated with the given data
    if (data == NULL || LENGTH(data) == rows * cols) {
        return matrix_gen(rows, cols, data);
    }

    // Check if rows is less than data_rows
    if (rows < data_rows) {
        PERROR(INVALID_INPUT_002, "rows", data_rows, __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if cols is less than data_cols
    if (cols < data_cols) {
        PERROR(INVALID_INPUT_002, "cols", data_cols, __FILE__, __FUNCTION__, __LINE__);
    }

    // Generate a matrix with the given rows and cols
    Matrix *mat = matrix_gen(rows, cols, NULL);
    PWARNING_RETURN_MALLOC(mat);

    // Populate the matrix with data from the given array
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            // If the current index is within the bounds of the data array,
            // copy the corresponding element into the matrix
            if (i < data_rows && j < data_cols) {
                mat->data[IDX(cols, i, j)] = data[IDX(data_cols, i, j)];
            } else {
                // Otherwise, set the element to 0
                mat->data[IDX(cols, i, j)] = 0;
            }
        }
    }

    return mat;
}

/**
 * Copies a matrix into another matrix.
 *
 * This function creates a deep copy of the input matrix, allocating new memory for the copy.
 * If the input matrix is NULL, it throws a warning and returns NULL.
 *
 * @param _source_mat The matrix to be copied.
 * @return A pointer to the copied matrix, or NULL if memory allocation fails.
 * @throws PWARNING_RETURN_INPUT_NO_NULL If the input matrix is NULL.
 */
Matrix *matrix_copy(const Matrix *_source_mat) {
    // Check if the input matrix is NULL and throw a warning if so
    PWARNING_RETURN_INPUT(_source_mat);
    Matrix *new_mat = malloc(sizeof(Matrix));
    PWARNING_RETURN_MALLOC(new_mat);
    new_mat->rows = _source_mat->rows;
    new_mat->cols = _source_mat->cols;
    // new_mat->size = _source_mat->size;
    new_mat->data = malloc(sizeof(MATRIX_TYPE) * _source_mat->rows * _source_mat->cols);
    if (new_mat->data == NULL) {
        matrix_free(&new_mat);
        return NULL;
    }
    memcpy(new_mat->data, _source_mat->data, sizeof(MATRIX_TYPE) * _source_mat->rows * _source_mat->cols);
    return new_mat;
}

/**
 * Copies the contents of a source matrix into a destination matrix.
 *
 * This function frees the existing contents of the destination matrix and
 * replaces it with a copy of the source matrix.
 *
 * @param dest The destination matrix to be copied into.
 * @param src The source matrix to be copied from.
 *
 * @return None
 *
 * @throws PWARNING_RETURN_INPUT_NO_NULL If the source matrix is NULL.
 * @throws PWARNING_RETURN_MALLOC_NO_NULL If memory allocation fails.
 */
void matrix_copy_r(Matrix **dest, const Matrix *src) {
    // Check if the source matrix is NULL
    PWARNING_RETURN_INPUT_NO_NULL(src);

    // Free the existing contents of the destination matrix
    matrix_free(dest);

    // Copy the source matrix into the destination matrix
    *dest = matrix_copy(src);
}

/**
 * This function copies the contents of a source matrix into a destination matrix,
 * frees the memory allocated for the source matrix, and updates the destination matrix pointer.
 *
 * @param dest Pointer to the destination matrix.
 * @param src Pointer to the source matrix.
 *
 * @return None
 *
 * @throws PWARNING_RETURN_INPUT_NO_NULL If the destination or source matrix is NULL.
 * @throws PWARNING_RETURN_MALLOC_NO_NULL If memory allocation fails.
 */
void matrix_copy_free(Matrix **dest, Matrix **src) {
    // Check if the destination matrix is NULL
    PWARNING_RETURN_INPUT_NO_NULL(dest);

    // Check if the source matrix is NULL
    PWARNING_RETURN_INPUT_NO_NULL(*src);

    // Free the memory allocated for the destination matrix
    matrix_free(dest);

    // Copy the contents of the source matrix into the destination matrix
    *dest = matrix_copy(*src);

    // Free the memory allocated for the source matrix
    matrix_free(src);
}

/**
 * Frees the memory allocated for a matrix.
 *
 * @param[in] mat Pointer to the matrix whose memory is to be freed.
 * @param mat The matrix whose memory is to be freed.
 *
 * @return None
 *
 * @throws PWARNING_RETURN_INPUT_NO_NULL If the input matrix is NULL.
 */
void matrix_free(Matrix **mat) {
    if (mat == NULL || *mat == NULL) {
        // If the input matrix is NULL, return immediately
        return;
    }

    // Free the memory allocated for the matrix data
    FREE((*mat)->data);

    // Free the memory allocated for the matrix structure
    FREE(*mat);
}

/**
 * Generates a matrix filled with zeros.
 *
 * This function creates a new matrix with the specified number of rows and columns,
 * and initializes all elements to zero.
 *
 * @param rows The number of rows in the matrix.
 * @param cols The number of columns in the matrix.
 *
 * @return A pointer to the generated matrix, or NULL if memory allocation fails.
 *
 * @throws PWARNING_RETURN_INPUT_NO_NULL If the input matrix is NULL.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
Matrix *zeros_matrix(const unsigned int rows, const unsigned int cols) {
    // Call matrix_gen to create a new matrix with the specified dimensions and NULL data
    // This will result in a matrix filled with zeros
    return matrix_gen(rows, cols, NULL);
}

/**
 * Generates an identity matrix with the specified number of rows and columns.
 *
 * An identity matrix is a square matrix with ones on the main diagonal and zeros elsewhere.
 * This function creates an identity matrix with the specified number of rows and columns.
 *
 * @param rows The number of rows in the matrix.
 * @param cols The number of columns in the matrix.
 *
 * @return A pointer to the generated identity matrix.
 *
 * @throws INPUT_NULL_004 If the number of rows or columns is zero.
 * @throws PARAMETER_VALUE_ERROR_001 If the generated matrix is NULL.
 */
Matrix *eye_matrix(const unsigned int rows, const unsigned int cols) {
    // Delegate the actual creation of the identity matrix to eye_matrix_value
    // This allows for a simple and consistent interface while hiding the implementation details
    return eye_matrix_value(rows, cols);
}

/**
 * Generates a random matrix with the specified number of rows and columns,
 * and fills it with random values within the specified range.
 *
 * @param rows The number of rows in the matrix.
 * @param cols The number of columns in the matrix.
 * @param min The minimum value of the random range.
 * @param max The maximum value of the random range.
 *
 * @return A pointer to the generated random matrix, or NULL if memory allocation fails.
 *
 * @throws INPUT_NULL_004 If the number of rows or columns is zero.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
Matrix *rand_matrix(const unsigned int rows, const unsigned int cols, MATRIX_TYPE min, MATRIX_TYPE max) {
    // Check if the input dimensions are valid
    if (rows == 0 || cols == 0) {
        // If not, throw an error with a descriptive message
        PWARNING_RETURN(INPUT_NULL_004, VAR_NAME(rows), VAR_NAME(cols), __FILE__, __FUNCTION__, __LINE__);
    }

    // Generate a new matrix with the specified dimensions and NULL data
    Matrix *mat = matrix_gen(rows, cols, NULL);
    // Check if the memory allocation was successful
    PWARNING_RETURN_MALLOC(mat);

    // Fill the matrix with random values within the specified range
    for (int i = 0; i < rows * cols; i++) {
        // Use the RAND function to generate a random value between min and max
        mat->data[i] = RAND(min, max, MATRIX_TYPE);
    }

    // Return the generated matrix
    return mat;
}

/**
 * Compares two matrices for equality.
 *
 * This function checks if two matrices have the same size and identical elements.
 * It returns 0 if the matrices are equal, and 1 otherwise.
 *
 * @param a Pointer to the first matrix.
 * @param b Pointer to the second matrix.
 *
 * @return 1 if the matrices are not equal, 0 if they are equal.
 *
 * @throws INPUT_NULL_007 If either matrix is NULL.
 */
int matrix_eq(const Matrix *a, const Matrix *b) {
    // Check if both matrices are non-NULL
    if (a != NULL && b != NULL) {
        if (a->cols != b->cols || a->rows != b->rows) {
            return 1;
        }

        // Compare the elements of the two matrices
        return array_cmp(a->data, b->data, _DOUBLE_);
    }

    // If either matrix is NULL, throw an error
    PWARNING(INPUT_NULL_007, VAR_NAME(a), VAR_NAME(b), 0, __FILE__, __FUNCTION__, __LINE__);
    return 1;
}

/**
 * Multiplies a matrix by another matrix or a scalar.
 *
 * This function takes a variable number of arguments. The first argument is the matrix to be multiplied.
 * The second argument is an integer indicating the type of multiplication:
 *  - 0: matrix multiplication (the third argument is the matrix to multiply by)
 *  - 1: scalar multiplication (the third argument is the scalar to multiply by)
 *
 * @param a The matrix to be multiplied.
 * @param ... A variable number of arguments, depending on the type of multiplication.
 *
 * @return The result of the matrix multiplication, or NULL if memory allocation fails.
 *
 * @throws MATRIX_SIZE_ERROR_001 If the number of columns in the first matrix does not match the number of rows in the second matrix.
 * @throws PARAMETER_VALUE_ERROR_001 If memory allocation fails.
 */
static Matrix *__matrix_mul(Matrix *a, ...) {
    // Check if the input matrix is valid
    PWARNING_RETURN_INPUT(a);

    // Initialize the variable argument list
    va_list ap;
    va_start(ap, a);

    // Get the type of multiplication from the variable argument list
    const int type_index = va_arg(ap, int);

    Matrix *mat; // The result matrix

    // Perform matrix multiplication
    if (type_index == 0) {
        // Get the second matrix from the variable argument list
        const Matrix *b = va_arg(ap, Matrix *);

        // Check if the second matrix is valid
        if (b == NULL) {
            va_end(ap);
            return NULL;
        }

        // Get the dimensions of the matrices
        const int a_rows = a->rows, a_cols = a->cols, b_cols = b->cols, b_rows = b->rows;

        // Check if the matrices can be multiplied
        if (a_cols != b_rows) {
            // Throw an error if the matrices cannot be multiplied
            PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
            va_end(ap);
        }

        // Allocate memory for the result matrix
        mat = matrix_gen(a_rows, b_cols, NULL);
        if (mat == NULL) {
            // Throw an error if memory allocation fails
            PWARNING(PARAMETER_VALUE_ERROR_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            va_end(ap);
            return NULL;
        }

        // Perform the matrix multiplication
        for (int i = 0; i < a_rows; i++) {
            for (int j = 0; j < b_cols; j++) {
                for (int k = 0; k < a_cols; k++) {
                    // Calculate the dot product of the rows and columns
                    mat->data[IDX(b_cols, i, j)] += a->data[IDX(a_cols, i, k)] * b->data[IDX(b_cols, k, j)];
                }
            }
        }
    }
    // Perform scalar multiplication
    else {
        // Get the scalar from the variable argument list
        const double scalar = va_arg(ap, double);

        // Allocate memory for the result matrix
        mat = matrix_gen(a->rows, a->cols, NULL);
        if (mat == NULL) {
            // Throw an error if memory allocation fails
            PWARNING(PARAMETER_VALUE_ERROR_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            va_end(ap);
            return NULL;
        }

        // Perform the scalar multiplication
        for (int i = 0; i < a->rows * a->cols; i++) {
            // Multiply each element of the matrix by the scalar
            mat->data[i] = a->data[i] * scalar;
        }
    }

    // Clean up the variable argument list
    va_end(ap);

    // Return the result matrix
    return mat;
}

/**
 * Multiplies two matrices.
 *
 * @param a The first matrix.
 * @param b The second matrix.
 *
 * @return The product of the two matrices.
 *
 * @throws MATRIX_SIZE_ERROR_001 If the number of columns in the first matrix does not match the number of rows in the second matrix.
 */
Matrix *matrix_mul(Matrix *a, Matrix *b) {
    // Call the __matrix_mul function with the appropriate arguments
    // The second argument is set to 0 to indicate matrix multiplication
    return __matrix_mul(a, 0, b);
}

/**
 * Multiplies two matrices.
 *
 * @param b The first matrix.
 * @param a The second matrix.
 *
 * @return The product of the two matrices.
 *
 * @throws MATRIX_SIZE_ERROR_001 If the number of columns in the first matrix does not match the number of rows in the second matrix.
 */
Matrix *matrix_right_mul(Matrix *a, Matrix *b) {
    // Call the __matrix_mul function with the appropriate arguments
    // The second argument is set to 0 to indicate matrix multiplication
    return __matrix_mul(b, 0, a);
}

/**
 * Multiplies a matrix by a scalar.
 *
 * @param a The matrix to be multiplied.
 * @param b The scalar to multiply by.
 *
 * @return The product of the matrix and the scalar.
 */
Matrix *matrix_mul_single(Matrix *a, const MATRIX_TYPE b) {
    return __matrix_mul(a, 1, b);
}

/**
 * Multiplies two matrices and stores the result in the first matrix.
 *
 * @param a The first matrix, which will be overwritten with the result.
 * @param b The second matrix.
 *
 * @return None
 *
 * @throws MATRIX_SIZE_ERROR_001 If the number of columns in the first matrix does not match the number of rows in the second matrix.
 */
void matrix_mul_void(Matrix *a, Matrix *b) {
    Matrix *temp = __matrix_mul(a, 0, b);
    matrix_copy_free(&a, &temp);
}

/**
 * Multiplies two matrices and stores the result in the first matrix.
 *
 * @param a The first matrix, which will be overwritten with the result.
 * @param b The second matrix.
 *
 * @return None
 *
 * @throws MATRIX_SIZE_ERROR_001 If the number of columns in the first matrix does not match the number of rows in the second matrix.
 */
void matrix_right_mul_void(Matrix *a, Matrix *b) {
    Matrix *temp = __matrix_mul(b, 0, a);
    matrix_copy_free(&b, &temp);
}

/**
 * Multiplies a matrix by a scalar and stores the result in the first matrix.
 *
 * @param a The matrix, which will be overwritten with the result.
 * @param b The scalar to multiply by.
 *
 * @return None
 */
void matrix_mul_single_void(Matrix *a, const MATRIX_TYPE b) {
    Matrix *temp = __matrix_mul(a, 1, b);
    matrix_copy_free(&a, &temp);
}

/**
 * Adds two matrices together element-wise and returns a new matrix.
 *
 * @param a Pointer to the first matrix to be added.
 * @param ... Variable number of arguments. The first argument should be an integer
 *            representing the type index (0 for addition, 1 for subtraction). The second
 *            argument should be a pointer to the second matrix to be added.
 *
 * @return A pointer to the newly created matrix with the sum of the input matrices, or
 *         NULL if an error occurred.
 *
 * @throws INPUT_NULL_005 If either input matrix is NULL.
 * @throws MATRIX_SIZE_ERROR_001 If the matrices have different sizes.
 * @throw MALLOC_FAILURE_001 If memory allocation fails.
 */
static Matrix *__matrix_add(Matrix *a, ...) {
    // Check if the first matrix is NULL
    PWARNING_RETURN_INPUT(a);

    // Get the variable number of arguments
    va_list ap;
    va_start(ap, a);

    // Get the type index and the second matrix
    const int type_index = va_arg(ap, int);
    const Matrix *b = va_arg(ap, Matrix *);

    // Check if the second matrix is NULL or its data is NULL
    if (b == NULL || b->data == NULL) {
        PWARNING(INPUT_NULL_005, VAR_NAME(b), VAR_NAME(b->data), __FILE__, __FUNCTION__, __LINE__);
        va_end(ap);
        return NULL;
    }

    // Get the number of rows and columns of the first matrix
    const int a_rows = a->rows, a_cols = a->cols;


    if (a_rows != b->rows || a_cols != b->cols) {
        va_end(ap);
        PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
    }

    // Create a new matrix with the same size as the first matrix
    Matrix *mat = matrix_gen(a_rows, a_cols, NULL);

    // Check if the new matrix is NULL
    if (mat == NULL) {
        PWARNING(PARAMETER_VALUE_ERROR_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
        va_end(ap);
        return NULL;
    }

    // Perform the element-wise addition or subtraction
    for (int i = 0; i < a_rows * a_cols; i++) {
        if (type_index == 0) {
            mat->data[i] = a->data[i] + b->data[i];
        } else {
            mat->data[i] = a->data[i] - b->data[i];
        }
    }

    return mat;
}

/**
 * Adds two matrices together.
 *
 * @param a Pointer to the first matrix to be added.
 * @param b Pointer to the second matrix to be added.
 *
 * @return A pointer to the newly created matrix with the sum of the input matrices, or NULL if an error occurred.
 *
 * @throws INPUT_NULL_005 If either input matrix is NULL.
 * @throws MATRIX_SIZE_ERROR_001 If the matrices have different sizes.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
Matrix *matrix_add(Matrix *a, Matrix *b) {
    return __matrix_add(a, 0, b);
}

/**
 * Subtracts two matrices.
 *
 * @param a Pointer to the first matrix to be subtracted from.
 * @param b Pointer to the second matrix to be subtracted.
 *
 * @return A pointer to the newly created matrix with the difference of the input matrices, or NULL if an error occurred.
 *
 * @throws INPUT_NULL_005 If either input matrix is NULL.
 * @throws MATRIX_SIZE_ERROR_001 If the matrices have different sizes.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
Matrix *matrix_sub(Matrix *a, Matrix *b) {
    return __matrix_add(a, 1, b);
}

/**
 * Adds two matrices together and stores the result in the first matrix.
 *
 * @param a Pointer to the first matrix to be added.
 * @param b Pointer to the second matrix to be added.
 *
 * @return None
 *
 * @throws INPUT_NULL_005 If either input matrix is NULL.
 * @throws MATRIX_SIZE_ERROR_001 If the matrices have different sizes.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
void matrix_add_void(Matrix *a, Matrix *b) {
    matrix_copy_free(&a, (Matrix **) __matrix_add(a, 0, b));
}

/**
 * Subtracts the second matrix from the first matrix and stores the result in the first matrix.
 *
 * @param a Pointer to the first matrix to be subtracted from.
 * @param b Pointer to the second matrix to be subtracted.
 *
 * @return None
 *
 * @throws INPUT_NULL_005 If either input matrix is NULL.
 * @throws MATRIX_SIZE_ERROR_001 If the matrices have different sizes.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
void matrix_sub_void(Matrix *a, Matrix *b) {
    matrix_copy_free(&a, (Matrix **) __matrix_add(a, 1, b));
}


/**
 * @brief Transposes a matrix in-place.
 *
 * This function takes a matrix as input and transposes it in-place.
 *
 * @param mat Pointer to the matrix to be transposed.
 *
 * @throws INPUT_NULL_005 If either the input matrix or its data is NULL.
 */
void matrix_transpose(Matrix *mat) {
    // Check if the input matrix or its data is NULL
    if (mat == NULL || mat->data == NULL) {
        // If either is NULL, print an error message and return
        PWARNING_RETURN_NO_NULL(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), VAR_NAME(mat->data), __FILE__,
                                __FUNCTION__,
                                __LINE__);
    }

    // Calculate the new number of columns and rows
    const int rows = mat->rows;
    const int cols = mat->cols;

    // Create a new matrix size struct
    // const matrix_size new_size = {new_rows, new_cols};

    // If the matrix is a 1x1 or 1xn or nx1 matrix, just update the size and return
    if (cols == 1 || rows == 1) {
        mat->cols = rows;
        mat->rows = cols;
        return;
    }
    Matrix *new_mat = matrix_gen(cols, rows,NULL);
    if (new_mat == NULL) {
        PWARNING_RETURN_MALLOC_NO_NULL(new_mat);
    }
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            const int index = IDX(cols, i, j);
            const int index2 = IDX(rows, j, i);
            new_mat->data[index2] = mat->data[index];
        }
    }
    matrix_copy_free(&mat, &new_mat);
}


/**
 * Creates a new transposed matrix from the input matrix.
 *
 * This function creates a copy of the input matrix, transposes it, and returns the transposed matrix.
 *
 * @param mat Pointer to the input matrix to be transposed.
 *
 * @return Pointer to the transposed matrix, or NULL on failure.
 *
 * @throws INPUT_NULL_005 If the input matrix is NULL.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
Matrix *matrix_transpose_r(const Matrix *mat) {
    // Create a copy of the input matrix
    Matrix *new = matrix_copy(mat);

    // Check if the copy operation failed
    if (new == NULL) {
        // If the copy operation failed, print an error message and return NULL
        PWARNING_RETURN_MALLOC(new);
    }

    // Transpose the copied matrix
    matrix_transpose(new);

    // Return the transposed matrix
    return new;
}

/**
 * Converts a matrix to a 2D array.
 *
 * This function takes a matrix as input and returns a 2D array representation of the matrix.
 * The function allocates memory for the 2D array and copies the matrix data into the array.
 *
 * @param mat The input matrix to be converted.
 *
 * @return A 2D array that is the result of converting the input matrix, or NULL if memory allocation fails.
 *
 * @throws INPUT_NULL_005 If the input matrix or its data is NULL.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
MATRIX_TYPE **matrix_to_2D_array(const Matrix *mat) {
    // Check if the input matrix or its data is NULL
    if (mat == NULL || mat->data == NULL) {
        // If either is NULL, return an error
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Allocate memory for the 2D array
    MATRIX_TYPE **array = (MATRIX_TYPE **) malloc(sizeof(MATRIX_TYPE *) * mat->rows);
    if (array == NULL) {
        // If memory allocation fails, return an error
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(array), __FILE__, __FUNCTION__, __LINE__);
    }

    // Get the number of rows and columns in the matrix
    const int rows = mat->rows, cols = mat->cols;

    // Iterate over each row in the matrix
    for (int i = 0; i < rows; i++) {
        // Allocate memory for the current row in the 2D array
        array[i] = (MATRIX_TYPE *) malloc(sizeof(MATRIX_TYPE) * cols);
        if (array[i] == NULL) {
            // If memory allocation fails, free any previously allocated memory and return an error
            for (int j = i; j >= 0; j--) {
                FREE(array[j]);
            }
            FREE(array);
            PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(array[i]), __FILE__, __FUNCTION__, __LINE__);
        }

        // Iterate over each column in the current row
        for (int j = 0; j < cols; j++) {
            // Copy the matrix data into the 2D array
            array[i][j] = mat->data[IDX(cols, i, j)];
        }
    }

    // Return the 2D array
    return array;
}

/**
 * Creates a Matrix from a 2D array.
 *
 * This function takes a 2D array and its dimensions as input, and returns a Matrix object.
 * It checks for invalid input and memory allocation failures, and throws exceptions accordingly.
 *
 * @param array the 2D array to convert
 * @param rows the number of rows in the array
 * @param cols the number of columns in the array
 *
 * @return the created Matrix
 *
 * @throws INVALID_INPUT_003 if the array is NULL or has an invalid length
 * @throws MALLOC_FAILURE_001 if memory allocation fails
 */
Matrix *matrix_from_2D_array(MATRIX_TYPE **array, const unsigned int rows, const unsigned int cols) {
    // Check for invalid input: NULL array or mismatched dimensions
    if (array == NULL || LENGTH(array) != rows) {
        // Throw exception with descriptive error message
        PWARNING_RETURN(INVALID_INPUT_003, VAR_NAME(LENGTH(array)), rows, __FILE__, __FUNCTION__, __LINE__);
    }

    // Check each row of the array for mismatched column length
    for (int i = 0; i < rows; i++) {
        if (LENGTH(array[i]) != cols) {
            // Throw exception with descriptive error message
            PWARNING_RETURN(INVALID_INPUT_003, VAR_NAME(LENGTH(array[i])), cols, __FILE__, __FUNCTION__, __LINE__);
        }
    }

    // Allocate memory for the Matrix object
    Matrix *mat = matrix_gen(rows, cols, NULL);
    if (mat == NULL) {
        // Throw exception if memory allocation fails
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
    }

    // Copy data from the 2D array to the Matrix object
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            // Use IDX macro to calculate index into Matrix data array
            mat->data[IDX(cols, i, j)] = array[i][j];
        }
    }

    // Return the created Matrix object
    return mat;
}

/**
 * Splices two matrices together.
 *
 * This function takes two matrices, `a` and `b`, and an axis `aix` to splice along.
 * It returns a new matrix that is the result of splicing `a` and `b` along the specified axis.
 *
 * @param a The first matrix to splice.
 * @param b The second matrix to splice.
 * @param aix The axis to splice along (0: vertical, 1: horizontal, 2: vertical from bottom, 3: horizontal from right).
 *
 * @return A new matrix that is the result of splicing `a` and `b`.
 *
 * @throws MATRIX_SIZE_ERROR_001 If the matrices are not the same size along the specified axis.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 * @throws INVALID_INPUT_005 If `aix` is not one of the allowed values.
 */
Matrix *matrix_splicing(const Matrix *a, const Matrix *b, const unsigned int aix) {
    // Handle edge cases where one or both matrices are NULL
    if (a == NULL && b == NULL) {
        // If both matrices are NULL, return NULL
        return NULL;
    }
    if (a == NULL) {
        // If only matrix `a` is NULL, return a copy of matrix `b`
        return matrix_copy(b);
    }
    if (b == NULL) {
        // If only matrix `b` is NULL, return a copy of matrix `a`
        return matrix_copy(a);
    }

    // Get the dimensions of the matrices
    const int a_rows = a->rows, a_cols = a->cols, b_rows = b->rows, b_cols = b->cols;

    // Calculate the total number of columns and rows in the resulting matrix
    const int a_col_plus_b_cols = a_cols + b_cols;
    const int a_rows_cols = a_rows * a_cols;
    const int b_rows_cols = b_rows * b_cols;

    // Create a new matrix to store the result
    Matrix *mat;

    // Splice the matrices along the specified axis
    switch (aix) {
        case 0:
            // Splice vertically
            if (a_cols != b_cols) {
                // Check if the matrices have the same number of columns
                PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
            }
        // Create a new matrix with the same number of columns as the input matrices
            mat = matrix_gen(a_rows + b_rows, a_cols, NULL);
            if (mat == NULL) {
                // Check if memory allocation failed
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            }
        // Copy the data from matrix `b` to the new matrix
            for (int i = 0; i < b_rows_cols; i++) {
                mat->data[i] = b->data[i];
            }
        // Copy the data from matrix `a` to the new matrix
            for (int i = b_rows_cols; i < b_rows_cols + a_rows_cols; i++) {
                mat->data[i] = a->data[i - b_rows_cols];
            }
            break;
        case 1:
            // Splice horizontally
            if (a_rows != b_rows) {
                // Check if the matrices have the same number of rows
                PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
            }
        // Create a new matrix with the same number of rows as the input matrices
            mat = matrix_gen(a_rows, a_col_plus_b_cols, NULL);
            if (mat == NULL) {
                // Check if memory allocation failed
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            }
        // Copy the data from matrix `a` to the new matrix
            for (int i = 0; i < a_rows; i++) {
                for (int j = 0; j < a_cols; j++) {
                    mat->data[IDX(a_col_plus_b_cols, i, j)] = a->data[IDX(a_cols, i, j)];
                }
                // Copy the data from matrix `b` to the new matrix
                for (int j = a_cols; j < a_col_plus_b_cols; j++) {
                    mat->data[IDX(a_col_plus_b_cols, i, j)] = b->data[IDX(b_cols, i, j - a_cols)];
                }
            }
            break;
        case 2:
            // Splice vertically from bottom
            if (a_cols != b_cols) {
                // Check if the matrices have the same number of columns
                PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
            }
        // Create a new matrix with the same number of columns as the input matrices
            mat = matrix_gen(a_rows + b_rows, a_cols, NULL);
            if (mat == NULL) {
                // Check if memory allocation failed
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            }
        // Copy the data from matrix `a` to the new matrix
            for (int i = 0; i < a_rows_cols; i++) {
                mat->data[i] = a->data[i];
            }
        // Copy the data from matrix `b` to the new matrix
            for (int i = a_rows_cols; i < b_rows_cols + a_rows_cols; i++) {
                mat->data[i] = b->data[i - a_rows_cols];
            }
            break;
        case 3:
            // Splice horizontally from right
            if (a_rows != b_rows) {
                // Check if the matrices have the same number of rows
                PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
            }
        // Create a new matrix with the same number of rows as the input matrices
            mat = matrix_gen(a_rows, a_cols + b_cols, NULL);
            if (mat == NULL) {
                // Check if memory allocation failed
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            }
        // Copy the data from matrix `b` to the new matrix
            for (int i = 0; i < a_rows; i++) {
                for (int j = 0; j < b_cols; j++) {
                    mat->data[IDX(a_col_plus_b_cols, i, j)] = b->data[IDX(b_cols, i, j)];
                }
                // Copy the data from matrix `a` to the new matrix
                for (int j = b_cols; j < a_col_plus_b_cols; j++) {
                    mat->data[IDX(a_col_plus_b_cols, i, j)] = a->data[IDX(a_cols, i, j - b_cols)];
                }
            }
            break;
        default:
            // Check if the axis is valid
            PERROR(INVALID_INPUT_005, VAR_NAME(aix), 0, 3, __FILE__, __FUNCTION__, __LINE__);
    }

    // Return the resulting matrix
    return mat;
}

/**
 * Extracts a sub-matrix from the given matrix.
 *
 * This function creates a new matrix containing the extracted sub-matrix.
 * The sub-matrix is defined by the given row and column indices, which are 1-indexed.
 *
 * @param a The input matrix.
 * @param begin_row The starting row index of the sub-matrix (1-indexed).
 * @param end_row The ending row index of the sub-matrix (1-indexed).
 * @param begin_col The starting column index of the sub-matrix (1-indexed).
 * @param end_col The ending column index of the sub-matrix (1-indexed).
 *
 * @return A new matrix containing the extracted sub-matrix.
 *
 * @throws INVALID_INPUT_006 If the row or column indices are out of range.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
Matrix *matrix_cat(const Matrix *a, const unsigned int begin_row, const unsigned int end_row,
                   const unsigned int begin_col,
                   const unsigned int end_col) {
    // Get the number of rows and columns in the input matrix
    const int a_rows = a->rows, a_cols = a->cols;

    // Check if the row indices are within the valid range
    if (MIN(begin_row, end_row) < 1 || MAX(begin_row, end_row) > a_rows) {
        // If not, throw an error
        PERROR(INVALID_INPUT_006, VAR_NAME(begin_row), VAR_NAME(end_row), 1, a_rows, __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if the column indices are within the valid range
    if (MIN(begin_col, end_col) < 1 || MAX(begin_col, end_col) > a_cols) {
        // If not, throw an error
        PERROR(INVALID_INPUT_006, VAR_NAME(begin_col), VAR_NAME(end_col), 1, a_cols, __FILE__, __FUNCTION__, __LINE__);
    }

    // Calculate the number of rows and columns in the sub-matrix
    const int mat_rows = abs(end_row - begin_row) + 1, mat_cols = abs(end_col - begin_col) + 1;

    // Create a new matrix to store the sub-matrix
    Matrix *mat = matrix_gen(mat_rows, mat_cols, NULL);

    // Check if memory allocation failed
    if (mat == NULL) {
        // If so, throw a warning and return
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
    }

    // Calculate the starting and ending indices for the sub-matrix
    const int start_rows_index = MIN(begin_row, end_row) - 1, start_cols_index = MIN(begin_col, end_col) - 1;
    const int end_rows_index = MAX(begin_row, end_row) - 1, end_cols_index = MAX(begin_col, end_col) - 1;

    // Copy the data from the input matrix to the sub-matrix
    for (int i = start_rows_index; i <= end_rows_index; i++) {
        for (int j = start_cols_index; j <= end_cols_index; j++) {
            // Use the IDX macro to calculate the index in the sub-matrix
            mat->data[IDX(mat_cols, i - start_rows_index, j - start_cols_index)] = a->data[IDX(a_cols, i, j)];
        }
    }

    // Return the sub-matrix
    return mat;
}

/**
 * Swaps two rows or columns in the given matrix.
 *
 * @param a The input matrix.
 * @param aix An integer indicating whether to swap rows (0) or columns (1).
 * @param select_index The index of the first row or column to be swapped (0-indexed).
 * @param aim_index The index of the second row or column to be swapped (0-indexed).
 *
 * @throws INVALID_INPUT_006 If the row or column index is out of range.
 * @throws INPUT_NULL_007 If the input matrix is NULL.
 * @throws INVALID_INPUT_005 If aix is not 0 or 1.
 */
void matrix_swap(const Matrix *a, const unsigned int aix, const unsigned int select_index,
                 const unsigned int aim_index) {
    // Check for NULL input matrix
    if (a == NULL || a->data == NULL) {
        // If NULL, print warning and return
        PWARNING_RETURN_NO_NULL(INPUT_NULL_007, VAR_NAME(a), VAR_NAME(a->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Get number of rows and columns in the matrix
    const int a_rows = a->rows, a_cols = a->cols;

    // Check if aix is 0 (rows) or 1 (columns)
    if (aix == 0) {
        // Check if row indices are within range
        if (MIN(select_index, aim_index) < 0 || MAX(select_index, aim_index) >= a_rows) {
            // If out of range, print error and return
            PERROR(INVALID_INPUT_006, VAR_NAME(select_index), VAR_NAME(aim_index), 0, a->cols - 1, __FILE__,
                   __FUNCTION__,
                   __LINE__);
        }

        // Check if row indices are the same
        if (select_index == aim_index) {
            // If same, no need to swap, return
            return;
        }

        // Swap rows using memswap
        _memswap(a->data + (size_t) (select_index * a_cols), a->data + (size_t) (aim_index * a_cols),
                 a_cols * sizeof(MATRIX_TYPE));

        // Old version of swapping rows (commented out)
        // for (int i = 0; i < a_cols; i++) {
        //     const MATRIX_TYPE temp = a->data[IDX(a_cols, select_index, i)];
        //     a->data[IDX(a_cols, select_index, i)] = a->data[IDX(a_cols, aim_index, i)];
        //     a->data[IDX(a_cols, aim_index, i)] = temp;
        // }

        // Return after swapping rows
        return;
    }

    // Check if aix is 1 (columns)
    if (aix == 1) {
        // Check if column indices are within range
        if (MIN(select_index, aim_index) < 0 || MAX(select_index, aim_index) >= a_cols) {
            // If out of range, print error and return
            PERROR(INVALID_INPUT_006, VAR_NAME(select_index), VAR_NAME(aim_index), 0, a->cols - 1, __FILE__,
                   __FUNCTION__, __LINE__);
        }

        // Check if column indices are the same
        if (select_index == aim_index) {
            // If same, no need to swap, return
            return;
        }

        // Swap columns using a loop
        for (int i = 0; i < a_rows; i++) {
            const MATRIX_TYPE temp = a->data[IDX(a_cols, i, select_index)];
            a->data[IDX(a_cols, i, select_index)] = a->data[IDX(a_cols, i, aim_index)];
            a->data[IDX(a_cols, i, aim_index)] = temp;
        }

        // Return after swapping columns
        return;
    }

    // If aix is not 0 or 1, print error and return
    PERROR(INVALID_INPUT_005, VAR_NAME(aix), 0, 1, __FILE__, __FUNCTION__, __LINE__);
}

/**
 * Compares two matrix elements based on the specified column index.
 *
 * This function takes in three parameters: the column index to compare, and two matrix elements.
 * It returns an integer indicating the result of the comparison:
 *  - 1 if the first element is greater than the second
 *  - 0 if the two elements are equal
 *  - -1 if the first element is smaller than the second
 *
 * @param index The column index to compare.
 * @param a The first matrix element to compare.
 * @param b The second matrix element to compare.
 *
 * @return 1 if the first element is greater, 0 if they are equal, and -1 if the first element is smaller.
 *
 * @throws None
 */
int matrix_default_cmp_r(void *index, const void *a, const void *b) {
    // Cast the column index to an unsigned integer
    const uintptr_t col = (uintptr_t) index;

    // Cast the matrix elements to pointers to MATRIX_TYPE
    const MATRIX_TYPE *p1 = (MATRIX_TYPE *) a;
    const MATRIX_TYPE *p2 = (MATRIX_TYPE *) b;

    // Compare the elements at the specified column index
    if (p1[col] > p2[col]) {
        // If the first element is greater, return 1
        return 1;
    } else if (p1[col] == p2[col]) {
        // If the elements are equal, return 0
        return 0;
    } else {
        // If the first element is smaller, return -1
        return -1;
    }
}

/**
 * Sorts a matrix by the values in the specified column.
 *
 * This function sorts the matrix in-place, meaning it modifies the original matrix.
 * It uses the qsort_s function from the C standard library to perform the sort.
 *
 * @param mat The matrix to sort.
 * @param col_index The index of the column to sort by.
 *
 * @return None
 *
 * @throws INVALID_INPUT_006 if the column index is out of range.
 * @throws INVALID_INPUT_007 if the matrix or its data is NULL.
 */
void matrix_sort_by_cols_values(const Matrix *mat, const unsigned int col_index) {
    // Check for invalid input
    if (mat == NULL || mat->data == NULL) {
        // If the matrix or its data is NULL, print an error message and return
        PWARNING_RETURN_NO_NULL(INPUT_NULL_007, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if the column index is out of range
    if (col_index >= mat->cols) {
        // If the column index is out of range, print an error message
        PERROR(INVALID_INPUT_006, VAR_NAME(col_index), 0, mat->cols - 1, __FILE__, __FUNCTION__, __LINE__);
    }

    // Perform the sort using qsort_s
    // The comparison function is matrix_default_cmp_r, which compares two matrix elements based on the specified column index
    // The arg parameter is used to pass the column index to the comparison function
    qsort_s(mat->data, mat->rows, sizeof(MATRIX_TYPE) * mat->cols, matrix_default_cmp_r,
            (void *) ((uintptr_t) col_index));
}

/**
 * Sorts a matrix by the number of zeros in each row.
 *
 * This function first counts the number of zeros in each row of the matrix,
 * then sorts the matrix based on this count.
 *
 * @param mat the input matrix to be sorted
 *
 * @return none
 *
 * @throws INPUT_NULL_007 if the matrix or its data is NULL
 * @throws MALLOC_FAILURE_001 if memory allocation fails for the temporary matrix
 * @throws MALLOC_FAILURE_002 if memory allocation fails for the spliced matrix
 */
void matrix_sort_by_zeros_num(const Matrix *mat) {
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN_NO_NULL(INPUT_NULL_007, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }
    // Get the number of rows and columns of the matrix
    const int rows = mat->rows, cols = mat->cols;
    // Generate a new matrix with the same number of rows and 1 column
    Matrix *temp = matrix_gen(rows, 1, NULL);
    if (temp == NULL || temp->data == NULL) {
        matrix_free(&temp);
        PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(temp), __FILE__, __FUNCTION__, __LINE__);
    }

    // Iterate through the matrix, and if a element is 0, add 1 to the corresponding element in the temp matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (DOUBLE_COMP_EQ2ZERO(mat->data[IDX(cols, i, j)])) {
                temp->data[IDX(1, i, 0)] += 1.0;
                continue;
            }
            // If a element is not 0, or we have reached the end of the row, break out of the loop
            if (mat->data[IDX(cols, i, j)] != 0 || j == cols - 1) {
                break;
            }
        }
    }
    // Splice the original matrix and the temp matrix together
    Matrix *tep_mat = matrix_splicing(mat, temp, 3);
    if (tep_mat == NULL || tep_mat->data == NULL) {
        matrix_free(&temp);
        PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_002, VAR_NAME(tep_mat), __FILE__, __FUNCTION__, __LINE__);
    }
    // Sort the spliced matrix by the values in the first column
    matrix_sort_by_cols_values(tep_mat, 0);
    matrix_free(&temp);
    // Concatenate the spliced matrix and the original matrix together
    temp = matrix_cat(tep_mat, 1, rows, 2, cols + 1);
    matrix_free(&tep_mat);
    // Copy the data from the temp matrix to the original matrix
    memcpy(mat->data, temp->data, rows * cols * sizeof(MATRIX_TYPE));
    matrix_free(&temp);
}

/**
 * Performs a partial Gaussian elimination on the given matrix.
 *
 * This function modifies the input matrix in-place by subtracting a multiple of one row from another row.
 *
 * @param mat The input matrix.
 * @param select_index The index of the row to select (i.e., the row whose multiple will be subtracted).
 * @param aim_index The index of the row to aim (i.e., the row that will be modified).
 * @param begin_index The starting column index for the elimination.
 * @param value The value to use for elimination (i.e., the multiple of the selected row).
 *
 * @return None
 *
 * @throws None
 */
void matrix_gauss_elimination_(const Matrix *mat, const unsigned int select_index, const unsigned int aim_index,
                               const int begin_index, const MATRIX_TYPE value) {
    // Perform elimination for each column starting from begin_index
    for (int i = begin_index; i < mat->cols; i++) {
        // Subtract the product of the selected row's element and the value from the aim row's element
        mat->data[IDX(mat->cols, aim_index, i)] -= mat->data[IDX(mat->cols, select_index, i)] * value;
    }

    // Check if the first element of the aim row is close to zero
    if (!DOUBLE_COMP_EQ2ZERO(mat->data[IDX(mat->cols, aim_index, begin_index)])) {
        // If not, explicitly set it to zero to avoid numerical instability
        mat->data[IDX(mat->cols, aim_index, begin_index)] = 0.0;
    }
}

/**
 * Performs a Gaussian elimination on the given matrix.
 *
 * @param mat The input matrix.
 *
 * @return None
 *
 * @throws INPUT_NULL_007 If the input matrix is NULL.
 */
void matrix_gauss_elimination(const Matrix *mat) {
    // Check if the input matrix is null or has no data
    if (mat == NULL || mat->data == NULL) {
        // Print a warning and return if the input matrix is null
        PWARNING_RETURN_NO_NULL(INPUT_NULL_007, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }
    // Get the number of rows and columns in the matrix
    const int rows = mat->rows, cols = mat->cols;

    /**
     * It is for testing purposes only and can be used but may cause serious errors
     * Normalize the matrix
     */
    {
        // matrix_normalization(mat);
    }

    // Sort the matrix by the number of zeros
    matrix_sort_by_zeros_num(mat);

    const int min = MIN(rows, cols);
    // Iterate through the matrix
    for (int i = 0; i < min; i++) {
        // Skip if the current element is zero
        if (DOUBLE_COMP_EQ2ZERO(mat->data[IDX(cols, i, i)])) {
            continue;
        }
        // Iterate through the matrix
        for (int j = i + 1; j < cols; j++) {
            // Skip if the current element is zero
            if (DOUBLE_COMP_EQ2ZERO(mat->data[IDX(cols, j, i)])) {
                break;
            }
            // Calculate the coefficient
            const MATRIX_TYPE coefficient = mat->data[IDX(cols, j, i)] / mat->data[IDX(cols, i, i)];
            // Iterate through the matrix
            matrix_gauss_elimination_(mat, i, j, i, coefficient);
        }
    }
}

/**
 * Normalizes the elements of a matrix by scaling them to the range [0, 1].
 *
 * @param mat Pointer to the matrix to be normalized.
 *
 * @throws INPUT_NULL_007 If either the input matrix or its data is NULL.
 */
void matrix_normalization(const Matrix *mat) {
    // Check if the matrix or its data is null and return an error if it is.
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN_NO_NULL(INPUT_NULL_007, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }
    // Initialize the minimum and maximum values to the first element of the matrix.
    MATRIX_TYPE min = mat->data[0], max = mat->data[0];
    // Iterate through the matrix and find the minimum and maximum values.
    for (int i = 1; i < mat->rows * mat->cols; i++) {
        if (mat->data[i] < min) {
            min = mat->data[i];
        }
        if (mat->data[i] > max) {
            max = mat->data[i];
        }
    }
    // If the minimum and maximum values are equal, return without normalizing.
    if (min == max) {
        return;
    }
    // Calculate the normalization factor and store it in a constant variable.
    const MATRIX_TYPE factor = 1.0 / (max - min);
    // Iterate through the matrix and normalize each element.
    for (int i = 0; i < mat->rows * mat->cols; i++) {
        if (DOUBLE_COMP_EQ2ZERO(mat->data[i])) {
            continue;
        }
        mat->data[i] = (mat->data[i] - min) * factor;
    }
}

/**
 * Calculates the rank of a given matrix.
 *
 * The rank of a matrix is the maximum number of linearly independent rows or columns.
 * This function uses Gaussian elimination to transform the matrix into row echelon form,
 * and then counts the number of non-zero rows.
 *
 * @param mat Pointer to the input matrix.
 *
 * @return The rank of the input matrix.
 *
 * @throws INPUT_NULL_009 If the input matrix or its data is NULL.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
int matrix_rank(const Matrix *mat) {
    // Check for invalid input
    if (mat == NULL || mat->data == NULL) {
        // If the input matrix or its data is NULL, print a warning and return 0
        PWARNING_RETURN_ZERO(INPUT_NULL_009, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Create a temporary matrix to perform Gaussian elimination
    Matrix *temp_mat = matrix_gen(mat->rows, mat->cols, mat->data);
    if (temp_mat == NULL || temp_mat->data == NULL) {
        // If memory allocation fails, print a warning and return 0
        PWARNING_RETURN_ZERO(MALLOC_FAILURE_001, VAR_NAME(temp_mat), __FILE__, __FUNCTION__, __LINE__);
    }

    // Perform Gaussian elimination on the temporary matrix
    matrix_gauss_elimination(temp_mat);

    // Print the transformed matrix (for debugging purposes)
    {
        // matrix_print(temp_mat);
    }

    // Initialize the rank to 0
    int rank = 0;

    // Count the number of non-zero rows in the transformed matrix
    for (int i = 0; i < MIN(temp_mat->rows, temp_mat->cols); i++) {
        // Check if the diagonal element is non-zero
        if (!DOUBLE_COMP_EQ2ZERO(temp_mat->data[IDX(temp_mat->cols, i, i)])) {
            // If the diagonal element is non-zero, increment the rank
            rank++;
        } else {
            // If the diagonal element is zero, break out of the loop
            break;
        }
    }

    // Free the temporary matrix
    matrix_free(&temp_mat);

    // Return the rank
    return rank;
}

/**
 * Compares two values of type MATRIX_TYPE for equality.
 *
 * @param a The first value to compare.
 * @param b The second value to compare.
 *
 * @return 1 if the values are equal, 0 otherwise.
 */
int matrix_default_find_cmp(const void *a, const void *b) {
    return *(MATRIX_TYPE *) a == *(MATRIX_TYPE *) b;
}

/**
 * Searches for elements in a matrix that match a given value based on a comparison function.
 *
 * @param mat Pointer to the input matrix.
 * @param value The value to search for in the matrix.
 * @param cmp_func A comparison function to determine if a matrix element matches the given value.
 *
 * @return A pointer to an array of element positions that match the given value, or NULL if no matches are found.
 *
 * @throws INPUT_NULL_005 If the input matrix is NULL.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
elem_pos_array *matrix_find(const Matrix *mat, MATRIX_TYPE value, __matrix_find_cmp_func cmp_func) {
    // Check if input matrix is NULL
    if (mat == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Create a new list to store element positions
    List *pos_list = newList();

    // Iterate over each element in the matrix
    for (int i = 0; i < mat->rows * mat->cols; i++) {
        // Get the current element's value
        MATRIX_TYPE *temp_mat_val = &mat->data[i];

        // Get the value to compare with
        MATRIX_TYPE *temp_val_cmp = &value;

        // Check if the current element matches the given value using the comparison function
        if (cmp_func(temp_mat_val, temp_val_cmp)) {
            // Create a new element position structure
            elem_pos *temp_pos = (elem_pos *) malloc(sizeof(elem_pos));

            // Check if memory allocation failed
            if (temp_pos == NULL) {
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(temp_pos), __FILE__, __FUNCTION__, __LINE__);
            }

            // Set the element position's row, column, and value
            temp_pos->row = i / mat->cols;
            temp_pos->col = i % mat->cols;
            temp_pos->value = mat->data[i];

            // Add the element position to the list
            listPushBack(pos_list, temp_pos);
        }
    }

    // Check if any matches were found
    if (pos_list->size == 0) {
        // Return NULL if no matches were found
        return NULL;
    }

    // Create a new array to store the element positions
    elem_pos *pos_arr = (elem_pos *) malloc(sizeof(elem_pos) * pos_list->size);

    // Check if memory allocation failed
    if (pos_arr == NULL) {
        // Delete the list and return an error
        deleteList(pos_list);
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(pos_arr), __FILE__, __FUNCTION__, __LINE__);
    }

    // Get the size of the list
    int size = pos_list->size;

    // Iterate over each element in the list
    for (int i = 0; i < size; i++) {
        // Get the top element from the list and remove it
        elem_pos *temp_pos = listGetTopAndPop(pos_list);

        // Copy the element position to the array
        pos_arr[i] = *temp_pos;

        // Free the element position structure
        free(temp_pos);
    }

    // Delete the list
    deleteList(pos_list);

    // Create a new element position array structure
    elem_pos_array *pos_arr_ptr = (elem_pos_array *) malloc(sizeof(elem_pos_array));

    // Check if memory allocation failed
    if (pos_arr_ptr == NULL) {
        // Free the array and return an error
        free(pos_arr);
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(pos_arr_ptr), __FILE__, __FUNCTION__, __LINE__);
    }

    // Set the size and element position array of the structure
    pos_arr_ptr->size = size;
    pos_arr_ptr->elem_pos_arr = pos_arr;

    // Return the element position array structure
    return pos_arr_ptr;
}

/**
 * Finds the minimum element in a matrix.
 *
 * This function iterates over all elements in the matrix and returns the smallest one.
 *
 * @param mat A pointer to the matrix to find the minimum element in.
 *
 * @return The minimum element in the matrix.
 *
 * @throws INPUT_NULL_009 If the input matrix or its data is NULL.
 */
MATRIX_TYPE matrix_min(const Matrix *mat) {
    // Check if the input matrix or its data is NULL
    if (mat == NULL || mat->data == NULL) {
        // If either is NULL, return an error with a warning message
        PWARNING_RETURN_ZERO(INPUT_NULL_009, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Initialize the minimum value to the first element of the matrix
    MATRIX_TYPE min = mat->data[0];

    // Iterate over all elements in the matrix
    for (int i = 1; i < mat->rows * mat->cols; i++) {
        // Check if the current element is smaller than the current minimum
        if (mat->data[i] < min) {
            // If it is, update the minimum value
            min = mat->data[i];
        }
    }

    // Return the minimum value found
    return min;
}

/**
 * Finds the maximum element in a matrix.
 *
 * @param mat A pointer to the matrix to find the maximum element in.
 * @return The maximum element in the matrix.
 * @throws INPUT_NULL_009 If the input matrix or its data is NULL.
 */
MATRIX_TYPE matrix_max(const Matrix *mat) {
    // Check if the input matrix or its data is NULL
    if (mat == NULL || mat->data == NULL) {
        // If either is NULL, return an error with a warning message
        PWARNING_RETURN_ZERO(INPUT_NULL_009, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Initialize the maximum value to the first element of the matrix
    MATRIX_TYPE max = mat->data[0];

    // Iterate over all elements in the matrix
    for (int i = 1; i < mat->rows * mat->cols; i++) {
        // Check if the current element is greater than the current maximum
        if (mat->data[i] > max) {
            // If it is, update the maximum value
            max = mat->data[i];
        }
    }

    // Return the maximum value found
    return max;
}

/**
 * Finds all positions of the minimum element in a matrix.
 *
 * @param mat A pointer to the matrix to find the minimum element positions in.
 *
 * @return A pointer to an array of positions of the minimum element.
 *
 * @throws INPUT_NULL_009 If the input matrix or its data is NULL.
 */
elem_pos_array *matrix_min_array(const Matrix *mat) {
    return matrix_find(mat, matrix_min(mat), matrix_default_find_cmp);
}

/**
 * Finds all positions of the maximum element in a matrix.
 *
 * @param mat A pointer to the matrix to find the maximum element positions in.
 *
 * @return A pointer to an array of positions of the maximum element.
 *
 * @throws INPUT_NULL_009 If the input matrix or its data is NULL.
 */
elem_pos_array *matrix_max_array(const Matrix *mat) {
    return matrix_find(mat, matrix_max(mat), matrix_default_find_cmp);
}

/**
 * Performs element-wise matrix multiplication between two matrices.
 *
 * This function multiplies the corresponding elements of two matrices
 * and returns the resulting matrix.
 *
 * @param a A pointer to the first matrix.
 * @param b A pointer to the second matrix.
 *
 * @return A pointer to the resulting matrix.
 *
 * @throws INPUT_NULL_005 If either of the input matrices is NULL.
 * @throws INPUT_NULL_005 If either of the input matrices' data is NULL.
 * @throws MATRIX_SIZE_ERROR_001 If the input matrices are not the same size.
 */
Matrix *matrix_cdot_mul(const Matrix *a, const Matrix *b) {
    // Check if either of the input matrices is NULL
    if (a == NULL || b == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(a), VAR_NAME(b), __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if either of the input matrices' data is NULL
    if (a->data == NULL || b->data == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(a->data), VAR_NAME(b->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if the input matrices are the same size
    if (a->rows != b->rows || a->cols != b->cols) {
        PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
    }

    Matrix *temp = matrix_copy(a);
    if (temp == NULL || temp->data == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_002, VAR_NAME(temp), __FILE__, __FUNCTION__, __LINE__);
    }

    // Perform element-wise multiplication
    for (int i = 0; i < a->rows * a->cols; i++) {
        temp->data[i] *= b->data[i];
    }

    // Return the resulting matrix
    return temp;
}

/**
 * Performs element-wise matrix multiplication between two matrices and assigns the result to the first matrix.
 *
 * This function multiplies the corresponding elements of two matrices and stores the result in the first matrix.
 *
 * @param a A pointer to the first matrix, which will be modified to hold the result.
 * @param b A pointer to the second matrix.
 *
 * @return None
 */
void matrix_cdot_mul_void(Matrix *a, const Matrix *b) {
    // Create a temporary matrix to hold the result of the multiplication
    Matrix *temp = matrix_cdot_mul(a, b);

    // Copy the result from the temporary matrix to the first matrix and free the temporary matrix
    matrix_copy_free(&a, &temp);
}

/**
 * Applies a given function to each element of a matrix.
 *
 * This function iterates over each element of the input matrix, applies the
 * given function to the element and the provided argument, and stores the
 * result back in the matrix.
 *
 * @param mat A pointer to the matrix to be modified.
 * @param arg A void pointer to an argument to be passed to the function.
 * @param func A pointer to a function that takes a MATRIX_TYPE and a void*
 *             as arguments and returns a MATRIX_TYPE.
 *
 * @return None
 *
 * @throws INPUT_NULL_005 If the input matrix or its data is NULL.
 */
void matrix_change(Matrix *mat, void *arg, MATRIX_TYPE (*func)(MATRIX_TYPE, void *)) {
    // Check if the input matrix or its data is NULL
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN_NO_NULL(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Iterate over each element of the matrix
    for (int i = 0; i < mat->rows * mat->cols; i++) {
        // Apply the given function to the current element and store the result
        mat->data[i] = func(mat->data[i], arg);
    }
}

/**
 * Swaps two elements in a matrix.
 *
 * This function takes a matrix and two positions as input, and swaps the elements at those positions.
 *
 * @param mat A pointer to the matrix to be modified.
 * @param pos1 The position of the first element to be swapped.
 * @param pos2 The position of the second element to be swapped.
 *
 * @return None
 *
 * @throws INPUT_NULL_005 If the input matrix or its data is NULL.
 * @throws INVALID_INPUT_006 If the row or column of either position is out of bounds.
 */
void matrix_swap_elem(Matrix *mat, elem_pos pos1, elem_pos pos2) {
    // Check if the input matrix or its data is NULL
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN_NO_NULL(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Get the number of columns and rows in the matrix
    const unsigned int cols = mat->cols, rows = mat->rows;

    // Check if the row or column of either position is out of bounds
    if (pos1.row >= rows || pos2.row >= rows) {
        PERROR(INVALID_INPUT_006, VAR_NAME(pos1.row), VAR_NAME(pos2.row), 0, rows - 1, __FILE__, __FUNCTION__,
               __LINE__);
    }
    if (pos1.col >= cols || pos2.col >= cols) {
        PERROR(INVALID_INPUT_006, VAR_NAME(pos1.col), VAR_NAME(pos2.col), 0, cols - 1, __FILE__, __FUNCTION__,
               __LINE__);
    }

    // Swap the elements at the two positions
    const MATRIX_TYPE temp = mat->data[IDX(mat->cols, pos1.row, pos1.col)];
    mat->data[IDX(mat->cols, pos1.row, pos1.col)] = mat->data[IDX(mat->cols, pos2.row, pos2.col)];
    mat->data[IDX(mat->cols, pos2.row, pos2.col)] = temp;
}

/**
 * Calculates the determinant of a matrix using Gaussian elimination.
 *
 * @param mat The input matrix.
 * @return The determinant of the matrix.
 */
static inline MATRIX_TYPE __matrix_det(Matrix *mat) {
    // Get the number of rows and columns in the matrix
    const int rows = mat->rows, cols = mat->cols;

    // Base case: 2x2 matrix
    if (rows == 2) {
        // Calculate the determinant directly
        return mat->data[IDX(cols, 0, 0)] * mat->data[IDX(cols, 1, 1)] - mat->data[IDX(cols, 0, 1)] * mat->data[
                   IDX(cols, 1, 0)];
    }
    // Base case: 1x1 matrix
    if (rows == 1) {
        // The determinant is the single element
        return mat->data[0];
    }

    // Initialize the determinant and the number of calculations
    MATRIX_TYPE det = 1.0;
    int calculate_times = 0;

    // Create a copy of the input matrix
    Matrix *new_mat = matrix_copy(mat);

    // Create a temporary matrix to store the number of zeros in each row
    const int temp_cols = 2;
    Matrix *temp = matrix_gen(rows, temp_cols, NULL);
    if (temp == NULL || temp->data == NULL) {
        // Handle memory allocation failure
        matrix_free(&temp);
        PWARNING_RETURN_ZERO(MALLOC_FAILURE_001, VAR_NAME(temp), __FILE__, __FUNCTION__, __LINE__);
    }

    // Initialize the maximum and minimum number of zeros
    int max_zero_num = 0;
    int min_zero_num = 0;

    // Iterate through the matrix to count the number of zeros in each row
    for (int i = 0; i < rows; i++) {
        temp->data[IDX(temp_cols, i, 1)] = i;
        for (int j = 0; j < cols; j++) {
            if (DOUBLE_COMP_EQ2ZERO(mat->data[IDX(cols, i, j)])) {
                // Increment the count of zeros for this row
                temp->data[IDX(temp_cols, i, 0)] += 1.0;
                continue;
            }
            // If a non-zero element is found, or we've reached the end of the row, break out of the loop
            if (mat->data[IDX(cols, i, j)] != 0 || j == cols - 1) {
                break;
            }
        }
        // Update the maximum and minimum number of zeros
        if (temp->data[IDX(temp_cols, i, 0)] > max_zero_num) {
            max_zero_num = temp->data[IDX(1, i, 0)];
        }
        if (temp->data[IDX(temp_cols, i, 0)] < min_zero_num) {
            min_zero_num = temp->data[IDX(1, i, 0)];
        }
    }
    if (max_zero_num == min_zero_num && min_zero_num != 0) {
        matrix_free(&temp);
        return 0.0;
    }

    // If the maximum and minimum number of zeros are different, sort the rows by the number of zeros
    if (max_zero_num != min_zero_num) {
        matrix_sort_by_cols_values(temp, 0);
        for (int i = rows - 1; i >= 0; i--) {
            if ((int) temp->data[IDX(temp_cols, i, 1)] == i) {
                continue;
            }
            // Swap the rows to put the row with the most zeros at the top
            matrix_swap(new_mat, 0, (int) temp->data[IDX(temp_cols, i, 1)], i);
            calculate_times++;
            for (int j = 0; j <= i; j++) {
                if ((int) temp->data[IDX(temp_cols, j, 1)] == i) {
                    temp->data[IDX(temp_cols, j, 1)] = temp->data[IDX(temp_cols, i, 1)];
                    break;
                }
            }
        }
    }
    // Free the temporary matrix
    matrix_free(&temp);

    // Perform Gaussian elimination
    const int min = MIN(rows, cols);
    for (int i = 0; i < min; i++) {
        // Skip if the current element is zero
        if (DOUBLE_COMP_EQ2ZERO(new_mat->data[IDX(cols, i, i)])) {
            continue;
        }
        // Iterate through the matrix to eliminate the elements below the pivot
        for (int j = cols - 1; j > i; j--) {
            // Skip if the current element is zero
            if (DOUBLE_COMP_EQ2ZERO(new_mat->data[IDX(cols, j, i)])) {
                break;
            }
            // Calculate the coefficient
            const MATRIX_TYPE coefficient = new_mat->data[IDX(cols, j, i)] / new_mat->data[IDX(cols, i, i)];
            // Eliminate the element
            matrix_gauss_elimination_(new_mat, i, j, i, coefficient);
            calculate_times++;
        }
        // Update the determinant
        det *= new_mat->data[IDX(cols, i, i)];
        // 如果最后一行最后一位为0，说明矩阵不满秩，直接返回0
        if (DOUBLE_COMP_EQ2ZERO(new_mat->data[(rows - 1) * (cols - 1)])) {
            matrix_free(&new_mat);
            return 0.0;
        }
    }
    matrix_free(&new_mat);

    // Return the determinant, taking into account the number of row swaps
    return det * pow(-1, calculate_times);
}

/**
 * Calculates the determinant of a matrix.
 *
 * This function checks for invalid input and then calls the internal
 * __matrix_det function to perform the actual calculation.
 *
 * @param mat The input matrix.
 * @return The determinant of the matrix.
 */
MATRIX_TYPE matrix_det(Matrix *mat) {
    // Check for null input
    if (mat == NULL || mat->data == NULL) {
        // If input is null, print a warning and return 0
        PWARNING_RETURN_ZERO(INPUT_NULL_009, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if matrix is square
    if (mat->rows != mat->cols) {
        // If matrix is not square, print an error and exit
        PERROR(MATRIX_SIZE_ERROR_002, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
    }

    // Perform the actual determinant calculation
    return __matrix_det(mat);
}

/**
 * Performs a division operation on two input values.
 *
 * This function checks for division by zero and returns an error value in that case.
 *
 * @param a The dividend.
 * @param b The divisor.
 * @return The result of the division operation, or an error value if b is zero.
 */
static inline MATRIX_TYPE divide(const MATRIX_TYPE a, const MATRIX_TYPE b) {
    if (b == 0) {
        // Handle division by zero
        // This could involve returning an error value, printing an error message, or throwing an exception
        return NAN; // Return Not a Number
    }

    // Perform the division operation
    return a / b;
}

/**
 * Calculates a new value for a row or column of a matrix.
 *
 * This function applies a given calculation function to each element of a row or column of a matrix.
 *
 * @param mat The input matrix.
 * @param select_index The index of the row or column to calculate.
 * @param start_index The starting index for the calculation (not used in this implementation).
 * @param caculate_c A constant value used in the calculation.
 * @param aix A flag indicating whether to calculate a row (0) or column (non-0).
 * @param caculate_func A function pointer to the calculation function to apply.
 */
static inline void matrix_row_or_col_calculate(Matrix *mat, const int select_index, const int start_index,
                                               const MATRIX_TYPE caculate_c, const unsigned int aix,
                                               MATRIX_TYPE (*caculate_func)(const MATRIX_TYPE, const MATRIX_TYPE)) {
    // Get the number of rows and columns in the matrix
    const int rows = mat->rows;
    const int cols = mat->cols;

    // Determine whether to calculate a row or column based on the aix flag
    if (aix == 0) {
        // Calculate a row
        for (int i = 0; i < cols; i++) {
            // Calculate the index of the current element
            const int index = IDX(cols, select_index, i);
            // Apply the calculation function to the current element
            mat->data[index] = caculate_func(mat->data[index], caculate_c);
        }
    } else {
        // Calculate a column
        for (int i = 0; i < rows; i++) {
            // Calculate the index of the current element
            const int index = IDX(cols, i, select_index);
            // Apply the calculation function to the current element
            mat->data[index] = caculate_func(mat->data[index], caculate_c);
        }
    }
}

/**
 * Checks if a matrix is an upper triangular matrix.
 *
 * An upper triangular matrix is a square matrix where all the elements below the main diagonal are zero.
 *
 * @param mat The input matrix to check.
 * @return 1 if the matrix is upper triangular, 0 if not, and -1 if the input matrix is null or invalid.
 */
inline int isUpTriangleMatrix(const Matrix *mat) {
    // Check for null input
    if (mat == NULL || mat->data == NULL) {
        // If input is null, return an error code
        return -1;
    }

    // Get the number of columns and rows in the matrix
    const int cols = mat->cols;
    const int rows = mat->rows;

    // Iterate over each row in the matrix
    for (int i = 0; i < rows; i++) {
        // Reset the zero counter for each row
        int zeros_count = 0;

        // Iterate over each column in the row
        for (int j = 0; j < cols; j++) {
            // Calculate the index of the current element in the matrix data array
            const int index = IDX(cols, i, j);

            // Check if the current element is zero
            if (DOUBLE_COMP_EQ2ZERO(mat->data[index])) {
                // If the element is zero, increment the zero counter
                zeros_count++;

                // If we've reached the end of the row or the next element is not zero, break out of the inner loop
                if (j == cols - 1 || !DOUBLE_COMP_EQ2ZERO(mat->data[index + 1])) {
                    break;
                }
            } else {
                if (j == 0) {
                    break;
                }
            }
        }

        // Check if the number of zeros in the row is equal to the row index
        if (zeros_count != i) {
            // If not, the matrix is not upper triangular, so return 0
            return 0;
        }
    }

    // If we've made it through all the rows without returning, the matrix is upper triangular, so return 1
    return 1;
}

/**
 * Checks if a matrix is a lower triangular matrix.
 *
 * A lower triangular matrix is a square matrix where all the elements above the main diagonal are zero.
 *
 * @param mat The input matrix to check.
 * @return 1 if the matrix is lower triangular, 0 if not, and -1 if the input matrix is null or invalid.
 */
inline int isLowerTriangleMatrix(const Matrix *mat) {
    // Check for null input
    if (mat == NULL || mat->data == NULL) {
        // If input is null, return an error code
        return -1;
    }

    // Initialize a counter for zeros in each row
    int zeros_count = 0;

    // Get the number of columns and rows in the matrix
    const int cols = mat->cols;
    const int rows = mat->rows;

    // Iterate over each row in the matrix
    for (int i = 0; i < rows; i++) {
        // Reset the zero counter for each row
        zeros_count = 0;

        // Iterate over each column in the row, starting from the last column
        for (int j = cols - 1; j >= 0; j--) {
            // Calculate the index of the current element in the matrix data array
            const int index = IDX(cols, i, j);

            // Check if the current element is zero
            if (DOUBLE_COMP_EQ2ZERO(mat->data[index])) {
                // If the element is zero, increment the zero counter
                zeros_count++;

                // If we've reached the first column or the previous element is not zero, break out of the inner loop
                if (j == 0 || !DOUBLE_COMP_EQ2ZERO(mat->data[index - 1])) {
                    break;
                }
            } else {
                if (j == cols - 1) {
                    break;
                }
            }
        }

        // Check if the number of zeros in the row is equal to the number of columns minus the row index minus 1
        if (zeros_count != cols - i - 1) {
            // If not, the matrix is not lower triangular, so return 0
            return 0;
        }
    }

    // If we've made it through all the rows without returning, the matrix is lower triangular, so return 1
    return 1;
}

/**
 * @brief Performs Gaussian inversion on a matrix.
 *
 * This function takes a matrix as input, performs Gaussian elimination, and returns the inverted matrix.
 *
 * @param mat The input matrix to be inverted.
 * @return Matrix* The inverted matrix, or NULL if the input matrix is singular.
 */
static inline Matrix *__matrix_gauss_invertion(Matrix *mat) {
    // Check for NULL input matrix or data
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if matrix is square
    if (mat->rows != mat->cols) {
        PERROR(MATRIX_SIZE_ERROR_002, __FILE__, __FUNCTION__, __LINE__);
    }

    const int rows = mat->rows;
    const int cols = mat->cols;

    // Create an identity matrix of the same size as the input matrix
    Matrix *temp_mat = eye_matrix(rows, cols);
    if (temp_mat == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(temp_mat), __FILE__, __FUNCTION__, __LINE__);
    }

    // Splice the input matrix with the identity matrix
    Matrix *new_mat = matrix_splicing(mat, temp_mat, 1);
    matrix_free(&temp_mat);

    // Check for NULL output matrix
    if (new_mat == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_mat), __FILE__, __FUNCTION__, __LINE__);
    }

    // Perform Gaussian elimination on the new matrix
    matrix_gauss_elimination(new_mat);

    // Check if the input matrix is singular
    if (DOUBLE_COMP_EQ2ZERO(new_mat->data[IDX(2 * cols, rows - 1, cols - 1)])) {
        matrix_free(&new_mat);
        PWARNING_RETURN(
            "The input matrix is singular, so it does not have an inverse.\nWill return NULL\n@File:%s\n@Function:%s\n@Line:%d\n",
            __FILE__, __FUNCTION__,
            __LINE__);
    }

    const int new_mat_cols = 2 * cols;

    // Perform back substitution to find the inverted matrix
    for (int i = rows - 1; i >= 0; i--) {
        const int index_i = IDX(new_mat_cols, i, i);
        matrix_row_or_col_calculate(new_mat, i, i, new_mat->data[index_i], 0, divide);
        for (int j = i - 1; j >= 0; j--) {
            const int index = IDX(new_mat_cols, i, j);
            if (DOUBLE_COMP_EQ2ZERO(new_mat->data[index])) {
                continue;
            }
            const MATRIX_TYPE confience = new_mat->data[index] / new_mat->data[index_i];
            matrix_gauss_elimination_(new_mat, i, j, j, confience);
        }
    }

    // Extract the inverted matrix from the new matrix
    Matrix *result_mat = matrix_cat(new_mat, 1, rows, cols + 1, new_mat_cols);
    matrix_free(&new_mat);

    // Check for NULL output matrix
    if (result_mat == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(result_mat), __FILE__, __FUNCTION__, __LINE__);
    }

    return result_mat;
}

/**
 * @brief Inverts a given matrix using Gaussian elimination.
 *
 * This function takes a matrix as input and returns its inverse.
 *
 * @param mat The input matrix to be inverted.
 * @return Matrix* The inverted matrix, or NULL if the input matrix is singular.
 */
Matrix *matrix_invert(Matrix *mat) {
    // Call the internal Gaussian inversion function to perform the inversion
    return __matrix_gauss_invertion(mat);
}

/**
 * @brief Compares two elem_pos objects based on their value.
 *
 * This function compares the value of two elem_pos objects and returns true if they are equal.
 *
 * @param a Pointer to the first elem_pos object.
 * @param b Pointer to the second elem_pos object.
 * @return true if the value of the two elem_pos objects are equal, false otherwise.
 */
static int isElemPosArrayMemberCmp(const void *a, const void *b) {
    // Cast the void pointers to elem_pos objects
    const elem_pos a1 = *(const elem_pos *) a;
    const elem_pos b1 = *(const elem_pos *) b;

    // Compare the value of the two elem_pos objects
    return a1.value == b1.value;
}

/**
 * Finds unique elements in a matrix and returns an array of their positions.
 *
 * @param mat Pointer to the input matrix.
 * @return A pointer to an array of unique element positions, or NULL if no unique elements are found.
 *
 * @throws INPUT_NULL_005 If the input matrix is NULL or its data is NULL.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
elem_pos_array *matrix_find_unique(const Matrix *mat) {
    // Check if input matrix or its data is NULL
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Initialize a stack to store unique element positions
    Stack *uniqeStack = stackInit();

    // Get the number of rows and columns in the matrix
    const int rows = mat->rows;
    const int cols = mat->cols;

    // Iterate over each element in the matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            // Calculate the index of the current element
            const int index = IDX(cols, i, j);

            // Create a new element position structure
            elem_pos newElemPos = {i, j, mat->data[index]};

            // Create a new stack element with the element position and its size
            stackElemWithSize newElem = {&newElemPos, sizeof(elem_pos)};

            // Check if the current element is unique or the stack is empty
            if (isStackMember(uniqeStack, newElem, isElemPosArrayMemberCmp) == 0 || stackIsEmpty(uniqeStack)) {
                // Push the new stack element onto the stack
                stackPush(uniqeStack, newElem.data, newElem.elemSize);
            }
        }
    }

    // Check if any unique elements were found
    if (uniqeStack->size == 0) {
        return NULL;
    }

    // Allocate memory for the unique element array
    elem_pos_array *uniqeArray = (elem_pos_array *) malloc(sizeof(elem_pos_array));
    if (uniqeArray == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(uniqeArray), __FILE__, __FUNCTION__, __LINE__);
    }

    // Set the size of the unique element array
    uniqeArray->size = uniqeStack->size;

    // Allocate memory for the unique element array data
    uniqeArray->elem_pos_arr = (elem_pos *) malloc(uniqeStack->size * sizeof(elem_pos));
    if (uniqeArray->elem_pos_arr == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(uniqeArray->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Swap the stack to get the unique elements in the correct order
    stackSwap(uniqeStack);

    // Copy the unique element positions from the stack to the array
    for (int i = 0; i < uniqeArray->size; i++) {
        stackElem elem = stackPop(uniqeStack);
        uniqeArray->elem_pos_arr[i] = *(elem_pos *) elem;
    }
    // Free the stack
    stackDestroy(&uniqeStack);

    // Return the unique element array
    return uniqeArray;
}

/**
 * Checks if a given value is a member of a matrix.
 *
 * @param mat  The input matrix to search in.
 * @param value The value to search for in the matrix.
 *
 * @return 1 if the value is found in the matrix, 0 otherwise.
 *         Returns -1 if the input matrix is NULL or its data is NULL.
 */
int isMatrixMember(const Matrix *mat, MATRIX_TYPE value) {
    // Check if the input matrix is NULL or its data is NULL
    if (mat == NULL || mat->data == NULL) {
        // If either is NULL, return an error code
        return -1;
    }

    // Calculate the length of the matrix data array
    const int len = mat->rows * mat->cols;

    // Iterate over the matrix data array
    for (int i = 0; i < len; i++) {
        // Check if the current element matches the given value
        if (mat->data[i] == value) {
            // If a match is found, return 1
            return 1;
        }
    }

    // If no match is found after iterating over the entire array, return 0
    return 0;
}

/**
 * Calculates the eigen matrix of a given square matrix.
 *
 * This function takes a square matrix as input, performs Gaussian elimination,
 * and returns the resulting eigen matrix.
 *
 * @param mat The input square matrix.
 *
 * @return The eigen matrix of the input matrix, or NULL if memory allocation fails.
 */
Matrix *matrix_eigen_matrix(Matrix *mat) {
    // Check if the input matrix is NULL
    if (mat == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if the input matrix is square
    if (mat->cols != mat->rows) {
        PERROR("@ERROR: This function only supports square matrices\n@FILE: %s\n@FUNCTION: %s\n@LINE: %d\n", __FILE__,
               __FUNCTION__, __LINE__);
    }

    // Create a copy of the input matrix
    Matrix *new_mat = matrix_copy(mat);
    if (new_mat == NULL) {
        PWARNING_RETURN_MALLOC(new_mat);
    }

    // Perform Gaussian elimination on the copied matrix
    matrix_gauss_elimination(new_mat);

    // Get the number of columns in the matrix
    const int cols = new_mat->cols;

    // Create an identity matrix with the same dimensions as the input matrix
    Matrix *result_mat = eye_matrix(cols, cols);
    if (result_mat == NULL) {
        PWARNING_RETURN_MALLOC(result_mat);
    }

    // Copy the diagonal elements of the Gaussian-eliminated matrix to the result matrix
    for (int i = 0; i < cols; i++) {
        const int index = IDX(cols, i, i);
        result_mat->data[index] = new_mat->data[index];
    }

    // Free the memory allocated for the copied matrix
    matrix_free(&new_mat);

    // Return the resulting eigen matrix
    return result_mat;
}

/**
 * Extracts a row vector from a matrix.
 *
 * @param mat The input matrix.
 * @param row_index The index of the row to extract (0-based).
 *
 * @return A new MVector object containing the extracted row, or NULL on error.
 */
MVector *getMatrixRowVector(Matrix *mat, unsigned int row_index) {
    // Check for invalid input
    if (mat == NULL || mat->data == NULL) {
        // Log warning and return NULL if input is invalid
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Get matrix dimensions
    const int rows = mat->rows;
    const int cols = mat->cols;

    // Check if row index is within bounds
    if (row_index < 0 || row_index >= rows) {
        // Log error and return NULL if row index is out of bounds
        PERROR(INVALID_INPUT_005, VAR_NAME(row_index), 0, rows - 1, __FILE__, __FUNCTION__, __LINE__);
    }

    // Allocate memory for new vector
    MVector *new_vector = (MVector *) malloc(sizeof(MVector));
    if (new_vector == NULL) {
        // Log warning and return NULL if memory allocation fails
        PWARNING_RETURN_MALLOC(new_vector);
    }

    // Allocate memory for vector data
    new_vector->data = (MATRIX_TYPE *) malloc(sizeof(MATRIX_TYPE) * cols);
    if (new_vector->data == NULL) {
        // Log warning and return NULL if memory allocation fails
        PWARNING_RETURN_MALLOC(new_vector->data);
    }

    // Copy row data from matrix to new vector
    memcpy(new_vector->data, mat->data + IDX(cols, row_index, 0) * sizeof(MATRIX_TYPE), sizeof(MATRIX_TYPE) * cols);

    // Set vector dimensions
    new_vector->cols = cols;
    new_vector->rows = 1;

    // Return new vector
    return new_vector;
}

/**
 * Extracts a column vector from a matrix.
 *
 * @param mat The input matrix.
 * @param col_index The index of the column to extract (0-based).
 *
 * @return A new MVector object containing the extracted column vector, or NULL on error.
 */
MVector *getMatrixColVector(Matrix *mat, unsigned int col_index) {
    // Check for invalid input
    if (mat == NULL || mat->data == NULL) {
        // Log warning and return NULL if input is invalid
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Get matrix dimensions
    const int rows = mat->rows;
    const int cols = mat->cols;

    // Check if column index is within bounds
    if (col_index < 0 || col_index >= cols) {
        // Log error and return NULL if column index is out of bounds
        PERROR(INVALID_INPUT_005, VAR_NAME(col_index), 0, cols - 1, __FILE__, __FUNCTION__, __LINE__);
    }

    // Allocate memory for new vector
    MVector *new_vector = (MVector *) malloc(sizeof(MVector));
    if (new_vector == NULL) {
        // Log warning and return NULL if memory allocation fails
        PWARNING_RETURN_MALLOC(new_vector);
    }

    // Allocate memory for vector data
    new_vector->data = (MATRIX_TYPE *) malloc(sizeof(MATRIX_TYPE) * rows);
    if (new_vector->data == NULL) {
        // Log warning and return NULL if memory allocation fails
        PWARNING_RETURN_MALLOC(new_vector->data);
    }

    // Copy column data from matrix to new vector
    for (int i = 0; i < rows; i++) {
        new_vector->data[i] = mat->data[IDX(cols, i, col_index)];
    }

    // Set vector dimensions
    new_vector->cols = 1;
    new_vector->rows = rows;

    // Return new vector
    return new_vector;
}

MVector *getMatrixDiagonalVector(Matrix *mat) {
    return getMatrixDiagonalVector_p(mat, 0);
}

/**
 * Returns a diagonal vector of a matrix.
 *
 * This function extracts a diagonal vector from a given matrix.
 * The diagonal vector is defined by the axis parameter (aix).
 * If aix is negative, the diagonal vector is extracted from the top-left to the bottom-right.
 * If aix is positive, the diagonal vector is extracted from the top-right to the bottom-left.
 *
 * @param mat The input matrix.
 * @param aix The axis parameter.
 * @return A diagonal vector of the matrix.
 */
MVector *getMatrixDiagonalVector_p(Matrix *mat, int aix) {
    // Check for null input
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    // Get the number of rows and columns in the matrix
    const int rows = mat->rows;
    const int cols = mat->cols;

    // Check if the axis parameter is within the valid range
    if (aix < 1 - rows || aix > cols - 1) {
        PERROR(INVALID_INPUT_005, VAR_NAME(aix), -rows+1, cols - 1, __FILE__, __FUNCTION__, __LINE__);
    }

    // Calculate the length of the diagonal vector
    int len;

    // Allocate memory for the diagonal vector
    MVector *new_vector = (MVector *) malloc(sizeof(MVector));
    if (new_vector == NULL) {
        PWARNING_RETURN_MALLOC(new_vector);
    }

    // Calculate the absolute value of the axis parameter
    const int abs_aix = abs(aix);

    // Extract the diagonal vector from the top-left to the bottom-right (aix < 0)
    if (aix < 0) {
        // Calculate the length of the diagonal vector
        len = rows - abs_aix;

        // Calculate the minimum length between the diagonal vector and the number of columns
        const int min = MIN(len, cols);

        // Set the number of columns and rows in the diagonal vector
        new_vector->cols = min;
        new_vector->rows = 1;

        // Allocate memory for the diagonal vector data
        new_vector->data = (MATRIX_TYPE *) malloc(sizeof(MATRIX_TYPE) * min);
        if (new_vector->data == NULL) {
            PWARNING_RETURN_MALLOC(new_vector->data);
        }

        // Extract the diagonal vector data from the matrix
        for (int i = 0; i < min; i++) {
            // Calculate the index of the diagonal vector data in the matrix
            const int index = IDX(cols, i+abs_aix, i);

            // Copy the diagonal vector data from the matrix to the diagonal vector
            new_vector->data[i] = mat->data[index];
        }

        // Return the diagonal vector
        return new_vector;
    }

    // Extract the diagonal vector from the top-right to the bottom-left (aix >= 0)
    // Calculate the length of the diagonal vector
    len = cols - abs_aix;

    // Calculate the minimum length between the diagonal vector and the number of rows
    const int min = MIN(len, rows);

    // Set the number of columns and rows in the diagonal vector
    new_vector->cols = min;
    new_vector->rows = 1;

    // Allocate memory for the diagonal vector data
    new_vector->data = (MATRIX_TYPE *) malloc(sizeof(MATRIX_TYPE) * min);
    if (new_vector->data == NULL) {
        PWARNING_RETURN_MALLOC(new_vector->data);
    }

    // Extract the diagonal vector data from the matrix
    for (int i = 0; i < min; i++) {
        // Calculate the index of the diagonal vector data in the matrix
        const int index = IDX(cols, i, i+abs_aix);

        // Copy the diagonal vector data from the matrix to the diagonal vector
        new_vector->data[i] = mat->data[index];
    }

    // Return the diagonal vector
    return new_vector;
}

/**
 * Calculates the eigen vector of a given matrix.
 *
 * This function takes a matrix as input, calculates its eigen matrix using the
 * matrix_eigen_matrix function, and then extracts the diagonal vector from the
 * eigen matrix using the getMatrixDiagonalVector function.
 *
 * @param mat The input matrix.
 *
 * @return A pointer to the eigen vector of the input matrix.
 */
MVector *matrix_eigen_vector(Matrix *mat) {
    // Calculate the eigen matrix of the input matrix
    Matrix *eigen_mat = matrix_eigen_matrix(mat);

    // Extract the diagonal vector from the eigen matrix
    MVector *eigen_vector = getMatrixDiagonalVector(eigen_mat);

    // Free the memory allocated for the eigen matrix
    matrix_free(&eigen_mat);

    // Return the eigen vector
    return eigen_vector;
}

/**
 * Solves a matrix equation of the form Ax = b, where A is a square matrix and b is a column vector.
 *
 * This function first checks if the input matrices are valid, then checks if the matrix A is square and
 * has the same number of rows as the number of rows in matrix b. If these conditions are met, it
 * inverts matrix A and multiplies the result by matrix b to solve for x.
 *
 * @param aMat The square matrix A in the equation Ax = b.
 * @param bMat The column vector b in the equation Ax = b.
 *
 * @return A pointer to the solution matrix x.
 *
 * @throws INPUT_NULL_005 If either of the input matrices is NULL.
 * @throws MATRIX_SIZE_ERROR_002 If matrix A is not square.
 * @throws MATRIX_SIZE_ERROR_001 If matrix A and matrix b do not have the same number of rows.
 */
Matrix *matrixEquation(Matrix *aMat, Matrix *bMat) {
    // Check if either of the input matrices is NULL
    if (aMat == NULL || bMat == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(aMat), VAR_NAME(bMat), __FILE__, __FUNCTION__, __LINE__);
    }

    // Get the dimensions of the input matrices
    const int rows_a = aMat->rows;
    const int cols_a = aMat->cols;
    const int rows_b = bMat->rows;

    // Check if matrix A is square
    if (rows_a != cols_a) {
        PERROR(MATRIX_SIZE_ERROR_002, __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if matrix A and matrix b have the same number of rows
    if (rows_a != rows_b) {
        PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
    }

    // Invert matrix A
    Matrix *aMat_inv = matrix_invert(aMat);

    // Multiply the inverse of matrix A by matrix b to solve for x
    return matrix_mul(aMat_inv, bMat);
}
