#include "Matrix.h"
#include "../CustomSort.c"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>
#include <string.h>
#include <stdarg.h>

Matrix *
matrix_gen(unsigned int rows, unsigned int cols, MATRIX_TYPE *data)
{
    if (rows == 0 || cols == 0)
    {
        printf(INPUT_NULL_004, VNAME(rows), VNAME(cols), __FILE__, __FUNCTION__, __LINE__);
        return NULL;
    }

    Matrix *mat = (Matrix *)malloc(sizeof(Matrix));
    PWARNING_RETURN_MALLOC(mat);
    mat->data = (MATRIX_TYPE *)malloc(rows * cols * sizeof(MATRIX_TYPE));
    PWARNING_RETURN_MALLOC(mat->data);
    mat->rows = rows;
    mat->cols = cols;

    if (!(data == NULL || LENGTH(data) != rows * cols))
    {
        memcpy(mat->data, data, rows * cols * sizeof(MATRIX_TYPE));
        return mat;
    }
    else
    {
        mat->data = (MATRIX_TYPE *)malloc(rows * cols * sizeof(MATRIX_TYPE));
        if (mat->data == NULL)
        {
            free(mat);
            printf(MALLOC_FAILURE_001, VNAME(mat->data), __FILE__, __FUNCTION__, __LINE__);
            return NULL;
        }
    }

    if (data == NULL)
    {
        for (int i = 0; i < rows * cols; i++)
        {
            mat->data[i] = 0;
        }
    }
    else
    {
        int len = LENGTH(data);

        for (int i = 0; i < rows * cols; i++)
        {
            if (i < len)
            {
                mat->data[i] = data[i];
            }
            else
            {
                mat->data[i] = 0.0;
            }
        }
    }

    return mat;
}

Matrix *matrix_gen_(unsigned int rows, unsigned int cols, MATRIX_TYPE *data, unsigned int data_rows,
                    unsigned int data_cols)
{
    if (data == NULL || rows * cols == LENGTH(data))
    {
        return matrix_gen(rows, cols, data);
    }
    else if (data_cols * data_rows != LENGTH(data))
    {
        PERROR(INVALID_INPUT_003, VNAME(data), data_rows * data_cols, __FILE__, __FUNCTION__, __LINE__);
    }

    if (rows < data_rows)
    {
        PERROR(INVALID_INPUT_002, "rows", data_rows, __FILE__, __FUNCTION__, __LINE__);
    }
    else if (cols < data_cols)
    {
        PERROR(INVALID_INPUT_001, "cols", data_cols, __FILE__, __FUNCTION__, __LINE__);
    }

    Matrix *mat = matrix_gen(rows, cols, NULL);
    PWARNING_RETURN_MALLOC(mat);

    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            if (i < data_rows && j < data_cols)
            {
                mat->data[IDX(cols, i, j)] = data[IDX(data_cols, i, j)];
            }
        }
    }

    return mat;
}

Matrix *matrix_copy(Matrix *_sourse_mat)
{
    PWARNING_RETURN_INPUT(_sourse_mat);
    return matrix_gen(_sourse_mat->rows, _sourse_mat->cols, _sourse_mat->data);
}

/**
 * Copies the contents of the source matrix to the destination matrix.
 *
 * @param dest The matrix to copy to.
 * @param src The matrix to copy from.
 */
void matrix_copy_(Matrix *dest, Matrix *src)
{
    // Check if either matrix is NULL
    PWARNING_RETURN_INPUT_NO_NULL(dest);
    PWARNING_RETURN_INPUT_NO_NULL(src);

    // Free the memory allocated for the data in the destination matrix
    if (dest->data != NULL)
    {
        free(dest->data);
    }

    // Allocate memory for the data in the destination matrix and copy the data from the source matrix
    dest->data = (MATRIX_TYPE *)malloc(src->rows * src->cols * sizeof(MATRIX_TYPE));
    PWARNING_RETURN_MALLOC_NO_NULL(dest->data);
    memcpy(dest->data, src->data, src->rows * src->cols * sizeof(MATRIX_TYPE));

    // Update the dimensions of the destination matrix to match the source matrix
    dest->rows = src->rows;
    dest->cols = src->cols;
}

void matrix_copy_free(Matrix *dest, Matrix *src)
{
    // Check if either matrix is NULL
    PWARNING_RETURN_INPUT_NO_NULL(dest);
    PWARNING_RETURN_INPUT_NO_NULL(src);

    // Free the memory allocated for the data in the destination matrix
    if (dest->data != NULL)
    {
        free(dest->data);
    }

    // Allocate memory for the data in the destination matrix and copy the data from the source matrix
    dest->data = (MATRIX_TYPE *)malloc(src->rows * src->cols * sizeof(MATRIX_TYPE));
    PWARNING_RETURN_MALLOC_NO_NULL(dest->data);
    memcpy(dest->data, src->data, src->rows * src->cols * sizeof(MATRIX_TYPE));

    // Update the dimensions of the destination matrix to match the source matrix
    dest->rows = src->rows;
    dest->cols = src->cols;
    matrix_free(src);
}

void matrix_free(Matrix *mat)
{
    PWARNING_RETURN_INPUT_NO_NULL(mat);

    // Free the memory allocated for the matrix data
    if (mat->data != NULL)
    {
        free(mat->data);
    }

    // Free the memory allocated for the matrix structure
    free(mat);
}

