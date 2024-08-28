// Copyright  2024 hatsusakuramiku
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//
// Created by 79240 on 24-8-27.
//

#include <stdio.h>
#include "constDef.h"
#include "sort.h"
#include "memswap.h"
#include <stdalign.h>

#include "matrix.h"

// 默认比较函数

/**
 * Compares two double values.
 *
 * @param a The first double value.
 * @param b The second double value.
 *
 * @return -1 if a is less than b, 1 if a is greater than b, and 0 if a is equal to b.
 */
int default_compare_example(const void *a, const void *b) {
    const double p1 = *(double *) a;
    const double p2 = *(double *) b;
    if (p1 < p2) {
        return -1;
    }
    if (p1 > p2) {
        return 1;
    }
    return 0;
}

/**
 * Compares two double values referenced by pointers.
 *
 * @param arg Unused argument.
 * @param a The first double value referenced by a pointer.
 * @param b The second double value referenced by a pointer.
 *
 * @return -1 if a is less than b, 1 if a is greater than b, and 0 if a is equal to b.
 *
 * @throws None
 */
int default_compare_example_r(const void *a, const void *b, const void *arg) {
    const double *p1 = *(double **) a;
    const double *p2 = *(double **) b;
    const int index = *(int *) arg;
    if (p1[index] < p2[index]) {
        return -1;
    }
    if (p1[index] > p2[index]) {
        return 1;
    }
    return 0;
}

//Quick sort block start
// 快速排序的实现借鉴(抄的)自开源项目 https://github.com/bminor/glibc/blob/master
///Quick sort code @ref https://github.com/bminor/glibc/blob/master/stdlib/qsort.c


/**
 * Swap SIZE bytes between addresses A and B.  These helpers are provided
 * along the generic one as an optimization.
 */
enum swap_type_t {
    SWAP_WORDS_64,
    SWAP_WORDS_32,
    SWAP_VOID_ARGS,
    SWAP_BYTES
};

typedef unsigned long int uint32_t;
typedef unsigned long long int uint64_t;

typedef uint32_t __attribute__((__may_alias__)) uint32_alias_t;
typedef uint64_t __attribute__((__may_alias__)) uint64_alias_t;
#define  QSORT_STACK_SIZE 1024
#define  INDIRECT_SORT_SIZE_THRES 32

/**
 * Swaps 64-bit words between two memory addresses.
 *
 * @param a The first memory address.
 * @param b The second memory address.
 * @param n The number of 64-bit words to swap.
 *
 * @return None
 *
 * @throws None
 */
static inline void swap_words_64(void *__restrict a, void *__restrict b, size_t n) {
    do {
        n -= 8;
        const uint64_alias_t tmp = *(uint64_alias_t *) (a + n);
        *(uint64_alias_t *) (a + n) = *(uint64_alias_t *) (b + n);
        *(uint64_alias_t *) (b + n) = tmp;
    } while (n);
}

/**
 * Swaps 32-bit words between two memory addresses.
 *
 * @param a The first memory address.
 * @param b The second memory address.
 * @param n The number of 32-bit words to swap.
 *
 * @return None
 *
 * @throws None
 */
static inline void swap_words_32(void *__restrict a, void *__restrict b, size_t n) {
    do {
        n -= 4;
        const uint32_alias_t tmp = *(uint32_alias_t *) (a + n);
        *(uint32_alias_t *) (a + n) = *(uint32_alias_t *) (b + n);
        *(uint32_alias_t *) (b + n) = tmp;
    } while (n);
}

/**
 * Performs a swap operation on a block of memory using the specified swap type.
 *
 * @param a The starting memory address of the block.
 * @param b The ending memory address of the block.
 * @param n The size of the block in bytes.
 * @param type The type of swap operation to perform.
 *
 * @return None.
 *
 * @throws None.
 */
static void do_swap(void *__restrict a, void *__restrict b, size_t n, enum swap_type_t type) {
    if (type == SWAP_WORDS_64) {
        swap_words_64(a, b, n);
    } else if (type == SWAP_WORDS_32) {
        swap_words_32(a, b, n);
    } else {
        _memswap(a, b, n);
    }
}


