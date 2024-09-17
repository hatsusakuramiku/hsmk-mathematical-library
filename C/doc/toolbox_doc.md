# 说明

本文件是[toolbox.c](/C/srcrc/Toolbox/toolbox.c)和[toolbox.h](/C/includede/Toolbox/toolbox.h)
的简要说明文档。简要说明其中可供外部调用的函数/宏定义的功能和用法。

### **ARRAY2PTR**

说明: 将静态数组转换为动态数组的宏定义。

定义如下：

```C
/**
 * Converts a fixed-size array to a dynamically allocated pointer.
 *
 * This macro allocates memory for a new array of the same type and length as the input array,
 * copies the contents of the input array to the new array, and returns a pointer to the new array.
 *
 * @param type The type of the elements in the array.
 * @param array The input array to be converted.
 * @param len The length of the input array.
 *
 * @return A pointer to the newly allocated array, or NULL on failure.
 */
#define ARRAY2PTR(type, array, len)                                                              \
    ({                                                                                           \
        type *ptr = NULL;                                                                        \
        if (array != NULL && len > 0)                                                            \
        {                                                                                        \
            /* Allocate memory for a new array of the same type and length as the input array */ \
            ptr = (type *)malloc(sizeof(type) * len);                                            \
            if (ptr != NULL)                                                                     \
            {                                                                                    \
                /* Copy the contents of the input array to the new array */                      \
                memcpy(ptr, array, sizeof(type) * len);                                          \
            }                                                                                    \
            else                                                                                 \
            {                                                                                    \
                /* Error handling: memory allocation failed */                                   \
                fprintf(stderr, "Error: memory allocation failed\n");                            \
            }                                                                                    \
        }                                                                                        \
        /* Return the pointer to the new array, or NULL on failure */                            \
        ptr;                                                                                     \
    })
```

### **isMember**

说明： 判断某个元素是否在数组中。

函数原型：

```C
int isMember(const void *ptr, const void *base, size_t elemSize, size_t count,
                    int (*cmp)(const void *, const void *))
```

**Input**:

| name     | type                                | description     | required                                 |
|----------|-------------------------------------|-----------------|------------------------------------------|
| ptr      | void*                               | 指向待判断元素的指针      | 不可为NULL                                  |
| base     | void*                               | 指向数组首元素的指针      | 不可为NULL                                  |
| elemSize | size_t                              | 数组中每个元素的大小      | 不可为0                                     |
| count    | size_t                              | 数组中元素的数量        | 不可为0                                     |
| cmp      | int (*)(const void *, const void *) | 比较函数，用于比较元素是否相等 | 不可为NULL ,需要用户自己实现，要求返回 1 表示相等，返回 0 表示不相等 |

**Output**:

| type | description                                                             |
|------|-------------------------------------------------------------------------|
| int  | 1 表示相等，0 表示不相等,-1 表示指向数组首元素的指针、表示指向待判断元素的指针、 元素大小、元素数量和比较函数中至少一个为NULL或0 |

使用示例:

```C
int cmp(const void *a, const void *b) {
 return *(int *) a == *(int *) b;
}

void main(void) {
 int arr[] = {1, 2, 3, 4, 5};
 int a = 1;
 printf("is a = %d in arr? %s\n", a, isMember(&a, arr, sizeof(int), 5, cmp) ? "yes" : "no");
}

//预览结果如下
is a = 1 in arr? yes
```

### **getUniqueStackFromArray**

说明：获取数组中唯一元素，并以栈的形式返回。注意：此处的栈为本项目中定义的栈类型，具体请参考[stack_doc.md](/C/dococ/stack_doc.md)。

函数原型：

```C
Stack *getUniqueStackFromArray(const void *base, size_t elemSize, size_t count, int (*cmp)(const void *, const void *))
```

**Input**:

| name     | type                                | description     | required                                 |
|----------|-------------------------------------|-----------------|------------------------------------------|
| base     | void*                               | 指向数组首元素的指针      | 不可为NULL                                  |
| elemSize | size_t                              | 数组中每个元素的大小      | 不可为0                                     |
| count    | size_t                              | 数组中元素的数量        | 不可为0                                     |
| cmp      | int (*)(const void *, const void *) | 比较函数，用于比较元素是否相等 | 不可为NULL ,需要用户自己实现，要求返回 1 表示相等，返回 0 表示不相等 |

**Output**:

| type   | description         |
|--------|---------------------|
| Stack* | 返回一个栈，栈中存储的是数组中唯一元素 |

使用示例:

```C
int cmp(const void *a, const void *b) {
 return *(int *) a == *(int *) b;
}

void main(void) {
 int arr[] = {1, 2, 3, 4, 5, 1, 2, 3, 4, 5};
 Stack *stack = getUniqueStackFromArray(arr, sizeof(int), 10, cmp);
 while (!isStackEmpty(stack)) {
  const int data = *(int *) stackPop(stack);
  printf("%d\n", data);
 }
}

//预览结果如下
5
4
3
2
1
```

### **getUniqueArrayFromArray**

说明：获取数组中唯一元素，并以数组的形式返回。

函数原型：

```C
void *getUniqueArrayFromArray(const void *base, size_t elemSize, size_t count, int (*cmp)(const void *, const void *))
```

**Input**:

| name     | type                                | description     | required                                 |
|----------|-------------------------------------|-----------------|------------------------------------------|
| base     | void*                               | 指向数组首元素的指针      | 不可为NULL                                  |
| elemSize | size_t                              | 数组中每个元素的大小      | 不可为0                                     |
| count    | size_t                              | 数组中元素的数量        | 不可为0                                     |
| cmp      | int (*)(const void *, const void *) | 比较函数，用于比较元素是否相等 | 不可为NULL ,需要用户自己实现，要求返回 1 表示相等，返回 0 表示不相等 |

**Output**:

| type  | description              |
|-------|--------------------------|
| void* | 返回一个数组，数组中存储的是被比较数组中唯一元素 |

使用示例:

```C
int cmp(const void *a, const void *b) {
 return *(int *) a == *(int *) b;
}

void main(void) {
 int arr[] = {1, 2, 3, 4, 5, 1, 2, 3, 4, 5};
 int *uniqueArr = (int *) getUniqueArrayFromArray(arr, sizeof(int), 10, cmp);
 for (int i = 0; i < 5; i++) {
  printf("%d\n", uniqueArr[i]);
 }
}

//预览结果如下
5
4
3
2
1
```
