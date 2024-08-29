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
 * @brief Creates a new Pair object with the specified left and right elements.
 *
 * This function dynamically allocates memory for a new Pair object and initializes
 * its left and right elements with the provided values.
 *
 * @param left The left element of the pair.
 * @param right The right element of the pair.
 *
 * @return A pointer to the newly created Pair object, or NULL if memory allocation fails.
 *
 * @throws MALLOC_FAILURE_002 If memory allocation fails.
 */
Pair *make_pair(pair_element_t left, pair_element_t right) {
    // Dynamically allocate memory for a new Pair object
    Pair *pair = (Pair *) malloc(sizeof(Pair));

    // Check if memory allocation failed
    if (pair == NULL) {
        // Print a warning message and return NULL
        PWARNING_RETURN_MALLOC(pair);
    }

    // Set the left and right elements of the Pair object
    pair->left = left;
    pair->right = right;

    // Return the newly created Pair object
    return pair;
}

/**
 * Swaps the left and right elements of a Pair object.
 *
 * This function takes a pointer to a Pair object as input and swaps its left and right elements.
 * If the input Pair object is NULL, the function returns immediately without performing any operation.
 *
 * @param pair The Pair object whose elements are to be swapped.
 *
 * @return None
 *
 * @throws None
 */
void swap_pair(Pair *pair) {
    // Check if the input Pair object is NULL to prevent null pointer dereferences
    if (pair == NULL) {
        // If the Pair object is NULL, return immediately without performing any operation
        return;
    }

    // Create a temporary variable to hold the value of the left element
    pair_element_t temp = pair->left;

    // Swap the left and right elements of the Pair object
    pair->left = pair->right; // Assign the value of the right element to the left element
    pair->right = temp; // Assign the value of the temporary variable to the right element
}

/**
 * Frees the memory allocated for a Pair object and its elements.
 *
 * This function checks if the Pair object and its elements are not NULL before attempting to free them.
 * It is safe to call this function with a NULL Pair object, as it will simply return without doing anything.
 *
 * @param pair The Pair object to be freed.
 *
 * @return None
 *
 * @throws None
 */
void free_pair(Pair *pair) {
    // Check if the Pair object is NULL before attempting to free it
    if (pair == NULL) {
        // If the Pair object is NULL, return immediately
        return;
    }

    // Check if the left element of the Pair object is not NULL before attempting to free it
    if (pair->left != NULL) {
        // Free the left element of the Pair object
        FREE(pair->left);
    }

    // Check if the right element of the Pair object is not NULL before attempting to free it
    if (pair->right != NULL) {
        // Free the right element of the Pair object
        FREE(pair->right);
    }

    // Finally, free the Pair object itself
    FREE(pair);
}
