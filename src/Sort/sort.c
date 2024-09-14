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
 * @headerfile sort.h
 */

#include <stdio.h>
#include "sort.h"
#include "constDef.h"
#include "memswap.h"
#include "stdlib.h"

// 默认比较函数

/**
 * Compares two double values.
 *
 * This function takes two void pointers to double values as input, compares them,
 * and returns an integer indicating their relative order.
 *
 * @param a The first double value.
 * @param b The second double value.
 *
 * @return -1 if a is less than b, 1 if a is greater than b, and 0 if a is equal to b.
 */
int default_compare_example(const void *a, const void *b) {
    // Cast the void pointers to double pointers to access the double values
    const double p1 = *(double *) a;
    const double p2 = *(double *) b;

    // Compare the double values
    if (p1 < p2) {
        // If p1 is less than p2, return -1
        return -1;
    } else if (p1 > p2) {
        // If p1 is greater than p2, return 1
        return 1;
    } else {
        // If p1 is equal to p2, return 0
        return 0;
    }
}

/**
 * Compares two double values referenced by pointers.
 *
 * This function takes two void pointers to double values and an additional argument,
 * which is used as an index to access the double values. It compares the double values
 * at the specified index and returns an integer indicating their relative order.
 *
 * @param arg The index to access the double values.
 * @param a The first double value referenced by a pointer.
 * @param b The second double value referenced by a pointer.
 *
 * @return -1 if a is less than b, 1 if a is greater than b, and 0 if a is equal to b.
 *
 * @throws None
 */
int default_compare_example_s(const void *a, const void *b, const void *arg) {
    // Cast the void pointers to double pointers to access the double values
    const double *p1 = *(double **) a;
    const double *p2 = *(double **) b;

    // Extract the index from the arg parameter
    const int index = (uintptr_t) arg;

    // Compare the double values at the specified index
    if (p1[index] < p2[index]) {
        // If p1 is less than p2, return -1
        return -1;
    } else if (p1[index] > p2[index]) {
        // If p1 is greater than p2, return 1
        return 1;
    } else {
        // If p1 is equal to p2, return 0
        return 0;
    }
}

/**
 * Recursively sorts an array of elements using the quicksort algorithm.
 *
 * @param array The array to be sorted.
 * @param arg Additional argument to be passed to the comparison function.
 * @param elemNum The number of elements in the array.
 * @param elemSize The size of each element in the array.
 * @param compare The comparison function used to determine the order of elements.
 *
 * @return None
 *
 * @throws None
 */
void quickSort_s(void *const array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg) {
    if (elemNum <= 1) {
        return;
    }
    mergeSort_s(array, elemNum, elemSize, compare, arg);
}

/**
 * Sorts an array of elements using the quicksort algorithm.
 *
 * @param array The array to be sorted.
 * @param elemNum The number of elements in the array.
 * @param elemSize The size of each element in the array.
 * @param compare A function that compares two elements.
 *
 * @return None
 */
void quickSort(void *array, size_t elemNum, size_t elemSize, default_compare compare) {
    return quickSort_s(array, elemNum, elemSize, (default_compare_s) compare, NULL);
}

/// Quick sort block end

/**
 * Sorts an array of elements using the bubble sort algorithm.
 *
 * @param array The array to be sorted.
 * @param elemNum The number of elements in the array.
 * @param elemSize The size of each element in the array.
 * @param compare A function that compares two elements.
 *
 * @return None
 */
void bubbleSort(void *array, size_t elemNum, size_t elemSize, default_compare compare) {
    // If the array has less than 2 elements or is NULL, return early
    if (elemNum <= 1 || array == NULL) {
        return;
    }

    // Loop through the array
    for (size_t i = 0; i < elemNum; i++) {
        int flag = 0;

        // Loop through the unsorted part of the array
        for (size_t j = 0; j < elemNum - 1 - i; j++) {
            // Compare the current element with the next element
            if (compare((char *) array + j * elemSize, (char *) array + (j + 1) * elemSize) > 0) {
                // If the current element is greater than the next element, swap them
                __memswap((char *) array + j * elemSize, (char *) array + (j + 1) * elemSize, elemSize);
                flag = 1;
            }
        }

        // If no swaps were made in the last iteration, the array is already sorted
        if (!flag) {
            return;
        }
    }
}

