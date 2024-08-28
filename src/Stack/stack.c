// Copyright  2024 hatsusakuramiku
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

void stackClear(Stack *stack) {
    if (stack == NULL) {
        return;
    }
    while (stackSize(stack) > 0) {
        stackPop(stack);
    }
}

void stackDestroy(Stack *stack) {
    if (stack == NULL) {
        return;
    }
    stackClear(stack);
    free(stack);
}

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
        free(node);
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
    free(node);
    return elem;
}

stackElem stackBottom(Stack *stack) {
    if (stack == NULL || stack->size == 0) {
        return NULL;
    }
    return stack->tail->data;
}

stackElem stackTop(Stack *stack) {
    if (stack == NULL || stack->size == 0) {
        return NULL;
    }
    return stack->head->data;
}

int stackSize(Stack *stack) {
    if (stack == NULL) {
        return 0;
    }
    return stack->size;
}

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

stackElemWithSize stackBotWithSizetom(Stack *stack) {
    if (stack == NULL || stack->size == 0) {
        stackElemWithSize tmp = {NULL, 0};
        return tmp;
    }
    stackElemWithSize elem = {stack->tail->data, stack->tail->elemSize};
    return elem;
}

stackElemWithSize stackTopWithSize(Stack *stack) {
    if (stack == NULL || stack->size == 0) {
        stackElemWithSize tmp = {NULL, 0};
        return tmp;
    }
    stackElemWithSize elem = {stack->head->data, stack->head->elemSize};
    return elem;
}
