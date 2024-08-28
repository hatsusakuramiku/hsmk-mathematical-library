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

#include "constDef.h"
#include "pair.h"
#include <stdio.h>
#include <stdlib.h>


/**
 * Creates a new Pair object with the specified left and right elements.
 *
 * @param left The left element of the pair.
 * @param right The right element of the pair.
 *
 * @return A pointer to the newly created Pair object, or NULL if memory allocation fails.
 *
 * @throws MALLOC_FAILURE_002 If memory allocation fails.
 */
Pair* make_pair(pair_element_t left, pair_element_t right) {
    Pair* pair = (Pair*)malloc(sizeof(Pair));
    if (pair == NULL) {
        PWARNING_RETURN_MALLOC(pair);
    }
    pair->left = left;
    pair->right = right;
    return pair;
}
/**
 * Swaps the left and right elements of a Pair object.
 *
 * @param pair The Pair object whose elements are to be swapped.
 *
 * @return None
 *
 * @throws None
 */
void swap_pair(Pair *pair) {
    if (pair == NULL) {
        return;
    }
    pair_element_t temp = pair->left;
    pair->left = pair->right;
    pair->right = temp;
}
/**
 * Frees the memory allocated for a Pair object and its elements.
 *
 * @param pair The Pair object to be freed.
 *
 * @return None
 *
 * @throws None
 */
void free_pair(Pair *pair) {
    if (pair == NULL) {
        return;
    }
    if (pair->left != NULL) {
        FREE(pair->left);
    }
    if (pair->right != NULL) {
        FREE(pair->right);
    }
    FREE(pair);
}