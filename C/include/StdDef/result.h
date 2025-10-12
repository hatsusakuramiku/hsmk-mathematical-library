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

#ifndef _HSMK_MATH_LIB_RESULT_H
#define _HSMK_MATH_LIB_RESULT_H

// Project Headers
#include "exception.h"

// Standard Headers
#include <stddef.h>

/**
 * @brief Enum representing the result type of a function or operation.
 *        Indicates whether the operation was successful or resulted in an error.
 */
typedef enum
{
    HSMK_MATH_LIB_RESULT_STATUS_SUCCESS, ///< Operation completed successfully
    HSMK_MATH_LIB_RESULT_STATUS_ERROR    ///< Operation resulted in an error
} HSMK_MATH_LIB_RESULT_STATUS;

/**
 * @brief Structure representing the result of a mathematical library operation.
 *
 * Contains information about the result type (success or error),
 * a pointer to the result data, the size of the data, the data type,
 * and an exception object if an error occurred.
 */
typedef struct
{
    HSMK_MATH_LIB_RESULT_STATUS status; ///< Result type: success or error
    void *data;                         ///< Pointer to result data (type depends on data_type)
    size_t size;                        ///< Size of the data in bytes
    const char *type_name;              ///< Type descriptor for the data
    HSMK_MATH_LIB_EXCEPTION exception;  ///< Exception information if an error occurred
} HSMK_MATH_LIB_RESULT;

/**
 * @brief Alias for HSMK_MATH_LIB_RESULT for convenience.
 */
#define HSMK_RESULT HSMK_MATH_LIB_RESULT

/**
 * @brief Macro to create a HSMK_MATH_LIB_RESULT structure with all fields specified.
 * @param type      Result type (success or error)
 * @param data      Pointer to result data
 * @param size      Size of the data in bytes
 * @param data_type Type of the data
 * @param exception Exception information (NULL if no error)
 */
#define HSMK_RESULT_CREATE(status, data, size, data_type, exception) \
    ((HSMK_RESULT){                                                  \
        status,                                                      \
        data,                                                        \
        size,                                                        \
        data_type,                                                   \
        exception})

/**
 * @brief Macro to create a successful result with data.
 * @param data      Pointer to result data
 * @param size      Size of the data in bytes
 * @param data_type Type of the data
 */
#define HSMK_RESULT_CREATE_SUCCESS(data, size, data_type) \
    HSMK_RESULT_CREATE(HSMK_MATH_LIB_RESULT_STATUS_SUCCESS, data, size, data_type, HSMK_MATH_LIB_NO_EXCEPTION)

/**
 * @brief Macro to create an error result with exception information.
 * @param exceptionMessage Exception information
 */
#define HSMK_RESULT_CREATE_ERROR(exceptionMessage) \
    HSMK_RESULT_CREATE(HSMK_MATH_LIB_RESULT_STATUS_ERROR, NULL, 0, "void", HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(exceptionMessage))

typedef char *(*result_to_string)(HSMK_RESULT result);

void print_hsmk_result(HSMK_RESULT result, result_to_string func)
{

    printf(func(result));
}
#endif