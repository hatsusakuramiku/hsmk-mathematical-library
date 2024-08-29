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
    if (length == 0) {
        PWARNING_RETURN(INPUT_NULL_004, VAR_NAME(length), __FILE__, __FUNCTION__, __LINE__);
    }

    Vector *new_vector = (Vector *) calloc(1, sizeof(Vector));
    if (new_vector == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector), __FILE__, __FUNCTION__, __LINE__);
    }
    const int min_len = MIN(length, LENGTH(data));
    switch (type) {
        case VECTOR_TYPE_INT: {
            new_vector->data = (void *) calloc(length, sizeof(int));
            if (new_vector->data == NULL) {
                vector_free_p(&new_vector);
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector->data), __FILE__, __FUNCTION__, __LINE__);
            }
            for (int i = 0; i < min_len; i++) {
                if (data == NULL) {
                    break;
                }
                ((int *) new_vector->data)[i] = ((int *) data)[i];
            }
            for (int i = min_len; i < length; i++) {
                ((int *) new_vector->data)[i] = 0;
            }
            break;
        }
        case VECTOR_TYPE_FLOAT: {
            new_vector->data = (void *) calloc(length, sizeof(float));
            if (new_vector->data == NULL) {
                vector_free_p(&new_vector);
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector->data), __FILE__, __FUNCTION__, __LINE__);
            }
            for (int i = 0; i < min_len; i++) {
                if (data == NULL) {
                    break;
                }
                ((float *) new_vector->data)[i] = ((float *) data)[i];
            }
            for (int i = min_len; i < length; i++) {
                ((float *) new_vector->data)[i] = 0.0f;
            }
            break;
        }
        case VECTOR_TYPE_DOUBLE: {
            new_vector->data = (void *) calloc(length, sizeof(double));
            if (new_vector->data == NULL) {
                vector_free_p(&new_vector);
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector->data), __FILE__, __FUNCTION__, __LINE__);
            }
            for (int i = 0; i < min_len; i++) {
                if (data == NULL) {
                    break;
                }
                ((double *) new_vector->data)[i] = ((double *) data)[i];
            }
            for (int i = min_len; i < length; i++) {
                ((double *) new_vector->data)[i] = 0.0;
            }
            break;
        }
        case VECTOR_TYPE_CHAR: {
            new_vector->data = (void *) calloc(length, sizeof(char));
            if (new_vector->data == NULL) {
                vector_free_p(&new_vector);
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector->data), __FILE__, __FUNCTION__, __LINE__);
            }
            for (int i = 0; i < min_len; i++) {
                if (data == NULL) {
                    break;
                }
                ((char *) new_vector->data)[i] = ((char *) data)[i];
            }
            for (int i = min_len; i < length; i++) {
                ((char *) new_vector->data)[i] = 0;
            }
            break;
        }
        case VECTOR_TYPE_VOID: {
            new_vector->data = (void *) calloc(length, sizeof(void *));
            if (new_vector->data == NULL) {
                vector_free_p(&new_vector);
                PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector->data), __FILE__, __FUNCTION__, __LINE__);
            }
            if (0 == min_len) {
                break;
            }
            memcpy(new_vector->data, data, min_len * sizeof(void *));
            break;
        }
        default: {
            PERROR(TYPE_ERROR_001, VAR_NAME(type), __FILE__, __FUNCTION__, __LINE__);
        }
    }
    new_vector->type = type;
    new_vector->length = length;
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
 * @param vector A pointer to the vector to be printed.
 *
 * @return None
 *
 * @throws INPUT_NULL_007 if the vector is NULL or its data is NULL.
 * @throws TYPE_ERROR_001 if the vector type is not supported.
 */
