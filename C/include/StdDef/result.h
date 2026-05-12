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
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>

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
 * a union of result data (for success) or exception (for error),
 * and an owns_data flag indicating memory ownership.
 *
 * @note When status == SUCCESS, only 'data' field is valid.
 *       When status == ERROR, only 'exception' field is valid.
 */
typedef struct
{
    HSMK_MATH_LIB_RESULT_STATUS status;  ///< Result type: success or error
    union
    {
        void *data;                         ///< Result data (valid on SUCCESS)
        HSMK_MATH_LIB_EXCEPTION exception;  ///< Exception info (valid on ERROR)
    };
    size_t size;                           ///< Size of data in bytes (valid on SUCCESS)
    bool owns_data;                        ///< If true, caller is responsible for freeing data
} HSMK_MATH_LIB_RESULT;

/**
 * @brief Alias for HSMK_MATH_LIB_RESULT for convenience.
 */
typedef HSMK_MATH_LIB_RESULT HSMK_RESULT;

/**
 * @brief Create a successful result with data.
 * @param ptr    Pointer to result data
 * @param sz     Size of data in bytes
 * @param owner  If true, caller owns the data and must free it; if false, data is borrowed
 */
#define HSMK_RESULT_OK(ptr, sz, owner) \
    ((HSMK_RESULT){ \
        .status = HSMK_MATH_LIB_RESULT_STATUS_SUCCESS, \
        .data = (ptr), \
        .size = (sz), \
        .owns_data = (owner) \
    })

/**
 * @brief Create an error result with exception.
 * @param ex  Exception object (use HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(msg))
 */
#define HSMK_RESULT_ERR(ex) \
    ((HSMK_RESULT){ \
        .status = HSMK_MATH_LIB_RESULT_STATUS_ERROR, \
        .exception = (ex), \
        .size = 0, \
        .owns_data = false \
    })

/**
 * @brief Destroy a result, freeing data if owned.
 * @param r  Result to destroy
 */
#define HSMK_RESULT_DESTROY(r) \
    do { \
        if ((r).owns_data && (r).data != NULL) { \
            free((r).data); \
            (r).data = NULL; \
        } \
    } while (0)

/**
 * @brief Check if result is successful.
 * @param r  Result to check
 */
#define HSMK_RESULT_IS_OK(r) ((r).status == HSMK_MATH_LIB_RESULT_STATUS_SUCCESS)

/**
 * @brief Check if result is an error.
 * @param r  Result to check
 */
#define HSMK_RESULT_IS_ERR(r) ((r).status == HSMK_MATH_LIB_RESULT_STATUS_ERROR)

/**
 * @brief Get error message from result (valid only on ERROR).
 * @param r  Result to get message from
 */
#define HSMK_RESULT_GET_ERROR_MSG(r) ((r).exception.message)

#endif