/**
 * Recursively sorts an array of elements using the bubble sort algorithm.
 *
 * This function works by repeatedly swapping the adjacent elements if they are in wrong order.
 *
 * @param array The array to be sorted.
 * @param arg An additional argument to be passed to the comparison function.
 * @param elemNum The number of elements in the array.
 * @param elemSize The size of each element in the array.
 * @param compare A function that compares two elements.
 *
 * @return None
 */
void bubbleSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg) {
    // Base case: If the array has one or zero elements, it is already sorted.
    if (elemNum <= 1 || array == NULL) {
        return;
    }

    // Loop through the array, last element is already in place after each iteration.
    for (size_t i = 0; i < elemNum; i++) {
        // Initialize a flag to track if any swaps were made in the current iteration.
        int flag = 0;

        // Loop through the unsorted part of the array.
        for (size_t j = 0; j < elemNum - 1 - i; j++) {
            // Compare the current element with the next element.
            if (compare((char *) array + j * elemSize, (char *) array + (j + 1) * elemSize, arg) > 0) {
                // If the current element is greater than the next element, swap them.
                __memswap((char *) array + j * elemSize, (char *) array + (j + 1) * elemSize, elemSize);
                flag = 1; // Set the flag to indicate a swap was made.
            }
        }

        // If no swaps were made in the last iteration, the array is already sorted.
        if (!flag) {
            return;
        }
    }
}

/**
 * Sorts an array of elements using the insertion sort algorithm.
 *
 * @param array The array to be sorted.
 * @param elemNum The number of elements in the array.
 * @param elemSize The size of each element in the array.
 * @param compare A function that compares two elements.
 *
 * @return None
 *
 * @throws MALLOC_FAILURE_002 If memory allocation fails.
 */
void insertionSort(void *array, size_t elemNum, size_t elemSize, default_compare compare) {
    return insertionSort_s(array, elemNum, elemSize, (default_compare_s) compare, NULL);
}

/**
 * Recursively sorts an array of elements using the insertion sort algorithm.
 *
 * This function takes an array, its size, the size of each element, and a comparison function as input.
 * It sorts the array in-place using the insertion sort algorithm.
 *
 * @param array The array to be sorted.
 * @param arg An additional argument to be passed to the comparison function.
 * @param elemNum The number of elements in the array.
 * @param elemSize The size of each element in the array.
 * @param compare A function that compares two elements.
 *
 * @return None
 *
 * @throws MALLOC_FAILURE_002 If memory allocation fails.
 */
void insertionSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg) {
    // Check for invalid input
    if (elemNum <= 1 || array == NULL || compare == NULL) {
        // If the array has one or zero elements, it is already sorted
        // If the array is NULL or the comparison function is NULL, return immediately
        return;
    }

    // Allocate memory for a temporary key
    char *key = (char *) malloc(sizeof(char) * elemSize);
    PWARNING_RETURN_MALLOC_NO_NULL(key); // Check for memory allocation failure

    // Iterate over the array starting from the second element
    for (size_t i = 1; i < elemNum; ++i) {
        // Swap the current element with the temporary key
        __memswap(key, (char *) array + i * elemSize, elemSize);

        // Initialize the index for the inner loop
        size_t j = i - 1;

        // Shift elements to the right until the correct position for the key is found
        while (compare((char *) array + j * elemSize, key, arg) > 0) {
            // Swap the current element with the next element
            __memswap((char *) array + j * elemSize, (char *) array + (j + 1) * elemSize, elemSize);
            j--; // Decrement the index
        }

        // Swap the key with the element at the correct position
        __memswap((char *) array + (j + 1) * elemSize, key, elemSize);
    }

    // Free the memory allocated for the temporary key
    FREE(key);
}