void matrix_print(Matrix *mat)
{
    PWARNING_RETURN_INPUT_NO_NULL(mat);
    int rows = mat->rows, cols = mat->cols;
    if (rows > MATRIX_ROWS_OMIT_PRINT_LIMIT || cols > MATRIX_COLS_OMIT_PRINT_LIMIT)
    {
        for (int i = 0; i < rows; i++)
        {
            if (i == 2 && rows > MATRIX_ROWS_OMIT_PRINT_LIMIT)
            {
                printf("%-10s\t", "⋮");
                for (int j = 0; j < cols; j++)
                {
                    if (j == 2 && cols > MATRIX_COLS_OMIT_PRINT_LIMIT)
                    {
                        printf("%-10s\t", "⋮");
                        j = cols - 2;
                    }
                    printf("%-10s\t", "⋮");
                }
                i = rows - 3;
                printf("\n");
                continue;
            }
            else
            {
                printf("%c\t", '|'); // 打印竖线
            }
            for (int j = 0; j < cols; j++)
            {
                if (j == 2 && cols > MATRIX_COLS_OMIT_PRINT_LIMIT)
                {
                    printf("%s\t", "...");
                    j = cols - 2;
                }
                printf(MATRIX_DEFAULT_PRECISION, mat->data[IDX(cols, i, j)]);
            }
            printf("%c\t", '|'); // 打印竖线
            printf("\n");
        }
    }
    else
    {
        for (int i = 0; i < rows; i++)
        {
            printf("%c\t", '|'); // 打印竖线
            for (int j = 0; j < cols; j++)
            {
                printf(MATRIX_DEFAULT_PRECISION, mat->data[IDX(cols, i, j)]);
            }
            printf("%c\t", '|'); // 打印竖线
            printf("\n");
        }
    }
    printf("Matrix rows: %d, cols: %d\n", rows, cols);
}

Matrix *ones_matrix(unsigned int rows, unsigned int cols)
{
    if (rows == 0 || cols == 0)
    {
        PWARNING(INPUT_NULL_004, VNAME(rows), VNAME(cols), __FILE__, __FUNCTION__, __LINE__);
        return NULL;
    }
    Matrix *mat = matrix_gen(rows, cols, NULL);

    if (mat == NULL)
    {
        PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(mat), __FILE__, __FUNCTION__, __LINE__);
        return NULL;
    }

    for (int i = 0; i < rows * cols; i++)
    {
        mat->data[i] = 1;
    }

    return mat;

    /* 与上面的函数等价 */
    // return ones_matrix_value(rows, cols, 1.0);
}

Matrix *_ones_matrix_(int num, ...)
{
    if (num == 1)
    {
        va_list ap;
        va_start(ap, num);
        unsigned int rows = va_arg(ap, unsigned int);
        va_end(ap);

        return ones_matrix(rows, rows);
    }
    else if (num == 2)
    {
        va_list ap;
        va_start(ap, num);
        unsigned int rows = va_arg(ap, unsigned int);
        unsigned int cols = va_arg(ap, unsigned int);
        va_end(ap);

        return ones_matrix(rows, cols);
    }
    else if (num == 3)
    {
        va_list ap;
        va_start(ap, num);
        unsigned int rows = va_arg(ap, unsigned int);
        unsigned int cols = va_arg(ap, unsigned int);
        MATRIX_TYPE value = va_arg(ap, MATRIX_TYPE);
        va_end(ap);

        if (rows == 0 || cols == 0)
        {
            return NULL;
        }

        Matrix *mat = matrix_gen(rows, cols, NULL);

        if (mat == NULL)
        {
            PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(mat), __FILE__, __FUNCTION__, __LINE__);
            return NULL;
        }

        if (DOUBLE_COMPARE_EQ2ZERO(value))
        {
            PWARNING(VALUE_TYPE_WARNING_001, 0, __FILE__, __FUNCTION__, __LINE__);
        }

        for (int i = 0; i < rows * cols; i++)
        {
            mat->data[i] = value;
        }

        return mat;
    }
    else
    {
        PERROR(PARAMETERS_NUM_ERROR_002, 1, 3, __FILE__, __FUNCTION__, __LINE__);
    }
}

Matrix *zeros_matrix(unsigned int rows, unsigned int cols)
{
    return matrix_gen(rows, cols, NULL);
}

Matrix *eye_matrix(unsigned int rows, unsigned int cols)
{
    if (rows == 0 || cols == 0)
    {
        PWARNING(INPUT_NULL_004, VNAME(rows), VNAME(cols), __FILE__, __FUNCTION__, __LINE__);
        return NULL;
    }
    Matrix *mat = matrix_gen(rows, cols, NULL);
    PWARNING_RETURN_MALLOC(mat);
    for (int i = 0; i < MIN(rows, cols); i++)
    {
        mat->data[IDX(cols, i, i)] = 1;
    }
    return mat;

    /* 与上面的函数等价 */
    // return eye_matrix_value(rows, cols, 1.0);
}

