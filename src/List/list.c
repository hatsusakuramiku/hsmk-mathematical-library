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
 * @return A pointer to the newly created list.
 *
 * @throws MALLOC_FAILURE_001 if memory allocation fails.
 */
List *newList() {
 ListNode *node = (ListNode *) malloc(sizeof(ListNode));
 if (node == NULL) {
  PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(node), __FILE__, __FUNCTION__, __LINE__);
 }
 node->data = NULL;
 node->next = NULL;
 node->prev = NULL;
 List *list = (List *) malloc(sizeof(List));
 if (list == NULL) {
  PWARNING_RETURN(MALLOC_FAILURE_001, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__);
 }
 list->head = node;
 list->tail = node;
 list->size = 0;
 return list;
}

void deleteList(List *list) {
 if (list == NULL) {
  return;
 }
 listClear(list);
 free(list);
}

void listPush(List *list, ListNodeData data) {
 ListNode *newNode = (ListNode *) malloc(sizeof(ListNode));
 if (newNode == NULL) {
  PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(newNode), __FILE__, __FUNCTION__, __LINE__);
 }
 newNode->data = data;
 newNode->prev = NULL;
 if (list->size == 0) {
  newNode->next = NULL;
  list->tail = newNode;
  list->head = newNode;
  list->size++;
  return;
 }
 newNode->next = list->head;
 list->head->prev = newNode;
 list->head = newNode;
 list->size++;
}

void listPushBack(List *list, ListNodeData data) {
 ListNode *newNode = (ListNode *) malloc(sizeof(ListNode));
 if (newNode == NULL) {
  PWARNING_RETURN_NO_NULL(MALLOC_FAILURE_001, VAR_NAME(newNode), __FILE__, __FUNCTION__, __LINE__);
 }
 newNode->data = data;
 newNode->next = NULL;
 if (list->size == 0) {
  newNode->prev = NULL;
  list->tail = newNode;
  list->head = newNode;
  list->size++;
  return;
 }
 newNode->prev = list->tail;
 list->tail->next = newNode;
 list->tail = newNode;
 list->size++;
}

void listPop(List *list) {
 if (list == NULL) {
  return;
 }
 if (list->head == NULL) {
  return;
 }
 if (list->size == 1) {
  listClear(list);
  return;
 }
 ListNode *node = list->head;
 list->head = node->next;
 list->head->prev = NULL;
 free(node);
 list->size--;
}

void listPopBack(List *list) {
 if (list == NULL) {
  return;
 }
 if (list->tail == NULL) {
  return;
 }
 ListNode *node = list->tail;
 list->tail = node->prev;
 list->tail->next = NULL;
 free(node);
 list->size--;
}

void listClear(List *list) {
 if (list == NULL) {
  return;
 }
 ListNode *node = list->head;
 while (node != NULL) {
  ListNode *next = node->next;
  free(node);
  node = next;
 }
 list->head = NULL;
 list->tail = NULL;
 list->size = 0;
}

void listInsert(List *list, int index, ListNodeData data) {
 if (list == NULL) {
  return;
 }
 if (index < 0 || index > list->size) {
  PERROR(INVALID_INPUT_005, VAR_NAME(index), 0, list->size - 1, __FILE__, __FUNCTION__, __LINE__);
 }
}

/**
 * @brief Erase the element at the given index in the list.
 *
 * @param list The list to erase from.
 * @param index The index of the element to erase.
 * @throws None
 */
void listErase(List *list, int index) {
 if (list == NULL) {
  PERROR(INPUT_NULL_002, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__);
 }
 if (index < 0 || index >= list->size) {
  PERROR(INVALID_INPUT_005, VAR_NAME(index), 0, list->size - 1, __FILE__, __FUNCTION__, __LINE__);
 }
 ListNode *node = list->head;
 for (int i = 0; i < index; i++) {
  node = node->next;
 }
 ListNode *prev = node->prev;
 ListNode *next = node->next;
 if (prev != NULL) {
  prev->next = next;
 }
 if (next != NULL) {
  next->prev = prev;
 }
 if (node == list->head) {
  list->head = next;
 }
 if (node == list->tail) {
  list->tail = prev;
 }
 list->size--;
 free(node);
}

ListNodeData listTopNode(List *list) {
 if (list == NULL) { PWARNING_RETURN(INPUT_NULL_001, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__); }
 return list->head->data;
}

ListNodeData listBackNode(List *list) {
 if (list == NULL) { PWARNING_RETURN(INPUT_NULL_001, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__); }

 return list->tail->data;
}

ListNodeData listGetTopAndPop(List *list) {
 if (list == NULL) {
  PWARNING_RETURN(INPUT_NULL_001, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__);
 }
 if (list->size == 0) {
  PERROR(INVALID_INPUT_005, VAR_NAME(list->size), 1, list->size, __FILE__, __FUNCTION__, __LINE__);
 }
 ListNodeData data = list->head->data;
 if (list->size == 1) {
  listClear(list);
  return data;
 }
 list->head = list->head->next;
 list->head->prev = NULL;
 list->size--;
 return data;
}

ListNodeData listGetBackAndPop(List *list) {
 if (list == NULL) {
  PWARNING_RETURN(INPUT_NULL_001, VAR_NAME(list), __FILE__, __FUNCTION__, __LINE__);
 }
 ListNodeData data = list->tail->data;
 list->tail = list->tail->prev;
 if (list->tail != NULL) {
  list->tail->next = NULL;
 } else {
  // If the list has only one node, set head to NULL
  list->head = NULL;
 }
 list->size--;
 return data;
}
