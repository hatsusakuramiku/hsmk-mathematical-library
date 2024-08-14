#include "CustomSort.h"

// 一个比较函数示例，此示例仅支持int类型
// 要求此函数返回 1 表示a > b,返回 0 表示 a = b，返回 -1 表示 a < b
int _example_compare_(const void *a, const void *b)
{
    int x = *(int *)a;
    int y = *(int *)b;
    if (x < y)
    {
        return -1;
    }
    else if (x > y)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

void custom_sort(void *array, int sort_method, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *))
{
    switch (sort_method)
    {
    case 1:
        selection_sort(array, elem_num, elem_size, compar);
        break;
    case 2:
        bubble_sort(array, elem_num, elem_size, compar);
        break;
    case 3:
        insert_sort(array, elem_num, elem_size, compar);
        break;
    // case 4:
    //     count_sort(array, elem_num, compar);
    //     break;
    case 5:
        quick_sort(array, elem_num, elem_size, compar);
        break;
    case 6:
        merge_sort(array, elem_num, elem_size, compar);
        break;
    case 7:
        sift_sort(array, elem_num, elem_size, compar);
        break;
    case 8:
        bucket_sort(array, elem_num, elem_size, compar);
        break;
    case 9:
        shell_sort(array, elem_num, elem_size, compar);
        break;
    case 10:
        tournament_sort(array, elem_num, elem_size, compar);
        break;
    case 11:
        tim_sort(array, elem_num, elem_size, compar);
        break;
    case 12:
        qsort(array, elem_num, elem_size, compar);
        break;
    }
}

void swap_elem(char *a, char *b, size_t size)
{

    for (int i = 0; i < size; i++)
    {
        char temp = *a;
        *a = *b;
        *b = temp;
        a++;
        b++;
    }
}

void set_elem_value(char *a, char *b, size_t size)
{
    for (int i = 0; i < size; i++)
    {
        *a = *b;
        a++;
        b++;
    }
}

void bubble_sort(void *base, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *))
{
    for (size_t i = 0; i < elem_num - 1; i++)
    {
        int flag = 0;
        for (size_t j = 0; j < elem_num - 1 - i; j++)
        {
            if (compar((char *)base + j * elem_size, (char *)base + (j + 1) * elem_size) > 0)
            {
                swap_elem((char *)base + j * elem_size, (char *)base + (j + 1) * elem_size, elem_size);
                flag = 1;
            }
        }
        if (flag == 0)
        {
            return;
        }
    }
}

void selection_sort(void *base, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *))
{
    for (size_t i = 0; i < elem_num - 1; i++)
    {
        size_t min = i;
        for (size_t j = i + 1; j < elem_num; j++)
        {
            if (compar((char *)base + j * elem_size, (char *)base + min * elem_size) < 0)
            {
                min = j;
            }
        }
        swap_elem((char *)base + i * elem_size, (char *)base + min * elem_size, elem_size);
    }
}

void insert_sort(void *base, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *))
{
    if (base == NULL || elem_num <= 0 || elem_size <= 0 || compar == NULL)
    {
        if (elem_num <= 1)
            return;
    }
    char *key = (char *)malloc(sizeof(char) * elem_size);
    PWARNING_RETURN_MALLOC_NO_NULL(key);
    for (size_t i = 1; i < elem_num; ++i)
    {
        set_elem_value(key, (char *)base + i * elem_size, elem_size);
        size_t j = i - 1;
        while (j >= 0 && compar((char *)base + j * elem_size, key) > 0)
        {
            set_elem_value((char *)base + (j + 1) * elem_size, (char *)base + j * elem_size, elem_size);
            j--;
        }
        set_elem_value((char *)base + (j + 1) * elem_size, key, elem_size);
    }
    free(key);
}