Matrix *_eye_matrix_(int num, ...)
{
    if (num == 1)
    {
        va_list ap;
        va_start(ap, num);
        unsigned int rows = va_arg(ap, unsigned int);
        va_end(ap);
        return eye_matrix(rows, rows);
    }
    else if (num == 2)
    {
        va_list ap;
        va_start(ap, num);
        unsigned int rows = va_arg(ap, unsigned int);
        unsigned int cols = va_arg(ap, unsigned int);
        va_end(ap);
        return eye_matrix(rows, cols);
    }
    else if (num == 3)
    {
        va_list ap;
        va_start(ap, num);
        unsigned int rows = va_arg(ap, unsigned int);
        unsigned int cols = va_arg(ap, unsigned int);
        MATRIX_TYPE value = va_arg(ap, MATRIX_TYPE);
        va_end(ap);
        if (rows == 0 || cols == 0)
        {
            return NULL;
        }

        Matrix *mat = matrix_gen(rows, cols, NULL);

        if (mat == NULL)
        {
            PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(mat), __FILE__, __FUNCTION__, __LINE__);
            return NULL;
        }

        if (DOUBLE_COMPARE_EQ2ZERO(value))
        {
            PWARNING(VALUE_TYPE_WARNING_001, 0, __FILE__, __FUNCTION__, __LINE__);
        }

        for (int i = 0; i < MIN(rows, cols); i++)
        {
            mat->data[IDX(cols, i, i)] = value;
        }

        return mat;
    }
    else
    {
        PERROR(PARAMETERS_NUM_ERROR_002, 1, 3, __FILE__, __FUNCTION__, __LINE__);
    }
}

Matrix *rand_matrix(unsigned int rows, unsigned int cols, MATRIX_TYPE min, MATRIX_TYPE max)
{
    if (rows == 0 || cols == 0)
    {
        return NULL;
    }

    Matrix *mat = matrix_gen(rows, cols, NULL);
    PWARNING_RETURN_MALLOC(mat);

    for (int i = 0; i < rows * cols; i++)
    {
        mat->data[i] = RAND(min, max, MATRIX_TYPE);
    }

    return mat;
}

bool matrix_eq(Matrix *a, Matrix *b)
{
    if (a == NULL || b == NULL || a->data == NULL || b->data == NULL)
    {
        return false;
    }

    if (LENGTH(a->data) != LENGTH(b->data))
    {
        return false;
    }

    for (int i = 0; i < a->rows * a->cols; i++)
    {
        if (!DOUBLE_COMPARE_EQ2ZERO(a->data[i] - b->data[i]))
        {
            return false;
        }
    }

    return true;
}

Matrix *_matrix_mul_(Matrix *a, ...)
{
    PWARNING_RETURN_INPUT(a);
    va_list ap;
    va_start(ap, a);
    int type_index = va_arg(ap, int);

    Matrix *mat;
    if (type_index == 0)
    {
        Matrix *b = va_arg(ap, Matrix *);
        if (b == NULL)
        {
            va_end(ap);
            return NULL;
        }
        int a_rows = a->rows, a_cols = a->cols, b_cols = b->cols, b_rows = b->rows;
        if (a_cols != b_rows)
        {
            PERROR(MATRIX_SIZE_ERROR_001, __FUNCTION__, __LINE__, __FILE__);
            va_end(ap);
            return NULL;
        }

        mat = matrix_gen(a_rows, b_cols, NULL);
        if (mat == NULL)
        {
            PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(mat), __FILE__, __FUNCTION__, __LINE__);
            va_end(ap);
            return NULL;
        }

        for (int i = 0; i < a_rows; i++)
        {
            for (int j = 0; j < b_cols; j++)
            {
                for (int k = 0; k < a_cols; k++)
                {
                    mat->data[IDX(b_cols, i, j)] += a->data[IDX(a_cols, i, k)] * b->data[IDX(b_cols, k, j)];
                }
            }
        }
    }
    else
    {
        double scalar;
        if (type_index == 1)
        {
            scalar = va_arg(ap, double);
        }
        else
        {
            scalar = va_arg(ap, int);
        }

        mat = matrix_gen(a->rows, a->cols, NULL);
        if (mat == NULL)
        {
            PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(mat), __FILE__, __FUNCTION__, __LINE__);
            va_end(ap);
            return NULL;
        }

        for (int i = 0; i < a->rows * a->cols; i++)
        {
            mat->data[i] = a->data[i] * scalar;
        }
    }

    va_end(ap);
    return mat;
}

Matrix *matrix_mul(Matrix *a, Matrix *b)
{
    return _matrix_mul_(a, 0, b);
}

Matrix *matrix_right_mul(Matrix *a, Matrix *b)
{
    return matrix_mul(b, a);
}

Matrix *matrix_mul_single_int(Matrix *a, int b)
{
    return _matrix_mul_(a, 2, b);
}

Matrix *matrix_mul_single_double(Matrix *a, double b)
{
    return _matrix_mul_(a, 1, b);
}

void matrix_mul_void(Matrix *a, Matrix *b)
{
    matrix_copy_free(a, matrix_mul(a, b));
}

void matrix_right_mul_void(Matrix *a, Matrix *b)
{
    matrix_mul_void(b, a);
}

void matrix_mul_single_int_void(Matrix *a, int b)
{
    matrix_copy_free(a, matrix_mul_single_int(a, b));
}

void matrix_mul_single_double_void(Matrix *a, double b)
{
    matrix_copy_free(a, matrix_mul_single_double(a, b));
}