void vector_print_p(const Vector *vector) {
    if (vector == NULL || vector->data == NULL) {
        PWARNING_RETURN_NO_NULL(INPUT_NULL_007, VAR_NAME(vector), VAR_NAME(vector->data), __FILE__, __FUNCTION__,
                                __LINE__);
    }
    const int len = vector->length;
    switch (vector->type) {
        case VECTOR_TYPE_INT: {
            const int *tmp = (int *) vector->data;
            printf("[");
            if (len > VECTOR_DEAFAULT_PRINT_LENTH_LIMIT) {
                for (int i = 0; i < len; i++) {
                    if (i == 2) {
                        printf("...\t");
                        i = len - 2;
                    }
                    printf("%d\t", tmp[i]);
                }
                printf("]\n");
                break;
            }
            for (int i = 0; i < len; i++) {
                printf("%d ", tmp[i]);
            }
            printf("]\n");
            break;
        }
        case VECTOR_TYPE_FLOAT: {
            const float *tmp = (float *) vector->data;
            printf("[");
            if (len > VECTOR_DEAFAULT_PRINT_LENTH_LIMIT) {
                for (int i = 0; i < len; i++) {
                    if (i == 2) {
                        printf("...\t");
                        i = len - 2;
                    }
                    printf("%.6f\t", tmp[i]);
                }
                printf("]\n");
                break;
            }
            for (int i = 0; i < len; i++) {
                printf("%.6f\t", tmp[i]);
            }
            printf("]\n");
            break;
        }
        case VECTOR_TYPE_DOUBLE: {
            const double *tmp = (double *) vector->data;
            printf("[");
            if (len > VECTOR_DEAFAULT_PRINT_LENTH_LIMIT) {
                for (int i = 0; i < len; i++) {
                    if (i == 2) {
                        printf("...\t");
                        i = len - 2;
                    }
                    printf("%.6lf\t", tmp[i]);
                }
                printf("]\n");
                break;
            }
            for (int i = 0; i < len; i++) {
                printf("%.6lf\t ", tmp[i]);
            }
            printf("]\n");
            break;
        }
        case VECTOR_TYPE_CHAR: {
            printf("[");
            const char *tmp = (char *) vector->data;
            if (len > VECTOR_DEAFAULT_PRINT_LENTH_LIMIT) {
                for (int i = 0; i < len; i++) {
                    if (i == 2) {
                        printf("...\t");
                        i = len - 2;
                    }
                    printf("%c\t", tmp[i]);
                }
                printf("]\n");
                break;
            }
            for (int i = 0; i < len; i++) {
                printf("%c\t", tmp[i]);
            }
            printf("]\n");
            break;
        }
        default: {
            PERROR(TYPE_ERROR_001, VAR_NAME(vector->type), __FILE__, __FUNCTION__, __LINE__);
        }
    }
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
    if (forward == NULL || backward == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(forward), VAR_NAME(backward), __FILE__, __FUNCTION__, __LINE__);
    }
    if (forward->type != backward->type) {
        PERROR(TYPE_ERROR_002, VAR_NAME(forward->type), VAR_NAME(backward->type), __FILE__, __FUNCTION__,
               __LINE__);
    }
    Vector *new_vector = vector_gen_p(forward->length + backward->length, NULL, forward->type);
    if (new_vector == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(new_vector), __FILE__, __FUNCTION__, __LINE__);
    }
    switch (new_vector->type) {
        case VECTOR_TYPE_INT: {
            int *tmp = (int *) new_vector->data;
            memcpy(tmp, forward->data, forward->length * sizeof(int));
            memcpy(tmp + forward->length, backward->data, backward->length * sizeof(int));
            break;
        }
        case VECTOR_TYPE_FLOAT: {
            float *tmp = (float *) new_vector->data;
            memcpy(tmp, forward->data, forward->length * sizeof(float));
            memcpy(tmp + forward->length, backward->data, backward->length * sizeof(float));
            break;
        }
        case VECTOR_TYPE_DOUBLE: {
            double *tmp = (double *) new_vector->data;
            memcpy(tmp, forward->data, forward->length * sizeof(double));
            memcpy(tmp + forward->length, backward->data, backward->length * sizeof(double));
            break;
        }
        case VECTOR_TYPE_CHAR: {
            char *tmp = (char *) new_vector->data;
            memcpy(tmp, forward->data, forward->length * sizeof(char));
            memcpy(tmp + forward->length, backward->data, backward->length * sizeof(char));
            break;
        }
        default: {
            PERROR(TYPE_ERROR_001, VAR_NAME(new_vector->type), __FILE__, __FUNCTION__, __LINE__);
        }
    }
    return new_vector;
}

