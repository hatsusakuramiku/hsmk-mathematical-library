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
    HSMK_MATH_LIB_RESULT_TYPE_SUCCESS, ///< Operation completed successfully
    HSMK_MATH_LIB_RESULT_TYPE_ERROR    ///< Operation resulted in an error
} HSMK_MATH_LIB_RESULT_TYPE;

/**
 * @brief Enum representing the type of data stored in the result structure.
 *        Used to interpret the 'data' field in the result struct.
 */
typedef enum
{
    HSMK_MATH_LIB_RESULT_DATA_TYPE_VOID,      ///< No data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_INT,       ///< Integer data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_LONG,      ///< Long integer data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_CHAR,      ///< Character data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_SHORT,     ///< Short integer data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_LONG_LONG, ///< Long long integer data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_FLOAT,     ///< Float data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_DOUBLE,    ///< Double data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_STRING,    ///< String data (char*)
    HSMK_MATH_LIB_RESULT_DATA_TYPE_ARRAY,     ///< Array data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_STRUCT,    ///< Struct data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_FUNCTION,  ///< Function pointer
    HSMK_MATH_LIB_RESULT_DATA_TYPE_POINTER,   ///< Generic pointer
    HSMK_MATH_LIB_RESULT_DATA_TYPE_ENUM,      ///< Enum data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_UNION,     ///< Union data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_BITFIELD,  ///< Bitfield data
    HSMK_MATH_LIB_RESULT_DATA_TYPE_TYPEDEF,   ///< Typedef data
} HSMK_MATH_LIB_RESULT_DATA_TYPE;

/**
 * @brief Structure representing the result of a mathematical library operation.
 *
 * Contains information about the result type (success or error),
 * a pointer to the result data, the size of the data, the data type,
 * and an exception object if an error occurred.
 */
typedef struct
{
    HSMK_MATH_LIB_RESULT_TYPE type;           ///< Result type: success or error
    void *data;                               ///< Pointer to result data (type depends on data_type)
    size_t size;                              ///< Size of the data in bytes
    HSMK_MATH_LIB_RESULT_DATA_TYPE data_type; ///< Type of the data stored in 'data'
    HSMK_MATH_LIB_EXCEPTION exception;        ///< Exception information if an error occurred
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
#define HSMK_RESULT_CREATE(type, data, size, data_type, exception) \
    ((HSMK_RESULT){                                                \
        type,                                                      \
        data,                                                      \
        size,                                                      \
        data_type,                                                 \
        exception})

/**
 * @brief Macro to create a successful result with data.
 * @param data      Pointer to result data
 * @param size      Size of the data in bytes
 * @param data_type Type of the data
 */
#define HSMK_RESULT_CREATE_SUCCESS(data, size, data_type) \
    HSMK_RESULT_CREATE(HSMK_MATH_LIB_RESULT_TYPE_SUCCESS, data, size, data_type, HSMK_MATH_LIB_NO_EXCEPTION)

/**
 * @brief Macro to create an error result with exception information.
 * @param exceptionMessage Exception information
 */
#define HSMK_RESULT_CREATE_ERROR(exceptionMessage) \
    HSMK_RESULT_CREATE(HSMK_MATH_LIB_RESULT_TYPE_ERROR, NULL, 0, HSMK_MATH_LIB_RESULT_DATA_TYPE_VOID, HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(exceptionMessage))

#endif