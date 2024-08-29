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
#include <stdlib.h>
#include "constDef.h"
#include "queue.h"
#include <stdio.h>
#include <string.h>


Queue *queueInit() {
    Queue *queue = (Queue *) malloc(sizeof(Queue));
    if (queue == NULL) {
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(queue), __FILE__, __FUNCTION__, __LINE__);
    }
    queue->front = NULL;
    queue->rear = NULL;
    queue->size = 0;
    return queue;
}

void queuePush(Queue *queue, queueElem data, size_t elemSize) {
    if (queue == NULL) {
        return;
    }
    QueueNode *node = (QueueNode *) malloc(sizeof(QueueNode));
    if (node == NULL) {
        PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(node), __FILE__, __FUNCTION__, __LINE__);
    }
    queueElem new_elem = malloc(elemSize);
    if (new_elem == NULL) {
        FREE(node);
        PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(new_elem), __FILE__, __FUNCTION__, __LINE__);
    }
    memcpy(new_elem, data, elemSize);
    node->data = new_elem;
    node->elemSize = elemSize;
    node->next = NULL;
    if (queue->size == 0) {
        queue->front = node;
    } else {
        queue->rear->next = node;
    }
    queue->rear = node;
    queue->size++;
}

queueElem queuePop(Queue *queue) {
    if (queue == NULL || queue->size == 0) {
        return NULL;
    }

    QueueNode *node = queue->front;
    queue->front = node->next;
    queue->size--;
    return node->data;
}

int queueIsEmpty(Queue *queue) {
    if (queue == NULL) {
        return -1;
    }
    if (queue->size == 0) {
        return 1;
    }
    return 0;
}

void queueDestroy(Queue **queue) {
    if (queue == NULL) {
        return;
    }
    queueClear(*queue);
    FREE(*queue);
}

void queueClear(Queue *queue) {
    if (queue == NULL || queue->size == 0) {
        return;
    }
    while (queue->size > 0) {
        queuePop(queue);
    }
}

queueElem queueFront(Queue *queue) {
    if (queue == NULL || queue->size == 0) {
        return NULL;
    }
    return queue->front->data;
}

queueElem queueRear(Queue *queue) {
    if (queue == NULL || queue->size == 0) {
        return NULL;
    }
    return queue->rear->data;
}

int queueSize(Queue *queue) {
    if (queue == NULL) {
        return -1;
    }
    return queue->size;
}

queueElemWithSize queuePopWithSize(Queue *queue) {
    if (queue == NULL || queue->size == 0) {
        queueElemWithSize tmp = {NULL, 0};
        return tmp;
    }
    QueueNode *node = queue->front;
    queue->front = node->next;
    queue->size--;
    queueElemWithSize elem = {node->data, node->elemSize};
    FREE(node);
    return elem;
}

queueElemWithSize queueFrontWithSize(Queue *queue) {
    if (queue == NULL || queue->size == 0) {
        queueElemWithSize tmp = {NULL, 0};
        return tmp;
    }
    QueueNode *node = queue->front;
    queueElemWithSize elem = {node->data, node->elemSize};
    return elem;
}

queueElemWithSize queueRearWithSize(Queue *queue) {
    if (queue == NULL || queue->size == 0) {
        queueElemWithSize tmp = {NULL, 0};
        return tmp;
    }
    QueueNode *node = queue->rear;
    queueElemWithSize elem = {node->data, node->elemSize};
    return elem;
}

/**
 * Reverses the order of elements in the given queue.
 *
 * @param queue the queue to be reversed
 *
 * @return void
 *
 * @throws none
 */
void queueSwap(Queue *queue) {
    if (queue == NULL || queue->size <= 1) {
        return;
    }
    QueueNode *current = queue->front;
    QueueNode *next = NULL;
    QueueNode *prev = NULL;
    while (current != NULL) {
        next = current->next;
        current->next = prev;
        prev = current;
        current = next;
    }
    queue->front = prev;
    queue->rear = queue->front;
}
