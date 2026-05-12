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
 * @file result_types.h
 * @brief Pre-defined result types for C built-in data types.
 *
 * This file provides specialized result wrappers for common C types.
 * Use HSMK_RESULT as the base generic type for complex or custom types.
 *
 * ===================== CUSTOM RESULT TYPE GUIDE =====================
 *
 * To create a custom result type for your specific data type:
 *
 * 1. Embed HSMK_RESULT as the first member (base)
 * 2. Add your value field(s)
 * 3. Create factory functions for construction
 *
 * Example - creating a Matrix result type:
 *
 *   typedef struct {
 *       HSMK_RESULT base;    // MUST be first member
 *       Matrix *value;       // your data
 *   } MatrixResult;
 *
 *   static inline MatrixResult MatrixResult_ok(Matrix *m) {
 *       return (MatrixResult){
 *           .base = HSMK_RESULT_OK(m, sizeof(Matrix), true),
 *           .value = m
 *       };
 *   }
 *
 *   static inline MatrixResult MatrixResult_err(const char *msg) {
 *       return (MatrixResult){
 *           .base = HSMK_RESULT_ERR(HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(msg)),
 *           .value = NULL
 *       };
 *   }
 *
 *   // Usage:
 *   MatrixResult r = matrix_invert(&A);
 *   if (HSMK_RESULT_IS_ERR(r.base)) {
 *       printf("Error: %s\n", HSMK_RESULT_GET_ERROR_MSG(r.base));
 *   } else {
 *       use_matrix(r.value);
 *       HSMK_RESULT_DESTROY(r.base);  // cleanup if needed
 *   }
 *
 * ===================== AVAILABLE TYPES =====================
 *
 * Integer types:
 *   - HSMK_RESULT_CHAR      / char
 *   - HSMK_RESULT_SHORT     / short
 *   - HSMK_RESULT_INT       / int
 *   - HSMK_RESULT_LONG      / long
 *   - HSMK_RESULT_LLONG     / long long
 *   - HSMK_RESULT_UCHAR     / unsigned char
 *   - HSMK_RESULT_USHORT    / unsigned short
 *   - HSMK_RESULT_UINT      / unsigned int
 *   - HSMK_RESULT_ULONG     / unsigned long
 *   - HSMK_RESULT_ULLONG    / unsigned long long
 *
 * Size types:
 *   - HSMK_RESULT_SSIZE     / ssize_t (signed size_t)
 *   - HSMK_RESULT_SIZE      / size_t (unsigned)
 *
 * Floating point types:
 *   - HSMK_RESULT_FLOAT     / float
 *   - HSMK_RESULT_DOUBLE    / double
 *
 * Other types:
 *   - HSMK_RESULT_BOOL      / bool (true/false)
 *   - HSMK_RESULT_PTR       / void* (generic pointer, borrowed)
 *   - HSMK_RESULT_CSTR      / char* (C string, borrowed)
 *
 * ===================== USAGE EXAMPLE =====================
 *
 *   // Double result
 *   HSMK_RESULT_DOUBLE area = calculate_area(r);
 *   if (HSMK_RESULT_IS_ERR(area.base)) {
 *       handle_error(HSMK_RESULT_GET_ERROR_MSG(area.base));
 *   } else {
 *       printf("Area = %f\n", area.value);
 *   }
 *
 *   // Int result
 *   HSMK_RESULT_INT count = count_elements(list);
 *   if (HSMK_RESULT_IS_ERR(count.base)) {
 *       fprintf(stderr, "Count failed: %s\n", HSMK_RESULT_GET_ERROR_MSG(count.base));
 *   } else {
 *       printf("Found %d items\n", count.value);
 *   }
 */

#ifndef _HSMK_MATH_LIB_RESULT_TYPES_H
#define _HSMK_MATH_LIB_RESULT_TYPES_H

// Project Headers
#include "result.h"

// Standard Headers
#include <stdbool.h>
#include <stddef.h>

// ============================================================================
// INTEGER TYPES
// ============================================================================

#define HSMK_DEFINE_INT_RESULT_TYPE(type_name, c_type)                          \
    typedef struct                                                              \
    {                                                                           \
        HSMK_RESULT base;                                                       \
        c_type value;                                                           \
    } type_name;                                                                \
    static inline type_name type_name##_ok(c_type val)                          \
    {                                                                           \
        return (type_name){                                                     \
            .base = HSMK_RESULT_OK(NULL, 0, false),                             \
            .value = val};                                                      \
    }                                                                           \
    static inline type_name type_name##_err(const char *msg)                    \
    {                                                                           \
        return (type_name){                                                     \
            .base = HSMK_RESULT_ERR(HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(msg)), \
            .value = 0};                                                        \
    }

// Signed integers
HSMK_DEFINE_INT_RESULT_TYPE(HSMK_RESULT_CHAR, char)
HSMK_DEFINE_INT_RESULT_TYPE(HSMK_RESULT_SHORT, short)
HSMK_DEFINE_INT_RESULT_TYPE(HSMK_RESULT_INT, int)
HSMK_DEFINE_INT_RESULT_TYPE(HSMK_RESULT_LONG, long)
HSMK_DEFINE_INT_RESULT_TYPE(HSMK_RESULT_LLONG, long long)

