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
 * @headerfile vector.h
 */

#include <malloc.h>
#include "constDef.h"
#include "vector.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

/**
 * Creates a new Vector instance with the specified length, data, and type.
 *
 * @param length The length of the new Vector instance.
 * @param data The data to be copied into the new Vector instance.
 * @param type The type of the new Vector instance.
 *
 * @return A pointer to the newly created Vector instance.
 *
 * @throws INPUT_NULL_004 If the length is zero.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 * @throws TYPE_ERROR_001 If the type is invalid.
 */
Vector *vector_p(const unsigned int length, const void *data, const enum VectorType type) {
    return vector_gen_p(length, data, type);
}

/**
 * Creates a new Vector instance with the specified length, data, and type.
 *
 * @param length The length of the new Vector instance.
 * @param data The data to be copied into the new Vector instance.
 * @param type The type of the new Vector instance.
 *
 * @return A pointer to the newly created Vector instance.
 *
 * @throws INPUT_NULL_004 If the length is zero.
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 * @throws TYPE_ERROR_001 If the type is invalid.
 */
Vector *vector_gen_p(const unsigned int length, const void *data, const enum VectorType type) {
    // Check if the length is zero and throw an error if so
    if (length == 0) {
        PWARNING_RETURN(INPUT_NULL_003, VAR_NAME(length), __FILE__, __FUNCTION__, __LINE__);
    }

    // Allocate memory for the new Vector instance
    Vector *new_vector = (Vector *) calloc(1, sizeof(Vector));
    if (new_vector == NULL) {
        // If memory allocation fails, throw an error
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector), __FILE__, __FUNCTION__, __LINE__);
    }

    // Determine the minimum length between the specified length and the length of the data
    const int min_len = MIN(length, VECTOR_LENGTH(data));

    // Initialize the data for the new Vector instance based on the type
    switch (type) {
        case VECTOR_TYPE_INT: {
            // Allocate memory for the int data
            new_vector->data = (void *) calloc(length, sizeof(int));
            if (new_vector->data == NULL) {
                // If memory allocation fails, free the Vector instance and throw an error
                vector_free_p(&new_vector);
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector->data), __FILE__, __FUNCTION__, __LINE__);
            }

            // Copy the int data from the source data
            for (int i = 0; i < min_len; i++) {
                if (data == NULL) {
                    break;
                }
                ((int *) new_vector->data)[i] = ((int *) data)[i];
            }

            // Initialize any remaining elements to zero
            for (int i = min_len; i < length; i++) {
                ((int *) new_vector->data)[i] = 0;
            }
            break;
        }
        case VECTOR_TYPE_FLOAT: {
            // Allocate memory for the float data
            new_vector->data = (void *) calloc(length, sizeof(float));
            if (new_vector->data == NULL) {
                // If memory allocation fails, free the Vector instance and throw an error
                vector_free_p(&new_vector);
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector->data), __FILE__, __FUNCTION__, __LINE__);
            }

            // Copy the float data from the source data
            for (int i = 0; i < min_len; i++) {
                if (data == NULL) {
                    break;
                }
                ((float *) new_vector->data)[i] = ((float *) data)[i];
            }

            // Initialize any remaining elements to zero
            for (int i = min_len; i < length; i++) {
                ((float *) new_vector->data)[i] = 0.0f;
            }
            break;
        }
        case VECTOR_TYPE_DOUBLE: {
            // Allocate memory for the double data
            new_vector->data = (void *) calloc(length, sizeof(double));
            if (new_vector->data == NULL) {
                // If memory allocation fails, free the Vector instance and throw an error
                vector_free_p(&new_vector);
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector->data), __FILE__, __FUNCTION__, __LINE__);
            }

            // Copy the double data from the source data
            for (int i = 0; i < min_len; i++) {
                if (data == NULL) {
                    break;
                }
                ((double *) new_vector->data)[i] = ((double *) data)[i];
            }

            // Initialize any remaining elements to zero
            for (int i = min_len; i < length; i++) {
                ((double *) new_vector->data)[i] = 0.0;
            }
            break;
        }
        case VECTOR_TYPE_CHAR: {
            // Allocate memory for the char data
            new_vector->data = (void *) calloc(length, sizeof(char));
            if (new_vector->data == NULL) {
                // If memory allocation fails, free the Vector instance and throw an error
                vector_free_p(&new_vector);
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector->data), __FILE__, __FUNCTION__, __LINE__);
            }

            // Copy the char data from the source data
            for (int i = 0; i < min_len; i++) {
                if (data == NULL) {
                    break;
                }
                ((char *) new_vector->data)[i] = ((char *) data)[i];
            }

            // Initialize any remaining elements to zero
            for (int i = min_len; i < length; i++) {
                ((char *) new_vector->data)[i] = 0;
            }
            break;
        }
        case VECTOR_TYPE_VOID: {
            // Allocate memory for the void data
            new_vector->data = (void *) calloc(length, sizeof(void *));
            if (new_vector->data == NULL) {
                // If memory allocation fails, free the Vector instance and throw an error
                vector_free_p(&new_vector);
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector->data), __FILE__, __FUNCTION__, __LINE__);
            }

            // Copy the void data from the source data
            if (0 == min_len) {
                break;
            }
            memcpy(new_vector->data, data, min_len * sizeof(void *));
            break;
        }
        default: {
            // If the type is invalid, throw an error
            PERROR(TYPE_ERROR_001, VAR_NAME(type), __FILE__, __FUNCTION__, __LINE__);
        }
    }

    // Set the type and length of the new Vector instance
    new_vector->type = type;
    new_vector->length = length;

    // Return the new Vector instance
    return new_vector;
}

