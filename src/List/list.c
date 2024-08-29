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

#include "list.h"

#include <stdio.h>
#include <stdlib.h>

#include "constDef.h"

/**
 * Creates a new list with a single node.
 *
 * This function allocates memory for a new list and its first node, and initializes the node's properties.
 *
 * @return A pointer to the newly created list.
 *
 * @throws MALLOC_FAILURE_001 if memory allocation fails.
 */
List *newList() {
    // Allocate memory for the new node
    ListNode *node = (ListNode *) malloc(sizeof(ListNode));
    if (node == NULL) {
        // Handle memory allocation failure
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(node), __FILE__, __FUNCTION__, __LINE__);
    }

    // Initialize the node's properties
    node->data = NULL; // No data assigned to the node initially
    node->next = NULL; // Node is not linked to any next node
    node->prev = NULL; // Node is not linked to any previous node

    // Allocate memory for the new list
    List *list = (List *) malloc(sizeof(List));
    if (list == NULL) {
        // Handle memory allocation failure
        PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__);
    }

    // Initialize the list's properties
    list->head = node; // Set the node as the head of the list
    list->tail = node; // Set the node as the tail of the list (since it's the only node)
    list->size = 0; // List is initially empty

    // Return the newly created list
    return list;
}

/**
 * Deletes a list and all its nodes.
 *
 * This function checks if the list is NULL, then clears the list by deleting all its nodes,
 * and finally frees the memory allocated for the list itself.
 *
 * @param list The list to be deleted.
 */
void deleteList(List *list) {
    // Check if the list is NULL to avoid dereferencing a null pointer
    if (list == NULL) {
        // If the list is NULL, there's nothing to delete, so return immediately
        return;
    }

    // Clear the list by deleting all its nodes
    listClear(list);

    // Free the memory allocated for the list itself
    free(list);
}

/**
 * Pushes a new node with the given data to the front of the list.
 *
 * This function allocates memory for a new node, sets its data and pointers,
 * and updates the list's head and size accordingly. If the list is empty,
 * the new node becomes both the head and tail of the list.
 *
 * @param list The list to which the new node will be added.
 * @param data The data to be stored in the new node.
 */
void listPush(List *list, ListNodeData data) {
    // Allocate memory for a new node
    ListNode *newNode = (ListNode *) malloc(sizeof(ListNode));

    // Check if memory allocation failed
    if (newNode == NULL) {
        // Handle memory allocation failure
        PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(newNode), __FILE__, __FUNCTION__, __LINE__);
    }

    // Initialize the new node's data and pointers
    newNode->data = data;
    newNode->prev = NULL; // New node has no previous node

    // Check if the list is empty
    if (list->size == 0) {
        // If the list is empty, set the new node as both head and tail
        newNode->next = NULL;
        list->tail = newNode;
        list->head = newNode;
        list->size++; // Increment the list's size
        return;
    }

    // If the list is not empty, add the new node to the front
    newNode->next = list->head;
    list->head->prev = newNode; // Update the previous node's pointer
    list->head = newNode; // Update the list's head
    list->size++; // Increment the list's size
}

/**
 * Adds a new node with the given data to the end of the list.
 *
 * @param list The list to which the new node will be added.
 * @param data The data to be stored in the new node.
 */
void listPushBack(List *list, ListNodeData data) {
    // Allocate memory for a new node
    ListNode *newNode = (ListNode *) malloc(sizeof(ListNode));

    // Check if memory allocation failed
    if (newNode == NULL) {
        // Handle memory allocation failure
        PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(newNode), __FILE__, __FUNCTION__, __LINE__);
    }

    // Initialize the new node's data and pointers
    newNode->data = data;
    newNode->next = NULL; // New node has no next node

    // Check if the list is empty
    if (list->size == 0) {
        // If the list is empty, set the new node as both head and tail
        newNode->prev = NULL;
        list->tail = newNode;
        list->head = newNode;
        list->size++; // Increment the list's size
        return;
    }

    // If the list is not empty, add the new node to the end
    newNode->prev = list->tail; // Update the new node's previous pointer
    list->tail->next = newNode; // Update the current tail's next pointer
    list->tail = newNode; // Update the list's tail
    list->size++; // Increment the list's size
}