/**
 * Copy the content of @p src_vec to @p dst_vec, and free @p src_vec.
 *
 * @param src_vec The source vector.
 * @param dst_vec The destination vector.
 *
 * @throws INPUT_NULL_005 if either of the two input vectors is NULL.
 * @throws MALLOC_FAILURE_001 if memory allocation fails.
 */
void vector_copy_free_p(Vector **src_vec, Vector *dst_vec) {
    if (*src_vec == NULL || (*src_vec)->data == NULL) {
        PWARNING_RETURN_NO_NULL(INPUT_NULL_005, VAR_NAME(src_vec), VAR_NAME(src_vec->data), __FILE__, __FUNCTION__,
                                __LINE__);
    }
    if (dst_vec != NULL) {
        vector_free_p(&dst_vec);
    }
    dst_vec = vector_gen_p((*src_vec)->length, (*src_vec)->data, (*src_vec)->type);
    if (dst_vec == NULL) {
        PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(dst_vec), __FILE__, __FUNCTION__, __LINE__);
    }
    vector_free_p(src_vec);
}

/**
 * Copy the content of @p src_vec to a new vector.
 *
 * @param src_vec The source vector.
 *
 * @return A new vector that is the copy of the source vector.
 *
 * @throws INPUT_NULL_005 if either of the input vectors is NULL.
 * @throws MALLOC_FAILURE_001 if memory allocation fails.
 */
Vector *vector_copy_p(const Vector *src_vec) {
    if (src_vec == NULL || src_vec->data == NULL) {
        PWARNING_RETURN(INPUT_NULL_005, VAR_NAME(src_vec), VAR_NAME(src_vec->data), __FILE__, __FUNCTION__,
                        __LINE__);
    }
    Vector *det_vec = vector_gen_p(src_vec->length, src_vec->data, src_vec->type);
    if (det_vec == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(det_vec), __FILE__, __FUNCTION__, __LINE__);
    }
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
 * @param vector A pointer to a pointer to the Vector instance to be freed.
 *
 * @throws None.
 */
void vector_free(Vector **vector) {
    if (vector == NULL || *vector == NULL) {
        return;
    }
    if ((*vector)->data == NULL) {
        FREE(*vector);
        return;
    }
    FREE((*vector)->data);
    FREE(*vector);
}

/**
 * Prints the contents of a vector to the console.
 *
 * @param vector A pointer to the vector to be printed.
 *
 * @return None
 *
 * @throws INPUT_NULL_007 if the vector is NULL or its data is NULL.
 */
void vector_print(const Vector *vector) {
    if (vector == NULL || vector->data == NULL) {
        PWARNING_RETURN_NO_NULL(INPUT_NULL_007, VAR_NAME(vector), VAR_NAME(vector->data), __FILE__, __FUNCTION__,
                                __LINE__);
    }
    const int len = vector->length;
    printf("[");
    if (len > VECTOR_DEAFAULT_PRINT_LENTH_LIMIT) {
        for (int i = 0; i < len; i++) {
            if (i == 2) {
                printf("...\t");
                i = len - 2;
            }
            printf(VECTOR_DEFAULT_PRECISION, ((VECTOR_DEAFAULT_TYPE *) vector->data)[i]);
        }
        printf("]\n");
    } else {
        for (int i = 0; i < len; i++) {
            printf(VECTOR_DEFAULT_PRECISION, ((VECTOR_DEAFAULT_TYPE *) vector->data)[i]);
        }
        printf("]\n");
    }
    printf("vector: length: %d, type: %s\n", vector->length, "double");
}
