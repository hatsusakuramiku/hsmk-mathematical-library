#include "Matrix.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>
#include <string.h>
#include <stdarg.h>

Matrix *matrix_gen(unsigned int rows, unsigned int cols, MATRIX_TYPE *data)
{
    if (rows == 0 || cols == 0)
    {
        return NULL;
    }

    Matrix *mat = malloc(sizeof(Matrix));
    if (mat == NULL)
    {
        return NULL;
    }

    mat->rows = rows;
    mat->cols = cols;
    mat->data = (data == NULL || LENGTH(data) != rows * cols) ? calloc(rows * cols, sizeof(MATRIX_TYPE)) : data;

    if (mat->data == NULL)
    {
        free(mat);
        return NULL;
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
        memcpy(mat->data, data, rows * cols * sizeof(MATRIX_TYPE));
    }

    return mat;
}

Matrix *matrix_copy(Matrix *_sourse_mat)
{
    if (_sourse_mat == NULL)
    {
        return NULL;
    }
    Matrix *mat = matrix_gen(_sourse_mat->rows, _sourse_mat->cols, _sourse_mat->data);
    return mat;
}

/**
 * Copies the contents of matrix `b` to matrix `a`.
 *
 * @param a The matrix to copy to.
 * @param b The matrix to copy from.
 */
void matrix_copy_(Matrix *a, Matrix *b)
{
    // If either matrix is NULL, there is nothing to do.
    if (a == NULL || b == NULL)
    {
        return;
    }

    // Copy the data from `b` to `a`.
    memcpy(a->data, b->data, b->rows * b->cols * sizeof(MATRIX_TYPE));

    // Update the dimensions of `a` to match `b`.
    a->rows = b->rows;
    a->cols = b->cols;
}
// void matrix_copy_(Matrix *a, Matrix *b)
// {
//     if (a == NULL || b == NULL)
//     {
//         return;
//     }
//     memcpy(a->data, b->data, b->rows * b->cols * sizeof(MATRIX_TYPE));
//     a->rows = b->rows;
//     a->cols = b->cols;
// }

void matrix_free(Matrix *mat)
{
    if (mat == NULL)
    {
        // No need to free anything, just return
        return;
    }

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
    if (mat == NULL)
    {
        printf("Matrix is NULL\n");
        return;
    }
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
            }else{
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
        return NULL;
    }
    Matrix *mat = matrix_gen(rows, cols, NULL);
    if (mat == NULL)
    {
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
        PERROR(VAR_LIST_LENGTH_002, 1, 3, __FILE__, __FUNCTION__, __LINE__);
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
        return NULL;
    }
    Matrix *mat = matrix_gen(rows, cols, NULL);
    if (mat == NULL)
    {
        return NULL;
    }
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
        PERROR(VAR_LIST_LENGTH_002, 1, 3, __FILE__, __FUNCTION__, __LINE__);
    }
}

Matrix *rand_matrix(unsigned int rows, unsigned int cols, MATRIX_TYPE min, MATRIX_TYPE max)
{
    if (rows == 0 || cols == 0)
    {
        return NULL;
    }
    Matrix *mat = matrix_gen(rows, cols, NULL);
    if (mat == NULL)
    {
        return NULL;
    }
    for (int i = 0; i < rows * cols; i++)
    {
        mat->data[i] = RAND(min, max, MATRIX_TYPE);
    }
    return mat;
}

bool matrix_eq(Matrix *a, Matrix *b)
{
    if (a == NULL || b == NULL)
    {
        return false;
    }
    if (a->rows != b->rows || a->cols != b->cols)
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
    if (a == NULL)
    {
        return NULL;
    }

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
            PERROR(MATRIX_SIZE_ERROR_001, "Matrix *matrix_mul(Matrix *a, Matrix *b);");
            va_end(ap);
            return NULL;
        }

        mat = matrix_gen(a_rows, b_cols, NULL);
        if (mat == NULL)
        {
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
    matrix_copy_(a, matrix_mul(a, b));
}

void matrix_right_mul_void(Matrix *a, Matrix *b)
{
    matrix_mul_void(b, a);
}

void matrix_mul_single_int_void(Matrix *a, int b)
{
    matrix_copy_(a, matrix_mul_single_int(a, b));
}

void matrix_mul_single_double_void(Matrix *a, double b)
{
    matrix_copy_(a, matrix_mul_single_double(a, b));
}

Matrix *_matrix_add_(Matrix *a, ...)
{
    if (a == NULL)
    {
        return NULL;
    }
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
        PERROR(MATRIX_SIZE_ERROR_001, "Matrix *matrix_mul(Matrix *a, Matrix *b);");
        va_end(ap);
        return NULL;
    }
    mat = matrix_gen(a_rows, a_cols, NULL);
    if (mat == NULL)
    {
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
    matrix_copy_(a, matrix_add(a, b));
}