/**
 * @brief Removes the first element from the list.
 *
 * If the list is empty or only contains one element, this function does nothing.
 * Otherwise, it updates the list's head and size accordingly.
 *
 * @param list The list to remove the first element from.
 */
void listPop(List *list) {
    // Check if the list is NULL
    if (list == NULL) {
        // If the list is NULL, do nothing and return
        return;
    }

    // Check if the list is empty
    if (list->head == NULL) {
        // If the list is empty, do nothing and return
        return;
    }

    // Check if the list only contains one element
    if (list->size == 1) {
        // If the list only contains one element, clear the list
        listClear(list);
        return;
    }

    // Get the node to be removed
    ListNode *node = list->head;

    // Update the list's head to the next node
    list->head = node->next;

    // Update the new head's previous pointer to NULL
    list->head->prev = NULL;

    // Free the memory allocated for the removed node
    free(node);

    // Decrement the list's size
    list->size--;
}

/**
 * Removes the last element from the list.
 *
 * @param list The list from which the last element will be removed.
 */
void listPopBack(List *list) {
    // Check if the list is NULL to prevent null pointer dereferences
    if (list == NULL) {
        return;
    }

    // Check if the list is empty (i.e., tail is NULL)
    if (list->tail == NULL) {
        return;
    }

    // Get the node to be removed (the current tail)
    ListNode *node = list->tail;

    // Update the list's tail to the previous node
    list->tail = node->prev;

    // Update the new tail's next pointer to NULL
    list->tail->next = NULL;

    // Free the memory allocated for the removed node
    free(node);

    // Decrement the list's size
    list->size--;
}

/**
 * Clears the list by freeing all nodes and resetting the list's head, tail, and size.
 *
 * @param list The list to be cleared.
 */
void listClear(List *list) {
    // Check if the list is NULL to prevent null pointer dereferences
    if (list == NULL) {
        return;
    }

    // Initialize a pointer to the current node
    ListNode *node = list->head;

    // Traverse the list and free each node
    while (node != NULL) {
        // Store the next node before freeing the current node
        ListNode *next = node->next;

        // Free the memory allocated for the current node
        free(node);

        // Move to the next node
        node = next;
    }

    // Reset the list's head, tail, and size
    list->head = NULL;
    list->tail = NULL;
    list->size = 0;
}

/**
 * @brief Inserts a new element at the specified index in the list.
 *
 * @param list The list to insert into.
 * @param index The index at which to insert the new element.
 * @param data The data to be inserted.
 *
 * @throws PERROR if the index is out of bounds (less than 0 or greater than the current list size).
 */
void listInsert(List *list, int index, ListNodeData data) {
    // Check if the list is NULL to prevent null pointer dereferences
    if (list == NULL) {
        // If the list is NULL, return immediately without attempting to insert
        return;
    }

    // Check if the index is within the valid range (0 to list->size)
    if (index < 0 || index > list->size) {
        // If the index is out of bounds, throw a PERROR with a descriptive message
        PERROR(INVALID_INPUT_005, VAR_NAME(index), 0, list->size - 1, __FILE__, __FUNCTION__, __LINE__);
    }
}

/**
 * @brief Erase the element at the given index in the list.
 *
 * This function removes the element at the specified index from the list.
 * It updates the list's head, tail, and size as necessary.
 * It also handles edge cases such as an empty list or an out-of-bounds index.
 *
 * @param list The list to erase from.
 * @param index The index of the element to erase.
 * @throws PERROR if the list is NULL or the index is out of bounds.
 */
