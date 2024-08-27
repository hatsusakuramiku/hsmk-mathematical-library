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
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include <math.h>

#include "list.h"

/**
 * Creates a new matrix size structure with the given number of rows and columns.
 *
 * @param rows The number of rows in the matrix.
 * @param cols The number of columns in the matrix.
 *
 * @return A matrix_size structure containing the specified rows and columns.
 */
inline matrix_size new_matrix_size(const unsigned int rows, const unsigned int cols) {
    matrix_size new_size = {rows, cols};
    return new_size;
}

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
 * Compares the size of two matrices.
 *
 * @param a The first matrix size to compare.
 * @param b The second matrix size to compare.
 *
 * @return 0 if the matrix sizes are equal, 1 otherwise.
 */
inline int matrix_size_cmp(const matrix_size a, const matrix_size b) {
    if (a.cols != b.cols || a.rows != b.rows)
        return 1;
    return 0;
}

/**
 * Compares two arrays of the specified type.
 *
 * @param a Pointer to the first array.
 * @param b Pointer to the second array.
 * @param type The type of the arrays to compare.
 *
 * @return 0 if the arrays are equal, 1 otherwise.
 *
 * @throws None.
 */
static int array_cmp(const void *a, const void *b, enum ARRAY_CMP_TYPE type) {
    if (type == _INT_) {
        const int *pa = (int *) a;
        const int *pb = (int *) b;
        if (LENGTH(a) != LENGTH(b)) {
            return 1;
        } else {
            return memcmp(pa, pb, LENGTH(a) * sizeof(int));
        }
    } else if (type == _DOUBLE_) {
        const double *pa = (double *) a;
        const double *pb = (double *) b;
        printf("a_len = %llu, b_len = %llu\n", LENGTH(a), LENGTH(b));
        if (LENGTH(a) != LENGTH(b)) {
            return 1;
        } else {
            return memcmp(pa, pb, LENGTH(a) * sizeof(double));
        }
    } else {
        return 1;
    }
}

/**
 * Creates a matrix filled with ones or a specified value.
 *
 * This function generates a matrix with the specified number of rows and columns,
 * and fills it with ones or a specified value. It supports variable number of arguments.
 *
 * @param num The number of arguments passed to the function.
 * @param ... Variable number of arguments. If num is 1, a single argument specifying the size of the square matrix.
 *             If num is 2, two arguments specifying the number of rows and columns.
 *             If num is 3, three arguments specifying the number of rows, columns, and the fill value.
 *
 * @return A pointer to the generated matrix, or NULL if an error occurs.
 *
 * @throws PARAMETERS_NUM_ERROR_002 If the number of arguments is not 1, 2, or 3.
 * @throws INPUT_NULL_004 If the number of rows or columns is zero.
 * @throws PARAMETER_VALUE_ERROR_001 If the generated matrix is NULL.
 * @throws VALUE_TYPE_WARNING_001 If the fill value is zero.
 */
