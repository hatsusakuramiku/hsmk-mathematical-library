#ifndef _CUSTOMSORT_H
#define _CUSTOMSORT_H
#include "ConstDef.h"
#include <omp.h>

// doc https://oi-wiki.org/basic/sort-intro/
void custom_sort(void *array, int sort_method, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));

int _example_compare_(const void *a, const void *b);
void swap_elem(char *a, char *b, size_t size); // 交换元素
void set_elem_value(char *a, char *b, size_t size);

void selection_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));
void bubble_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));
void insert_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));
void count_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));
void quick_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));
void merge_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));
void sift_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));
void bucket_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));
void shell_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));
void tournament_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));
void tim_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *));

/* Matrix sort 特化 */
int _matrix_compare_(const void *a, const void *b, int col);
void matrix_custom_sort(void *array, int sort_method,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
void matrix_selection_sort(void *array,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
void matrix_bubble_sort(void *array,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
void matrix_insert_sort(void *array,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
void matrix_count_sort(void *array,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
void matrix_quick_sort(void *array,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
void matrix_merge_sort(void *array,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
void matrix_sift_sort(void *array,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
void matrix_bucket_sort(void *array,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
void matrix_shell_sort(void *array,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
void matrix_tournament_sort(void *array,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
void matrix_tim_sort(void *array,int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int));
#endif // _CUSTOMSORT_H