/**
 * Siftdown operation to maintain heap property in a binary heap.
 *
 * This function takes an array, its size, an index k, the total number of elements n,
 * a swap type, a comparison function, and an argument for the comparison function.
 * It ensures that the heap property is maintained by comparing the element at index k
 * with its children and swapping if necessary.
 *
 * @param array The array representing the binary heap.
 * @param size The size of each element in the array.
 * @param k The index of the element to start the siftdown operation from.
 * @param n The total number of elements in the heap.
 * @param type The type of swap operation to perform.
 * @param cmp The comparison function to use for comparing elements.
 * @param arg The argument to pass to the comparison function.
 *
 * @return None
 *
 * @throws None
 */
static inline void siftdown(void *array, size_t size, size_t k, size_t n, enum swap_type_t type,
                            default_compare_r cmp, void *arg) {
    /* There can only be a heap condition violation if there are
     children.  */
    while (2 * k + 1 <= n) {
        /* Left child.  */
        size_t j = 2 * k + 1;
        /* If the right child is larger, use it.  */
        if (j < n && cmp(array + (j * size), array + ((j + 1) * size), arg) < 0) {
            j++;
        }

        /* If k is already >= to its children, we are done.  */
        if (j == k || cmp(array + (k * size), array + (j * size), arg) >= 0) {
            break;
        }

        /* Heal the violation.  */
        do_swap(array + (k * size), array + (j * size), size, type);

        /* Swapping with j may have introduced a violation at j.  Fix
     it in the next loop iteration.  */
        k = j;
    }
}

/**
 * Builds a max heap from an array by repeatedly performing the siftdown operation.
 *
 * @param array The array to heapify.
 * @param size The size of each element in the array.
 * @param n The number of elements in the array.
 * @param type The type of swap operation to perform.
 * @param cmp The comparison function to use for comparing elements.
 * @param arg The argument to pass to the comparison function.
 *
 * @return None
 *
 * @throws None
 */
static inline void cs_heapify(void *array, size_t size, size_t n, enum swap_type_t type, default_compare_r cmp,
                              void *arg) {
    size_t k = n / 2;

    while (1) {
        siftdown(array, size, k, n, type, cmp, arg);
        if (k-- == 0) {
            break;
        }
    }
}

/**
 * Determines the swap type based on the size and alignment of the given array.
 *
 * @param parray The array to check.
 * @param size The size of the array.
 *
 * @return The swap type, either SWAP_WORDS_32, SWAP_WORDS_64, or SWAP_BYTES.
 *
 * @throws None
 */
static enum swap_type_t get_swap_type(void *const parray, size_t size) {
    if ((size & (sizeof(uint32_t) - 1)) == 0 && ((uintptr_t) parray) % __alignof__(uint32_t) == 0) {
        if (size == sizeof(uint32_t))
            return SWAP_WORDS_32;
        if (size == sizeof(uint64_t) && ((uintptr_t) parray) % __alignof__(uint64_t) == 0)
            return SWAP_WORDS_64;
    }
    return SWAP_BYTES;
}

/**
 * Performs a heap sort on the given array in-place.
 *
 * @param array The array to sort.
 * @param n The number of elements in the array.
 * @param size The size of each element in the array.
 * @param cmp The comparison function to use for comparing elements.
 * @param arg The argument to pass to the comparison function.
 *
 * @return None
 *
 * @throws None
 */
static void heapsort_r(void *array, size_t n, size_t size, default_compare_r cmp, void *arg) {
    if (n == 0) {
        return;
    }

    enum swap_type_t type = get_swap_type(array, size);
    cs_heapify(array, size, n, type, cmp, arg);
    while (1) {
        /* 索引0 .. n包含二叉堆。提取最大的元素并将其放入数组中的最终位置。  */
        do_swap(array, array + (n * size), size, type);
        /* 堆现在少了一个元素。  */
        n--;
        if (n == 0)
            break;
        siftdown(array, size, 0, n, type, cmp, arg);
    }
}