/**
 * Frees the memory allocated for a vector and its data.
 *
 * @param vector A pointer to a pointer to the vector to be freed.
 *
 * @return None
 *
 * @throws None
 */
void vector_free_p(Vector **vector) {
    if (vector == NULL || *vector == NULL) {
        return;
    }
    FREE((*vector)->data);
    FREE(*vector);
}

/**
 * Prints the contents of a vector to the console.
 *
 * This function takes a pointer to a Vector struct as input and prints its contents
 * to the console. It handles different data types (int, float, double, char) and
 * truncates the output if the vector length exceeds a certain limit.
 *
 * @param vector A pointer to the Vector struct to be printed.
 *
 * @return None
 *
 * @throws INPUT_NULL_007 if the vector is NULL or its data is NULL.
 * @throws TYPE_ERROR_001 if the vector type is not supported.
 */
void vector_print_p(const Vector *vector) {
    // Check for NULL input
    if (vector == NULL || vector->data == NULL) {
        // If input is NULL, print an error message and return
        PWARNING_RETURN_NO_NULL(INPUT_NULL_007, VAR_NAME(vector), VAR_NAME(vector->data), __FILE__, __FUNCTION__,
                                __LINE__);
    }

    // Get the length of the vector
    const int len = vector->length;

    // Switch statement to handle different data types
    switch (vector->type) {
        case VECTOR_TYPE_INT: {
            // Cast data to int pointer
            const int *tmp = (int *) vector->data;

            // Print vector contents
            printf("[");
            if (len > VECTOR_DEAFAULT_PRINT_LENTH_LIMIT) {
                // If vector length exceeds limit, truncate output
                for (int i = 0; i < len; i++) {
                    if (i == 2) {
                        // Print ellipsis to indicate truncation
                        printf("...\t");
                        i = len - 2;
                    }
                    printf("%d\t", tmp[i]);
                }
                printf("]\n");
                break;
            }
            // Print full vector contents
            for (int i = 0; i < len; i++) {
                printf("%d ", tmp[i]);
            }
            printf("]\n");
            break;
        }
        case VECTOR_TYPE_FLOAT: {
            // Cast data to float pointer
            const float *tmp = (float *) vector->data;

            // Print vector contents
            printf("[");
            if (len > VECTOR_DEAFAULT_PRINT_LENTH_LIMIT) {
                // If vector length exceeds limit, truncate output
                for (int i = 0; i < len; i++) {
                    if (i == 2) {
                        // Print ellipsis to indicate truncation
                        printf("...\t");
                        i = len - 2;
                    }
                    printf("%.6f\t", tmp[i]);
                }
                printf("]\n");
                break;
            }
            // Print full vector contents
            for (int i = 0; i < len; i++) {
                printf("%.6f\t", tmp[i]);
            }
            printf("]\n");
            break;
        }
        case VECTOR_TYPE_DOUBLE: {
            // Cast data to double pointer
            const double *tmp = (double *) vector->data;

            // Print vector contents
            printf("[");
            if (len > VECTOR_DEAFAULT_PRINT_LENTH_LIMIT) {
                // If vector length exceeds limit, truncate output
                for (int i = 0; i < len; i++) {
                    if (i == 2) {
                        // Print ellipsis to indicate truncation
                        printf("...\t");
                        i = len - 2;
                    }
                    printf("%.6lf\t", tmp[i]);
                }
                printf("]\n");
                break;
            }
            // Print full vector contents
            for (int i = 0; i < len; i++) {
                printf("%.6lf\t ", tmp[i]);
            }
            printf("]\n");
            break;
        }
        case VECTOR_TYPE_CHAR: {
            // Cast data to char pointer
            const char *tmp = (char *) vector->data;

            // Print vector contents
            printf("[");
            if (len > VECTOR_DEAFAULT_PRINT_LENTH_LIMIT) {
                // If vector length exceeds limit, truncate output
                for (int i = 0; i < len; i++) {
                    if (i == 2) {
                        // Print ellipsis to indicate truncation
                        printf("...\t");
                        i = len - 2;
                    }
                    printf("%C\t", tmp[i]);
                }
                printf("]\n");
                break;
            }
            // Print full vector contents
            for (int i = 0; i < len; i++) {
                printf("%C\t", tmp[i]);
            }
            printf("]\n");
            break;
        }
        default: {
            // If vector type is not supported, print an error message
            PERROR(TYPE_ERROR_001, VAR_NAME(vector->type), __FILE__, __FUNCTION__, __LINE__);
        }
    }

    // Print vector length and type
    printf("vector length: %d, type: %s\n", vector->length,
           vector->type == VECTOR_TYPE_INT
               ? "int"
               : vector->type == VECTOR_TYPE_FLOAT
                     ? "float"
                     : vector->type == VECTOR_TYPE_DOUBLE
                           ? "double"
                           : "char");
}

