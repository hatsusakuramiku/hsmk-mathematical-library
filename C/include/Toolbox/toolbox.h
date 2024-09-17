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
 * @file toolbox.C
 */

#ifndef _HSMK_MATH_LIB_TOOLBOX_H
#define _HSMK_MATH_LIB_TOOLBOX_H

int isMember(const void *ptr, const void *base, size_t elemSize, size_t count, int (*cmp)(const void *, const void *));

Stack *getUniqueStackFromArray(const void *base, size_t elemSize, size_t count, int (*cmp)(const void *, const void *));

void *getUniqueArrayFromArray(const void *base, size_t elemSize, size_t count, int (*cmp)(const void *, const void *));

/**
 * Converts a fixed-size array to a dynamically allocated pointer.
 *
 * This macro allocates memory for a new array of the same type and length as the input array,
 * copies the contents of the input array to the new array, and returns a pointer to the new array.
 *
 * @param type The type of the elements in the array.
 * @param array The input array to be converted.
 * @param len The length of the input array.
 *
 * @return A pointer to the newly allocated array, or NULL on failure.
 */
#define ARRAY2PTR(type, array, len)                                                              \
    ({                                                                                           \
        type *ptr = NULL;                                                                        \
        if (array != NULL && len > 0)                                                            \
        {                                                                                        \
            /* Allocate memory for a new array of the same type and length as the input array */ \
            ptr = (type *)malloc(sizeof(type) * len);                                            \
            if (ptr != NULL)                                                                     \
            {                                                                                    \
                for (int i = 0; i < len; i++)                                                    \
                {                                                                                \
                    ptr[i] = array[i];                                                           \
                }                                                                                \
            }                                                                                    \
            else                                                                                 \
            {                                                                                    \
                /* Error handling: memory allocation failed */                                   \
                fprintf(stderr, "Error: memory allocation failed\n");                            \
            }                                                                                    \
        }                                                                                        \
        /* Return the pointer to the new array, or NULL on failure */                            \
        ptr;                                                                                     \
    })

/**
 * Macro to check if the input array is a static array and transform it to a pointer.
 *
 * @param type The type of the array elements.
 * @param array The input array to be checked.
 * @param len The length of the array.
 *
 * @return A pointer to the array if it is a static array, otherwise the original array.
 */
#define CHECK_IS_STATAIC_ARRAY_AND_TRSANSFORM_TO_PTR(type, array, len)   \
    ({                                                                   \
        /* Check if the input array is a static array */                 \
        if (IS_STATIC_ARRAY(*array))                                     \
        {                                                                \
            /* If it is a static array, transform it to a pointer */     \
            ARRAY2PTR(type, array, len);                                 \
        }                                                                \
        else                                                             \
        {                                                                \
            /* If it is not a static array, return the original array */ \
            array;                                                       \
        }                                                                \
    })
#endif //_HSMK_MATH_LIB_TOOLBOX_H