struct cs_msort_param {
    size_t size;
    enum swap_type_t type;
    default_compare_r comp_func;
    void *arg;
    char *temp;
};

/**
 * Recursively performs a merge sort on the given array using a temporary buffer.
 *
 * @param param A pointer to the merge sort parameters, including the size of each element, the swap type, the comparison function, and the temporary buffer.
 * @param b The array to sort.
 * @param n The number of elements in the array.
 *
 * @return None
 *
 * @throws None
 */
static void msort_with_tmp(const struct cs_msort_param *param, void *b, size_t n) {
    char *b1, *b2;
    size_t n1, n2;

    if (n <= 1)
        return;

    n1 = n / 2;
    n2 = n - n1;
    b1 = b;
    b2 = (char *) b + (n1 * param->size);
    msort_with_tmp(param, b1, n1);
    msort_with_tmp(param, b2, n2);

    char *tmp = param->temp;
    const size_t size = param->size;
    default_compare_r cmp = param->comp_func;
    void *arg = param->arg;

    switch (param->type) {
        case SWAP_WORDS_32:
            while (n1 > 0 && n2 > 0) {
                if (cmp(b1, b2, arg) <= 0) {
                    *(uint32_alias_t *) tmp = *(uint32_alias_t *) b1;
                    b1 += sizeof(uint32_alias_t);
                    --n1;
                } else {
                    *(uint32_alias_t *) tmp = *(uint32_alias_t *) b2;
                    b2 += sizeof(uint32_alias_t);
                    --n2;
                }
                tmp += sizeof(uint32_alias_t);
            }
            break;
        case SWAP_WORDS_64:
            while (n1 > 0 && n2 > 0) {
                if (cmp(b1, b2, arg) <= 0) {
                    *(uint64_alias_t *) tmp = *(uint64_alias_t *) b1;
                    b1 += sizeof(uint64_alias_t);
                    --n1;
                } else {
                    *(uint64_alias_t *) tmp = *(uint64_alias_t *) b2;
                    b2 += sizeof(uint64_alias_t);
                    --n2;
                }
                tmp += sizeof(uint64_alias_t);
            }
            break;
        case SWAP_VOID_ARGS:
            while (n1 > 0 && n2 > 0) {
                if (cmp(*(const void **) b1, *(const void **) b2, arg) <= 0) {
                    *(void **) tmp = *(void **) b1;
                    b1 += sizeof(void *);
                    --n1;
                } else {
                    *(void **) tmp = *(void **) b2;
                    b2 += sizeof(void *);
                    --n2;
                }
                tmp += sizeof(void *);
            }
            break;
        default:
            while (n1 > 0 && n2 > 0) {
                if (cmp(b1, b2, arg) <= 0) {
                    tmp = (char *) mempcpy(tmp, b1, size);
                    b1 += size;
                    --n1;
                } else {
                    tmp = (char *) mempcpy(tmp, b2, size);
                    b2 += size;
                    --n2;
                }
                tmp++;
            }
            break;
    }
    if (n1 > 0)
        memcpy(tmp, b1, n1 * size);
    memcpy(b, param->temp, (n - n2) * size);
}

/**
 * Performs an indirect merge sort on an array using a temporary storage.
 *
 * @param param A pointer to a cs_msort_param structure containing the sorting parameters.
 * @param array The array to be sorted.
 * @param n The number of elements in the array.
 * @param size The size of each element in the array.
 *
 * @return None
 *
 * @throws None
 */