/**
 * Splices two vectors together and returns a new vector.
 *
 * This function takes two input vectors, checks for errors, and then creates a new vector
 * that is the concatenation of the two input vectors.
 *
 * @param forward The first vector.
 * @param backward The second vector.
 *
 * @return A new vector that is the splicing of the two input vectors.
 *
 * @throws INPUT_NULL_005 if either of the input vectors is NULL.
 * @throws MALLOC_FAILURE_001 if memory allocation fails.
 * @throws TYPE_ERROR_002 if the two input vectors have different types.
 * @throws TYPE_ERROR_001 if the type of the input vectors is not supported.
 */
Vector *_vector_splicing_p(const Vector *forward, const Vector *backward) {
    // Check for NULL input vectors
    if (forward == NULL || backward == NULL) {
        // If either vector is NULL, throw an error
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(forward), VAR_NAME(backward), __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if the two input vectors have the same type
    if (forward->type != backward->type) {
        // If the types are different, throw an error
        PERROR(TYPE_ERROR_002, VAR_NAME(forward->type), VAR_NAME(backward->type), __FILE__, __FUNCTION__,
               __LINE__);
    }

    // Create a new vector that is the concatenation of the two input vectors
    Vector *new_vector = vector_gen_p(forward->length + backward->length, NULL, forward->type);

    // Check if memory allocation failed
    if (new_vector == NULL) {
        // If memory allocation failed, throw an error
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector), __FILE__, __FUNCTION__, __LINE__);
    }

    // Copy the data from the input vectors to the new vector
    switch (new_vector->type) {
        case VECTOR_TYPE_INT: {
            // Copy int data
            int *tmp = (int *) new_vector->data;
            memcpy(tmp, forward->data, forward->length * sizeof(int));
            memcpy(tmp + forward->length, backward->data, backward->length * sizeof(int));
            break;
        }
        case VECTOR_TYPE_FLOAT: {
            // Copy float data
            float *tmp = (float *) new_vector->data;
            memcpy(tmp, forward->data, forward->length * sizeof(float));
            memcpy(tmp + forward->length, backward->data, backward->length * sizeof(float));
            break;
        }
        case VECTOR_TYPE_DOUBLE: {
            // Copy double data
            double *tmp = (double *) new_vector->data;
            memcpy(tmp, forward->data, forward->length * sizeof(double));
            memcpy(tmp + forward->length, backward->data, backward->length * sizeof(double));
            break;
        }
        case VECTOR_TYPE_CHAR: {
            // Copy char data
            char *tmp = (char *) new_vector->data;
            memcpy(tmp, forward->data, forward->length * sizeof(char));
            memcpy(tmp + forward->length, backward->data, backward->length * sizeof(char));
            break;
        }
        default: {
            // If the type is not supported, throw an error
            PERROR(TYPE_ERROR_001, VAR_NAME(new_vector->type), __FILE__, __FUNCTION__, __LINE__);
        }
    }

    // Return the new vector
    return new_vector;
}

