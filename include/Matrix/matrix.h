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

/**
 *@file matrix.h
 *@brief Matrix
 *@author hatsusakuramiku
 *@version 0.1
 *@date 2024-8-17
 */

#ifndef _HSMK_MATH_LIB_MATRIX_H
#define _HSMK_MATH_LIB_MATRIX_H

#define MATRIX_TYPE double                   /// Matrix default type
#define MATRIX_DEFAULT_PRECISION "%10.6lf\t" /// matrix default precision
#define MATRIX_COLS_OMIT_PRINT_LIMIT 20      /// matrix cols omit print limit
#define MATRIX_ROWS_OMIT_PRINT_LIMIT 200     /// matrix rows omit print limit

/// Matrix sort compare function type
typedef int (*__matrix_cmp_func)(void *, const void *, const void *);

typedef int (*__matrix_find_cmp_func)(const void *, const void *);

#ifndef size_t
#ifdef _WIN64
#define size_t unsigned long long int
#else
#define size_t unsigned long int
#endif
#endif

/// Error define
#define MATRIX_SIZE_ERROR_001 "@ERROR: The matrix size does not match\n@File: %s\n@Function: %s\n@Line: %d\n"

//
enum ARRAY_CMP_TYPE {
    _INT_,
    _DOUBLE_
};

/// Matrix struct
typedef struct _matrix_size {
    unsigned int rows;
    unsigned int cols;
} matrix_size;

typedef struct _elem_pos {
    unsigned int row;
    unsigned int col;
    MATRIX_TYPE value;
} elem_pos;

typedef struct _elem_pos_array {
    struct _elem_pos *elem_pos_arr;
    unsigned int size;
} elem_pos_array;

matrix_size new_matrix_size(const unsigned int rows, const unsigned int cols);

elem_pos new_elem_pos(const unsigned int row, const unsigned int col, MATRIX_TYPE value);

int matrix_size_cmp(const matrix_size a, const matrix_size b);

static int array_cmp(const void *a, const void *b, enum ARRAY_CMP_TYPE type);

typedef struct _Matrix {
    unsigned int rows;
    unsigned int cols;
    matrix_size size;
    MATRIX_TYPE *data;
} Matrix;

/// 2D array index to matrix index
#define IDX(col, rows, cols) ((col) * (rows) + (cols))

/// Variadics function
Matrix *__ones_matrix(const int num, ...);

Matrix *__eye_matrix(const int num, ...);

static Matrix *__matrix_mul(Matrix *a, ...);

static Matrix *__matrix_add(Matrix *a, ...);

#define ones_matrix_value(...) __ones_matrix(ARGC(__VA_ARGS__), __VA_ARGS__)

#define eye_matrix_value(...) __eye_matrix(ARGC(__VA_ARGS__), __VA_ARGS__)

// Matrix function
Matrix *matrix_gen(const unsigned int rows, const unsigned int cols, const MATRIX_TYPE *data); // generate matrix
Matrix *matrix_gen_r(const unsigned int rows, const unsigned int cols, const MATRIX_TYPE *data,
                     const unsigned int data_rows,
                     const unsigned int data_cols); // generate matrix
Matrix *matrix_copy(const Matrix *_sourse_mat); // copy matrix
void matrix_copy_r(Matrix **dest, const Matrix *src);

void matrix_copy_free(Matrix **dest, Matrix **src); // copy matrix
void matrix_free(Matrix **mat); // free matrix

void matrix_print(const Matrix *mat); // print matrix
static void print_matrix_without_omitting_elements(const Matrix *mat, int rows, int cols);

static void print_matrix_with_omitted_elements(const Matrix *mat, int rows, int cols);

static void print_ellipsis_row(const Matrix *mat, int cols);

Matrix *ones_matrix(const unsigned int rows, const unsigned int cols); // generate ones matrix
Matrix *zeros_matrix(const unsigned int rows, const unsigned int cols); // generate zeros matrix
Matrix *eye_matrix(const unsigned int rows, const unsigned int cols); // generate eye matrix
Matrix *rand_matrix(const unsigned int rows, const unsigned int cols, MATRIX_TYPE min, MATRIX_TYPE max);

// generate random matrix
int matrix_eq(const Matrix *a, const Matrix *b); // matrix equal
Matrix *matrix_mul(Matrix *a, Matrix *b); // matrix multiply
Matrix *matrix_right_mul(Matrix *a, Matrix *b); // matrix right multiply
Matrix *matrix_mul_single(Matrix *a, const MATRIX_TYPE b);

void matrix_mul_void(Matrix *a, Matrix *b); // matrix multiply
void matrix_right_mul_void(Matrix *a, Matrix *b); // matrix right multiply
void matrix_mul_single_void(Matrix *a, const MATRIX_TYPE b);

Matrix *matrix_add(Matrix *a, Matrix *b); // matrix add
Matrix *matrix_sub(Matrix *a, Matrix *b); // matrix su
void matrix_add_void(Matrix *a, Matrix *b); // matrix add
void matrix_sub_void(Matrix *a, Matrix *b); // matrix sub
void matrix_transpose(Matrix *mat); // matrix transpose
Matrix *matrix_transpose_r(const Matrix *mat); // matrix transpose
MATRIX_TYPE **matrix_to_2D_array(const Matrix *mat); // matrix to 2D array
Matrix *matrix_from_2D_array(MATRIX_TYPE **array, const unsigned int rows, const unsigned int cols);

// 2D array to matrix
Matrix *matrix_splicing(const Matrix *a, const Matrix *b, const unsigned int aix); // matrix splicing
Matrix *matrix_cat(const Matrix *a, const unsigned int begin_row, const unsigned int end_row,
                   const unsigned int begin_col,
                   const unsigned int end_col); // matrix cat
void matrix_swap(const Matrix *a, const unsigned int aix, const unsigned int select_index,
                 const unsigned int aim_index);

int matrix_default_cmp_r(void *index, const void *a, const void *b);

void matrix_sort_by_cols_values(const Matrix *mat, const unsigned int col_index); // matrix sort by rows values
void matrix_sort_by_zeros_num(const Matrix *mat);

void matrix_gauss_elimination_(const Matrix *mat, const unsigned int select_index, const unsigned int aim_index,
                               const int
                               begin_index,
                               const MATRIX_TYPE value);

void matrix_gauss_elimination(const Matrix *mat);

void matrix_normalization(const Matrix *mat);

int matrix_rank(const Matrix *mat);

int matrix_default_find_cmp(const void *a, const void *b);

elem_pos_array *matrix_find(const Matrix *mat, MATRIX_TYPE value, __matrix_find_cmp_func cmp_func);

MATRIX_TYPE matrix_min(const Matrix *mat);

MATRIX_TYPE matrix_max(const Matrix *mat);

elem_pos_array *matrix_min_array(const Matrix *mat);

elem_pos_array *matrix_max_array(const Matrix *mat);

Matrix *matrix_dot_mul(const Matrix *a, const Matrix *b);

void matrix_dot_mul_void(Matrix *a, const Matrix *b);

void matrix_change(Matrix *mat, void *arg, MATRIX_TYPE (*func)(MATRIX_TYPE, void *));
#endif // _HSMK_MATH_LIB_MATRIX_H
