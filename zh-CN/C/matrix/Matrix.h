#ifndef _MATRIX_H_
#define _MATRIX_H_
#include "../ConstDef.h"

#define MATRIX_DEFAULT_TYPE double
#define MATRIX_DEFAULT_PRECISION "%-10.6lf\t"
#define MATRIX_COLS_OMIT_PRINT_LIMIT 20
#define MATRIX_ROWS_OMIT_PRINT_LIMIT 200

#define MATRIX_TYPE MATRIX_DEFAULT_TYPE

/* ERROR DEFINE */
#define MATRIX_SIZE_ERROR_001 "@ERROR: The matrix size does not match\n@Function: %s\n"

/* MATRIX DEFINE */
typedef struct _Matrix
{
    unsigned int rows;
    unsigned int cols;
    MATRIX_TYPE *data;
} Matrix;

typedef struct _Eifen
{
    unsigned int num;
    MATRIX_TYPE *value;
    MATRIX_TYPE max_value;
    MATRIX_TYPE min_value;
    MATRIX_TYPE *eifen_vector;
} Eifen;

typedef struct _Complex_Matrix
{
    Matrix *main_marix;
    Matrix *upper_matrix;
    Matrix *lower_matrix;
    Eifen *eifen;
    int rank;
} Complex_Matrix;

#define IDX(col, rows, cols) ((col) * (rows) + (cols))
#define LENGTH(vector) ((vector) == NULL ? 0 : _msize(vector) / sizeof(vector))
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define RAND(min, max, TYPE) \
    ((TYPE)((min) + ((max - min) * ((TYPE)rand()) / ((TYPE)RAND_MAX + 1.0))))
#define INDEX_END(col, rows) ((col - 1) * (rows))
/* Variadics function */
Matrix *_ones_matrix_(int num, ...);      // generate ones matrix
Matrix *_eye_matrix_(int num, ...);       // generate eye matrix
Matrix *_matrix_mul_(Matrix *a, ...);     // matrix multiply
Matrix *_matrix_add_(Matrix *a, ...);     // matrix add
MATRIX_TYPE *_vector_splicing_(int num, ...); // vector compose
#define ones_matrix_value(...) _ones_matrix_(ARGC(__VA_ARGS__), __VA_ARGS__)
#define eye_matrix_value(...) _eye_matrix_(ARGC(__VA_ARGS__), __VA_ARGS__)
#define vector_splicing(...) _vector_splicing_(ARGC(__VA_ARGS__), __VA_ARGS__)

/* Tool function */

/* Function */
Matrix *matrix_gen(unsigned int rows, unsigned int cols, MATRIX_TYPE *data);// generate matrix
Matrix *matrix_copy(Matrix *_sourse_mat);// copy matrix
void matrix_copy_(Matrix *a, Matrix *b);// copy matrix
void matrix_free(Matrix *mat);// free matrix
void matrix_print(Matrix *mat);// print matrix
Matrix *ones_matrix(unsigned int rows, unsigned int cols);// generate ones matrix
Matrix *zeros_matrix(unsigned int rows, unsigned int cols);// generate zeros matrix
Matrix *eye_matrix(unsigned int rows, unsigned int cols);// generate eye matrix
Matrix *rand_matrix(unsigned int rows, unsigned int cols, MATRIX_TYPE min, MATRIX_TYPE max);// generate random matrix
bool matrix_eq(Matrix *a, Matrix *b);// matrix equal
Matrix *matrix_mul(Matrix *a, Matrix *b);// matrix multiply
Matrix *matrix_right_mul(Matrix *a, Matrix *b);// matrix right multiply
Matrix *matrix_mul_single_int(Matrix *a, int b);// matrix multiply
Matrix *matrix_mul_single_double(Matrix *a, double b);// matrix multiply
void matrix_mul_void(Matrix *a, Matrix *b);// matrix multiply
void matrix_right_mul_void(Matrix *a, Matrix *b);// matrix right multiply
void matrix_mul_single_int_void(Matrix *a, int b);// matrix multiply
void matrix_mul_single_double_void(Matrix *a, double b);// matrix multiply
Matrix *matrix_add(Matrix *a, Matrix *b);// matrix add
Matrix *matrix_sub(Matrix *a, Matrix *b);// matrix sub
void matrix_add_void(Matrix *a, Matrix *b);// matrix add
void matrix_sub_void(Matrix *a, Matrix *b);// matrix sub
void matrix_transpose(Matrix *mat);// matrix transpose
Matrix *matrix_transpose_(Matrix *mat);// matrix transpose
MATRIX_TYPE **matrixTo2Array(Matrix *mat);// matrix to 2D array
Matrix *twoArrayToMatrix(MATRIX_TYPE **array, unsigned int rows, unsigned int cols);// 2D array to matrix
Matrix *matrix_splicing(Matrix *a, Matrix *b, unsigned int aix);// matrix splicing
Matrix *matrix_cat(Matrix *a, unsigned int begin_row, unsigned int end_row, unsigned int begin_col, unsigned int end_col);// matrix cat
void matrix_swap(Matrix *a, unsigned int aix, unsigned int select_index, unsigned int aim_index);// matrix row/col swap
Matrix *matrix_2uppper_triangle(Matrix *mat);
void matrix__2upper_triangle_void(Matrix *mat);
Matrix *matrix_2lower_triangle(Matrix *mat);
void matrix__2lower_triangle_void(Matrix *mat);
int matrix_rank(Matrix *mat);
Matrix *matrix_inverse(Matrix *mat);
MATRIX_TYPE matrix_det(Matrix *mat);

/* OpenMP function */
#define OMP_MAX_THREADS_NUM omp_get_max_threads() / 2
Matrix *matrix_gen_omp(unsigned int rows, unsigned int cols, MATRIX_TYPE *data);
void matrix_swap_omp(Matrix *a, unsigned int aix, unsigned int select_index, unsigned int aim_index);
#endif// _MATRIX_H