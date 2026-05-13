# Stack (C)

> [!NOTE]
> This documentation covers `stack.h` and `stack.c`.

A **stack** is a Last-In-First-Out (LIFO) data structure. This implementation uses a linked list for flexibility.

## Types

```c
// Stack element (generic pointer)
typedef void *stackElem;

// Stack node
typedef struct _StackNode {
    stackElem data;
    struct _StackNode *next;
    size_t elemSize;  // Element size for deep copy
} StackNode;

// Stack structure
typedef struct _Stack {
    StackNode *head;  // Top of stack
    StackNode *tail;  // Bottom of stack
    int size;
} Stack;

// Element with size
typedef struct _stackElemWithSize {
    stackElem data;
    size_t elemSize;
} stackElemWithSize;
```

## Common Element Sizes

```c
enum STACK_TYPE_SIZE {
    STACK_TYPE_SIZE_INT = sizeof(int),
    STACK_TYPE_SIZE_LONG = sizeof(long),
    STACK_TYPE_SIZE_FLOAT = sizeof(float),
    STACK_TYPE_SIZE_DOUBLE = sizeof(double),
    STACK_TYPE_SIZE_CHAR = sizeof(char),
    STACK_TYPE_SIZE_SHORT = sizeof(short),
    STACK_TYPE_SIZE_LONG_LONG = sizeof(long long)
};
```

## Functions

### stackInit

```c
Stack *stackInit(void);
```

Creates and initializes a new stack.

**Returns:** Pointer to new Stack, or NULL on allocation failure.

---

### stackPush

```c
void stackPush(Stack *stack, stackElem elem, size_t elemSize);
```

Pushes an element onto the stack (copies elemSize bytes).

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| stack | Stack\* | Stack to push to |
| elem | stackElem | Element to push |
| elemSize | size_t | Size of element in bytes |

---

### stackPop

```c
stackElem stackPop(Stack *stack);
```

Removes and returns the top element.

**Returns:** Top element (without size), or NULL if empty.

---

### stackPopWithSize

```c
stackElemWithSize stackPopWithSize(Stack *stack);
```

Removes and returns the top element with its size.

**Returns:** stackElemWithSize struct, or with data=NULL if empty.

---

### stackTop

```c
stackElem stackTop(Stack *stack);
```

Returns the top element without removing it.

**Returns:** Top element, or NULL if empty.

---

### stackTopWithSize

```c
stackElemWithSize stackTopWithSize(Stack *stack);
```

Returns the top element with size, without removing it.

**Returns:** stackElemWithSize struct, or with data=NULL if empty.

---

### stackBottom / stackBottomWithSize

```c
stackElem stackBottom(Stack *stack);
stackElemWithSize stackBottomWithSize(Stack *stack);
```

Returns the bottom element of the stack.

---

### stackSize

```c
int stackSize(Stack *stack);
```

**Returns:** Number of elements in stack, or -1 if stack is NULL.

---

### stackClear

```c
void stackClear(Stack *stack);
```

Removes all elements but keeps the stack structure.

---

### stackDestroy

```c
void stackDestroy(Stack **stack);
```

Frees all nodes and the stack itself. Sets pointer to NULL.

---

### stackSwap

```c
void stackSwap(Stack *stack);
```

Reverses the order of elements in the stack.

---

### isStackEmpty

```c
int isStackEmpty(Stack *stack);
```

**Returns:** 1 if empty, 0 if not empty, -1 if stack is NULL.

---

### isStackMember

```c
int isStackMember(Stack *stack, stackElemWithSize elem,
                  int (*cmp)(const void *, const void *));
```

Checks if an element exists in the stack.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| stack | Stack\* | Stack to search |
| elem | stackElemWithSize | Element to find |
| cmp | function | Comparison function (returns 1 if equal) |

**Returns:** 1 if found, 0 if not found, -1 if stack is NULL.

---

### stackToArray

```c
void *stackToArray(Stack *stack);
```

Converts stack to array (top of stack = index 0).

**Returns:** Pointer to new array, or NULL if empty. Caller must free.

---

### stackCopy

```c
Stack *stackCopy(Stack *stack);
```

Creates a deep copy of the stack.

**Returns:** Pointer to new stack, or NULL if empty/failure.

---

## Usage Example

```c
#include "stack.h"
#include <stdio.h>

int main(void) {
    Stack *stack = stackInit();

    // Push elements
    int arr[] = {1, 2, 3, 4, 5};
    for (int i = 0; i < 5; i++) {
        stackPush(stack, &arr[i], STACK_TYPE_SIZE_INT);
    }

    // Pop all elements
    while (!isStackEmpty(stack)) {
        int *val = (int *)stackPop(stack);
        printf("%d ", *val);
    }
    // Output: 5 4 3 2 1

    stackDestroy(&stack);
    return 0;
}
```