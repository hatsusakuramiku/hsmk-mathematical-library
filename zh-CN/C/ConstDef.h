#ifndef _CONSTDEF_H_
#define _CONSTDEF_H_

#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>

// #define FALSE false
// #define TRUE true
#define DBL_EPSILON 1e-15
#define FLT_EPSILON 1e-6
#define VNAME(value) (#value)

/* ERROR DEFINE */
#define VAR_LIST_LENGTH_001 "@ERROR: Too many or too few parameters are entered !\nThis function only supports %d variable !\n@File: %s\n@Function: %s\n@Line: %d\n"
#define VAR_LIST_LENGTH_002 "@ERROR: Too many or too few parameters are entered !\nThis function can only support a maximum of %d to %d parameters !\n@File: %s\n@Function: %s\n@Line: %d\n"
#define PERROR(fmt, ...)            \
    {                               \
        printf(fmt, ##__VA_ARGS__); \
        exit(1);                    \
    }
#define INVALID_INPUT_001 "@ERROR: The input parameter called \"%s\" must be an integer between %d and %d !\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INVALID_INPUT_002 "@ERROR: The input parameter called \"%s\" must be an integer and equal or greater than %d !\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INVALID_INPUT_003 "@ERROR: The length of the input parameter named \"%s\" must be equal to %d !\n@File: %s\n@Function: %s\n@Line: %d\n"

/* WARNING DEFINE */
#define VALUE_TYPE_WARNING_001 "@WARNING: value == %d\nMaybe a variable of the wrong type was entered\n@File: %s\n@Function: %s\n@Line: %d\n"
#define MALLOC_FAILURE_001 "@WARNING: Failed to allocate memory for variable called '%s', will return NULL\n@File: %s\n@Function: %s\n@Line: %d\n"
#define MALLOC_FAILURE_002 "@WARNING: Failed to allocate memory for variable called '%s', will abort the operation and return\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INPUT_NULL_001 "@WARNING: The input parameter called '%s' is NULL, will abort the operation and return NULL\n@File: %s\n@Function: %s\n@Line: %d\n"
#define INPUT_NULL_002 "@WARNING: The input parameter called '%s' is NULL, will abort the operation and return \n@File: %s\n@Function: %s\n@Line: %d\n"
#define PWARNING(fmt, ...) printf(fmt, ##__VA_ARGS__)
#define PWARNING_RETURN(fmt, ...)     \
    {                                 \
        PWARNING(fmt, ##__VA_ARGS__); \
        return NULL;                  \
    }
#define PWARNING_RETURN_MALLOC(a)                                                   \
    if (a == NULL)                                                                  \
    {                                                                               \
        /*free(a);*/                                                                \
        printf(MALLOC_FAILURE_002, VNAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return NULL;                                                                \
    }

#define PWARNING_RETURN_MALLOC_NO_NULL(a)                                           \
    if (a == NULL)                                                                  \
    {                                                                               \
        /*free(a);*/                                                                \
        printf(MALLOC_FAILURE_002, VNAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        exit; /*return; */                                                          \
    }

#define PWARNING_RETURN_INPUT_NO_NULL(a)                                        \
    if (a == NULL)                                                              \
    {                                                                           \
        printf(INPUT_NULL_002, VNAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        exit; /*return; */                                                      \
    }

#define PWARNING_RETURN_INPUT(a)                                                \
    if (a == NULL)                                                              \
    {                                                                           \
        printf(INPUT_NULL_002, VNAME(a), __FILE__, __FUNCTION__, __LINE__ - 1); \
        return NULL;                                                            \
    }
/* DOUBLE COMPARE DEFINE */
#define DOUBLE_COMPARE_EQ2ZERO(a) (a == 0.0 || (fabs(a) <= DBL_EPSILON))
#define DOUBLE_COMPARE_EQ(a, b) (DOUBLE_COMPARE_EQ2ZERO(a - b))

/* ARGC DEFINE */
// doc https://blog.csdn.net/lamdonn/article/details/129192959
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

#endif

#endif