/**
 * Copies the content of the source vector to the destination vector and frees the source vector.
 *
 * This function checks for null input vectors and allocates memory for the destination vector.
 * If memory allocation fails, it throws a MALLOC_FAILURE_001 error.
 *
 * @param src_vec The source vector to be copied.
 * @param dst_vec The destination vector where the content will be copied.
 *
 * @throws INPUT_NULL_005 if either the source or destination vector is NULL.
 * @throws MALLOC_FAILURE_001 if memory allocation fails.
 */
void vector_copy_free_p(Vector **src_vec, Vector *dst_vec) {
    // Check if the source vector or its data is NULL
    if (*src_vec == NULL || (*src_vec)->data == NULL) {
        // Throw an error if either is NULL
        PWARNING_RETURN_NO_NULL(INPUT_NULL_005, VAR_NAME(src_vec), VAR_NAME(src_vec->data), __FILE__, __FUNCTION__,
                                __LINE__);
    }

    // Check if the destination vector is not NULL
    if (dst_vec != NULL) {
        // Free the destination vector to avoid memory leaks
        vector_free_p(&dst_vec);
    }

    // Generate a new vector with the same length and type as the source vector
    dst_vec = vector_gen_p((*src_vec)->length, (*src_vec)->data, (*src_vec)->type);

    // Check if memory allocation failed
    if (dst_vec == NULL) {
        // Throw an error if memory allocation failed
        PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(dst_vec), __FILE__, __FUNCTION__, __LINE__);
    }

    // Free the source vector
    vector_free_p(src_vec);
}

/**
 * Copy the content of @p src_vec to a new vector.
 *
 * This function creates a deep copy of the source vector, allocating new memory for the data.
 *
 * @param src_vec The source vector to copy.
 *
 * @return A new vector that is a copy of the source vector.
 *
 * @throws INPUT_NULL_005 if either the source vector or its data is NULL.
 * @throws MALLOC_FAILURE_001 if memory allocation fails.
 */
Vector *vector_copy_p(const Vector *src_vec) {
    // Check if the source vector or its data is NULL
    if (src_vec == NULL || src_vec->data == NULL) {
        // If either is NULL, throw an error and return
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(src_vec), VAR_NAME(src_vec->data), __FILE__, __FUNCTION__,
                        __LINE__);
    }

    // Create a new vector with the same length and type as the source vector
    // This will allocate new memory for the data
    Vector *det_vec = vector_gen_p(src_vec->length, src_vec->data, src_vec->type);

    // Check if memory allocation failed
    if (det_vec == NULL) {
        // If allocation failed, throw an error and return
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(det_vec), __FILE__, __FUNCTION__, __LINE__);
    }

    // Return the new vector
    return det_vec;
}

/**
 * Copies the content of @p src_vec to @p dst_vec, and frees @p src_vec.
 *
 * @param src_vec The source vector.
 * @param dst_vec The destination vector.
 *
 * @throws INPUT_NULL_005 if either of the two input vectors is NULL.
 * @throws MALLOC_FAILURE_001 if memory allocation fails.
 */
