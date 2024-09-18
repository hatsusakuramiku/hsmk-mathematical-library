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
 * @file matrix.c
 */

#ifndef _HSMK_MATH_LIB_MATRIX_H
#define _HSMK_MATH_LIB_MATRIX_H

#define MATRIX_TYPE double                   /// Matrix default type
#define MATRIX_DEFAULT_PRECISION "%10.6lf\t" /// matrix default precision
#define MATRIX_COLS_OMIT_PRINT_LIMIT 20      /// matrix cols omit print limit
#define MATRIX_ROWS_OMIT_PRINT_LIMIT 200     /// matrix rows omit print limit
#define MATRIX_TYPE_SIZE sizeof(MATRIX_TYPE)

/// Matrix sort compare function type
typedef int (*__matrix_cmp_func)(void *, const void *, const void *);

/**
 * @brief A function pointer type for comparing matrix elements.
 *
 * This function pointer type is used to define a custom comparison function for finding matrix elements.
 * The function takes two `const void*` pointers as arguments, representing the elements to be compared.
 * The function should return an integer value:
 * - 1 if the elements satisfy the condition
 * - 0 if the elements do not satisfy the condition
 *
 * First argument: Pointer to the first element to compare.
 * Second argument: Pointer to the second element to compare.
 * @return An integer value: 1 if the elements satisfy the condition, 0 if they do not.
 */
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
#define MATRIX_SIZE_ERROR_002 "@ERROR: The input matrix called \"%s\" must be a square matrix\n@File: %s\n@Function: %s\n@Line: %d\n"

//
enum ARRAY_CMP_TYPE {
 _INT_,
 _DOUBLE_
};

/// Matrix struct

/**
 * @struct _elem_pos
 * @brief Represents a single element position in a matrix.
 *
 * This struct contains the row and column indices, as well as the value of the element.
 */
typedef struct _elem_pos {
 /**
  * @var row
  * @brief The row index of the element.
  */
 unsigned int row;

 /**
  * @var col
  * @brief The column index of the element.
  */
 unsigned int col;

 /**
  * @var value
  * @brief The value of the element.
  */
 MATRIX_TYPE value;
} elem_pos;

/**
 * @struct _elem_pos_array
 * @brief Represents an array of element positions in a matrix.
 *
 * This struct contains a pointer to an array of elem_pos structs, as well as the size of the array.
 */
typedef struct _elem_pos_array {
 /**
  * @var elem_pos_arr
  * @brief A pointer to an array of elem_pos structs.
  */
 struct _elem_pos *elem_pos_arr;

 /**
  * @var size
  * @brief The size of the array.
  */
 unsigned int size;
} elem_pos_array;

elem_pos new_elem_pos(const unsigned int row, const unsigned int col, MATRIX_TYPE value);

static int array_cmp(const void *a, const void *b, enum ARRAY_CMP_TYPE type);

/**
 * @struct _Matrix
 * @brief Represents a matrix with rows, columns, and data.
 */
typedef struct _Matrix {
 /**
  * @var rows
  * @brief The number of rows in the matrix.
  */
 unsigned int rows;

 /**
  * @var cols
  * @brief The number of columns in the matrix.
  */
 unsigned int cols;

 /**
  * @var data
  * @brief A pointer to the matrix data, stored in a contiguous array.
  */
 MATRIX_TYPE *data;
} Matrix;

/**
 * @typedef MVector
 * @brief Alias for Matrix, representing a vector.
 *
 * This type alias is used to distinguish between matrix and vector operations,
 * although the underlying data structure is the same.
 */
typedef Matrix MVector;

/// 2D array index to matrix index
#define IDX(col, rows, cols) ((col) * (rows) + (cols))

/// Variadics function
Matrix *__ones_matrix(const int num, ...);

Matrix *__eye_matrix(const int num, ...);

static Matrix *__matrix_mul(Matrix *a, ...);

static Matrix *__matrix_add(Matrix *a, ...);

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
#define ones_matrix_value(...) __ones_matrix(ARGC(__VA_ARGS__), __VA_ARGS__)

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
#define eye_matrix_value(...) __eye_matrix(ARGC(__VA_ARGS__), __VA_ARGS__)

// Matrix function
Matrix *matrix_gen(const unsigned int rows, const unsigned int cols, const MATRIX_TYPE *data); // generate matrix
Matrix *matrix_gen_r(const unsigned int rows, const unsigned int cols, const MATRIX_TYPE *data,
                     const unsigned int data_rows,
                     const unsigned int data_cols); // generate matrix
