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

#ifndef _HSMK_MATH_LIB_STACK_H
#define _HSMK_MATH_LIB_STACK_H

enum STACK_TYPE_SIZE {
    STACK_TYPE_SIZE_INT = sizeof(int),
    STACK_TYPE_SIZE_LONG = sizeof(long),
    STACK_TYPE_SIZE_FLOAT = sizeof(float),
    STACK_TYPE_SIZE_DOUBLE = sizeof(double),
    STACK_TYPE_SIZE_CHAR = sizeof(char),
    STACK_TYPE_SIZE_SHORT = sizeof(short),
    STACK_TYPE_SIZE_LONG_LONG = sizeof(long long)
};

typedef void *stackElem;

typedef struct _StackNode {
    stackElem data;
    struct _StackNode *next;
    size_t elemSize;
} StackNode;

typedef struct _Stack {
    StackNode *head;
    StackNode *tail;
    int size;
} Stack;

typedef struct _stackElemWithSize {
    stackElem data;
    size_t elemSize;
} stackElemWithSize;

Stack *stackInit();

void stackClear(Stack *stack);

void stackDestroy(Stack **stack);

void stackPush(Stack *stack, stackElem elem, size_t elemSize);

stackElem stackPop(Stack *stack);

stackElem stackBottom(Stack *stack);

stackElem stackTop(Stack *stack);

stackElemWithSize stackPopWithSize(Stack *stack);

stackElemWithSize stackBottomWithSize(Stack *stack);

stackElemWithSize stackTopWithSize(Stack *stack);

int stackSize(Stack *stack);

void stackSwap(Stack *stack);

int isStackEmpty(Stack *stack);

int isStackMember(Stack *stack, stackElemWithSize elem, int (*cmp)(const void *, const void *));

void *stackToArray(Stack *stack);

Stack *stackCopy(Stack *stack);

#endif //_HSMK_MATH_LIB_STACK_H