void _vector_copy_p(const Vector *src_vec, Vector *dst_vec) {
    vector_copy_free_p((Vector **) vector_copy_p(src_vec), dst_vec);
}

/**
 * Creates a new Vector instance with the specified length and data.
 *
 * @param length The length of the new Vector instance.
 * @param data The data to be copied into the new Vector instance.
 *
 * @return A pointer to the newly created Vector instance.
 */
Vector *vector(const unsigned int length, const VECTOR_DEAFAULT_TYPE *data) {
    return vector_gen_p(length, data, __gen_type());
}

/**
 * Returns the default type of a Vector instance.
 *
 * @return The default type of a Vector instance.
 */
static enum VectorType __gen_type() {
    return VECTOR_TYPE_DOUBLE;
}

/**
 * Generates a new vector with the specified length and data, and sets its type to
 * the default type.
 *
 * @param length The length of the new vector.
 * @param data The data to be copied into the new vector.
 *
 * @return A pointer to the newly created vector, or NULL if memory allocation fails.
 *
 * @throws MALLOC_FAILURE_001 If memory allocation fails.
 */
Vector *vector_gen(const unsigned int length, const VECTOR_DEAFAULT_TYPE *data) {
    return vector_gen_p(length, data, __gen_type());
}

/**
 * Frees the memory allocated for the specified Vector instance.
 *
 * This function checks if the input vector is NULL or if the vector's data is NULL.
 * If either condition is true, the function returns immediately.
 * Otherwise, it frees the memory allocated for the vector's data and then the vector itself.
 *
 * @param vector A pointer to a pointer to the Vector instance to be freed.
 *
 * @throws None.
 */
void vector_free(Vector **vector) {
    // Check if the input vector is NULL or if the vector itself is NULL
    if (vector == NULL || *vector == NULL) {
        // If either condition is true, return immediately
        return;
    }

    // Check if the vector's data is NULL
    if ((*vector)->data == NULL) {
        // If the data is NULL, only free the vector itself
        FREE(*vector);
        return;
    }

    // Free the memory allocated for the vector's data
    FREE((*vector)->data);

    // Free the memory allocated for the vector itself
    FREE(*vector);
}

/**
 * Prints the contents of a vector to the console.
 *
 * This function checks if the input vector and its data are not NULL, then prints
 * the vector's elements in a human-readable format. If the vector's length exceeds
 * a certain limit, it prints an ellipsis (...) to indicate that not all elements
 * are shown.
 *
 * @param vector A pointer to the vector to be printed.
 *
 * @return None
 *
 * @throws INPUT_NULL_007 if the vector is NULL or its data is NULL.
 */
void vector_print(const Vector *vector) {
    // Check if the input vector and its data are not NULL
    if (vector == NULL || vector->data == NULL) {
        // If either condition is true, print an error message and return
        PWARNING_RETURN_NO_NULL(INPUT_NULL_007, VAR_NAME(vector), VAR_NAME(vector->data), __FILE__, __FUNCTION__,
                                __LINE__);
    }

    // Get the length of the vector
    const int len = vector->length;

    // Print the opening bracket of the vector
    printf("[");

    // Check if the vector's length exceeds the print limit
    if (len > VECTOR_DEAFAULT_PRINT_LENTH_LIMIT) {
        // If the length exceeds the limit, print an ellipsis after the first two elements
        for (int i = 0; i < len; i++) {
            if (i == 2) {
                // Print the ellipsis and skip to the last two elements
                printf("...\t");
                i = len - 2;
            }
            // Print the current element
            printf(VECTOR_DEFAULT_PRECISION, ((VECTOR_DEAFAULT_TYPE *) vector->data)[i]);
        }
    } else {
        // If the length does not exceed the limit, print all elements
        for (int i = 0; i < len; i++) {
            printf(VECTOR_DEFAULT_PRECISION, ((VECTOR_DEAFAULT_TYPE *) vector->data)[i]);
        }
    }

    // Print the closing bracket and additional information about the vector
    printf("]\n");
    printf("vector: length: %d, type: %s\n", vector->length, "double");
}