void quick_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *)) {
    
}
void merge_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *)) {}
void sift_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *)) {}
void bucket_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *)) {}
void shell_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *)) {}
void tournament_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *)) {}
void tim_sort(void *array, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *)) {}
/* matrix sort 特化 */
int _matrix_compare_(const void *a, const void *b, int col)
{
    col--;
    double *p1 = *(double **)a;
    double *p2 = *(double **)b;
    if (p1[col] > p2[col])
        return 1;
    else if (p1[col] == p2[col])
        return 0;
    else
        return -1;
}
void matrix_custom_sort(void *array, int sort_method, int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int))
{
    switch (sort_method)
    {
    case 1:
        matrix_selection_sort(array, col, elem_num, elem_size, compar);
        break;
    case 2:
        matrix_bubble_sort(array, col, elem_num, elem_size, compar);
        break;
    case 3:
        matrix_insert_sort(array, col, elem_num, elem_size, compar);
        break;
    // case 4:
    //     matrix_count_sort(array, col, elem_num, elem_size, compar);
    //     break;
    case 5:
        matrix_quick_sort(array, col, elem_num, elem_size, compar);
        break;
    case 6:
        matrix_merge_sort(array, col, elem_num, elem_size, compar);
        break;
    case 7:
        matrix_sift_sort(array, col, elem_num, elem_size, compar);
        break;
    case 8:
        matrix_bucket_sort(array, col, elem_num, elem_size, compar);
        break;
    case 9:
        matrix_shell_sort(array, col, elem_num, elem_size, compar);
        break;
    case 10:
        matrix_tournament_sort(array, col, elem_num, elem_size, compar);
        break;
    case 11:
        matrix_tim_sort(array, col, elem_num, elem_size, compar);
        break;
    default:
        break;
    }
}
void matrix_selection_sort(void *array, int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int))
{
    for (size_t i = 0; i < elem_num - 1; i++)
    {
        size_t min = i;
        for (size_t j = i + 1; j < elem_num; j++)
        {
            if (compar((char *)array + j * elem_size, (char *)array + min * elem_size, col) < 0)
            {
                min = j;
            }
        }
        swap_elem((char *)array + i * elem_size, (char *)array + min * elem_size, elem_size);
    }
}
void matrix_bubble_sort(void *array, int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int))
{
    for (size_t i = 0; i < elem_num - 1; i++)
    {
        int flag = 0;
        for (size_t j = 0; j < elem_num - 1 - i; j++)
        {
            if (compar((char *)array + j * elem_size, (char *)array + (j + 1) * elem_size, col) > 0)
            {
                swap_elem((char *)array + j * elem_size, (char *)array + (j + 1) * elem_size, elem_size);
                flag = 1;
            }
        }
        if (flag == 0)
        {
            return;
        }
    }
}
void matrix_insert_sort(void *array, int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int))
{
    if (array == NULL || elem_num <= 0 || elem_size <= 0 || compar == NULL)
    {
        if (elem_num <= 1)
            return;
    }
    char *key = (char *)malloc(sizeof(char) * elem_size);
    PWARNING_RETURN_MALLOC_NO_NULL(key);
    for (size_t i = 1; i < elem_num; ++i)
    {
        set_elem_value(key, (char *)array + i * elem_size, elem_size);
        size_t j = i - 1;
        while (j >= 0 && compar((char *)array + j * elem_size, key, col) > 0)
        {
            set_elem_value((char *)array + (j + 1) * elem_size, (char *)array + j * elem_size, elem_size);
            j--;
        }
        set_elem_value((char *)array + (j + 1) * elem_size, key, elem_size);
    }
    free(key);
}
void matrix_quick_sort(void *array, int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int)) {}
void matrix_merge_sort(void *array, int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int)) {}
void matrix_sift_sort(void *array, int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int)) {}
void matrix_bucket_sort(void *array, int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int)) {}
void matrix_shell_sort(void *array, int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int)) {}
void matrix_tournament_sort(void *array, int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int)) {}
void matrix_tim_sort(void *array, int col, size_t elem_num, size_t elem_size, int (*compar)(const void *, const void *, int)) {}