#include "Matrix.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
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

void matrix_copy_(Matrix *a, Matrix *b)
{
    if (a == NULL || b == NULL)
    {
        return;
    }
    memcpy(a->data, b->data, b->rows * b->cols * sizeof(MATRIX_TYPE));
    a->rows = b->rows;
    a->cols = b->cols;
}

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
    for (int i = 0; i < mat->rows; i++)
    {
        for (int j = 0; j < mat->cols; j++)
        {
            printf(MATRIX_DEFAULT_PRECISION, mat->data[IDX(mat->cols, i, j)]);
        }
        printf("\n");
    }
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
            PWARNING(VALUE_TYPE_WARNING_001, 0, "Matrix *ones_matrix_value(unsigned int rows, unsigned int cols, MATRIX_TYPE value);\n");
        }
        for (int i = 0; i < rows * cols; i++)
        {
            mat->data[i] = value;
        }
        return mat;
    }
    else
    {
        PERROR(VAR_LIST_LENGTH_002, "Matrix *ones_matrix_value(unsigned int rows, unsigned int cols, MATRIX_TYPE value);", 1, 3);
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
            PWARNING(VALUE_TYPE_WARNING_001, 0, "Matrix *eye_matrix_value(unsigned int rows, unsigned int cols, MATRIX_TYPE value);\n");
        }
        for (int i = 0; i < MIN(rows, cols); i++)
        {
            mat->data[IDX(cols, i, i)] = value;
        }
        return mat;
    }
    else
    {
        PERROR(VAR_LIST_LENGTH_002, "Matrix *eye_matrix_value(unsigned int rows, unsigned int cols, MATRIX_TYPE value);", 1, 3);
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

Matrix* matrix_transpose_(Matrix *mat){
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
            new_mat->data[IDX(mat->cols, j, i)] = mat->data[IDX(mat->rows, i, j)];
        }
    }
    return new_mat;
}