Matrix *_matrix_add_(Matrix *a, ...)
{
    PWARNING_RETURN_INPUT(a);
    va_list ap;
    va_start(ap, a);
    int type_index = va_arg(ap, int);

    Matrix *mat;
    Matrix *b = va_arg(ap, Matrix *);

    if (b == NULL)
    {
        va_end(ap);
        return NULL;
    }

    int a_rows = a->rows, a_cols = a->cols, b_cols = b->cols, b_rows = b->rows;

    if (a_cols != b_cols && a_rows != b_rows)
    {
        PERROR(MATRIX_SIZE_ERROR_001, __FUNCTION__, __LINE__, __FILE__);
        va_end(ap);
    }

    mat = matrix_gen(a_rows, a_cols, NULL);

    if (mat == NULL)
    {
        PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(mat), __FILE__, __FUNCTION__, __LINE__);
        va_end(ap);
        return NULL;
    }

    for (int i = 0; i < a_rows * a_cols; i++)
    {
        if (type_index == 0)
        {
            mat->data[i] = a->data[i] + b->data[i];
        }
        else
        {
            mat->data[i] = a->data[i] - b->data[i];
        }
    }

    return mat;
}

Matrix *matrix_add(Matrix *a, Matrix *b)
{
    return _matrix_add_(a, 0, b);
}

Matrix *matrix_sub(Matrix *a, Matrix *b)
{
    return _matrix_add_(a, 1, b);
}

void matrix_add_void(Matrix *a, Matrix *b)
{
    matrix_copy_free(a, matrix_add(a, b));
}

void matrix_sub_void(Matrix *a, Matrix *b)
{
    matrix_copy_free(a, matrix_sub(a, b));
}

void matrix_transpose(Matrix *mat)
{
    matrix_copy_free(mat, matrix_transpose_(mat));
}

Matrix *matrix_transpose_(Matrix *mat)
{
    if (mat == NULL)
    {
        PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(mat), __FILE__, __FUNCTION__, __LINE__);
        return NULL;
    }

    Matrix *new_mat = matrix_gen(mat->cols, mat->rows, NULL);
    PWARNING_RETURN_MALLOC(mat);

    for (int i = 0; i < mat->rows; i++)
    {
        for (int j = 0; j < mat->cols; j++)
        {
            new_mat->data[IDX(new_mat->cols, j, i)] = mat->data[IDX(mat->cols, i, j)];
        }
    }

    return new_mat;
}

MATRIX_TYPE **matrixTo2Array(Matrix *mat)
{
    if (mat == NULL)
    {
        PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(mat), __FILE__, __FUNCTION__, __LINE__);
        // return NULL;
    }

    MATRIX_TYPE **array = (MATRIX_TYPE **)malloc(sizeof(MATRIX_TYPE *) * mat->rows);
    PWARNING_RETURN_MALLOC(mat);
    int m_cols = mat->cols;

    for (int i = 0; i < mat->rows; i++)
    {
        array[i] = (MATRIX_TYPE *)malloc(sizeof(MATRIX_TYPE) * m_cols);
        if (array[i] == NULL)
        {
            for (int j = 0; j < i; j++)
            {
                free(array[j]);
            }
            free(array);
            PWARNING(MALLOC_FAILURE_003, VNAME(array), __FILE__, __FUNCTION__, __LINE__ - 8);
            return NULL;
        }

        memcpy(array[i], mat->data + i * m_cols, m_cols * sizeof(MATRIX_TYPE));
    }

    return array;
}

Matrix *twoArrayToMatrix(MATRIX_TYPE **array, unsigned int rows, unsigned int cols)
{
    PWARNING_RETURN_INPUT(array);
    Matrix *mat = matrix_gen(rows, cols, NULL);

    if (mat == NULL)
    {
        PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(mat), __FILE__, __FUNCTION__, __LINE__);
        return NULL;
    }

    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            mat->data[IDX(mat->cols, i, j)] = array[i][j];
        }
    }

    return mat;
}

MATRIX_TYPE *_vector_splicing_(int num, ...)
{
    va_list ap;
    va_start(ap, num);

    MATRIX_TYPE **a = (MATRIX_TYPE **)malloc(sizeof(MATRIX_TYPE *) * num);
    if (a == NULL)
    {
        va_end(ap);
        PWARNING_RETURN_MALLOC(a);
    }

    int length = 0;
    for (int i = 0; i < num; i++)
    {
        a[i] = va_arg(ap, MATRIX_TYPE *);
        if (a[i] == NULL)
        {
            va_end(ap);

            for (int j = 0; j < i; j++)
            {
                free(a[j]);
            }

            free(a);
            PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(a[i]), __FILE__, __FUNCTION__, __LINE__);
            return NULL;
        }
        length += LENGTH(a[i]);
    }

    MATRIX_TYPE *b = (MATRIX_TYPE *)malloc(sizeof(MATRIX_TYPE) * length);
    if (b == NULL)
    {
        va_end(ap);

        for (int i = 0; i < num; i++)
        {
            free(a[i]);
        }

        free(a);
        PWARNING_RETURN_MALLOC(b);
    }

    int index = 0;
    for (int i = 0; i < num; i++)
    {
        for (int j = 0; j < LENGTH(a[i]); j++)
        {
            b[index] = a[i][j];
            index++;
        }
    }

    va_end(ap);

    for (int i = 0; i < num; i++)
    {
        free(a[i]);
    }

    free(a);
    return b;
}

