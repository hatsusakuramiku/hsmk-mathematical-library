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

#include <stdio.h>
#include "constDef.h"
#include "stack.h"
#include <stdlib.h>
#include <string.h>

#include "matrix.h"

/**
 * Initializes a new stack by allocating memory and setting its head and size.
 *
 * This function creates a new stack data structure and returns a pointer to it.
 * If memory allocation fails, it returns a NULL pointer and throws a warning.
 *
 * @return A pointer to the initialized stack, or NULL if memory allocation fails.
 *
 * @throws PWARNING_RETURN_MALLOC if memory allocation fails.
 */
Stack *stackInit() {
    // Allocate memory for the stack using malloc
    // The sizeof(Stack) operator returns the size of the Stack struct
    Stack *stack = (Stack *) malloc(sizeof(Stack));

    // Check if memory allocation failed
    if (stack == NULL) {
        // If allocation failed, throw a warning and return NULL
        PWARNING_RETURN_MALLOC(stack);
    }

    // Initialize the stack's head and size
    // The head is set to NULL, indicating an empty stack
    stack->head = NULL;

    // The size is set to 0, indicating an empty stack
    stack->size = 0;

    // Initialize the stack's tail pointer
    // The tail pointer is used to keep track of the last element in the stack
    stack->tail = NULL;

    // Return the pointer to the initialized stack
    return stack;
}

/**
 * Clears the contents of a stack by popping all elements.
 *
 * This function iteratively removes all elements from the stack until it is empty.
 *
 * @param stack The stack to be cleared.
 *
 * @return None
 *
 * @throws None
 */
void stackClear(Stack *stack) {
    // Check if the stack is NULL to prevent potential crashes
    if (stack == NULL) {
        // If the stack is NULL, there's nothing to clear, so return immediately
        return;
    }

    // Continue popping elements from the stack until it's empty
    while (stackSize(stack) > 0) {
        // Pop the top element from the stack
        stackPop(stack);
    }
}

/**
 * Destroys a stack by clearing its contents and freeing the allocated memory.
 *
 * This function takes a double pointer to the stack as an argument, allowing it to
 * modify the original pointer and set it to NULL after destruction.
 *
 * @param stack A double pointer to the stack to be destroyed.
 *
 * @return None.
 *
 * @throws None.
 */
void stackDestroy(Stack **stack) {
    // Check if the stack or its contents are NULL to prevent potential crashes
    if (stack == NULL || *stack == NULL) {
        // If either is NULL, there's nothing to destroy, so return immediately
        return;
    }

    // Clear the contents of the stack to prevent memory leaks
    stackClear(*stack);

    // Free the allocated memory for the stack
    FREE(*stack);

    // Set the original pointer to NULL to prevent dangling pointers
    *stack = NULL;
}

/**
 * Pushes an element onto the top of the stack.
 *
 * This function creates a new node with the given element and adds it to the top of the stack.
 * If the stack is empty, it also sets the tail of the stack to the new node.
 *
 * @param stack The stack to push the element onto.
 * @param elem The element to be pushed onto the stack.
 * @param elemSize The size of the element in bytes.
 *
 * @return None
 *
 * @throws MALLOC_FAILURE_002 if memory allocation fails.
 */
void stackPush(Stack *stack, stackElem elem, size_t elemSize) {
    // Check if the stack is NULL to prevent potential crashes
    if (stack == NULL) {
        // If the stack is NULL, there's nothing to push onto, so return immediately
        return;
    }

    // Allocate memory for a new node
    StackNode *node = (StackNode *) malloc(sizeof(StackNode));
    if (node == NULL) {
        // If memory allocation fails, print a warning and return
        PWARNING_RETURN_MALLOC_NO_NULL(node);
    }

    // Allocate memory for the new element
    stackElem new_elem = malloc(elemSize);
    if (new_elem == NULL) {
        // If memory allocation fails, free the node and print a warning
        FREE(node);
        PWARNING_RETURN_MALLOC_NO_NULL(new_elem);
    }

    // Copy the element into the new memory location
    memcpy(new_elem, elem, elemSize);

    // Set up the new node
    node->data = new_elem;
    node->elemSize = elemSize;
    node->next = stack->head; // Set the next pointer to the current head of the stack

    // Update the stack's head and tail if necessary
    stack->head = node;
    if (stack->size == 0) {
        // If the stack was empty, set the tail to the new node
        stack->tail = node;
    }

    // Increment the stack's size
    stack->size++;
}

/**
 * Removes and returns the top element from the stack.
 *
 * This function checks if the stack is empty or null, and returns null in such cases.
 * Otherwise, it updates the stack's head and tail pointers, decrements the size, and
 * returns the top element.
 *
 * @param stack The stack from which to pop the element.
 *
 * @return The top element of the stack, or NULL if the stack is empty.
 *
 * @throws None.
 */