void matrix_sub_void(Matrix *a, Matrix *b)
{
    matrix_copy_(a, matrix_sub(a, b));
}

void matrix_transpose(Matrix *mat)
{
    matrix_copy_(mat, matrix_transpose_(mat));
}

Matrix *matrix_transpose_(Matrix *mat)
{
    if (mat == NULL)
    {
        return NULL;
    }
    Matrix *new_mat = matrix_gen(mat->cols, mat->rows, NULL);
    if (new_mat == NULL)
    {
        return NULL;
    }
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
        return NULL;
    }
    MATRIX_TYPE **array = (MATRIX_TYPE **)malloc(sizeof(MATRIX_TYPE *) * mat->rows);
    if (array == NULL)
    {
        return NULL;
    }
    for (int i = 0; i < mat->rows; i++)
    {
        array[i] = (MATRIX_TYPE *)malloc(sizeof(MATRIX_TYPE) * mat->cols);
        if (array[i] == NULL)
        {
            for (int j = 0; j < i; j++)
            {
                free(array[j]);
            }
            free(array);
            return NULL;
        }
        int m_cols = mat->cols;
        for (int j = 0; j < mat->cols; j++)
        {
            array[i][j] = mat->data[IDX(m_cols, j, i)];
        }
    }
    return array;
}

Matrix *twoArrayToMatrix(MATRIX_TYPE **array, unsigned int rows, unsigned int cols)
{
    if (array == NULL)
    {
        return NULL;
    }
    Matrix *mat = matrix_gen(rows, cols, NULL);
    if (mat == NULL)
    {
        return NULL;
    }
    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            mat->data[IDX(mat->cols, j, i)] = array[i][j];
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
        PERROR("Failed to allocate memory for vector_splicing.\n");
        return NULL;
    }

    int length = 0;
    for (int i = 0; i < num; i++)
    {
        a[i] = va_arg(ap, MATRIX_TYPE *);
        if (a[i] == NULL)
        {
            va_end(ap);
            free(a);
            PERROR("Null pointer found in vector_splicing.\n");
            return NULL;
        }
        length += LENGTH(a[i]);
    }

    MATRIX_TYPE *b = (MATRIX_TYPE *)malloc(sizeof(MATRIX_TYPE) * length);
    if (b == NULL)
    {
        va_end(ap);
        free(a);
        PERROR("Failed to allocate memory for vector_splicing.\n");
        return NULL;
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
    free(a);
    return b;
}

Matrix *matrix_splicing(Matrix *a, Matrix *b, unsigned int aix)
{
    if (a == NULL && b == NULL)
    {
        return NULL;
    }
    else if (a == NULL && b != NULL)
    {
        return matrix_gen(b->rows, b->cols, b->data);
    }
    else if (a != NULL && b == NULL)
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
        if (aix = 1)
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
        if (aix = 2)
        {
            for (int i = 0; i < a_rows; i++)
            {
                for (int j = 0; j < a_cols; j++)
                {
                    mat->data[IDX(a_cols + b_cols, i, j)] = a->data[IDX(a_cols, i, j)];
                }
                for (int j = a_cols; j < b_cols + a_cols; j++)
                {
                    mat->data[IDX(a_cols + b_cols, i, j + a_cols)] = b->data[IDX(b_cols, i, j)];
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
                    mat->data[IDX(a_cols + b_cols, i, j + b_cols)] = a->data[IDX(a_cols, i, j)];
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

Matrix *matrix_cat(Matrix *a, unsigned int begin_row, unsigned int end_row, unsigned int begin_col, unsigned int end_col)
{

    if (a == NULL)
    {
        return NULL;
    }
    int rows = a->rows, cols = a->cols;
    if (begin_row > rows || end_row > rows || begin_col > cols || end_col > cols)
    {
        PERROR(MATRIX_SIZE_ERROR_001, "Matrix *matrix_cat(Matrix *a, unsigned int begin_row, unsigned int end_row, unsigned int begin_col, unsigned int end_col);");
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

    if (a == NULL)
        return;
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

/* Tool function */

/* OpenMP function */
Matrix *matrix_gen_omp(unsigned int rows, unsigned int cols, MATRIX_TYPE *data)
{
    if (rows == 0 || cols == 0)
    {
        return NULL;
    }

    Matrix *mat = malloc(sizeof(Matrix));
    if (mat == NULL)
    {
        // PWARNING_RETURN(MALLOC_FAILURE_001, __FILE__, __FUNCTION__, __LINE__);
        PWARNING_RETURN_MALLOC;
    }

    mat->rows = rows;
    mat->cols = cols;
    mat->data = (data == NULL || LENGTH(data) != rows * cols) ? calloc(rows * cols, sizeof(MATRIX_TYPE)) : data;

    if (mat->data == NULL)
    {
        free(mat);
        // PWARNING_RETURN(MALLOC_FAILURE_001, __FILE__, __FUNCTION__, __LINE__);
        PWARNING_RETURN_MALLOC;
    }

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