Matrix *matrix_splicing(Matrix *a, Matrix *b, unsigned int aix)
{
    if (a == NULL && b == NULL)
    {
        return NULL;
    }
    else if (a == NULL)
    {
        return matrix_gen(b->rows, b->cols, b->data);
    }
    else if (b == NULL)
    {
        return matrix_gen(a->rows, a->cols, a->data);
    }
    int a_rows = a->rows, a_cols = a->cols, b_cols = b->cols, b_rows = b->rows;
    if (aix == 1 || aix == 3)
    {
        if (a_cols != b_cols)
        {
            PERROR(MATRIX_SIZE_ERROR_001, "Matrix *matrix_splicing(Matrix *a, Matrix *b, unsigned int aix);");
        }
        if (aix == 1)
        {
            return matrix_gen(a_rows + b_rows, a_cols, vector_splicing(b->data, a->data));
        }
        else
        {
            return matrix_gen(b_rows + a_rows, b_cols, vector_splicing(a->data, b->data));
        }
    }
    else if (aix == 2 || aix == 4)
    {
        if (a_rows != b_rows)
        {
            PERROR(MATRIX_SIZE_ERROR_001, "Matrix *matrix_splicing(Matrix *a, Matrix *b, unsigned int aix);");
        }
        Matrix *mat = matrix_gen(a_rows, a_cols + b_cols, NULL);
        if (mat == NULL)
        {
            return NULL;
        }
        if (aix == 2)
        {
            for (int i = 0; i < a_rows; i++)
            {
                for (int j = 0; j < a_cols; j++)
                {
                    mat->data[IDX(a_cols + b_cols, i, j)] = a->data[IDX(a_cols, i, j)];
                }
                for (int j = a_cols; j < b_cols + a_cols; j++)
                {
                    mat->data[IDX(a_cols + b_cols, i, j)] = b->data[IDX(b_cols, i, j - a_cols)];
                }
            }
        }
        else
        {
            for (int i = 0; i < b_rows; i++)
            {
                for (int j = 0; j < b_cols; j++)
                {
                    mat->data[IDX(a_cols + b_cols, i, j)] = b->data[IDX(b_cols, i, j)];
                }
                for (int j = b_cols; j < a_cols + b_cols; j++)
                {
                    mat->data[IDX(a_cols + b_cols, i, j)] = a->data[IDX(a_cols, i, j - b_cols)];
                }
            }
        }
        return mat;
    }
    else
    {
        PERROR(INVALID_INPUT_001, "aix", 1, 4, __FILE__, __FUNCTION__, __LINE__);
    }
}

Matrix *matrix_cat(Matrix *a, unsigned int begin_row, unsigned int end_row, unsigned int begin_col,
                   unsigned int end_col)
{
    if (a == NULL)
    {
        return NULL;
    }
    int rows = a->rows, cols = a->cols;
    if (begin_row > rows || end_row > rows || begin_col > cols || end_col > cols)
    {
        PERROR(MATRIX_SIZE_ERROR_001,
               "Matrix *matrix_cat(Matrix *a, unsigned int begin_row, unsigned int end_row, unsigned int begin_col, unsigned int end_col);");
    }
    int mat_rows = end_row - begin_row + 1, mat_cols = end_col - begin_col + 1;
    Matrix *mat = matrix_gen(mat_rows, mat_cols, NULL);
    if (mat == NULL)
    {
        return NULL;
    }
    for (int i = 0; i < mat->rows; i++)
    {
        for (int j = 0; j < mat->cols; j++)
        {
            mat->data[IDX(mat->cols, i, j)] = a->data[IDX(cols, i + begin_row - 1, j + begin_col - 1)];
        }
    }
    return mat;
}

void matrix_swap(Matrix *a, unsigned int aix, unsigned int select_index, unsigned int aim_index)
{
    PWARNING_RETURN_INPUT_NO_NULL(a);
    if (aix != 1 && aix != 2)
    {
        PERROR(INVALID_INPUT_001, "aix", 1, 2, __FILE__, __FUNCTION__, __LINE__);
    }

    if (aix == 1)
    {
        if (select_index > a->rows || aim_index > a->rows)
        {
            PERROR(INVALID_INPUT_001, "select_index", 1, a->rows, __FILE__, __FUNCTION__, __LINE__);
        }
        for (int i = 0; i < a->cols; i++)
        {
            MATRIX_TYPE temp = a->data[IDX(a->cols, select_index - 1, i)];
            a->data[IDX(a->cols, select_index - 1, i)] = a->data[IDX(a->cols, aim_index - 1, i)];
            a->data[IDX(a->cols, aim_index - 1, i)] = temp;
        }
    }
    else
    {
        if (select_index > a->cols || aim_index > a->cols)
        {
            PERROR(INVALID_INPUT_001, "select_index", 1, a->cols, __FILE__, __FUNCTION__, __LINE__);
        }
        for (int i = 0; i < a->rows; i++)
        {
            MATRIX_TYPE temp = a->data[IDX(a->cols, i, select_index - 1)];
            a->data[IDX(a->cols, i, select_index - 1)] = a->data[IDX(a->cols, i, aim_index - 1)];
            a->data[IDX(a->cols, i, aim_index - 1)] = temp;
        }
    }
}

int compar(const void *a, const void *b)
{
    MATRIX_TYPE *pa = *(MATRIX_TYPE **)a;
    MATRIX_TYPE *pb = *(MATRIX_TYPE **)b;
    printf("pa[0] = %.6lf, pb[0] = %.6lf\n", pa[0], pb[0]);
    if (pa[0] > pb[0])
        return 1;
    else if (pa[0] < pb[0])
        return -1;
    else
        return 0;
}