/**
 * Sorts an array of elements using the selection sort algorithm.
 *
 * @param array The array to be sorted.
 * @param elemNum The number of elements in the array.
 * @param elemSize The size of each element in the array.
 * @param compare A function that compares two elements.
 *
 * @return None
 *
 * @throws None
 */
void selectionSort(void *array, size_t elemNum, size_t elemSize, default_compare compare) {
    return selectionSort_s(array, elemNum, elemSize, (default_compare_s) compare, NULL);
}

/**
 * Recursively sorts an array of elements using the selection sort algorithm.
 *
 * This function works by repeatedly finding the minimum element from the unsorted part of the array
 * and swapping it with the first unsorted element.
 *
 * @param array The array to be sorted.
 * @param arg An additional argument to be passed to the comparison function.
 * @param elemNum The number of elements in the array.
 * @param elemSize The size of each element in the array.
 * @param compare A function that compares two elements.
 *
 * @return None
 *
 * @throws None
 */
void selectionSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg) {
    // Base case: If the array has one or zero elements, it is already sorted.
    if (elemNum <= 1 || array == NULL || compare == NULL) {
        return;
    }

    // Iterate over the array, considering each element as the start of the unsorted part.
    for (size_t i = 0; i < elemNum - 1; i++) {
        // Initialize the index of the minimum element to the current index.
        size_t min = i;

        // Find the minimum element in the unsorted part of the array.
        for (size_t j = i + 1; j < elemNum; j++) {
            // Compare the current element with the minimum element found so far.
            if (compare((char *) array + j * elemSize, (char *) array + min * elemSize, arg) < 0) {
                // Update the index of the minimum element if a smaller element is found.
                min = j;
            }
        }

        // Swap the minimum element with the first unsorted element.
        __memswap((char *) array + i * elemSize, (char *) array + min * elemSize, elemSize);
    }
}

/**
 * Merge two sorted halves of an array into a single sorted array.
 *
 * This function takes a pointer to the array, the midpoint of the array, the size of each element,
 * the total number of elements, a comparison function, and an argument for the comparison function.
 *
 * It creates temporary arrays to store the left and right halves, copies the data into these arrays,
 * merges the sorted halves into the original array, and then frees the temporary arrays.
 *
 * @param array The array to be merged.
 * @param mid The midpoint of the array.
 * @param elemSize The size of each element in the array.
 * @param elemNum The total number of elements in the array.
 * @param compare A function that compares two elements.
 * @param arg An argument for the comparison function.
 *
 * @return None.
 */
static inline void merge(void *array, size_t mid, size_t elemSize, size_t elemNum, default_compare_s compare,
                         void *arg) {
    // Create temporary arrays to store the left and right halves
    void *left = malloc(mid * elemSize);
    void *right = malloc((elemNum - mid) * elemSize);

    // Check for memory allocation errors
    PWARNING_RETURN_MALLOC_NO_NULL(VAR_NAME(left));
    PWARNING_RETURN_MALLOC_NO_NULL(VAR_NAME(right));


    // Copy the left and right halves into the temporary arrays
    memcpy(left, array, mid * elemSize);
    memcpy(right, (char *) array + mid * elemSize, (elemNum - mid) * elemSize);

    // Merge the sorted left and right halves into the original array
    size_t i = 0, j = 0, k = 0;
    while (i < mid && j < elemNum - mid) {
        // Compare the current elements of the left and right halves
        if (compare((char *) left + i * elemSize, (char *) right + j * elemSize, arg) <= 0) {
            // Copy the smaller element into the original array
            memcpy((char *) array + k * elemSize, (char *) left + i * elemSize, elemSize);
            i++;
        } else {
            // Copy the larger element into the original array
            memcpy((char *) array + k * elemSize, (char *) right + j * elemSize, elemSize);
            j++;
        }
        k++;
    }

    // Copy any remaining elements from the left or right halves
    while (i < mid) {
        // Copy the remaining elements from the left half
        memcpy((char *) array + k * elemSize, (char *) left + i * elemSize, elemSize);
        i++;
        k++;
    }
    while (j < elemNum - mid) {
        // Copy the remaining elements from the right half
        memcpy((char *) array + k * elemSize, (char *) right + j * elemSize, elemSize);
        j++;
        k++;
    }

    // Free the temporary arrays
    free(left);
    free(right);
}