Matrix *matrix_copy(const Matrix *_source_mat); // copy matrix
void matrix_copy_r(Matrix **dest, const Matrix *src);

void matrix_copy_free(Matrix **dest, Matrix **src); // copy matrix
void matrix_free(Matrix **mat); // free matrix

void matrix_print(const Matrix *mat); // print matrix
void matrix_print_P(const Matrix *mat, const unsigned int rowsLimit, const unsigned int colsLimit); // print matrix
static void print_matrix_without_omitting_elements(const Matrix *mat, int rows, int cols);

static void print_matrix_with_omitted_elements(const Matrix *mat, int rows, int cols, const int rowsLimit, const int colsLimit);

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

Matrix *matrix_splicing(const Matrix *a, const Matrix *b, const unsigned int aix); // matrix splicing
Matrix *matrix_cat(const Matrix *a, const unsigned int begin_row, const unsigned int end_row,
                   const unsigned int begin_col,
                   const unsigned int end_col); // matrix cat
void matrix_swap(const Matrix *a, const unsigned int aix, const unsigned int select_index,
                 const unsigned int aim_index);

void matrix_swap_p(const Matrix *a, const unsigned int aix, const unsigned int select_index,
                   const unsigned int aim_index, const unsigned int begin_index, const unsigned int end_index);

int matrix_default_cmp_for_qsort_s(void *index, const void *a, const void *b);

int matrix_default_cmp_for_qsort_s_down(void *index, const void *a, const void *b);

int matrix_default_cmp_for_sort(const void *a, const void *b, void *index);

int matrix_default_cmp_for_sort_down(const void *a, const void *b, void *index);

void matrix_sort_by_cols_values(const Matrix *mat, const unsigned int col_index, const unsigned int aix); // matrix
// sort by
// rows values
void matrix_sort_by_zeros_num(const Matrix *mat, const unsigned int aix);

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

Matrix *matrix_cdot_mul(const Matrix *a, const Matrix *b);

void matrix_cdot_mul_void(Matrix *a, const Matrix *b);

void matrix_change(Matrix *mat, void *arg, MATRIX_TYPE (*func)(MATRIX_TYPE, void *));

void matrix_swap_elem(Matrix *mat, elem_pos pos1, elem_pos pos2);

int isUpTriangleMatrix(const Matrix *mat);

int isLowerTriangleMatrix(const Matrix *mat);

Matrix *matrix_invert(Matrix *mat);

elem_pos_array *matrix_find_unique(const Matrix *mat);

int isMatrixMember(const Matrix *mat, MATRIX_TYPE value);

MATRIX_TYPE matrix_det(Matrix *mat);

MVector *matrix_eigen_matrix(Matrix *mat);

MVector *rangeVector(const double begin, const double end, const unsigned int nodeNum);

MVector *genMVector(unsigned int length, unsigned int aix, MATRIX_TYPE *arr);

int isMVector(const Matrix *vec);

MVector *getMatrixRowVector(Matrix *mat, unsigned int row_index);

MVector *getMatrixColVector(Matrix *mat, unsigned int col_index);

MVector *getMatrixDiagonalVector(Matrix *mat);

MVector *getMatrixDiagonalVector_p(Matrix *mat, int aix);

MVector *matrix_eigen_vector(Matrix *mat);

Matrix *matrixEquation(Matrix *aMat, Matrix *bMat);

Matrix *diagMatrix_p(MVector *vec, const int aix);

Matrix *diagMatrix(MVector *vec);


/**
 * @struct _PLUMatrix
 * @brief Represents a PLU decomposition of a matrix.
 *
 * This struct contains pointers to the source matrix and the decomposed L, U, and P matrices.
 */
typedef struct _PLUMatrix {
 /**
  * @brief The source matrix being decomposed.
  */
 Matrix *srcMatrix; // 源矩阵

 /**
  * @brief The lower triangular matrix (L) resulting from the decomposition.
  */
 Matrix *LMatrix; // L矩阵

 /**
  * @brief The upper triangular matrix (U) resulting from the decomposition.
  */
 Matrix *UMatrix; // U矩阵

 /**
  * @brief The permutation matrix (P) resulting from the decomposition.
  */
 Matrix *PMatrix; // P矩阵
} PLUMatrix;

PLUMatrix *matrixPLUDecDiagCard(Matrix *mat);

PLUMatrix *matrixPLUDecMaxCard(Matrix *mat);

#endif // _HSMK_MATH_LIB_MATRIX_H
