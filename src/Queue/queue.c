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

/**
 * @brief Initializes a new queue.
 *
 * @return Pointer to the newly created queue.
 *
 * @throws MALLOC_FAILURE_001 if memory allocation fails.
 */
Queue *queueInit() {
    // Allocate memory for the queue.
    Queue *queue = (Queue *) malloc(sizeof(Queue));

    // Check if memory allocation was successful.
    if (queue == NULL) {
        // If not, print a warning and return NULL.
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(queue), __FILE__, __FUNCTION__, __LINE__);
    }

    // Initialize the queue.
    queue->front = NULL;
    queue->rear = NULL;
    queue->size = 0;

    // Return the pointer to the queue.
    return queue;
}

/**
 * @brief Pushes a new element onto the queue.
 *
 * This function allocates memory for a new queue node, copies the provided data into it,
 * and adds it to the end of the queue.
 *
 * @param queue The queue to push the element onto.
 * @param data The data to be copied into the new queue node.
 * @param elemSize The size of the data to be copied.
 *
 * @return None
 *
 * @throws MALLOC_FAILURE_001 if memory allocation fails.
 */
void queuePush(Queue *queue, queueElem data, size_t elemSize) {
    // Check if the queue is NULL, if so, return immediately
    if (queue == NULL) {
        return;
    }

    // Allocate memory for a new queue node
    QueueNode *node = (QueueNode *) malloc(sizeof(QueueNode));
    if (node == NULL) {
        // If memory allocation fails, print a warning and return
        PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(node), __FILE__, __FUNCTION__, __LINE__);
    }

    // Allocate memory for the new element
    queueElem new_elem = malloc(elemSize);
    if (new_elem == NULL) {
        // If memory allocation fails, free the node and print a warning
        FREE(node);
        PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(new_elem), __FILE__, __FUNCTION__, __LINE__);
    }

    // Copy the provided data into the new element
    memcpy(new_elem, data, elemSize);

    // Initialize the new node
    node->data = new_elem;
    node->elemSize = elemSize;
    node->next = NULL;

    // Add the new node to the end of the queue
    if (queue->size == 0) {
        // If the queue is empty, set the front and rear to the new node
        queue->front = node;
    } else {
        // Otherwise, set the next pointer of the current rear to the new node
        queue->rear->next = node;
    }

    // Update the rear and size of the queue
    queue->rear = node;
    queue->size++;
}

/**
 * @brief Removes and returns the front element from the queue.
 *
 * This function checks if the queue is NULL or empty, and if so, returns NULL.
 * Otherwise, it updates the front pointer, decrements the size, and returns the data of the removed node.
 *
 * @param queue The queue to pop the element from.
 *
 * @return The data of the removed node, or NULL if the queue is NULL or empty.
 */
queueElem queuePop(Queue *queue) {
    // Check if the queue is NULL or empty
    if (queue == NULL || queue->size == 0) {
        // If so, return NULL
        return NULL;
    }

    // Get the front node of the queue
    QueueNode *node = queue->front;

    // Update the front pointer to the next node
    queue->front = node->next;

    // Decrement the size of the queue
    queue->size--;

    // Return the data of the removed node
    return node->data;
}

/**
 * @brief Checks if a queue is empty.
 *
 * This function checks if the provided queue is NULL or if its size is 0.
 * It returns -1 if the queue is NULL, 1 if the queue is empty, and 0 otherwise.
 *
 * @param queue The queue to check.
 *
 * @return -1 if the queue is NULL, 1 if the queue is empty, and 0 otherwise.
 */
int queueIsEmpty(Queue *queue) {
    // Check if the queue is NULL
    if (queue == NULL) {
        // If so, return -1 to indicate an invalid queue
        return -1;
    }

    // Check if the queue's size is 0
    if (queue->size == 0) {
        // If so, return 1 to indicate an empty queue
        return 1;
    }

    // If the queue is not NULL and not empty, return 0
    return 0;
}

/**
 * @brief Destroys a queue.
 *
 * This function clears the queue and frees the memory allocated for it.
 *
 * @param queue A pointer to the queue to be destroyed.
 */
void queueDestroy(Queue **queue) {
    // Check if the queue pointer is NULL
    if (queue == NULL) {
        // If so, return and do nothing
        return;
    }

    // Clear the queue
    queueClear(*queue);

    // Free the memory allocated for the queue
    FREE(*queue);
}

/**
 * @brief Clears a queue by removing all elements.
 *
 * This function checks if the queue is NULL or empty, and if so, returns immediately.
 * Otherwise, it repeatedly calls queuePop to remove all elements from the queue.
 *
 * @param queue The queue to be cleared.
 */
void queueClear(Queue *queue) {
    // Check if the queue is NULL or empty
    if (queue == NULL || queue->size == 0) {
        // If so, return immediately
        return;
    }

    // Repeatedly remove elements from the queue until it is empty
    while (queue->size > 0) {
        // Remove the front element from the queue
        queuePop(queue);
    }
}

/**
 * @brief Returns the front element of the queue.
 *
 * This function checks if the queue is NULL or empty, and if so, returns NULL.
 * Otherwise, it returns the data of the front node.
 *
 * @param queue The queue to retrieve the front element from.
 *
 * @return The data of the front node, or NULL if the queue is NULL or empty.
 */