/**
 * Sorts an array using the merge sort algorithm.
 *
 * This function recursively divides the array into two halves until each half has
 * one or zero elements, and then merges the halves back together in sorted order.
 *
 * @param array     The array to be sorted.
 * @param elemNum   The number of elements in the array.
 * @param elemSize  The size of each element in the array.
 * @param compare   A comparison function that takes two elements and returns a
 *                  negative value if the first element is less than the second,
 *                  zero if the elements are equal, and a positive value if the
 *                  first element is greater than the second.
 * @param arg       An optional argument that can be passed to the comparison
 *                  function.
 *
 * @return None.
 */
void mergeSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg) {
    // Check for invalid input or base case
    // If the array has one or zero elements, it is already sorted
    if (elemNum <= 1 || array == NULL || elemSize == 0 || compare == NULL) {
        // No need to sort, return immediately
        return;
    }

    // Test if memory allocation is possible
    void *memTest = malloc(elemNum * elemSize);
    if (memTest == NULL) {
        // If memory allocation fails, print an error message and fall back to heap sort
        printf("Error: Unable to allocate memory for merge sort.\nWill sort by heap sort.\n");
        return heapSort_s(array, elemNum, elemSize, compare, arg);
    }
    // Free the test memory allocation
    FREE(memTest);

    // Calculate the middle index to divide the array into two halves
    size_t mid = elemNum / 2;

    // Recursively sort the left and right halves of the array
    // Sort the left half
    mergeSort_s(array, mid, elemSize, compare, arg);
    // Sort the right half
    mergeSort_s((char *) array + mid * elemSize, elemNum - mid, elemSize, compare, arg);

    // Merge the sorted left and right halves back together
    merge(array, mid, elemSize, elemNum, compare, arg);
}

/**
 * @brief Sorts an array of elements using the merge sort algorithm.
 *
 * This function sorts an array of elements using the merge sort algorithm.
 * It takes in the array to be sorted, the number of elements in the array,
 * the size of each element, and a comparison function to determine the order
 * of the elements.
 *
 * @param array The array to be sorted.
 * @param elemNum The number of elements in the array.
 * @param elemSize The size of each element in the array.
 * @param compare The comparison function used to determine the order of elements.
 *
 * @return None
 *
 * @throws None
 */
void mergeSort(void *array, size_t elemNum, size_t elemSize, default_compare compare) {
    // Cast the comparison function to the correct type
    default_compare_s compare_s = (default_compare_s) compare;

    // Call the mergeSort_s function with the provided arguments and a NULL argument
    mergeSort_s(array, elemNum, elemSize, compare_s, NULL);
}

/**
 * Heapifies a subtree rooted at index i in the given array.
 *
 * This function ensures that the heap property is maintained in the subtree,
 * i.e., the parent node is either greater than (in a max heap) or less than
 * (in a min heap) its child nodes.
 *
 * @param array The array to heapify.
 * @param elemNum The number of elements in the array.
 * @param i The index of the root of the subtree to heapify.
 * @param elemSize The size of each element in the array.
 * @param compare The comparison function used to determine the order of elements.
 * @param arg An optional argument passed to the comparison function.
 *
 * @return None.
 */