stackElem stackPop(Stack *stack) {
    // Check if the stack is null
    if (stack == NULL) {
        // If null, return null
        return NULL;
    }

    // Check if the stack is empty
    if (stack->size == 0) {
        // If empty, return null
        return NULL;
    }

    // Store the current head node
    StackNode *node = stack->head;

    // Update the stack's head pointer to the next node
    stack->head = node->next;

    // Decrement the stack's size
    stack->size--;

    // If the stack is now empty, update the tail pointer
    if (stack->size == 0) {
        // Set the tail pointer to null
        stack->tail = NULL;
    }

    // Extract the top element from the node
    stackElem elem = node->data;

    // Free the node's memory
    FREE(node);

    // Return the top element
    return elem;
}

/**
 * @brief Returns the bottom element of the stack.
 *
 * This function retrieves the bottom element of the stack.
 * If the stack is empty or NULL, it returns NULL.
 *
 * @param stack The stack from which to retrieve the bottom element.
 *
 * @return The bottom element of the stack, or NULL if the stack is empty.
 *
 * @throws None.
 */
stackElem stackBottom(Stack *stack) {
    // Check if the stack is NULL or empty
    if (stack == NULL || stack->size == 0) {
        // If the stack is empty or NULL, return NULL
        return NULL;
    }

    // Return the data of the last node in the stack
    return stack->tail->data;
}

/**
 * Returns the top element of the stack.
 *
 * This function checks if the stack is empty or null, and returns null in such cases.
 * Otherwise, it returns the data stored in the top element of the stack.
 *
 * @param stack The stack from which to retrieve the top element.
 *
 * @return The top element of the stack, or NULL if the stack is empty.
 *
 * @throws None.
 */
stackElem stackTop(Stack *stack) {
    // Check if the stack is null or empty
    if (stack == NULL || stack->size == 0) {
        // If null or empty, return null
        return NULL;
    }

    // Stack is not empty, return the data stored in the top element
    // The top element is stored in the 'head' node of the stack
    return stack->head->data;
}

/**
 * Returns the number of elements in the stack.
 *
 * This function checks if the provided stack is NULL, and returns -1 in such cases.
 * Otherwise, it returns the number of elements in the stack.
 *
 * @param stack The stack to retrieve the size from.
 *
 * @return The number of elements in the stack, or -1 if the stack is NULL.
 *
 * @throws None.
 */
int stackSize(Stack *stack) {
    // Check if the stack is NULL to prevent null pointer dereferences
    if (stack == NULL) {
        // If the stack is NULL, return -1 to indicate an error
        return -1;
    }

    // If the stack is not NULL, return the number of elements in the stack
    // The number of elements is stored in the 'size' member of the stack
    return stack->size;
}

/**
 * Reverses the order of elements in the stack.
 *
 * This function iterates through the stack, reversing the direction of the links
 * between nodes. The head and tail of the stack are also updated accordingly.
 *
 * @param stack The stack to be reversed.
 *
 * @return None.
 *
 * @throws None.
 */
void stackSwap(Stack *stack) {
    // Check if the stack is null or has less than 2 elements
    // In these cases, the stack is already "reversed" (i.e., no-op)
    if (stack == NULL || stack->size < 2) {
        return;
    }

    // Initialize pointers to keep track of the previous and current nodes
    StackNode *prev = NULL;
    StackNode *current = stack->head;
    StackNode *next = NULL;

    // Update the tail of the stack to point to the original head
    stack->tail = stack->head;

    // Iterate through the stack, reversing the direction of the links
    while (current != NULL) {
        // Store the next node in the list
        next = current->next;

        // Reverse the link of the current node
        current->next = prev;

        // Move the previous and current pointers forward
        prev = current;
        current = next;
    }

    // Update the head of the stack to point to the new first node
    stack->head = prev;
}

/**
 * Removes and returns the top element from the stack along with its size.
 *
 * This function checks if the stack is empty or null, and returns {NULL, 0} in such cases.
 * Otherwise, it updates the stack's head and tail pointers, decrements the size, and
 * returns the top element along with its size.
 *
 * @param stack The stack from which to pop the element.
 *
 * @return The top element of the stack along with its size, or {NULL, 0} if the stack is empty.
 *
 * @throws None.
 */
