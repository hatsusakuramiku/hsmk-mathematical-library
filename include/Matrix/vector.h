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
 * @file vector.c
 */

#ifndef _HSMK_MATH_LIB_VECTOR_H
#define _HSMK_MATH_LIB_VECTOR_H

#define VECTOR_DEAFAULT_TYPE double
#define VECTOR_DEAFAULT_PRINT_LENTH_LIMIT 20
#define VECTOR_DEFAULT_PRECISION "%.6lf\t" /// matrix default precision

enum VectorType {
    VECTOR_TYPE_INT, /// int
    VECTOR_TYPE_FLOAT, /// float
    VECTOR_TYPE_DOUBLE, /// double
    VECTOR_TYPE_CHAR, /// char
    VECTOR_TYPE_VOID /// void, need user defined
};

typedef struct _Vector {
    void *data;
    unsigned int length;
    enum VectorType type;
} Vector;

Vector *vector_p(const unsigned int length, const void *data, const enum VectorType type);

// Paradigm support function
Vector *vector_gen_p(const unsigned int length, const void *data, const enum VectorType type);

void vector_free_p(Vector **vector);

void vector_print_p(const Vector *vector);

Vector *_vector_splicing_p(const Vector *forward, const Vector *backward);

void vector_splicing_p(Vector *forward, const Vector *backward);

Vector *vector_copy_p(const Vector *vector);

void _vector_copy_p(const Vector *src_vec, Vector *dst_vec);

void vector_copy_free_p(Vector **src_vec, Vector *dst_vec);

// Deafault type support function
static enum VectorType __gen_type();

Vector *vector(const unsigned int length, const VECTOR_DEAFAULT_TYPE *data);

Vector *vector_gen(const unsigned int length, const VECTOR_DEAFAULT_TYPE *data);

void vector_free(Vector **vector);

void vector_print(const Vector *vector);

Vector *_vector_splicing(const Vector *forward, const Vector *backward);

void vector_splicing(Vector *forward, const Vector *backward);
#endif //_HSMK_MATH_LIB_VECTOR_H