static inline void heapify_s(void *array, size_t elemNum, size_t i, size_t elemSize, default_compare_s compare,
                             void *arg) {
    // Initialize the largest element as the root of the subtree
    size_t largest = i;

    // Calculate the indices of the left and right child nodes
    size_t left = 2 * i + 1;
    size_t right = 2 * i + 2;

    // Check if the left child node exists and is greater than the current largest element
    if (left < elemNum && compare((char *) array + left * elemSize, (char *) array + largest * elemSize, arg) > 0) {
        // Update the largest element if the left child node is greater
        largest = left;
    }

    // Check if the right child node exists and is greater than the current largest element
    if (right < elemNum && compare((char *) array + right * elemSize, (char *) array + largest * elemSize, arg) > 0) {
        // Update the largest element if the right child node is greater
        largest = right;
    }

    // If the largest element is not the root, swap them and recursively heapify the affected subtree
    if (largest != i) {
        // Swap the elements at indices i and largest
        __memswap((char *) array + i * elemSize, (char *) array + largest * elemSize, elemSize);

        // Recursively heapify the subtree rooted at the new largest element
        heapify_s(array, elemNum, largest, elemSize, compare, arg);
    }
}

/**
 * Constructs a heap from the given array.
 *
 * This function iterates over the array from the last non-leaf node to the root,
 * heapifying each subtree to ensure the heap property is maintained.
 *
 * @param array     The array to be converted into a heap.
 * @param elemNum   The number of elements in the array.
 * @param elemSize  The size of each element in the array.
 * @param compare   A comparison function that takes two elements and returns a
 *                  value indicating their relative order.
 * @param arg       An optional argument passed to the comparison function.
 *
 * @return None.
 */
static void buildHeap_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg) {
    // Handle edge case where array is empty or has only one element
    if (elemNum <= 0) {
        return;
    }

    // Calculate the index of the last non-leaf node
    size_t k = elemNum / 2 - 1;

    // Iterate over the array from the last non-leaf node to the root
    while (1) {
        // Heapify the subtree rooted at index k
        heapify_s(array, elemNum, k, elemSize, compare, arg);

        // Decrement k and check if we've reached the root
        if (k-- == 0) {
            break;
        }
    }
}

/**
 * Sorts an array using the heap sort algorithm.
 *
 * This function constructs a heap from the array, then repeatedly removes the
 * largest element from the heap and places it at the end of the array.
 *
 * @param array     The array to be sorted.
 * @param elemNum   The number of elements in the array.
 * @param elemSize  The size of each element in the array.
 * @param compare   A comparison function that takes two elements and returns a
 *                  negative value if the first element is less than the second,
 *                  zero if the elements are equal, and a positive value if the
 *                  first element is greater than the second.
 * @param arg       An optional argument that can be passed to the comparison
 *                  function.
 *
 * @return None.
 */
void heapSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg) {
    if (array == NULL || elemNum == 0 || elemSize == 0 || compare == NULL) {
        return;
    }
    const size_t tmp = elemNum;

    buildHeap_s(array, elemNum, elemSize, compare, arg);
    // Repeatedly remove the largest element from the heap and place it at the end
    // of the array
    while (1) {
        if (elemNum == 1) {
            break;
        }
        __memswap((char *) array, (char *) array + elemSize * (elemNum - 1), elemSize);
        elemNum--;
        heapify_s(array, elemNum, 0, elemSize, compare, arg);
    }
}

/**
 * Wraps the heapSort_s function to provide a simpler interface.
 *
 * This function sorts an array of elements using the heap sort algorithm.
 *
 * @param array     The array to be sorted.
 * @param elemNum   The number of elements in the array.
 * @param elemSize  The size of each element in the array.
 * @param compare   A comparison function that takes two elements and returns a
 *                  value indicating their relative order.
 *
 * @return None
 */
void heapSort(void *array, size_t elemNum, size_t elemSize, default_compare compare) {
    // Call the heapSort_s function with the provided arguments and a NULL arg
    return heapSort_s(array, elemNum, elemSize, (default_compare_s) compare, NULL);
}
