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

// This file use for constant definition
#ifndef _HSMK_MATH_LIB_CONSTDEF_H
#define _HSMK_MATH_LIB_CONSTDEF_H

#if __STDC_VERSION__ < 201112L
#error "This library requires C11 or later"
#endif

// double precision
#define DOUBLE_EPSILON 1e-32
#define DOUBLE_COMP_EQ2ZERO(x) (x == 0.0 || fabs(x) <= DOUBLE_EPSILON)
#define DOUBLE_COMP_EQ(x, y) (DOUBLE_COMP_EQZERO(x - y))
#define UNSIGEND_INT_MAX 2e32 - 1

// get parameter name
#define VAR_NAME(var) (#var)

// get max or min
#define MAX(x, y) ((x) > (y) ? (x) : (y))
#define MIN(x, y) ((x) < (y) ? (x) : (y))

// free pointer
#define FREE(x)        \
    {                  \
        if (x != NULL) \
        {              \
            free(x);   \
            x = NULL;  \
        }              \
    }
// #define IS_STATIC_ARRAY(x) (void *)(&x) == (void *)(&x[0])
#define IS_STATIC_ARRAY(x) ((void *)&(x) == (void *)&(x[0]))
#ifdef _WIN32
#define VECTOR_LENGTH(vector) ((vector) == NULL ? 0 : IS_STATIC_ARRAY(vector) ? sizeof(vector) / sizeof(vector[0]) \
                                                                              : _msize((void *)vector) / sizeof(vector[0]))
#elif defined __linux__
#define uintptr_t unsigned int
#define VECTOR_LENGTH(vector) ((vector) == NULL ? 0 : IS_STATIC_ARRAY(vector) ? sizeof(vector) / sizeof(vector[0]) \
                                                                              : malloc_usable_size((void *)vector) / sizeof(vector[0]))
#endif
// get vector length

/**
 * For checking the number of input parameters
 *
 * ref: @ref https://blog.csdn.net/lamdonn/article/details/129192959
 */
#ifndef ARG_MAX

#define __ARGS(X) (X)

#define __ARGC_N(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, N, ...) N == 1 ? (#_0)[0] != 0 : N

#define __ARGC(...) __ARGS(__ARGC_N(__VA_ARGS__, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1))

#define __ARG0(_0, ...) _0
#define __ARG1(_0, _1, ...) _1
#define __ARG2(_0, _1, _2, ...) _2
#define __ARG3(_0, _1, _2, _3, ...) _3
#define __ARG4(_0, _1, _2, _3, _4, ...) _4
#define __ARG5(_0, _1, _2, _3, _4, _5, ...) _5
#define __ARG6(_0, _1, _2, _3, _4, _5, _6, ...) _6
#define __ARG7(_0, _1, _2, _3, _4, _5, _6, _7, ...) _7
#define __ARG8(_0, _1, _2, _3, _4, _5, _6, _7, _8, ...) _8
#define __ARG9(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, ...) _9

#define __VA0(...) __ARGS(__ARG0(__VA_ARGS__, 0) + 0)
#define __VA1(...) __ARGS(__ARG1(__VA_ARGS__, 0, 0))
#define __VA2(...) __ARGS(__ARG2(__VA_ARGS__, 0, 0, 0))
#define __VA3(...) __ARGS(__ARG3(__VA_ARGS__, 0, 0, 0, 0))
#define __VA4(...) __ARGS(__ARG4(__VA_ARGS__, 0, 0, 0, 0, 0))
#define __VA5(...) __ARGS(__ARG5(__VA_ARGS__, 0, 0, 0, 0, 0, 0))
#define __VA6(...) __ARGS(__ARG6(__VA_ARGS__, 0, 0, 0, 0, 0, 0, 0))
#define __VA7(...) __ARGS(__ARG7(__VA_ARGS__, 0, 0, 0, 0, 0, 0, 0, 0))
#define __VA8(...) __ARGS(__ARG8(__VA_ARGS__, 0, 0, 0, 0, 0, 0, 0, 0, 0))
#define __VA9(...) __ARGS(__ARG9(__VA_ARGS__, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))

#define ARG_MAX 10
#define ARGC(...) __ARGC(__VA_ARGS__)
#define ARGS(x, ...) __VA##x(__VA_ARGS__)

#endif // ARG_MAX

/// Error and Warning define
/**
 * Error define
 *
 * Error message standaed format:
 * @Error: Error message\n@File: File name\n@Function: Function name\n@Line: Line number\n
 *
 * When error occurs, the program prints the error message and will exit.
 */
