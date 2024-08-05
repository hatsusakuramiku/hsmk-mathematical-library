#ifndef _MATRIX_H_
#define _MATRIX_H_
#include "../ConstDef.h"

#define MATRIX_DEFAULT_TYPE double
#define MATRIX_DEFAULT_PRECISION "%.6lf\t"

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

#define IDX(col, rows, cols) ((col) * (rows) + (cols))
#define LENGTH(vector) ((vector) == NULL ? 0 : sizeof(vector) / sizeof(vector[0]))
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define RAND(min, max, TYPE) \
    ((TYPE)((min) + ((max - min) * ((TYPE)rand()) / ((TYPE)RAND_MAX + 1.0))))

/* Variadics function */
Matrix *_ones_matrix_(int num, ...);// generate ones matrix
Matrix *_eye_matrix_(int num, ...);// generate eye matrix
Matrix *_matrix_mul_(Matrix *a, ...);// matrix multiply
Matrix *_matrix_add_(Matrix *a, ...);// matrix add
#define ones_matrix_value(...) _ones_matrix_(ARGC(__VA_ARGS__), __VA_ARGS__)
#define eye_matrix_value(...) _eye_matrix_(ARGC(__VA_ARGS__), __VA_ARGS__)

/* Function */
Matrix *matrix_gen(unsigned int rows, unsigned int cols, MATRIX_TYPE *data);
Matrix *matrix_copy(Matrix *_sourse_mat);
void matrix_copy_(Matrix *a, Matrix *b);
void matrix_free(Matrix *mat);
void matrix_print(Matrix *mat);
Matrix *ones_matrix(unsigned int rows, unsigned int cols);
Matrix *zeros_matrix(unsigned int rows, unsigned int cols);
Matrix *eye_matrix(unsigned int rows, unsigned int cols);
Matrix *rand_matrix(unsigned int rows, unsigned int cols, MATRIX_TYPE min, MATRIX_TYPE max);
bool matrix_eq(Matrix *a, Matrix *b);
Matrix *matrix_mul(Matrix *a, Matrix *b);
Matrix *matrix_right_mul(Matrix *a, Matrix *b);
Matrix *matrix_mul_single_int(Matrix *a, int b);
Matrix *matrix_mul_single_double(Matrix *a, double b);
void matrix_mul_void(Matrix *a, Matrix *b);
void matrix_right_mul_void(Matrix *a, Matrix *b);
void matrix_mul_single_int_void(Matrix *a, int b);
void matrix_mul_single_double_void(Matrix *a, double b);
Matrix *matrix_add(Matrix *a, Matrix *b);
Matrix *matrix_sub(Matrix *a, Matrix *b);
void matrix_add_void(Matrix *a, Matrix *b);
void matrix_sub_void(Matrix *a, Matrix *b);
void matrix_transpose(Matrix *mat);
Matrix* matrix_transpose_(Matrix *mat);
int matrix_rank(Matrix *mat);
int matrix_comp(Matrix *a, Matrix *b);
Matrix *matrix_inverse(Matrix *mat);
MATRIX_TYPE matrix_det(Matrix *mat);
MATRIX_TYPE **matrixTo2Array(Matrix *mat);
Matrix *arrayToMatrix(MATRIX_TYPE **array, unsigned int rows, unsigned int cols);
#endif