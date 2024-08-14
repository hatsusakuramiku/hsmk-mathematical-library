#ifndef _CONSTDEF_H_
#define _CONSTDEF_H_

#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

#define DBL_EPSILON 1e-15     // 2.220446049250313e-16
#define FLT_EPSILON 1e-6      // 1.1920928955078125e-7
#define VNAME(value) (#value) // Get variable name
#define MSG_BUFFER 1024       // Message buffer size
#define ZERO 0

/**
 * For double comparison with zero or epsilon
 */
#define DOUBLE_COMPARE_EQ2ZERO(a) (a == 0.0 || (fabs(a) <= DBL_EPSILON))
#define DOUBLE_COMPARE_EQ(a, b) (DOUBLE_COMPARE_EQ2ZERO(a - b))

/**
 * Error define
 *
 * Error message standaed format:
 * @ERROR: Error message\n@File: File name\n@Function: Function name\n@Line: Line number\n
 *
 * When error occurs, the program prints the error message and will exit.
 */

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

/**
 * Warning define
 *
 * Warning message standaed format:
 * @WARNING: Warning message\n@File: File name\n@Function: Function name\n@Line: Line number\n
 *
 * When warning occurs, the program prints the warning message and will return or do nothing.
 */

// Print warning
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

// Parameter value error
#define PARAMETER_VALUE_ERROR_001 "@WARNING: The parameter called \"%s\" is NULL , will abort the operation and return\n@File: %s\n@Function: %s\n@Line: %d\n"

#define PWARNING_RETURN(fmt, ...)     \
    {                                 \
        PWARNING(fmt, ##__VA_ARGS__); \
        return NULL;                  \
    }

#define PWARNING_RETURN_MALLOC(a)                                                   \
    if (a == NULL)                                                                  \
    {                                                                               \
        printf(MALLOC_FAILURE_002, VNAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return NULL;                                                                \
    }

#define PWARNING_RETURN_MALLOC_NO_NULL(a)                                           \
    if (a == NULL)                                                                  \
    {                                                                               \
        printf(MALLOC_FAILURE_002, VNAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return;                                                                     \
    }

#define PWARNING_RETURN_MALLOC_ZERO(a)                                              \
    if (a == NULL)                                                                  \
    {                                                                               \
        printf(MALLOC_FAILURE_002, VNAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return ZERO;                                                                \
    }

#define PWARNING_RETURN_INPUT_NO_NULL(a)                                        \
    if (a == NULL)                                                              \
    {                                                                           \
        printf(INPUT_NULL_002, VNAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return;                                                                 \
    }

#define PWARNING_RETURN_INPUT_ZERO(a)                                           \
    if (a == NULL)                                                              \
    {                                                                           \
        printf(INPUT_NULL_002, VNAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return ZERO;                                                            \
    }

#define PWARNING_RETURN_INPUT(a)                                                \
    if (a == NULL)                                                              \
    {                                                                           \
        printf(INPUT_NULL_002, VNAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return NULL;                                                            \
    }

/**
 * For checking the number of input parameters
 *
 * ref: https://blog.csdn.net/lamdonn/article/details/129192959
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

#endif // CONSTDEF_H