// Unsigned integers
HSMK_DEFINE_INT_RESULT_TYPE(HSMK_RESULT_UCHAR, unsigned char)
HSMK_DEFINE_INT_RESULT_TYPE(HSMK_RESULT_USHORT, unsigned short)
HSMK_DEFINE_INT_RESULT_TYPE(HSMK_RESULT_UINT, unsigned int)
HSMK_DEFINE_INT_RESULT_TYPE(HSMK_RESULT_ULONG, unsigned long)
HSMK_DEFINE_INT_RESULT_TYPE(HSMK_RESULT_ULLONG, unsigned long long)

#undef HSMK_DEFINE_INT_RESULT_TYPE

// ============================================================================
// SIZE TYPES
// ============================================================================

typedef struct
{
    HSMK_RESULT base;
    size_t value;
} HSMK_RESULT_SIZE;

static inline HSMK_RESULT_SIZE HSMK_RESULT_SIZE_ok(size_t val)
{
    return (HSMK_RESULT_SIZE){
        .base = HSMK_RESULT_OK(NULL, 0, false),
        .value = val};
}

static inline HSMK_RESULT_SIZE HSMK_RESULT_SIZE_err(const char *msg)
{
    return (HSMK_RESULT_SIZE){
        .base = HSMK_RESULT_ERR(HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(msg)),
        .value = 0};
}

typedef struct
{
    HSMK_RESULT base;
    ssize_t value;
} HSMK_RESULT_SSIZE;

static inline HSMK_RESULT_SSIZE HSMK_RESULT_SSIZE_ok(ssize_t val)
{
    return (HSMK_RESULT_SSIZE){
        .base = HSMK_RESULT_OK(NULL, 0, false),
        .value = val};
}

static inline HSMK_RESULT_SSIZE HSMK_RESULT_SSIZE_err(const char *msg)
{
    return (HSMK_RESULT_SSIZE){
        .base = HSMK_RESULT_ERR(HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(msg)),
        .value = -1};
}

// ============================================================================
// FLOATING POINT TYPES
// ============================================================================

typedef struct
{
    HSMK_RESULT base;
    float value;
} HSMK_RESULT_FLOAT;

static inline HSMK_RESULT_FLOAT HSMK_RESULT_FLOAT_ok(float val)
{
    return (HSMK_RESULT_FLOAT){
        .base = HSMK_RESULT_OK(NULL, 0, false),
        .value = val};
}

static inline HSMK_RESULT_FLOAT HSMK_RESULT_FLOAT_err(const char *msg)
{
    return (HSMK_RESULT_FLOAT){
        .base = HSMK_RESULT_ERR(HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(msg)),
        .value = 0.0f};
}

typedef struct
{
    HSMK_RESULT base;
    double value;
} HSMK_RESULT_DOUBLE;

static inline HSMK_RESULT_DOUBLE HSMK_RESULT_DOUBLE_ok(double val)
{
    return (HSMK_RESULT_DOUBLE){
        .base = HSMK_RESULT_OK(NULL, 0, false),
        .value = val};
}

static inline HSMK_RESULT_DOUBLE HSMK_RESULT_DOUBLE_err(const char *msg)
{
    return (HSMK_RESULT_DOUBLE){
        .base = HSMK_RESULT_ERR(HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(msg)),
        .value = 0.0};
}

// ============================================================================
// OTHER TYPES
// ============================================================================

typedef struct
{
    HSMK_RESULT base;
    bool value;
} HSMK_RESULT_BOOL;

static inline HSMK_RESULT_BOOL HSMK_RESULT_BOOL_ok(bool val)
{
    return (HSMK_RESULT_BOOL){
        .base = HSMK_RESULT_OK(NULL, 0, false),
        .value = val};
}

static inline HSMK_RESULT_BOOL HSMK_RESULT_BOOL_err(const char *msg)
{
    return (HSMK_RESULT_BOOL){
        .base = HSMK_RESULT_ERR(HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(msg)),
        .value = false};
}

typedef struct
{
    HSMK_RESULT base;
    void *ptr;
} HSMK_RESULT_PTR;

static inline HSMK_RESULT_PTR HSMK_RESULT_PTR_ok(void *ptr)
{
    return (HSMK_RESULT_PTR){
        .base = HSMK_RESULT_OK(ptr, 0, false), // borrowed, not owned
        .ptr = ptr};
}

static inline HSMK_RESULT_PTR HSMK_RESULT_PTR_err(const char *msg)
{
    return (HSMK_RESULT_PTR){
        .base = HSMK_RESULT_ERR(HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(msg)),
        .ptr = NULL};
}

typedef struct
{
    HSMK_RESULT base;
    const char *cstr;
} HSMK_RESULT_CSTR;

static inline HSMK_RESULT_CSTR HSMK_RESULT_CSTR_ok(const char *s)
{
    return (HSMK_RESULT_CSTR){
        .base = HSMK_RESULT_OK((void *)s, 0, false), // borrowed
        .cstr = s};
}

static inline HSMK_RESULT_CSTR HSMK_RESULT_CSTR_err(const char *msg)
{
    return (HSMK_RESULT_CSTR){
        .base = HSMK_RESULT_ERR(HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(msg)),
        .cstr = NULL};
}

#endif