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

//
// Created by 79240 on 24-8-26.
//

#ifndef _HSMK_MATH_LIB_LIST_H
#define _HSMK_MATH_LIB_LIST_H

typedef void *ListNodeData;

typedef struct _ListNode {
 ListNodeData data;
 struct _ListNode *next;
 struct _ListNode *prev;
} ListNode;

typedef struct _List {
 ListNode *head;
 ListNode *tail;
 int size;
} List;


List *newList();

void deleteList(List *list);

void listPush(List *list, ListNodeData data);

void listPushBack(List *list, ListNodeData data);

void listPop(List *list);

void listPopBack(List *list);

void listClear(List *list);

void listInsert(List *list, int index, ListNodeData data);

void listErase(List *list, int index);

ListNodeData listTopNode(List *list);

ListNodeData listBackNode(List *list);

ListNodeData listGetTopAndPop(List *list);

ListNodeData listGetBackAndPop(List *list);

#endif //_HSMK_MATH_LIB_LIST_H
