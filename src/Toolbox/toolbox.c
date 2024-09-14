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
 * @headerfile toolbox.h
 */

#include <stdlib.h>
#include "stack.h"
#include "toolbox.h"

/**
 * Checks if an element is a member of a collection.
 *
 * This function iterates over a collection of elements and checks if a given
 * element is present in the collection. The comparison is done using a custom
 * comparison function provided by the user.
 *
 * @param ptr        The element to search for in the collection.
 * @param base       The base address of the collection.
 * @param elemSize   The size of each element in the collection.
 * @param count      The number of elements in the collection.
 * @param cmp        A custom comparison function that takes two void pointers
 *                   as arguments and returns an integer indicating whether the
 *                   elements are equal.It should return 1 if the elements are
 *                   equal and 0 if they are not.
 *
 * @return 1 if the element is found in the collection, 0 if not found, and -1
 *         if any of the input parameters are invalid.
 */
inline int isMember(const void *ptr, const void *base, size_t elemSize, size_t count,
                    int (*cmp)(const void *, const void *)) {
    // Check for invalid input parameters
    if (ptr == NULL || base == NULL || elemSize == 0 || count == 0 || cmp == NULL) {
        // Return -1 to indicate an error
        return -1;
    }

    // Iterate over the collection
    for (size_t i = 0; i < count; i++) {
        // Compare the current element with the given element using the custom comparison function
        if (cmp(ptr, (char *) base + i * elemSize)) {
            // Return 1 if the element is found
            return 1;
        }
    }

    // Return 0 if the element is not found in the collection
    return 0;
}

/**
 * Returns a new stack containing unique elements from the given base array.
 *
 * The uniqueness of elements is determined by the custom comparison function `cmp`.
 *
 * @param base The base array to extract unique elements from.
 * @param elemSize The size of each element in the base array.
 * @param count The number of elements in the base array.
 * @param cmp A custom comparison function that takes two void pointers
 *            as arguments and returns an integer indicating whether the
 *            elements are equal.It should return 1 if the elements are
 *            equal and 0 if they are not.
 *
 * @return A new stack containing unique elements, or NULL if any input parameters are invalid.
 */
inline Stack *getUniqueStackFromArray(const void *base, size_t elemSize, size_t count,
                                      int (*cmp)(const void *, const void *)) {
    // Check for invalid input parameters
    if (base == NULL || elemSize == 0 || count == 0 || cmp == NULL) {
        // Return NULL to indicate an error
        return NULL;
    }

    // Initialize a new stack to store unique elements
    Stack *new_stack = stackInit();

    // Iterate over the base array
    for (size_t i = 0; i < count; i++) {
        // Calculate the address of the current element
        char *ptr = (char *) base + i * elemSize;

        // Create a new element with the current address and size
        const stackElemWithSize new_elem = {ptr, elemSize};

        // Check if the new element is already in the stack
        if (isStackMember(new_stack, new_elem, cmp) == 0 || isStackEmpty(new_stack)) {
            // Push the new element onto the stack if it's not already present
            stackPush(new_stack, ptr, elemSize);
        }
    }

    // Return the new stack containing unique elements
    return new_stack;
}

/**
 * Returns a unique array of elements from the given base array.
 *
 * The uniqueness of elements is determined by the custom comparison function `cmp`.
 *
 * @param base The base array to extract unique elements from.
 * @param elemSize The size of each element in the base array.
 * @param count The number of elements in the base array.
 * @param cmp A custom comparison function that takes two void pointers
 *            as arguments and returns an integer indicating whether the
 *            elements are equal. It should return 1 if the elements are
 *            equal and 0 if they are not.
 *
 * @return A unique array of elements, or NULL if any input parameters are invalid.
 */
inline void *getUniqueArrayFromArray(const void *base, size_t elemSize, size_t count,
                                     int (*cmp)(const void *, const void *)) {
    // Get a stack of unique elements from the base array
    Stack *uniqueStack = getUniqueStackFromArray(base, elemSize, count, cmp);

    // Check if the stack is not NULL
    if (uniqueStack != NULL) {
        // Convert the stack to an array
        void *uniqueArray = stackToArray(uniqueStack);

        // Destroy the stack to free memory
        stackDestroy(&uniqueStack);

        // Return the unique array
        return uniqueArray;
    }

    // Return NULL if any input parameters are invalid
    return NULL;
}
