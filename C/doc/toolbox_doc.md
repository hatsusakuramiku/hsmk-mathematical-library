# Toolbox Utilities (C)

> [!NOTE]
> This documentation covers `toolbox.h` and `toolbox.c`.

## ARRAY2PTR

```c
#define ARRAY2PTR(type, array, len)
```

Converts a static array to a dynamically allocated pointer.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| type | type | Element type |
| array | array | Input static array |
| len | size_t | Array length |

**Returns:** Newly allocated pointer, or NULL on failure. Caller must free.

**Example:**
```c
int static_arr[] = {1, 2, 3, 4, 5};
int *dynamic_arr = ARRAY2PTR(int, static_arr, 5);
```

---

## isMember

```c
int isMember(const void *ptr, const void *base, size_t elemSize, size_t count,
             int (*cmp)(const void *, const void *));
```

Checks if an element exists in an array.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| ptr | void\* | Pointer to element to find |
| base | void\* | Pointer to array base |
| elemSize | size_t | Size of each element |
| count | size_t | Number of elements |
| cmp | function | Comparison function (returns 1 if equal) |

**Returns:** 1 if found, 0 if not found, -1 on error.

**Example:**
```c
int cmp_int(const void *a, const void *b) {
    return *(int *)a == *(int *)b;
}

int arr[] = {1, 2, 3, 4, 5};
int target = 3;
if (isMember(&target, arr, sizeof(int), 5, cmp_int)) {
    printf("Found!\n");
}
```

---

## getUniqueStackFromArray

```c
Stack *getUniqueStackFromArray(const void *base, size_t elemSize, size_t count,
                                int (*cmp)(const void *, const void *));
```

Extracts unique elements from an array and returns them as a Stack.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| base | void\* | Pointer to array base |
| elemSize | size_t | Size of each element |
| count | size_t | Number of elements |
| cmp | function | Comparison function (returns 1 if equal) |

**Returns:** Stack containing unique elements (LIFO order). Caller must free with stackDestroy.

**Example:**
```c
int arr[] = {1, 2, 3, 2, 1, 4, 3};
Stack *unique = getUniqueStackFromArray(arr, sizeof(int), 7, cmp_int);

while (!isStackEmpty(unique)) {
    int *val = (int *)stackPop(unique);
    printf("%d ", *val);
}
// Output: 4 3 2 1 (order may vary)
stackDestroy(&unique);
```

---

## getUniqueArrayFromArray

```c
void *getUniqueArrayFromArray(const void *base, size_t elemSize, size_t count,
                              int (*cmp)(const void *, const void *));
```

Extracts unique elements from an array and returns them as a new array.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| base | void\* | Pointer to array base |
| elemSize | size_t | Size of each element |
| count | size_t | Number of elements |
| cmp | function | Comparison function (returns 1 if equal) |

**Returns:** Newly allocated array with unique elements, or NULL on failure. Caller must free.

**Example:**
```c
int arr[] = {1, 2, 3, 2, 1, 4, 3};
int *unique = getUniqueArrayFromArray(arr, sizeof(int), 7, cmp_int);
// unique now contains {1, 2, 3, 4} or similar
free(unique);
```