void matrix_sort_by_cols_values(Matrix *mat, unsigned int col_index, unsigned int sort_method,
                                int (*compar)(const void *, const void *, int))
{
    PWARNING_RETURN_INPUT_NO_NULL(mat);

    if (col_index > mat->cols || col_index < 1)
    {
        PERROR(INVALID_INPUT_001, "col_index", 1, mat->cols, __FILE__, __FUNCTION__, __LINE__);
    }

    MATRIX_TYPE **array = matrixTo2Array(mat);
    if (array == NULL)
    {
        return;
    }
    col_index--;
    matrix_custom_sort(array, sort_method, col_index, mat->rows, sizeof(MATRIX_TYPE *), compar);
    matrix_copy_free(mat, twoArrayToMatrix(array, mat->rows, mat->cols));
}

/* Tool function */

int matrix_sort_default_a2z(const void *a, const void *b, int col_index)
{
    MATRIX_TYPE *pa = *(MATRIX_TYPE **)a;
    MATRIX_TYPE *pb = *(MATRIX_TYPE **)b;
    if (pa[col_index] > pb[col_index])
        return 1;
    else if (pa[col_index] < pb[col_index])
        return -1;
    else
        return 0;
}

int matrix_sort_default_z2a(const void *a, const void *b, int col_index)
{
    MATRIX_TYPE *pa = *(MATRIX_TYPE **)a;
    MATRIX_TYPE *pb = *(MATRIX_TYPE **)b;
    if (pa[col_index] < pb[col_index])
        return 1;
    else if (pa[col_index] > pb[col_index])
        return -1;
    else
        return 0;
}

void matrix_gauss_elimination_(Matrix *mat, unsigned int select_index, unsigned int aim_index, double value)
{
    for (int i = 0; i < mat->cols; i++)
    {
        mat->data[IDX(mat->cols, aim_index, i)] = mat->data[IDX(mat->cols, aim_index, i)] + mat->data[IDX(
                                                                                                mat->cols, select_index, i)] *
                                                                                                value;
    }
}

// void matrix_gauss_elimination_col_(Matrix *mat, unsigned int select_index, unsigned int aim_index, double value)
// {
//     for (int i = 0; i < mat->cols; i++)
//     {
//         mat->data[IDX(mat->cols, i, aim_index)] = mat->data[IDX(mat->cols, i, aim_index)] + mat->data[IDX(mat->cols, i, select_index)] * value;
//     }
// }

void matrix_sort_by_zeros_num(Matrix *mat)
{
    Matrix *zeros_num = matrix_gen(mat->rows, 1, NULL);
    if (zeros_num == NULL)
    {
        PWARNING(PARAMETER_VALUE_ERROR_001, __FUNCTION__, __LINE__, __FILE__);
        return;
    }
    for (int i = 0; i < mat->rows; i++)
    {
        for (int j = 0; j < mat->cols; j++)
        {
            if (DOUBLE_COMPARE_EQ2ZERO(mat->data[IDX(mat->cols, i, j)]))
            {
                zeros_num->data[IDX(1, i, 0)]++;
                if (j + 1 == mat->cols || !(DOUBLE_COMPARE_EQ2ZERO(mat->data[IDX(mat->cols, i, j + 1)])))
                {
                    break;
                }
            }
            else
            {
                if (j == 0)
                {
                    break;
                }
            }
        }
    }

    Matrix *temp = matrix_splicing(mat, zeros_num, 4);
    matrix_sort_by_cols_values(temp, 1, 1, matrix_sort_default_a2z);
    matrix_copy_free(mat, matrix_cat(temp, 1, temp->rows, 2, temp->cols));

    matrix_free(zeros_num);
    matrix_free(temp);
}

void matrix_gauss_elimination(Matrix *mat)
{
    PWARNING_RETURN_INPUT_NO_NULL(mat);
    PWARNING_RETURN_INPUT_NO_NULL(mat->data);
    matrix_sort_by_zeros_num(mat);
    for (int i = 0; i < MIN(mat->cols, mat->rows) - 1; i++)
    {
        for (int j = i + 1; j < mat->rows; j++)
        {
            if (DOUBLE_COMPARE_EQ2ZERO(mat->data[IDX(mat->cols, i, i)]))
            {
                break;
            }
            else
            {
                matrix_gauss_elimination_(
                    mat, i, j, -(mat->data[IDX(mat->cols, j, i)] / mat->data[IDX(mat->cols, i, i)]));
            }
        }
    }
}

int matrix_rank(Matrix *mat)
{
    PWARNING_RETURN_INPUT_ZERO(mat);
    PWARNING_RETURN_INPUT_ZERO(mat->data);
    int rank = 0;
    Matrix *temp = matrix_gen(1, 1, NULL);
    if (temp == NULL)
    {
        PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(mat), __FILE__, __FUNCTION__, __LINE__);
        return ZERO;
    }

    matrix_copy_(temp, mat);
    matrix_gauss_elimination(temp);

    for (int i = 0; i < MIN(temp->cols, temp->rows); i++)
    {
        if (!(DOUBLE_COMPARE_EQ2ZERO(temp->data[IDX(temp->cols, i, i)])))
        {
            rank++;
        }
    }

    matrix_free(temp);
    return rank;
}

