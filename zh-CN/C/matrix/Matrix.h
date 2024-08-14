#ifndef _MATRIX_H_
#define _MATRIX_H_
#include "../ConstDef.h"

#define MATRIX_DEFAULT_TYPE double
#define MATRIX_DEFAULT_PRECISION "%-10.6lf\t"
#define MATRIX_COLS_OMIT_PRINT_LIMIT 20
#define MATRIX_ROWS_OMIT_PRINT_LIMIT 200

#define MATRIX_TYPE MATRIX_DEFAULT_TYPE

/* ERROR DEFINE */
#define MATRIX_SIZE_ERROR_001 "@ERROR: The matrix size does not match\n@Function: %s\n@Line: %d\n@File: %s\n"

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

typedef struct _Cat_Matrix
{
    Matrix *sorce_matrix;
    Matrix *cated_matrix;
    unsigned int o_start_rows;
    unsigned int o_end_rows;
    unsigned int o_start_cols;
    unsigned int o_end_cols;
} Cat_Matrix;

#define IDX(col, rows, cols) ((col) * (rows) + (cols))
#define LENGTH(vector) ((vector) == NULL ? 0 : _msize(vector) / sizeof(vector))
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define RAND(min, max, TYPE) \
    ((TYPE)((min) + ((max - min) * ((TYPE)rand()) / ((TYPE)RAND_MAX + 1.0))))
#define INDEX_END(col, rows) ((col - 1) * (rows))
/* Variadics function */
Matrix *_ones_matrix_(int num, ...);          // generate ones matrix
Matrix *_eye_matrix_(int num, ...);           // generate eye matrix
Matrix *_matrix_mul_(Matrix *a, ...);         // matrix multiply
Matrix *_matrix_add_(Matrix *a, ...);         // matrix add
MATRIX_TYPE *_vector_splicing_(int num, ...); // vector compose
Matrix *_matrix_mul_range_(Matrix *a, unsigned int start_rows, unsigned int end_rows, unsigned int start_cols, unsigned int end_cols, ...);
#define ones_matrix_value(...) _ones_matrix_(ARGC(__VA_ARGS__), __VA_ARGS__)
#define eye_matrix_value(...) _eye_matrix_(ARGC(__VA_ARGS__), __VA_ARGS__)
#define vector_splicing(...) _vector_splicing_(ARGC(__VA_ARGS__), __VA_ARGS__)

/* Tool function */
// 为提高效率 Tool function 中的所有函数均不会对输入进行校验！
void matrix_gauss_elimination(Matrix *mat);
// void matrix_gauss_elimination_col(Matrix *mat);
void matrix_gauss_elimination_(Matrix *mat, unsigned int select_index, unsigned int aim_index, double value);
// void matrix_gauss_elimination_col_(Matrix *mat, unsigned int select_index, unsigned int aim_index, double value);
void matrix_sort_by_zeros_num(Matrix *mat);
void vector_sort(MATRIX_TYPE *vector, unsigned int aix, unsigned int sort_method);
int matrix_sort_default_a2z(const void *a, const void *b, int col_index);
int matrix_sort_default_z2a(const void *a, const void *b, int col_index);

