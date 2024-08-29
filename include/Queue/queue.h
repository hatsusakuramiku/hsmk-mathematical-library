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

#ifndef _HSMK_MATH_LIB_QUEUE_H
#define _HSMK_MATH_LIB_QUEUE_H

typedef void *queueElem;

enum QUEUE_TYPE_SIZE {
    QUEUE_TYPE_INT = sizeof(int),
    QUEUE_TYPE_FLOAT = sizeof(float),
    QUEUE_TYPE_DOUBLE = sizeof(double),
    QUEUE_TYPE_CHAR = sizeof(char),
    QUEUE_TYPE_LONG = sizeof(long),
    QUEUE_TYPE_LONG_LONG = sizeof(long long)
};

typedef struct _QueueNode {
    queueElem data;
    size_t elemSize;
    struct _QueueNode *next;
} QueueNode;

typedef struct _queueElemWithSize {
    queueElem data;
    size_t elemSize;
} queueElemWithSize;

typedef struct _Queue {
    QueueNode *front;
    QueueNode *rear;
    unsigned int size;
} Queue;

Queue *queueInit();

void queuePush(Queue *queue, queueElem data, size_t elemSize);

int queueIsEmpty(Queue *queue);

void queueDestroy(Queue **queue);

void queueClear(Queue *queue);

queueElem queuePop(Queue *queue);

queueElem queueFront(Queue *queue);

queueElem queueRear(Queue *queue);

queueElemWithSize queuePopWithSize(Queue *queue);

queueElemWithSize queueFrontWithSize(Queue *queue);

queueElemWithSize queueRearWithSize(Queue *queue);

int queueSize(Queue *queue);

void queueSwap(Queue *queue);

#endif //_HSMK_MATH_LIB_QUEUE_H