// Print error message and abort
#define PERROR(fmt, ...)            \
    {                               \
        printf(fmt, ##__VA_ARGS__); \
        abort();                    \
    }

// Input parameter number error
#define PARAMETERS_NUM_ERROR_001 "@ERROR: Too many or too few parameters are entered !\nThis function only supports %d variable !\n@File: %s\n@Function: %s\n@Line: %d\n"
#define PARAMETERS_NUM_ERROR_002 "@ERROR: Too many or too few parameters are entered !\nThis function can only support a maximum of %d to %d parameters !\n@File: %s\n@Function: %s\n@Line: %d\n"

// Input parameter type error
#define INVALID_INPUT_001 "@ERROR: The input parameter called \"%s\" must be an integer between %d and %d !\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INVALID_INPUT_002 "@ERROR: The input parameter called \"%s\" must be an integer and equal or greater than %d !\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INVALID_INPUT_003 "@ERROR: The length of the input parameter named \"%s\" must be equal to %d !\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INVALID_INPUT_004 "@ERROR: The input parameter called \"%s\" must be an integer and equal or less than %d !\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INVALID_INPUT_005 "@ERROR: The input parameter called \"%s\" must be an integer and between %d and %d !\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INVALID_INPUT_006 "@ERROR: The input parameter called \"%s\" or the input parameter called \"%s\" must be an integer and between %d and %d !\n@File: %s\n@Function: %s\n@Line: %d\n"

// Type error
#define TYPE_ERROR_001 "@ERROR: The type called \"%s\" is not supported, will abort the operation\n@File: %s\n@Function: %s\n@Line: %d\n"
#define TYPE_ERROR_002 "@ERROR: The type of the parameter called \"%s\" and the parameter called \"%s\" is not compatible, will abort the operation\n@File: %s\n@Function: %s\n@Line: %d\n"

/**
 * Warning define
 *
 * Warning message standaed format:
 * @WARNING: Warning message\n@File: File name\n@Function: Function name\n@Line: Line number\n
 *
 * When warning occurs, the program prints the warning message and will return or do nothing.
 */

// Print warning message
#define PWARNING(fmt, ...) printf(fmt, ##__VA_ARGS__)

// Input parameter type warning
#define VALUE_TYPE_WARNING_001 "@WARNING: value == %d\nMaybe a variable of the wrong type was entered\n@File: %s\n@Function: %s\n@Line: %d\n"

// Memory allocate error
#define MALLOC_FAILURE_001 "@WARNING: Failed to allocate memory for variable called \"%s\", will abort the operation and return NULL\n@File: %s\n@Function: %s\n@Line: %d\n"
#define MALLOC_FAILURE_002 "@WARNING: Failed to allocate memory for variable called \"%s\", will abort the operation and return\n@File: %s\n@Function: %s\n@Line: %d\n"
#define MALLOC_FAILURE_003 "@WARNING: Failed to allocate memory for variable called \"%s\", will abort the operation and return zero\n@File: %s\n@Function: %s\n@Line: %d\n"

// Input parameter null
#define INPUT_NULL_001 "@WARNING: The input parameter called \"%s\" is NULL, will abort the operation and return NULL\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INPUT_NULL_002 "@WARNING: The input parameter called \"%s\" is NULL, will abort the operation and return \n@File: %s\n@Function: %s\n@Line: %d\n"
#define INPUT_NULL_003 "@WARNING: The input parameter called \"%s\" is zero, will abort the operation and return \n@File: %s\n@Function: %s\n@Line: %d\n"
#define INPUT_NULL_004 "@WARNING: The input parameter called \"%s\" or the input parameter called \"%s\" is zero, will abort the operation and return NULL\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INPUT_NULL_005 "@WARNING: The input parameter called \"%s\" or the input parameter called \"%s\" is NULL, will abort the operation and return NULL %d\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INPUT_NULL_006 "@WARNING: The input parameter called \"%s\" or the input parameter called \"%s\" is zero, will abort the operation and return\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INPUT_NULL_007 "@WARNING: The input parameter called \"%s\" or the input parameter called \"%s\" is NULL, will abort the operation and return\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INPUT_NULL_008 "@WARNING: The input parameter called \"%s\" or the input parameter called \"%s\" is zero, will abort the operation and return zero\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INPUT_NULL_009 "@WARNING: The input parameter called \"%s\" or the input parameter called \"%s\" is NULL, will abort the operation and return zero\n@File: %s\n@Function: %s\n@Line: %d\n"

// Parameter value error
#define PARAMETER_VALUE_ERROR_001 "@WARNING: The parameter called \"%s\" is NULL , will abort the operation and return\n@File: %s\n@Function: %s\n@Line: %d\n"

// Print warning message and return NULL
#define PWARNING_RETURN(fmt, ...)     \
    {                                 \
        PWARNING(fmt, ##__VA_ARGS__); \
        return NULL;                  \
    }

// Print warning message and return
#define PWARNING_RETURN_NO_NULL(fmt, ...) \
    {                                     \
        PWARNING(fmt, ##__VA_ARGS__);     \
        return;                           \
    }

// Print warning message and return 0
#define PWARNING_RETURN_ZERO(fmt, ...) \
    {                                  \
        PWARNING(fmt, ##__VA_ARGS__);  \
        return 0;                      \
    }

// Memory allocate error and return NULL
#define PWARNING_RETURN_MALLOC(a)                                                      \
    if (a == NULL)                                                                     \
    {                                                                                  \
        printf(MALLOC_FAILURE_002, VAR_NAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return NULL;                                                                   \
    }

// Memory allocate error and return
#define PWARNING_RETURN_MALLOC_NO_NULL(a)                                              \
    if (a == NULL)                                                                     \
    {                                                                                  \
        printf(MALLOC_FAILURE_002, VAR_NAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return;                                                                        \
    }

// Memory allocate error and return 0
#define PWARNING_RETURN_MALLOC_ZERO(a)                                                 \
    if (a == NULL)                                                                     \
    {                                                                                  \
        printf(MALLOC_FAILURE_002, VAR_NAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return ZERO;                                                                   \
    }

// Input parameter null and return
#define PWARNING_RETURN_INPUT_NO_NULL(a)                                           \
    if (a == NULL)                                                                 \
    {                                                                              \
        printf(INPUT_NULL_002, VAR_NAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return;                                                                    \
    }

// Input parameter null and return 0
#define PWARNING_RETURN_INPUT_ZERO(a)                                              \
    if (a == NULL)                                                                 \
    {                                                                              \
        printf(INPUT_NULL_002, VAR_NAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return ZERO;                                                               \
    }

// Input parameter null and return NULL
#define PWARNING_RETURN_INPUT(a)                                                   \
    if (a == NULL)                                                                 \
    {                                                                              \
        printf(INPUT_NULL_002, VAR_NAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return NULL;                                                               \
    }

#endif // _HSMK_MATH_LIB_CONSTDEF_H