/*
 * 参考：邓勇. 一种避免除法运算的矩阵的秩的计算方法[J]. 长江大学学报(自然科学版). 2014,11,(34):1-3.
 * 此方法不稳定，当矩阵规模较大时，使用计算机计算，矩阵元素的值的小变化会对结果产生极大扰动，不建议在
 * 矩阵规模超过 5*5 的情况下使用，要计算矩阵的秩请使用：int matrix_rank(Matrix *mat) (使用高斯消元法实现)
 */
int matrix_rank_DYMethod(Matrix *mat)
{
    PWARNING_RETURN_INPUT_ZERO(mat);
    PWARNING_RETURN_INPUT_ZERO(mat->data);
    int rank = 0;
    Matrix *temp = matrix_gen(1, 1, NULL);

    if (temp == NULL)
    {
        PWARNING(PARAMETER_VALUE_ERROR_001, VNAME(mat), __FILE__, __FUNCTION__, __LINE__);
        return ZERO;
    }

    matrix_copy_(temp, mat);
    while (true)
    {
        matrix_sort_by_zeros_num(temp);
        int i = 0;

        if (DOUBLE_COMPARE_EQ2ZERO(temp->data[i]))
        {
            if (MIN(temp->cols, temp->rows) < 2)
            {
                break;
            }
            matrix_copy_free(temp, matrix_cat(temp, 2, temp->rows, 2, temp->cols));
        }
        else
        {
            if (MIN(temp->cols, temp->rows) < 2)
            {
                break;
            }

            // matrix_mul_single_double_void(temp, 2);
            Cat_Matrix *cat_mat = cat_matrix_gen(temp, 2, temp->rows, 2, temp->cols);
            matrix_copy_free(temp, cat_matrix_to_matrix_vaule(cat_mat, 0, temp->data[i]));
            cat_matrix_free(cat_mat);
            rank++;
            matrix_copy_free(temp, matrix_cat(temp, 2, temp->rows, 2, temp->cols));
        }
    }
    if (!(DOUBLE_COMPARE_EQ2ZERO(temp->data[0])))
    {
        rank++;
    }
    matrix_free(temp);
    return rank;
}

/* Cat_Matrix function */
Cat_Matrix *cat_matrix_gen(Matrix *source_matrix, unsigned int start_row, unsigned int end_row, unsigned int start_col,
                           unsigned int end_col)
{
    PWARNING_RETURN_INPUT(source_matrix);
    PWARNING_RETURN_INPUT(source_matrix->data);

    if (MAX(start_row, end_row) > source_matrix->rows || MAX(start_col, end_col) > source_matrix->cols)
    {
        return NULL;
    }
    else if (MIN(end_row - start_row, end_col - start_col) < 0 || MIN(MIN(start_row, end_row),
                                                                      MIN(start_col, end_col)) < 0)
    {
        return NULL;
    }

    Cat_Matrix *cat_mat = malloc(sizeof(Cat_Matrix));
    PWARNING_RETURN_MALLOC(cat_mat);
    cat_mat->sorce_matrix = matrix_gen(1, 1, NULL);
    cat_mat->cated_matrix = matrix_gen(1, 1, NULL);
    cat_mat->o_start_cols = start_col;
    cat_mat->o_start_rows = start_row;
    cat_mat->o_end_cols = end_col;
    cat_mat->o_end_rows = end_row;
    matrix_copy_(cat_mat->sorce_matrix, source_matrix);
    matrix_copy_free(cat_mat->cated_matrix, matrix_cat(source_matrix, start_row, end_row, start_col, end_col));
    start_row--;
    start_col--;
    end_col--;
    end_row--;

    return cat_mat;
}

void cat_matrix_free(Cat_Matrix *cat_mat)
{
    if (cat_mat == NULL)
    {
        return;
    }
    matrix_free(cat_mat->sorce_matrix);
    matrix_free(cat_mat->cated_matrix);
    free(cat_mat);
}

Matrix *cat_matrix_to_matrix(Cat_Matrix *cat_mat, unsigned int method)
{
    PWARNING_RETURN_INPUT(cat_mat);
    PWARNING_RETURN_INPUT(cat_mat->cated_matrix);
    PWARNING_RETURN_INPUT(cat_mat->sorce_matrix);

    for (int i = cat_mat->o_start_rows - 1; i < cat_mat->o_end_rows; i++)
    {
        for (int j = cat_mat->o_start_cols - 1; j < cat_mat->o_end_cols; j++)
        {
            if (method == 0)
            {
                cat_mat->sorce_matrix->data[IDX(cat_mat->sorce_matrix->cols, i, j)] = cat_mat->cated_matrix->data[IDX(
                    cat_mat->cated_matrix->cols, i - cat_mat->o_start_rows + 1, j - cat_mat->o_start_cols + 1)];
            }
            else if (method == 1)
            {
                cat_mat->sorce_matrix->data[IDX(cat_mat->sorce_matrix->cols, i, j)] += cat_mat->cated_matrix->data[IDX(
                    cat_mat->cated_matrix->cols, i - cat_mat->o_start_rows + 1, j - cat_mat->o_start_cols + 1)];
            }
            else if (method == 2)
            {
                cat_mat->sorce_matrix->data[IDX(cat_mat->sorce_matrix->cols, i, j)] -= cat_mat->cated_matrix->data[IDX(
                    cat_mat->cated_matrix->cols, i - cat_mat->o_start_rows + 1, j - cat_mat->o_start_cols + 1)];
            }
        }
    }

    return matrix_gen(cat_mat->sorce_matrix->rows, cat_mat->sorce_matrix->cols, cat_mat->sorce_matrix->data);
}