stackElemWithSize stackPopWithSize(Stack *stack) {
    // Check if the stack is null or empty
    if (stack == NULL || stack->size == 0) {
        // If null or empty, return {NULL, 0}
        stackElemWithSize tmp = {NULL, 0};
        return tmp;
    }

    // Extract the top element from the stack
    stackElemWithSize elem = {stack->head->data, stack->head->elemSize};

    // Store the current head node
    StackNode *node = stack->head;

    // Update the stack's head pointer to the next node
    stack->head = node->next;

    // Decrement the stack's size
    stack->size--;

    // If the stack is now empty, update the tail pointer
    if (stack->size == 0) {
        // Set the tail pointer to null
        stack->tail = NULL;
    }

    // Free the memory allocated for the node
    free(node);

    // Return the top element along with its size
    return elem;
}

/**
 * Returns the bottom element of the stack along with its size.
 *
 * This function retrieves the bottom element from the stack and returns it along with its size.
 * If the stack is empty, it returns {NULL, 0}.
 *
 * @param stack The stack from which to retrieve the bottom element.
 *
 * @return The bottom element of the stack along with its size, or {NULL, 0} if the stack is empty.
 *
 * @throws None.
 */
stackElemWithSize stackBotWithSizetom(Stack *stack) {
    // Check if the stack is null or empty
    if (stack == NULL || stack->size == 0) {
        // If null or empty, return a default value {NULL, 0}
        stackElemWithSize tmp = {NULL, 0}; // Initialize a default return value
        return tmp; // Return the default value
    }

    // Retrieve the bottom element from the stack
    // The bottom element is stored in the 'tail' node of the stack
    stackElemWithSize elem = {stack->tail->data, stack->tail->elemSize}; // Extract the bottom element

    // Return the bottom element along with its size
    return elem;
}

/**
 * Returns the top element of the stack along with its size.
 *
 * @param stack The stack from which to retrieve the top element.
 *
 * @return The top element of the stack along with its size, or {NULL, 0} if the stack is empty.
 *
 * @throws None
 */
stackElemWithSize stackTopWithSize(Stack *stack) {
    // Check if the stack is null or empty
    if (stack == NULL || stack->size == 0) {
        // If null or empty, return a default value {NULL, 0}
        stackElemWithSize tmp = {NULL, 0}; // Initialize a default return value
        return tmp; // Return the default value
    }

    // Retrieve the top element from the stack
    // The top element is stored in the 'head' node of the stack
    stackElemWithSize elem = {stack->head->data, stack->head->elemSize}; // Extract the top element

    // Return the top element along with its size
    return elem;
}

/**
 * Checks if a stack is empty.
 *
 * This function checks if the provided stack is empty by verifying its size.
 * It also handles the case where the stack is NULL.
 *
 * @param stack The stack to check for emptiness.
 *
 * @return 1 if the stack is empty, 0 if it's not, or -1 if the stack is NULL.
 *
 * @throws None
 */
int stackIsEmpty(Stack *stack) {
    // Check if the stack is NULL to avoid dereferencing a null pointer
    if (stack == NULL) {
        // If the stack is NULL, return -1 to indicate an invalid state
        return -1;
    }

    // Check if the stack's size is 0 to determine if it's empty
    // The size of the stack is assumed to be a non-negative integer
    return stack->size == 0 ? 1 : 0;
}

/**
 * Checks if a given element is a member of the stack.
 *
 * This function iterates through the stack and uses a provided comparison function
 * to check if the given element is present in the stack.
 *
 * @param stack The stack to search for the element.
 * @param elem The element to search for, along with its size.
 * @param cmp A comparison function that takes two const void pointers as arguments.
 *            The function should return an integer indicating the result of the comparison.
 *
 * @return 1 if the element is found in the stack, 0 if it's not found, or -1 if the stack is NULL, empty, or the comparison function is NULL.
 */
int isStackMember(Stack *stack, stackElemWithSize elem, int (*cmp)(const void *, const void *)) {
    // Check for invalid input: NULL stack, empty stack, or NULL comparison function
    if (stack == NULL || stack->size == 0 || cmp == NULL) {
        // If any of these conditions are true, return an error code (-1)
        return -1;
    }

    // Initialize a pointer to the head of the stack
    StackNode *node = stack->head;

    // Extract the size and data of the element to search for
    size_t elem_size = elem.elemSize;
    stackElem elem_data = elem.data;

    // Iterate through the stack until we find the element or reach the end
    while (node != NULL) {
        // Extract the size and data of the current node
        size_t node_size = node->elemSize;
        stackElem node_data = node->data;

        // Check if the current node matches the element we're searching for
        if (elem_size == node_size && cmp(elem_data, node_data)) {
            // If we find a match, return 1 to indicate success
            return 1;
        }

        // Move to the next node in the stack
        node = node->next;
    }

    // If we reach the end of the stack without finding the element, return 0 to indicate failure
    return 0;
}