Matrix *__ones_matrix(const int num, ...) {
    unsigned int rows;
    unsigned int cols;
    MATRIX_TYPE value = 1.0;

    if (num == 1) {
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = rows;
        va_end(ap);
    } else if (num == 2) {
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = va_arg(ap, unsigned int);
        va_end(ap);
    } else if (num == 3) {
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = va_arg(ap, unsigned int);
        value = va_arg(ap, MATRIX_TYPE);
        va_end(ap);
    } else {
        PERROR(PARAMETERS_NUM_ERROR_002, 1, 3, __FILE__, __FUNCTION__, __LINE__);
    }

    if (rows == 0 || cols == 0) {
        PWARNING_RETURN(INPUT_NULL_004, VAR_NAME(rows), VAR_NAME(cols), __FILE__, __FUNCTION__, __LINE__);
    }

    Matrix *mat = matrix_gen(rows, cols, NULL);

    if (mat == NULL) {
        PWARNING(PARAMETER_VALUE_ERROR_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
        return NULL;
    }

    if (DOUBLE_COMP_EQ2ZERO(value)) {
        PWARNING(VALUE_TYPE_WARNING_001, 0, __FILE__, __FUNCTION__, __LINE__);
    }

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
    if (rows == 0 || cols == 0) {
        PWARNING_RETURN(INPUT_NULL_004, VAR_NAME(rows), VAR_NAME(cols), __FILE__, __FUNCTION__, __LINE__);
    }

    Matrix *mat = (Matrix *) malloc(sizeof(Matrix));

    if (mat == NULL) {
        matrix_free(&mat);
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
    }

    mat->rows = rows;
    mat->cols = cols;
    mat->size = new_matrix_size(rows, cols);
    mat->data = (MATRIX_TYPE *) malloc(rows * cols * sizeof(MATRIX_TYPE));

    if (mat->data == NULL) {
        matrix_free(&mat);
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }
    const int len = LENGTH(data);
    memcpy(mat->data, data, len * sizeof(MATRIX_TYPE));
    for (int i = len; i < rows * cols; i++) {
        mat->data[i] = 0;
    }
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
    unsigned int rows;
    unsigned int cols;
    MATRIX_TYPE value = 1.0;
    if (num == 1) {
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = rows;
        va_end(ap);
    } else if (num == 2) {
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = va_arg(ap, unsigned int);
        va_end(ap);
    } else if (num == 3) {
        va_list ap;
        va_start(ap, num);
        rows = va_arg(ap, unsigned int);
        cols = va_arg(ap, unsigned int);
        value = va_arg(ap, MATRIX_TYPE);
        va_end(ap);
    } else {
        PERROR(PARAMETERS_NUM_ERROR_002, 1, 3, __FILE__, __FUNCTION__, __LINE__);
    }

    if (rows == 0 || cols == 0) {
        PWARNING_RETURN(INPUT_NULL_004, VAR_NAME(rows), VAR_NAME(cols), __FILE__, __FUNCTION__, __LINE__);
    }

    Matrix *mat = matrix_gen(rows, cols, NULL);

    if (mat == NULL) {
        PWARNING(PARAMETER_VALUE_ERROR_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
        return NULL;
    }

    if (DOUBLE_COMP_EQ2ZERO(value)) {
        PWARNING(VALUE_TYPE_WARNING_001, 0, __FILE__, __FUNCTION__, __LINE__);
    }

    for (int i = 0; i < MIN(rows, cols); i++) {
        mat->data[IDX(cols, i, i)] = value;
    }

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
    PWARNING_RETURN_INPUT_NO_NULL(mat);
    const int rows = mat->rows, cols = mat->cols;
    if (rows > MATRIX_ROWS_OMIT_PRINT_LIMIT || cols > MATRIX_COLS_OMIT_PRINT_LIMIT) {
        for (int i = 0; i < rows; i++) {
            if (i == 2 && rows > MATRIX_ROWS_OMIT_PRINT_LIMIT) {
                printf("%-10s\t", "⋮");
                for (int j = 0; j < cols; j++) {
                    if (j == 2 && cols > MATRIX_COLS_OMIT_PRINT_LIMIT) {
                        printf("%-10s\t", "⋮");
                        j = cols - 2;
                    }
                    printf("%-10s\t", "⋮");
                }
                i = rows - 3;
                printf("\n");
                continue;
            } else {
                printf("%c\t", '|'); // 打印竖线
            }
            for (int j = 0; j < cols; j++) {
                if (j == 2 && cols > MATRIX_COLS_OMIT_PRINT_LIMIT) {
                    printf("%s\t", "...");
                    j = cols - 2;
                }
                printf(MATRIX_DEFAULT_PRECISION, mat->data[IDX(cols, i, j)]);
            }
            printf("%c\t", '|'); // 打印竖线
            printf("\n");
        }
    } else {
        for (int i = 0; i < rows; i++) {
            printf("%c\t", '|'); // 打印竖线
            for (int j = 0; j < cols; j++) {
                printf(MATRIX_DEFAULT_PRECISION, mat->data[IDX(cols, i, j)]);
            }
            printf("%c\t", '|'); // 打印竖线
            printf("\n");
        }
    }
    printf("Matrix rows: %d, cols: %d\n", rows, cols);
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
    if (data_cols * data_rows != LENGTH(data)) {
        PERROR(INVALID_INPUT_003, VAR_NAME(data), data_rows * data_cols, __FILE__, __FUNCTION__,
               __LINE__);
    }
    if (data == NULL || LENGTH(data) == rows * cols) {
        return matrix_gen(rows, cols, data);
    }

    if (rows < data_rows) {
        PERROR(INVALID_INPUT_002, "rows", data_rows, __FILE__, __FUNCTION__, __LINE__);
    }
    if (cols < data_cols) {
        PERROR(INVALID_INPUT_002, "cols", data_cols, __FILE__, __FUNCTION__, __LINE__);
    }

    Matrix *mat = matrix_gen(rows, cols, NULL);
    PWARNING_RETURN_MALLOC(mat);

    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (i < data_rows && j < data_cols) {
                mat->data[IDX(cols, i, j)] = data[IDX(data_cols, i, j)];
            } else {
                mat->data[IDX(cols, i, j)] = 0;
            }
        }
    }

    return mat;
}