Matrix *cat_matrix_to_matrix_vaule(Cat_Matrix *cat_mat, unsigned int method, MATRIX_TYPE value)
{
    PWARNING_RETURN_INPUT(cat_mat);
    PWARNING_RETURN_INPUT(cat_mat->cated_matrix);
    PWARNING_RETURN_INPUT(cat_mat->sorce_matrix);

    for (int i = cat_mat->o_start_rows - 1; i < cat_mat->o_end_rows; i++)
    {
        for (int j = cat_mat->o_start_cols - 1; j < cat_mat->o_end_cols; j++)
        {
            if (method == 0)
            {
                cat_mat->sorce_matrix->data[IDX(cat_mat->sorce_matrix->cols, i, j)] = cat_mat->cated_matrix->data[IDX(
                                                                                          cat_mat->cated_matrix->cols, i - cat_mat->o_start_rows + 1,
                                                                                          j - cat_mat->o_start_cols + 1)] *
                                                                                      value;
            }
            else if (method == 1)
            {
                cat_mat->sorce_matrix->data[IDX(cat_mat->sorce_matrix->cols, i, j)] += cat_mat->cated_matrix->data[IDX(
                                                                                           cat_mat->cated_matrix->cols, i - cat_mat->o_start_rows + 1, j - cat_mat->o_start_cols + 1)] *
                                                                                       value;
            }
            else if (method == 2)
            {
                cat_mat->sorce_matrix->data[IDX(cat_mat->sorce_matrix->cols, i, j)] -= cat_mat->cated_matrix->data[IDX(
                                                                                           cat_mat->cated_matrix->cols, i - cat_mat->o_start_rows + 1, j - cat_mat->o_start_cols + 1)] *
                                                                                       value;
            }
        }
    }

    return matrix_gen(cat_mat->sorce_matrix->rows, cat_mat->sorce_matrix->cols, cat_mat->sorce_matrix->data);
}

/* OpenMP function */
Matrix *matrix_gen_omp(unsigned int rows, unsigned int cols, MATRIX_TYPE *data)
{
    if (rows == 0)
    {
        printf(INPUT_NULL_002, VNAME(rows), __FILE__, __FUNCTION__, __LINE__ - 1);
        return NULL;
    }
    else if (cols == 0)
    {
        printf(INPUT_NULL_002, VNAME(cols), __FILE__, __FUNCTION__, __LINE__ - 1);
        return NULL;
    }

    Matrix *mat = malloc(sizeof(Matrix));
    // if (mat == NULL)
    // {
    //     PWARNING_RETURN(MALLOC_FAILURE_001, __FILE__, __FUNCTION__, __LINE__);

    // }
    PWARNING_RETURN_MALLOC(mat);

    mat->rows = rows;
    mat->cols = cols;
    mat->data = (data == NULL || LENGTH(data) != rows * cols) ? calloc(rows * cols, sizeof(MATRIX_TYPE)) : data;

    // if (mat->data == NULL)
    // {
    //     free(mat);
    //     PWARNING_RETURN(MALLOC_FAILURE_001, __FILE__, __FUNCTION__, __LINE__);

    // }
    PWARNING_RETURN_MALLOC(mat->data);
    if (data == NULL)
    {
        omp_set_num_threads(OMP_MAX_THREADS_NUM);
#pragma omp parallel for
        for (int i = 0; i < rows * cols; i++)
        {
            mat->data[i] = 0;
        }
        printf("I am thread %d / %d \n",
               omp_get_thread_num(), omp_get_num_threads());
#pragma omp barrier
    }
    else
    {
        memcpy(mat->data, data, rows * cols * sizeof(MATRIX_TYPE));
    }

    return mat;
}

/* index 为实际的行列，非索引*/
void matrix_swap_omp(Matrix *a, unsigned int aix, unsigned int select_index, unsigned int aim_index)
{
    if (a == NULL)
        return;
    if (aix != 1 && aix != 2)
    {
        PERROR(INVALID_INPUT_001, "aix", 1, 2, __FILE__, __FUNCTION__, __LINE__);
    }

    omp_set_num_threads(OMP_MAX_THREADS_NUM);
#pragma omp parallel
    if (aix == 1)
    {
        if (select_index > a->rows || aim_index > a->rows)
        {
            PERROR(INVALID_INPUT_001, "select_index", 1, a->rows, __FILE__, __FUNCTION__, __LINE__);
        }
#pragma omp for
        for (int i = 0; i < a->cols; i++)
        {
            MATRIX_TYPE temp = a->data[IDX(a->cols, select_index - 1, i)];
            a->data[IDX(a->cols, select_index - 1, i)] = a->data[IDX(a->cols, aim_index - 1, i)];
            a->data[IDX(a->cols, aim_index - 1, i)] = temp;
        }
    }
    else
    {
        if (select_index > a->cols || aim_index > a->cols)
        {
            PERROR(INVALID_INPUT_001, "select_index", 1, a->cols, __FILE__, __FUNCTION__, __LINE__);
        }
#pragma omp for
        for (int i = 0; i < a->rows; i++)
        {
            MATRIX_TYPE temp = a->data[IDX(a->cols, i, select_index - 1)];
            a->data[IDX(a->cols, i, select_index - 1)] = a->data[IDX(a->cols, i, aim_index - 1)];
            a->data[IDX(a->cols, i, aim_index - 1)] = temp;
        }
    }
}