queueElem queueFront(Queue *queue) {
    // Check if the queue is NULL or empty
    if (queue == NULL || queue->size == 0) {
        // If so, return NULL
        return NULL;
    }
    // Return the data of the front node
    return queue->front->data;
}

/**
 * @brief Returns the rear element of the queue.
 *
 * This function checks if the queue is NULL or empty, and if so, returns NULL.
 * Otherwise, it returns the data of the rear node.
 *
 * @param queue The queue to retrieve the rear element from.
 *
 * @return The data of the rear node, or NULL if the queue is NULL or empty.
 */
queueElem queueRear(Queue *queue) {
    // Check if the queue is NULL or empty
    if (queue == NULL || queue->size == 0) {
        // If so, return NULL to indicate an empty queue
        return NULL;
    }
    // Return the data of the rear node
    return queue->rear->data;
}

/**
 * @brief Returns the size of the queue.
 *
 * This function checks if the queue is NULL, and if so, returns -1 to indicate an error.
 * Otherwise, it returns the current size of the queue.
 *
 * @param queue The queue to retrieve the size from.
 *
 * @return The size of the queue, or -1 if the queue is NULL.
 */
int queueSize(Queue *queue) {
    // Check if the queue is NULL to prevent dereferencing a null pointer
    if (queue == NULL) {
        // If the queue is NULL, return -1 to indicate an error
        return -1;
    }
    // Return the current size of the queue
    return queue->size;
}

/**
 * @brief Pop an element from the front of the queue.
 *
 * This function removes the element at the front of the queue and returns it along with its size.
 *
 * @param queue The queue from which to pop the element.
 * @return The popped element along with its size.
 */
queueElemWithSize queuePopWithSize(Queue *queue) {
    // Check if the queue is NULL or empty
    if (queue == NULL || queue->size == 0) {
        // If the queue is NULL or empty, return a default element with NULL data and size 0
        queueElemWithSize tmp = {NULL, 0};
        return tmp;
    }

    // Get the front node of the queue
    QueueNode *node = queue->front;

    // Move the front pointer to the next node
    queue->front = node->next;

    // Decrease the size of the queue
    queue->size--;

    // Get the data and size of the popped element
    queueElemWithSize elem = {node->data, node->elemSize};

    // Free the memory of the popped node
    FREE(node);

    // Return the popped element along with its size
    return elem;
}

/**
 * @brief Returns the front element of the queue along with its size.
 *
 * This function checks if the queue is empty and returns a default element with NULL data and size 0 if it is.
 * Otherwise, it retrieves the front element of the queue and returns it along with its size.
 *
 * @param queue The queue from which to retrieve the front element.
 * @return The front element of the queue along with its size.
 */
queueElemWithSize queueFrontWithSize(Queue *queue) {
    // Check if the queue is NULL or empty
    if (queue == NULL || queue->size == 0) {
        // If the queue is NULL or empty, return a default element with NULL data and size 0
        queueElemWithSize tmp = {NULL, 0};
        return tmp;
    }

    // Get the front node of the queue
    QueueNode *node = queue->front;

    // Get the data and size of the front element
    queueElemWithSize elem = {node->data, node->elemSize};

    // Return the front element along with its size
    return elem;
}

/**
 * @brief Returns the rear element of the queue along with its size.
 *
 * This function checks if the queue is empty and returns a default element with NULL data and size 0 if it is.
 * Otherwise, it retrieves the rear element of the queue and returns it along with its size.
 *
 * @param queue The queue from which to retrieve the rear element.
 * @return The rear element of the queue along with its size.
 */
queueElemWithSize queueRearWithSize(Queue *queue) {
    // Check if the queue is NULL or empty
    if (queue == NULL || queue->size == 0) {
        // If the queue is NULL or empty, return a default element with NULL data and size 0
        queueElemWithSize tmp = {NULL, 0};
        return tmp;
    }

    // Get the rear node of the queue
    QueueNode *node = queue->rear;

    // Get the data and size of the rear element
    queueElemWithSize elem = {node->data, node->elemSize};

    // Return the rear element along with its size
    return elem;
}

/**
 * Reverses the order of elements in the given queue.
 *
 * This function iterates through the queue, reversing the direction of each node's
 * next pointer. The front and rear pointers of the queue are then updated to
 * reflect the new order of the elements.
 *
 * @param queue The queue to be reversed.
 *
 * @return void
 *
 * @throws none
 */
void queueSwap(Queue *queue) {
    // Check if the queue is NULL or has only one element
    if (queue == NULL || queue->size <= 1) {
        // In this case, there's nothing to reverse, so we return immediately
        return;
    }

    // Initialize pointers to keep track of the current node and its previous node
    QueueNode *current = queue->front;
    QueueNode *next = NULL;
    QueueNode *prev = NULL;

    // Iterate through the queue, reversing the direction of each node's next pointer
    while (current != NULL) {
        // Store the next node in the queue before we reverse the current node's next pointer
        next = current->next;

        // Reverse the current node's next pointer
        current->next = prev;

        // Move the previous node pointer forward
        prev = current;

        // Move the current node pointer forward
        current = next;
    }

    // Update the front and rear pointers of the queue to reflect the new order of the elements
    queue->front = prev;
    queue->rear = queue->front;
}