/**
 * Copies a matrix into another matrix.
 *
 * @param _sourse_mat The matrix to be copied.
 *
 * @return A pointer to the copied matrix, or NULL if memory allocation fails.
 *
 * @throws PWARNING_RETURN_INPUT_NO_NULL If the input matrix is NULL.
 */
Matrix *matrix_copy(const Matrix *_sourse_mat) {
    PWARNING_RETURN_INPUT(_sourse_mat);
    return matrix_gen(_sourse_mat->rows, _sourse_mat->cols, _sourse_mat->data);
}

/**
 * Copies the contents of a source matrix into a destination matrix.
 *
 * @param dest The destination matrix to be copied into.
 * @param src The source matrix to be copied from.
 *
 * @return None
 *
 * @throws PWARNING_RETURN_INPUT_NO_NULL If the destination or source matrix is NULL.
 * @throws PWARNING_RETURN_MALLOC_NO_NULL If memory allocation fails.
 */
void matrix_copy_r(Matrix **dest, const Matrix *src) {
    // PWARNING_RETURN_INPUT_NO_NULL(dest);
    PWARNING_RETURN_INPUT_NO_NULL(src);
    matrix_free(dest);
    *dest = matrix_copy(src);
}

/**
 * Copies the contents of a source matrix into a destination matrix and frees the source matrix.
 *
 * @param dest The destination matrix to be copied into.
 * @param src The source matrix to be copied from and then freed.
 *
 * @return None
 *
 * @throws PWARNING_RETURN_INPUT_NO_NULL If the destination or source matrix is NULL.
 * @throws PWARNING_RETURN_MALLOC_NO_NULL If memory allocation fails.
 */
void matrix_copy_free(Matrix **dest, Matrix **src) {
    // PWARNING_RETURN_INPUT_NO_NULL(dest);
    PWARNING_RETURN_INPUT_NO_NULL(*src);
    matrix_free(dest);
    *dest = matrix_copy(*src);
    matrix_free(src);
}

/**
 * Frees the memory allocated for a matrix.
 *
 * @param mat The matrix whose memory is to be freed.
 *
 * @return None
 *
 * @throws PWARNING_RETURN_INPUT_NO_NULL If the input matrix is NULL.
 */
void matrix_free(Matrix **mat) {
    if (mat == NULL || *mat == NULL) {
        return;
    }
    // #ifdef _CRT_USE_WINAPI_FAMILY_DESKTOP_APP
    //     if (mat == NULL || _msize(*mat) >= UNSIGEND_INT_MAX) {
    //         return;
    //     }
    // #else
    //     if (mat == NULL || malloc_usable_size(*mat)>= UNSIGEND_INT_MAX) {
    //         return;
    //     }
    // #endif

    FREE((*mat)->data);
    FREE(*mat);
}

/**
 * Generates a matrix filled with zeros.
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
    return matrix_gen(rows, cols, NULL);
}

/**
 * Generates an identity matrix with the specified number of rows and columns.
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
    if (rows == 0 || cols == 0) {
        PWARNING_RETURN(INPUT_NULL_004, VAR_NAME(rows), VAR_NAME(cols), __FILE__, __FUNCTION__, __LINE__);
    }
    Matrix *mat = matrix_gen(rows, cols, NULL);
    PWARNING_RETURN_MALLOC(mat);

    for (int i = 0; i < rows * cols; i++) {
        mat->data[i] = RAND(min, max, MATRIX_TYPE);
    }

    return mat;
}

/**
 * Compares two matrices for equality.
 *
 * @param a Pointer to the first matrix.
 * @param b Pointer to the second matrix.
 *
 * @return 1 if the matrices are not equal, 0 if they are equal.
 *
 * @throws INPUT_NULL_007 If either matrix is NULL.
 */