/* Function */
Matrix *matrix_gen(unsigned int rows, unsigned int cols, MATRIX_TYPE *data);                                                  // generate matrix
Matrix *matrix_gen_(unsigned int rows, unsigned int cols, MATRIX_TYPE *data, unsigned int data_rows, unsigned int data_cols); // generate matrix
Matrix *matrix_copy(Matrix *_sourse_mat);                                                                                     // copy matrix
void matrix_copy_(Matrix *dest, Matrix *src);
void matrix_copy_free(Matrix *dest, Matrix *src);                                                                                               // copy matrix
void matrix_free(Matrix *mat);                                                                                                                  // free matrix
void matrix_print(Matrix *mat);                                                                                                                 // print matrix
Matrix *ones_matrix(unsigned int rows, unsigned int cols);                                                                                      // generate ones matrix
Matrix *zeros_matrix(unsigned int rows, unsigned int cols);                                                                                     // generate zeros matrix
Matrix *eye_matrix(unsigned int rows, unsigned int cols);                                                                                       // generate eye matrix
Matrix *rand_matrix(unsigned int rows, unsigned int cols, MATRIX_TYPE min, MATRIX_TYPE max);                                                    // generate random matrix
bool matrix_eq(Matrix *a, Matrix *b);                                                                                                           // matrix equal
Matrix *matrix_mul(Matrix *a, Matrix *b);                                                                                                       // matrix multiply
Matrix *matrix_right_mul(Matrix *a, Matrix *b);                                                                                                 // matrix right multiply
Matrix *matrix_mul_single_int(Matrix *a, int b);                                                                                                // matrix multiply
Matrix *matrix_mul_single_double(Matrix *a, double b);                                                                                          // matrix multiply
void matrix_mul_void(Matrix *a, Matrix *b);                                                                                                     // matrix multiply
void matrix_right_mul_void(Matrix *a, Matrix *b);                                                                                               // matrix right multiply
void matrix_mul_single_int_void(Matrix *a, int b);                                                                                              // matrix multiply
void matrix_mul_single_double_void(Matrix *a, double b);                                                                                        // matrix multiply
Matrix *matrix_add(Matrix *a, Matrix *b);                                                                                                       // matrix add
Matrix *matrix_sub(Matrix *a, Matrix *b);                                                                                                       // matrix sub
void matrix_add_void(Matrix *a, Matrix *b);                                                                                                     // matrix add
void matrix_sub_void(Matrix *a, Matrix *b);                                                                                                     // matrix sub
void matrix_transpose(Matrix *mat);                                                                                                             // matrix transpose
Matrix *matrix_transpose_(Matrix *mat);                                                                                                         // matrix transpose
MATRIX_TYPE **matrixTo2Array(Matrix *mat);                                                                                                      // matrix to 2D array
Matrix *twoArrayToMatrix(MATRIX_TYPE **array, unsigned int rows, unsigned int cols);                                                            // 2D array to matrix
Matrix *matrix_splicing(Matrix *a, Matrix *b, unsigned int aix);                                                                                // matrix splicing
Matrix *matrix_cat(Matrix *a, unsigned int begin_row, unsigned int end_row, unsigned int begin_col, unsigned int end_col);                      // matrix cat
void matrix_swap(Matrix *a, unsigned int aix, unsigned int select_index, unsigned int aim_index);                                               // matrix row/col swap
void matrix_sort_by_cols_values(Matrix *mat, unsigned int col_index, unsigned int sort_method, int (*compar)(const void *, const void *, int)); // matrix sort by rows values
Matrix *matrix_2uppper_triangle(Matrix *mat);
void matrix__2upper_triangle_void(Matrix *mat);
Matrix *matrix_2lower_triangle(Matrix *mat);
void matrix__2lower_triangle_void(Matrix *mat);
int matrix_rank(Matrix *mat);
int matrix_rank_DYMethod(Matrix *mat);
Matrix *matrix_inverse(Matrix *mat);
MATRIX_TYPE matrix_det(Matrix *mat);
/* Cat_Matrix function */
Cat_Matrix *cat_matrix_gen(Matrix *source_matrix, unsigned int start_row, unsigned int end_row, unsigned int start_col, unsigned int end_col);
void cat_matrix_free(Cat_Matrix *cat_mat);
Matrix *cat_matrix_to_matrix(Cat_Matrix *cat_mat, unsigned int method);
Matrix *cat_matrix_to_matrix_vaule(Cat_Matrix *cat_mat, unsigned int method, MATRIX_TYPE value);
/* OpenMP function */
#define OMP_MAX_THREADS_NUM omp_get_max_threads() / 2
Matrix *matrix_gen_omp(unsigned int rows, unsigned int cols, MATRIX_TYPE *data);
void matrix_swap_omp(Matrix *a, unsigned int aix, unsigned int select_index, unsigned int aim_index);
#endif // _MATRIX_H