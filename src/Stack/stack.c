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


/**
 * Initializes a new stack by allocating memory and setting its head and size.
 *
 * @return A pointer to the initialized stack, or NULL if memory allocation fails.
 *
 * @throws PWARNING_RETURN_MALLOC if memory allocation fails.
 */
Stack *stackInit() {
    // Allocate memory for the stack
    Stack *stack = (Stack *) malloc(sizeof(Stack));
    // If memory allocation fails, return a NULL pointer
    if (stack == NULL) {
        PWARNING_RETURN_MALLOC(stack);
    }
    // Set the head of the stack to NULL
    stack->head = NULL;
    // Set the size of the stack to 0
    stack->size = 0;

    stack->tail = NULL;
    // Return the pointer to the initialized stack
    return stack;
}

/**
 * Clears the contents of a stack by popping all elements.
 *
 * @param stack The stack to be cleared.
 *
 * @return None
 *
 * @throws None
 */
void stackClear(Stack *stack) {
    if (stack == NULL) {
        return;
    }
    while (stackSize(stack) > 0) {
        stackPop(stack);
    }
}

/**
 * Destroys a stack by clearing its contents and freeing the allocated memory.
 *
 * @param stack A double pointer to the stack to be destroyed.
 *
 * @return None.
 *
 * @throws None.
 */
void stackDestroy(Stack **stack) {
    if (stack == NULL || *stack == NULL) {
        return;
    }
    stackClear(*stack);
    FREE(*stack);
}

/**
 * Pushes an element onto the top of the stack.
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
    if (stack == NULL) {
        return;
    }
    StackNode *node = (StackNode *) malloc(sizeof(StackNode));
    if (node == NULL) {
        PWARNING_RETURN_MALLOC_NO_NULL(node);
    }
    stackElem new_elem = malloc(elemSize);
    if (new_elem == NULL) {
        FREE(node);
        PWARNING_RETURN_MALLOC_NO_NULL(new_elem);
    }
    memcpy(new_elem, elem, elemSize);
    node->data = new_elem;
    node->elemSize = elemSize;
    node->next = stack->head;
    stack->head = node;
    if (stack->size == 0) {
        stack->tail = node;
    }
    stack->size++;
}

/**
 * Removes and returns the top element from the stack.
 *
 * @param stack The stack from which to pop the element.
 *
 * @return The top element of the stack, or NULL if the stack is empty.
 *
 * @throws None.
 */
stackElem stackPop(Stack *stack) {
    if (stack == NULL) {
        return NULL;
    }
    if (stack->size == 0) {
        return NULL;
    }
    StackNode *node = stack->head;
    stack->head = node->next;
    stack->size--;
    if (stack->size == 0) {
        stack->tail = NULL;
    }
    stackElem elem = node->data;
    FREE(node);
    return elem;
}

/**
 * Returns the bottom element of the stack.
 *
 * @param stack The stack from which to retrieve the bottom element.
 *
 * @return The bottom element of the stack, or NULL if the stack is empty.
 *
 * @throws None.
 */
stackElem stackBottom(Stack *stack) {
    if (stack == NULL || stack->size == 0) {
        return NULL;
    }
    return stack->tail->data;
}

/**
 * Returns the top element of the stack.
 *
 * @param stack The stack from which to retrieve the top element.
 *
 * @return The top element of the stack, or NULL if the stack is empty.
 *
 * @throws None.
 */
stackElem stackTop(Stack *stack) {
    if (stack == NULL || stack->size == 0) {
        return NULL;
    }
    return stack->head->data;
}


/**
 * Returns the number of elements in the stack.
 *
 * @param stack The stack to retrieve the size from.
 *
 * @return The number of elements in the stack, or -1 if the stack is NULL.
 *
 * @throws None.
 */
int stackSize(Stack *stack) {
    if (stack == NULL) {
        return -1;
    }
    return stack->size;
}

/**
 * Reverses the order of elements in the stack.
 *
 * @param stack The stack to be reversed.
 *
 * @return None.
 *
 * @throws None.
 */
void stackSwap(Stack *stack) {
    if (stack == NULL || stack->size < 2) {
        return;
    }

    StackNode *prev = NULL;
    StackNode *current = stack->head;
    StackNode *next = NULL;
    stack->tail = stack->head;

    while (current != NULL) {
        next = current->next;
        current->next = prev;
        prev = current;
        current = next;
    }

    stack->head = prev;
}

/**
 * Removes and returns the top element from the stack along with its size.
 *
 * @param stack The stack from which to pop the element.
 *
 * @return The top element of the stack along with its size, or {NULL, 0} if the stack is empty.
 *
 * @throws None.
 */
stackElemWithSize stackPopWithSize(Stack *stack) {
    if (stack == NULL || stack->size == 0) {
        stackElemWithSize tmp = {NULL, 0};
        return tmp;
    }

    stackElemWithSize elem = {stack->head->data, stack->head->elemSize};
    StackNode *node = stack->head;
    stack->head = node->next;
    stack->size--;
    if (stack->size == 0) {
        stack->tail = NULL;
    }
    free(node);
    return elem;
}

/**
 * Returns the bottom element of the stack along with its size.
 *
 * @param stack The stack from which to retrieve the bottom element.
 *
 * @return The bottom element of the stack along with its size, or {NULL, 0} if the stack is empty.
 *
 * @throws None.
 */
stackElemWithSize stackBotWithSizetom(Stack *stack) {
    if (stack == NULL || stack->size == 0) {
        stackElemWithSize tmp = {NULL, 0};
        return tmp;
    }
    stackElemWithSize elem = {stack->tail->data, stack->tail->elemSize};
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
    if (stack == NULL || stack->size == 0) {
        stackElemWithSize tmp = {NULL, 0};
        return tmp;
    }
    stackElemWithSize elem = {stack->head->data, stack->head->elemSize};
    return elem;
}

/**
 * Checks if a stack is empty.
 *
 * @param stack The stack to check for emptiness.
 *
 * @return 1 if the stack is empty, 0 if it's not, or -1 if the stack is NULL.
 *
 * @throws None
 */
int stackIsEmpty(Stack *stack) {
    if (stack == NULL) {
        return -1;
    }
    return stack->size == 0;
}