int matrix_eq(const Matrix *a, const Matrix *b) {
    if (a != NULL && b != NULL) {
        if (matrix_size_cmp(a->size, b->size) != 0) {
            return 1;
        }
        return array_cmp(a->data, b->data, _DOUBLE_);
    }
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
    PWARNING_RETURN_INPUT(a);
    va_list ap;
    va_start(ap, a);
    const int type_index = va_arg(ap, int);

    Matrix *mat;
    if (type_index == 0) {
        const Matrix *b = va_arg(ap, Matrix *);
        if (b == NULL) {
            va_end(ap);
            return NULL;
        }
        const int a_rows = a->rows, a_cols = a->cols, b_cols = b->cols, b_rows = b->rows;
        if (a_cols != b_rows) {
            PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
            va_end(ap);
        }

        mat = matrix_gen(a_rows, b_cols, NULL);
        if (mat == NULL) {
            PWARNING(PARAMETER_VALUE_ERROR_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            va_end(ap);
            return NULL;
        }

        for (int i = 0; i < a_rows; i++) {
            for (int j = 0; j < b_cols; j++) {
                for (int k = 0; k < a_cols; k++) {
                    mat->data[IDX(b_cols, i, j)] += a->data[IDX(a_cols, i, k)] * b->data[IDX(b_cols, k, j)];
                }
            }
        }
    } else {
        const double scalar = va_arg(ap, double);

        mat = matrix_gen(a->rows, a->cols, NULL);
        if (mat == NULL) {
            PWARNING(PARAMETER_VALUE_ERROR_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            va_end(ap);
            return NULL;
        }

        for (int i = 0; i < a->rows * a->cols; i++) {
            mat->data[i] = a->data[i] * scalar;
        }
    }

    va_end(ap);
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
    return __matrix_mul(a, 0, b);
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
Matrix *matrix_right_mul(Matrix *a, Matrix *b) {
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
 * Adds two matrices together element-wise and returns a new matrix. The second matrix
 * is subtracted from the first if the type index is 1. Returns NULL if either input
 * matrix is NULL or if the matrices have different sizes.
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
    PWARNING_RETURN_INPUT(a);
    va_list ap;
    va_start(ap, a);
    const int type_index = va_arg(ap, int);
    const Matrix *b = va_arg(ap, Matrix *);

    if (b == NULL || b->data == NULL) {
        PWARNING(INPUT_NULL_005, VAR_NAME(b), VAR_NAME(b->data), __FILE__, __FUNCTION__, __LINE__);
        va_end(ap);
        return NULL;
    }

    const int a_rows = a->rows, a_cols = a->cols;

    if (matrix_size_cmp(a->size, b->size)) {
        PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
        va_end(ap);
    }

    Matrix *mat = matrix_gen(a_rows, a_cols, NULL);

    if (mat == NULL) {
        PWARNING(PARAMETER_VALUE_ERROR_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
        va_end(ap);
        return NULL;
    }

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
 * Transposes the input matrix and stores the result in the original matrix.
 *
 * @param mat The input matrix to be transposed.
 *
 * @return None
 *
 * @throws INPUT_NULL_005 If the input matrix is NULL.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
void matrix_transpose(Matrix *mat) {
    Matrix *temp = matrix_transpose_r(mat);
    matrix_copy_free(&mat, &temp);
}

/**
 * Returns a new matrix that is the transpose of the input matrix.
 *
 * @param mat The input matrix to be transposed.
 *
 * @return A new matrix that is the transpose of the input matrix.
 *
 * @throws INPUT_NULL_005 If the input matrix or its data is NULL.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
Matrix *matrix_transpose_r(const Matrix *mat) {
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), VAR_NAME(mat->data), __FILE__, __FUNCTION__,
                        __LINE__);
    }
    Matrix *new_mat = matrix_gen(mat->cols, mat->rows, NULL);
    if (new_mat == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_mat), __FILE__, __FUNCTION__, __LINE__);
    }
    for (int i = 0; i < mat->rows; i++) {
        for (int j = 0; j < mat->cols; j++) {
            new_mat->data[IDX(mat->cols, i, j)] = mat->data[IDX(mat->rows, j, i)];
        }
    }

    return new_mat;
}

/**
 * Converts a matrix to a 2D array.
 *
 * @param mat The input matrix to be converted.
 *
 * @return A 2D array that is the result of converting the input matrix, or NULL if memory allocation fails.
 *
 * @throws INPUT_NULL_005 If the input matrix or its data is NULL.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
MATRIX_TYPE **matrix_to_2D_array(const Matrix *mat) {
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    MATRIX_TYPE **array = (MATRIX_TYPE **) malloc(sizeof(MATRIX_TYPE *) * mat->rows);
    if (array == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(array), __FILE__, __FUNCTION__, __LINE__);
    }
    const int rows = mat->rows, cols = mat->cols;
    for (int i = 0; i < rows; i++) {
        array[i] = (MATRIX_TYPE *) malloc(sizeof(MATRIX_TYPE) * cols);
        if (array[i] == NULL) {
            for (int j = i; j >= 0; j--) {
                FREE(array[j]);
            }
            FREE(array);
            PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(array[i]), __FILE__, __FUNCTION__, __LINE__);
        }
        for (int j = 0; j < cols; j++) {
            array[i][j] = mat->data[IDX(cols, i, j)];
        }
    }
    return array;
}

/**
 * Creates a Matrix from a 2D array.
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
    if (array == NULL || LENGTH(array) != rows) {
        PWARNING_RETURN(INVALID_INPUT_003, VAR_NAME(LENGTH(array)), rows, __FILE__, __FUNCTION__, __LINE__);
    }

    for (int i = 0; i < rows; i++) {
        if (LENGTH(array[i]) != cols) {
            PWARNING_RETURN(INVALID_INPUT_003, VAR_NAME(LENGTH(array[i])), cols, __FILE__, __FUNCTION__, __LINE__);
        }
    }

    Matrix *mat = matrix_gen(rows, cols, NULL);
    if (mat == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
    }
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            mat->data[IDX(cols, i, j)] = array[i][j];
        }
    }
    return mat;
}

/**
 * Splices two matrices together.
 *
 * @param a the first matrix to splice
 * @param b the second matrix to splice
 * @param aix the axis to splice along (0: vertical, 1: horizontal, 2: vertical from bottom, 3: horizontal from right)
 *
 * @return a new matrix that is the result of splicing a and b
 *
 * @throws MATRIX_SIZE_ERROR_001 if the matrices are not the same size along the specified axis
 * @throws MALLOC_FAILURE_001 if memory allocation fails
 * @throws INVALID_INPUT_005 if aix is not one of the allowed values
 */
Matrix *matrix_splicing(const Matrix *a, const Matrix *b, const unsigned int aix) {
    if (a == NULL && b == NULL) {
        return NULL;
    }
    if (a == NULL) {
        return matrix_copy(a);
    }
    if (b == NULL) {
        return matrix_copy(b);
    }

    Matrix *mat;
    const int a_rows = a->rows, a_cols = a->cols, b_rows = b->rows, b_cols = b->cols;
    const int a_col_plus_b_cols = a_cols + b_cols, a_rows_cols = a_rows * a_cols,
            b_rows_cols = b_rows * b_cols;
    switch (aix) {
        case 0:
            if (a_cols != b_cols) {
                PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
            }
            mat = matrix_gen(a_rows + b_rows, a_cols, NULL);
            if (mat == NULL) {
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            }
            for (int i = 0; i < b_rows_cols; i++) {
                mat->data[i] = b->data[i];
            }
            for (int i = b_rows_cols; i < b_rows_cols + a_rows_cols; i++) {
                mat->data[i] = a->data[i - b_rows_cols];
            }
            break;
        case 1:
            if (a_rows != b_rows) {
                PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
            }
            mat = matrix_gen(a_rows, a_cols + b_cols, NULL);
            if (mat == NULL) {
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            }

            for (int i = 0; i < a_rows; i++) {
                for (int j = 0; j < a_cols; j++) {
                    mat->data[IDX(a_col_plus_b_cols, i, j)] = a->data[IDX(a_cols, i, j)];
                }
                for (int j = a_cols; j < a_col_plus_b_cols; j++) {
                    mat->data[IDX(a_col_plus_b_cols, i, j)] = b->data[IDX(b_cols, i, j - a_cols)];
                }
            }
            break;
        case 2:
            if (a_cols != b_cols) {
                PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
            }
            mat = matrix_gen(a_rows + b_rows, a_cols, NULL);
            if (mat == NULL) {
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            }
            for (int i = 0; i < a_rows_cols; i++) {
                mat->data[i] = a->data[i];
            }
            for (int i = a_rows_cols; i < b_rows_cols + a_rows_cols; i++) {
                mat->data[i] = b->data[i - a_rows_cols];
            }
            break;
        case 3:
            if (a_rows != b_rows) {
                PERROR(MATRIX_SIZE_ERROR_001, __FILE__, __FUNCTION__, __LINE__);
            }
            mat = matrix_gen(a_rows, a_cols + b_cols, NULL);
            if (mat == NULL) {
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
            }
            for (int i = 0; i < a_rows; i++) {
                for (int j = 0; j < b_cols; j++) {
                    mat->data[IDX(a_col_plus_b_cols, i, j)] = b->data[IDX(b_cols, i, j)];
                }
                for (int j = b_cols; j < a_col_plus_b_cols; j++) {
                    mat->data[IDX(a_col_plus_b_cols, i, j)] = a->data[IDX(a_cols, i, j - b_cols)];
                }
            }
            break;
        default:
            PERROR(INVALID_INPUT_005, VAR_NAME(aix), 0, 3, __FILE__, __FUNCTION__, __LINE__);
    }
    return mat;
}

/**
 * Extracts a sub-matrix from the given matrix.
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
    const int a_rows = a->rows, a_cols = a->cols;

    if (MIN(begin_row, end_row) < 1 || MAX(begin_row, end_row) > a_rows) {
        PERROR(INVALID_INPUT_006, VAR_NAME(begin_row), VAR_NAME(end_row), 1, a_rows, __FILE__, __FUNCTION__, __LINE__);
    }

    if (MIN(begin_col, end_col) < 1 || MAX(begin_col, end_col) > a_cols) {
        PERROR(INVALID_INPUT_006, VAR_NAME(begin_col), VAR_NAME(end_col), 1, a_cols, __FILE__, __FUNCTION__, __LINE__);
    }

    const int mat_rows = abs(end_row - begin_row) + 1, mat_cols = abs(end_col - begin_col) + 1;
    Matrix *mat = matrix_gen(mat_rows, mat_cols, NULL);

    if (mat == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(mat), __FILE__, __FUNCTION__, __LINE__);
    }

    const int start_rows_index = MIN(begin_row, end_row) - 1, start_cols_index = MIN(begin_col, end_col) - 1;
    const int end_rows_index = MAX(begin_row, end_row) - 1, end_cols_index = MAX(begin_col, end_col) - 1;
    for (int i = start_rows_index; i <= end_rows_index; i++) {
        for (int j = start_cols_index; j <= end_cols_index; j++) {
            mat->data[IDX(mat_cols, i - start_rows_index, j - start_cols_index)] = a->data[IDX(a_cols, i, j)];
        }
    }

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
    if (a == NULL || a->data == NULL) {
        PWARNING_RETURN_NO_NULL(INPUT_NULL_007, VAR_NAME(a), VAR_NAME(a->data), __FILE__, __FUNCTION__, __LINE__);
    }

    const int a_rows = a->rows, a_cols = a->cols;
    if (aix == 0) {
        if (MIN(select_index, aim_index) < 0 || MAX(select_index, aim_index) >= a_rows) {
            PERROR(INVALID_INPUT_006, VAR_NAME(select_index), VAR_NAME(aim_index), 0, a->cols - 1, __FILE__,
                   __FUNCTION__,
                   __LINE__);
        }
        if (select_index == aim_index) {
            return;
        }
        _memswap(a->data + (size_t) (select_index * a_cols), a->data + (size_t) (aim_index * a_cols),
                 a_cols * sizeof(MATRIX_TYPE));
        /*** old version may be slow ***/
        // for (int i = 0; i < a_cols; i++) {
        //     const MATRIX_TYPE temp = a->data[IDX(a_cols, select_index, i)];
        //     a->data[IDX(a_cols, select_index, i)] = a->data[IDX(a_cols, aim_index, i)];
        //     a->data[IDX(a_cols, aim_index, i)] = temp;
        // }
        return;
    }
    if (aix == 1) {
        if (MIN(select_index, aim_index) < 0 || MAX(select_index, aim_index) >= a_cols) {
            PERROR(INVALID_INPUT_006, VAR_NAME(select_index), VAR_NAME(aim_index), 0, a->cols - 1, __FILE__,
                   __FUNCTION__, __LINE__);
        }
        if (select_index == aim_index) {
            return;
        }
        for (int i = 0; i < a_rows; i++) {
            const MATRIX_TYPE temp = a->data[IDX(a_cols, i, select_index)];
            a->data[IDX(a_cols, i, select_index)] = a->data[IDX(a_cols, i, aim_index)];
            a->data[IDX(a_cols, i, aim_index)] = temp;
        }
        return;
    }
    PERROR(INVALID_INPUT_005, VAR_NAME(aix), 0, 1, __FILE__, __FUNCTION__, __LINE__);
}

/**
 * Compares two matrix elements based on the specified column index.
 *
 * @param index The column index to compare.
 * @param a The first matrix element to compare.
 * @param b The second matrix element to compare.
 *
 * @return 1 if the first element is greater, 0 if they are equal, and -1 if the first element is smaller.
 *
 * @throws None
 */
int matrix_default_cmp(void *index, const void *a, const void *b) {
    const uintptr_t col_index = (uintptr_t) index;
    const MATRIX_TYPE *p1 = *(MATRIX_TYPE **) a;
    const MATRIX_TYPE *p2 = *(MATRIX_TYPE **) b;
    if (p1[col_index] > p2[col_index]) {
        return 1;
    }
    if (p1[col_index] == p2[col_index]) {
        return 0;
    }
    return -1;
}

/**
 * Compares two matrix elements based on the specified column index.
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
    const uintptr_t col = (uintptr_t) index;
    const MATRIX_TYPE *p1 = (MATRIX_TYPE *) a;
    const MATRIX_TYPE *p2 = (MATRIX_TYPE *) b;

    if (p1[col] > p2[col]) {
        return 1;
    }

    if (p1[col] == p2[col]) {
        return 0;
    }

    return -1;
}

/**
 * Sorts a matrix by the values in the specified column.
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
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN_NO_NULL(INPUT_NULL_007, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }

    if (col_index >= mat->cols) {
        PERROR(INVALID_INPUT_006, VAR_NAME(col_index), 0, mat->cols - 1, __FILE__, __FUNCTION__, __LINE__);
    }

    /**** old code may be slow ***/
    // MATRIX_TYPE **temp_array = matrix_to_2D_array(mat);
    // if (temp_array == NULL) {
    //     PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(temp_array), __FILE__, __FUNCTION__, __LINE__);
    // }
    //
    // const int rows = mat->rows, cols = mat->cols;
    // qsort_s(temp_array, rows, sizeof(MATRIX_TYPE *), matrix_default_cmp, (void *) col_index);
    // Matrix *temp = matrix_from_2D_array(temp_array, rows, cols);
    //
    // if (temp == NULL || temp->data == NULL) {
    //     for (int i = 0; i < rows; i++) {
    //         FREE(temp_array[i]);
    //     }
    //     FREE(temp_array);
    //     PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_002, VAR_NAME(temp), __FILE__, __FUNCTION__, __LINE__);
    // }
    //
    // matrix_copy_free(&mat, &temp);
    //
    // for (int i = 0; i < rows; i++) {
    //     FREE(temp_array[i]);
    // }
    // FREE(temp_array);

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
 * @param mat The input matrix.
 * @param select_index The index of the row to select.
 * @param aim_index The index of the row to aim.
 * @param begin_index The starting column index.
 * @param value The value to use for elimination.
 *
 * @return None
 *
 * @throws None
 */
void matrix_gauss_elimination_(const Matrix *mat, const unsigned int select_index, const unsigned int aim_index,
                               const int
                               begin_index,
                               const MATRIX_TYPE value) {
    for (int i = begin_index; i < mat->cols; i++) {
        mat->data[IDX(mat->cols, aim_index, i)] -= mat->data[IDX(mat->cols, select_index, i)] * value;
    }
    if (!DOUBLE_COMP_EQ2ZERO(mat->data[IDX(mat->cols, aim_index, begin_index)])) {
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

    // Iterate through the matrix
    for (int i = 0; i < MIN(rows, cols); i++) {
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
 * @param mat Pointer to the input matrix.
 *
 * @return The rank of the input matrix.
 *
 * @throws INPUT_NULL_009 If the input matrix or its data is NULL.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
int matrix_rank(const Matrix *mat) {
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN_ZERO(INPUT_NULL_009, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }
    Matrix *temp_mat = matrix_gen(mat->rows, mat->cols, mat->data);
    if (temp_mat == NULL || temp_mat->data == NULL) {
        PWARNING_RETURN_ZERO(MALLOC_FAILURE_001, VAR_NAME(temp_mat), __FILE__, __FUNCTION__, __LINE__);
    }
    matrix_gauss_elimination(temp_mat);
    matrix_print(temp_mat);
    int rank = 0;
    for (int i = 0; i < MIN(temp_mat->rows, temp_mat->cols); i++) {
        if (!DOUBLE_COMP_EQ2ZERO(temp_mat->data[IDX(temp_mat->cols, i, i)])) {
            rank++;
        } else {
            break;
        }
    }
    matrix_free(&temp_mat);
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
    if (mat == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }
    List *pos_list = newList();
    for (int i = 0; i < mat->rows * mat->cols; i++) {
        MATRIX_TYPE *temp_mat_val = &mat->data[i];
        MATRIX_TYPE *temp_val_cmp = &value;
        if (cmp_func(temp_mat_val, temp_val_cmp)) {
            elem_pos *temp_pos = (elem_pos *) malloc(sizeof(elem_pos));
            if (temp_pos == NULL) {
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(temp_pos), __FILE__, __FUNCTION__, __LINE__);
            }
            temp_pos->row = i / mat->cols;
            temp_pos->col = i % mat->cols;
            temp_pos->value = mat->data[i];
            listPushBack(pos_list, temp_pos);
        }
    }
    if (pos_list->size == 0) {
        return NULL;
    }
    elem_pos *pos_arr = (elem_pos *) malloc(sizeof(elem_pos) * pos_list->size);
    if (pos_arr == NULL) {
        deleteList(pos_list);
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(pos_arr), __FILE__, __FUNCTION__, __LINE__);
    }
    int size = pos_list->size;
    for (int i = 0; i < size; i++) {
        elem_pos *temp_pos = listGetTopAndPop(pos_list);
        pos_arr[i] = *temp_pos;
        free(temp_pos);
    }
    deleteList(pos_list);
    elem_pos_array *pos_arr_ptr = (elem_pos_array *) malloc(sizeof(elem_pos_array));
    if (pos_arr_ptr == NULL) {
        free(pos_arr);
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(pos_arr_ptr), __FILE__, __FUNCTION__, __LINE__);
    }
    pos_arr_ptr->size = size;
    pos_arr_ptr->elem_pos_arr = pos_arr;
    return pos_arr_ptr;
}

/**
 * Finds the minimum element in a matrix.
 *
 * @param mat A pointer to the matrix to find the minimum element in.
 *
 * @return The minimum element in the matrix.
 *
 * @throws INPUT_NULL_009 If the input matrix or its data is NULL.
 */
MATRIX_TYPE matrix_min(const Matrix *mat) {
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN_ZERO(INPUT_NULL_009, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }
    MATRIX_TYPE min = mat->data[0];
    for (int i = 1; i < mat->rows * mat->cols; i++) {
        if (mat->data[i] < min) {
            min = mat->data[i];
        }
    }
    return min;
}

/**
 * Finds the maximum element in a matrix.
 *
 * @param mat A pointer to the matrix to find the maximum element in.
 *
 * @return The maximum element in the matrix.
 *
 * @throws INPUT_NULL_009 If the input matrix or its data is NULL.
 */
MATRIX_TYPE matrix_max(const Matrix *mat) {
    if (mat == NULL || mat->data == NULL) {
        PWARNING_RETURN_ZERO(INPUT_NULL_009, VAR_NAME(mat), VAR_NAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
    }
    MATRIX_TYPE max = mat->data[0];
    for (int i = 1; i < mat->rows * mat->cols; i++) {
        if (mat->data[i] > max) {
            max = mat->data[i];
        }
    }
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