void listErase(List *list, int index) {
    // Check if the list is NULL to prevent null pointer dereferences
    if (list == NULL) {
        // If the list is NULL, throw a PERROR with a descriptive message
        PERROR(INPUT_NULL_002, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if the index is within the valid range (0 to list->size - 1)
    if (index < 0 || index >= list->size) {
        // If the index is out of bounds, throw a PERROR with a descriptive message
        PERROR(INVALID_INPUT_005, VAR_NAME(index), 0, list->size - 1, __FILE__, __FUNCTION__, __LINE__);
    }

    // Find the node to be erased
    ListNode *node = list->head;
    for (int i = 0; i < index; i++) {
        // Traverse the list to find the node at the specified index
        node = node->next;
    }

    // Update the previous and next pointers of adjacent nodes
    ListNode *prev = node->prev;
    ListNode *next = node->next;
    if (prev != NULL) {
        // Update the next pointer of the previous node
        prev->next = next;
    }
    if (next != NULL) {
        // Update the previous pointer of the next node
        next->prev = prev;
    }

    // Update the list's head and tail if necessary
    if (node == list->head) {
        // If the node to be erased is the head, update the head pointer
        list->head = next;
    }
    if (node == list->tail) {
        // If the node to be erased is the tail, update the tail pointer
        list->tail = prev;
    }

    // Decrement the list size
    list->size--;

    // Free the memory allocated for the node
    free(node);
}

/**
 * Retrieves the data of the top node in the list.
 *
 * This function checks if the list is NULL and returns a warning if it is.
 * It then returns the data of the head node in the list.
 *
 * @param list The list to retrieve the top node from.
 * @return The data of the top node in the list.
 */
ListNodeData listTopNode(List *list) {
    // Check if the list is NULL to prevent null pointer dereferences
    if (list == NULL) {
        // If the list is NULL, return a warning with a descriptive message
        PWARNING_RETURN(INPUT_NULL_001, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__);
    }

    // Return the data of the head node in the list
    return list->head->data;
}

/**
 * Retrieves the data of the last node in the list.
 *
 * This function checks if the list is NULL and returns a warning if it is.
 * It then returns the data of the tail node in the list.
 *
 * @param list The list to retrieve the last node from.
 * @return The data of the last node in the list.
 */
ListNodeData listBackNode(List *list) {
    // Check if the list is NULL to prevent null pointer dereferences
    if (list == NULL) {
        // If the list is NULL, return a warning with a descriptive message
        PWARNING_RETURN(INPUT_NULL_001, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__);
    }

    // Return the data of the tail node
    return list->tail->data;
}

/**
 * Retrieves and removes the top node from the list.
 *
 * This function checks if the list is NULL and returns a warning if it is.
 * It then checks if the list is empty and returns an error if it is.
 * If the list has only one node, it clears the list and returns the node's data.
 * Otherwise, it updates the list's head to point to the next node and returns the data of the removed node.
 *
 * @param list The list to retrieve and remove the top node from.
 * @return The data of the removed top node.
 */
ListNodeData listGetTopAndPop(List *list) {
    // Check if the list is NULL to prevent null pointer dereferences
    if (list == NULL) {
        // If the list is NULL, return a warning with a descriptive message
        PWARNING_RETURN(INPUT_NULL_001, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__);
    }

    // Check if the list is empty
    if (list->size == 0) {
        // If the list is empty, return an error with a descriptive message
        PERROR(INVALID_INPUT_005, VAR_NAME(list->size), 1, list->size, __FILE__, __FUNCTION__, __LINE__);
    }

    // Store the data of the top node
    ListNodeData data = list->head->data;

    // Check if the list has only one node
    if (list->size == 1) {
        // If the list has only one node, clear the list
        listClear(list);
        // Return the data of the removed node
        return data;
    }

    // Update the list's head to point to the next node
    list->head = list->head->next;
    // Update the new head's previous pointer to NULL
    list->head->prev = NULL;
    // Decrement the list's size
    list->size--;
    // Return the data of the removed node
    return data;
}

/**
 * Retrieves and removes the last node from the list.
 *
 * @param list The list to retrieve and remove the last node from.
 * @return The data of the removed last node.
 */
ListNodeData listGetBackAndPop(List *list) {
    // Check if the list is NULL to prevent null pointer dereferences
    if (list == NULL) {
        // If the list is NULL, return a warning with a descriptive message
        PWARNING_RETURN(INPUT_NULL_001, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__);
    }

    // Store the data of the last node
    ListNodeData data = list->tail->data;

    // Update the list's tail to point to the previous node
    list->tail = list->tail->prev;

    // Check if the list has more than one node
    if (list->tail != NULL) {
        // If the list has more than one node, update the new tail's next pointer to NULL
        list->tail->next = NULL;
    } else {
        // If the list has only one node, set head to NULL
        list->head = NULL;
    }

    // Decrement the list's size
    list->size--;

    // Return the data of the removed node
    return data;
}
