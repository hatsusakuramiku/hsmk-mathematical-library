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

#ifndef _HSMK_MATH_LIB_EXCEPTION_H
#define _HSMK_MATH_LIB_EXCEPTION_H

// Maximum length for exception messages
#define HSMK_MATH_LIB_EXCEPTION_MAX_MESSAGE_LENGTH 1024

// Enum representing the type of exception
// ERROR: Indicates a critical error
// WARNING: Indicates a non-critical warning
// NONE: Indicates no exception
typedef enum
{
    HSMK_MATH_LIB_EXCEPTION_TYPE_ERROR,
    HSMK_MATH_LIB_EXCEPTION_TYPE_WARNING,
    HSMK_MATH_LIB_EXCEPTION_TYPE_NONE,
} HSMK_MATH_LIB_EXCEPTION_TYPE;

// Structure representing an exception in the library
// Contains the type, message, file, line, and function where the exception occurred
typedef struct
{
    HSMK_MATH_LIB_EXCEPTION_TYPE type; // Type of the exception (error, warning, none)
    const char *message;               // Exception message
    const char *file;                  // Source file where the exception occurred
    int line;                          // Line number in the source file
    const char *function;              // Function name where the exception occurred
} HSMK_MATH_LIB_EXCEPTION;

// Macro to create an exception object with all details specified
#define HSMK_MATH_LIB_EXCEPTION_CREATE(type, message, file, line, function) \
    ((HSMK_MATH_LIB_EXCEPTION){                                             \
        type,                                                               \
        message,                                                            \
        file,                                                               \
        line,                                                               \
        function})
// Macro to create an error exception with automatic file, line, and function information
#define HSMK_MATH_LIB_EXCEPTION_CREATE_ERROR(message) \
    HSMK_MATH_LIB_EXCEPTION_CREATE(HSMK_MATH_LIB_EXCEPTION_TYPE_ERROR, message, __FILE__, __LINE__, __FUNCTION__)

// Macro representing no exception (used as a default or placeholder)
#define HSMK_MATH_LIB_NO_EXCEPTION HSMK_MATH_LIB_EXCEPTION_CREATE(HSMK_MATH_LIB_EXCEPTION_TYPE_NONE, "No exception", __FILE__, __LINE__, __FUNCTION__)
#endif