static void __attribute__((used)) indirect_msort_with_tmp(const struct cs_msort_param *param, void *array, size_t n,
                                                          size_t size) {
    char *ip = (char *) array;
    void **tp = (void **) (param->temp + n * sizeof(void *));
    void **tmp = tp;
    void *tmp_storage = (void *) (tp + n);

    while ((void *) tmp < tmp_storage) {
        *tmp++ = ip;
        ip += size;
    }
    msort_with_tmp(param, param->temp + n * sizeof(void *), n);

    char *kp;
    size_t i;
    for (i = 0, ip = (char *) array; i < n; i++, ip += size) {
        if ((kp = tp[i]) != ip) {
            size_t j = i;
            char *jp = ip;
            memcpy(tmp_storage, ip, size);
            do {
                size_t k = (kp - (char *) array) / size;
                tp[j] = jp;
                memcpy(jp, kp, size);
                j = k;
                jp = kp;
                kp = tp[k];
            } while (kp != ip);
            tp[j] = jp;
            memcpy(jp, tmp_storage, size);
        }
    }
}

/**
 * Recursively sorts an array of elements using the quicksort algorithm.
 *
 * @param array The array to be sorted.
 * @param arg Additional argument to be passed to the comparison function.
 * @param elemNum The number of elements in the array.
 * @param elemSize The size of each element in the array.
 * @param compare The comparison function used to determine the order of elements.
 *
 * @return None
 *
 * @throws None
 */
void quickSort_r(void *array, void *arg, size_t elemNum, size_t elemSize, default_compare_r compare) {
    if (elemNum <= 1) {
        return;
    }
    _Alignas
    (uint64_t) char
    tmp[QSORT_STACK_SIZE];
    size_t total_size = elemNum * elemSize;
    char *buf;

    if (elemSize > INDIRECT_SORT_SIZE_THRES) {
        total_size = 2 * elemNum * sizeof(void *) + elemSize;
    }
    if (total_size <= sizeof tmp) {
        buf = tmp;
    } else {
        int save = errno;
        buf = malloc(total_size);
        _set_errno(save);
        if (buf == NULL) {
            heapsort_r(array, elemNum - 1, elemSize, compare, arg);
            return;
        }
    }

    if (elemSize > INDIRECT_SORT_SIZE_THRES) {
        const struct cs_msort_param msort_param = {
            .size = elemSize,
            .type = get_swap_type(array, elemSize),
            .comp_func = compare,
            .arg = arg,
            .temp = buf
        };
        indirect_msort_with_tmp(&msort_param, array, elemNum, elemSize);
    } else {
        const struct cs_msort_param msort_param = {
            .size = elemSize,
            .type = get_swap_type(array, elemSize),
            .comp_func = compare,
            .arg = arg,
            .temp = buf
        };
        msort_with_tmp(&msort_param, array, elemNum);
    }
    if (buf != tmp) {
        free(buf);
    }
}

/**
 * Sorts an array of elements using the quicksort algorithm.
 *
 * @param array The array to be sorted.
 * @param elemNum The number of elements in the array.
 * @param elemSize The size of each element in the array.
 * @param compare A function that compares two elements.
 *
 * @return None
 */
void quickSort(void *array, size_t elemNum, size_t elemSize, default_compare compare) {
    return quickSort_r(array, NULL, elemNum, elemSize, (default_compare_r) compare);
}

///Quick sort block end


void boubleSort(void *array, size_t elemNum, size_t elemSize, default_compare compare) {
    if (elemNum <= 1 || array == NULL) {
        return;
    }
    for (size_t i = 0; i < elemNum; i++) {
        int flag = 0;
        for (size_t j = 0; j < elemNum - 1 - i; j++) {
            if (compare(array + j * elemSize, array + (j + 1) * elemSize) > 0) {
                _memswap(array + j * elemSize, array + (j + 1) * elemSize, elemSize);
                flag = 1;
            }
        }
        if (!flag) {
            return;
        }
    }
}

void boubleSort_r(void *array, void *arg, size_t elemNum, size_t elemSize, default_compare_r compare) {
    if (elemNum <= 1 || array == NULL) {
        return;
    }
    for (size_t i = 0; i < elemNum; i++) {
        int flag = 0;
        for (size_t j = 0; j < elemNum - 1 - i; j++) {
            if (compare(array + j * elemSize, array + (j + 1) * elemSize, arg) > 0) {
                _memswap(array + j * elemSize, array + (j + 1) * elemSize, elemSize);
                flag = 1;
            }
        }
        if (!flag) {
            return;
        }
    }
}
