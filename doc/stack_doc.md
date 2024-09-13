# 说明

本文件是[stack.c](/src/Stack/stack.c)和[stack.h](/include/Stack/stack.h)的简要说明文档。简要说明其中可供外部调用的函数/宏定义的功能和用法。

栈(stack)是一种先进后出(FILO)的数据结构，常见的实现有数组型和链表型。为提高可扩展性，本项目采用链表型栈。

## 栈的类型定义

```C
// 定义栈中元素的类型为无符号指针，以确保其可扩展性
typedef void *stackElem; 

// 定义栈节点类型
typedef struct _StackNode {
    stackElem data;
    struct _StackNode *next;
    size_t elemSize;// 栈元素的大小，为了确保其可扩展性，每个栈节点的元素大小不一定相同，这意味着不同类型的元素可以存储在同一个栈中
} StackNode;

// 定义栈类型
typedef struct _Stack {
    StackNode *head;// 栈顶指针
    StackNode *tail;// 栈底指针
    int size;
} Stack;


// 定义带有大小的栈元素类型
typedef struct _stackElemWithSize {
    stackElem data;
    size_t elemSize;
} stackElemWithSize;

```

在向栈中添加节点时必须指定其元素的大小，为方便使用，这里定义了一些常见类型的栈元素大小。

```C
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

## 栈相关函数

### **stackInit**

说明: 初始化栈，并返回一个指向该栈的指针，必须先初始化栈后才能使用栈。

函数原型:

```C
Stack *stackInit();
```

**Output**

| type    | description                  |
|---------|------------------------------|
| Stack * | 指向初始化后的栈的指针，如果内存分配失败，返回 NULL |

**使用示例**

```C
Stack *stack = stackInit();
```

### **stackClear**

说明: 清空栈，释放栈中所有节点的内存，但保留栈本身。

函数原型:

```C
void stackClear(Stack *stack);
```

**Input**

| name  | type    | description | required |
|-------|---------|-------------|----------|
| stack | Stack * | 指向栈的指针      | 不可为NULL  |

使用示例:

```C
stackClear(stack);
```

### **stackDestroy**

说明: 释放栈，释放栈中所有节点的内存，并且释放栈的内存并将指向该栈的指针设置为 NULL。

函数原型:

```C
void stackDestroy(Stack **stack);
```

**Input**

| name  | type     | description | required |
|-------|----------|-------------|----------|
| stack | Stack ** | 指向栈的指针的指针   | 不可为NULL  |

使用示例:

```C
stackDestroy(&stack);
```

### **stackPush**

说明: 向栈中添加一个元素。

函数原型:

```C
void stackPush(Stack *stack, stackElem elem, size_t elemSize);
```

**Input**

| name     | type      | description | required |
|----------|-----------|-------------|----------|
| stack    | Stack *   | 指向栈的指针      | 不可为NULL  |
| elem     | stackElem | 要添加的元素      | 不可为NULL  |
| elemSize | size_t    | 要添加的元素的大小   | 不可为0     |

使用示例:

```C
int a = 10;
stackPush(stack, &a, STACK_TYPE_SIZE_INT);
```

### **stackPop**

说明: 弹出栈顶元素，如果栈为空，则返回 NULL。

函数原型:

```C
stackElem stackPop(Stack *stack);
```

**Input**

| name  | type    | description | required |
|-------|---------|-------------|----------|
| stack | Stack * | 指向栈的指针      | 不可为NULL  |

**Output**

| type      | description                |
|-----------|----------------------------|
| stackElem | 弹出的元素，不含元素大小，如果栈为空，返回 NULL |

使用示例:

```C
int a = 10;
stackPush(stack, &a, STACK_TYPE_SIZE_INT);
int a = *(int*)stackPop(stack);
```

### **stackBottom**

说明: 返回栈底元素，如果栈为空，则返回 NULL。

函数原型:

```C
stackElem stackBottom(Stack *stack);
```

**Input**

| name  | type    | description | required |
|-------|---------|-------------|----------|
| stack | Stack * | 指向栈的指针      | 不可为NULL  |

**Output**

| type      | description               |
|-----------|---------------------------|
| stackElem | 栈底元素，不含元素大小，如果栈为空，返回 NULL |

使用示例:

```C
int a = 10;
stackPush(stack, &a, STACK_TYPE_SIZE_INT);
int a = *(int*)stackBottom(stack);
```

### **stackTop**

说明: 返回栈顶元素，如果栈为空，则返回 NULL。

函数原型:

```C
stackElem stackTop(Stack *stack);
```

**Input**

| name  | type    | description | required |
|-------|---------|-------------|----------|
| stack | Stack * | 指向栈的指针      | 不可为NULL  |

**Output**

| type      | description               |
|-----------|---------------------------|
| stackElem | 栈顶元素，不含元素大小，如果栈为空，返回 NULL |

使用示例:

```C
int a = 10;
stackPush(stack, &a, STACK_TYPE_SIZE_INT);
int a = *(int*)stackTop(stack);
```

### **stackPopWithSize**

说明: 弹出栈顶元素，如果栈为空，则返回 NULL。

函数原型:

```C
stackElemWithSize stackPopWithSize(Stack *stack);
```

**Input**

| name  | type    | description | required |
|-------|---------|-------------|----------|
| stack | Stack * | 指向栈的指针      | 不可为NULL  |

**Output**

| type              | description               |
|-------------------|---------------------------|
| stackElemWithSize | 弹出的元素，含元素大小，如果栈为空，返回 NULL |

使用示例:

```C
int a = 10;
stackPush(stack, &a, STACK_TYPE_SIZE_INT);
int a = *(int*)stackPopWithSize(stack).data;
```

### **stackBottomWithSize**

说明: 返回栈底元素，如果栈为空，则返回 NULL。

函数原型:

```C
stackElemWithSize stackBottomWithSize(Stack *stack);
```

**Input**

| name  | type    | description | required |
|-------|---------|-------------|----------|
| stack | Stack * | 指向栈的指针      | 不可为NULL  |

**Output**

| type              | description              |
|-------------------|--------------------------|
| stackElemWithSize | 栈底元素，含元素大小，如果栈为空，返回 NULL |

使用示例:

```C
int a = 10;
stackPush(stack, &a, STACK_TYPE_SIZE_INT);
int a = *(int*)stackBottomWithSize(stack).data;
```

### **stackTopWithSize**

说明: 返回栈顶元素，如果栈为空，则返回 NULL。

函数原型:

```C
stackElemWithSize stackTopWithSize(Stack *stack);
```

**Input**

| name  | type    | description | required |
|-------|---------|-------------|----------|
| stack | Stack * | 指向栈的指针      | 不可为NULL  |

**Output**

| type              | description              |
|-------------------|--------------------------|
| stackElemWithSize | 栈顶元素，含元素大小，如果栈为空，返回 NULL |

使用示例:

```C
int a = 10;
stackPush(stack, &a, STACK_TYPE_SIZE_INT);
int a = *(int*)stackTopWithSize(stack).data;
```

### **stackSize**

说明: 返回栈的大小。

函数原型:

```C
int stackSize(Stack *stack);
```

**Input**

| name  | type    | description | required |
|-------|---------|-------------|----------|
| stack | Stack * | 指向栈的指针      | 不可为NULL  |

**Output**

| type | description     |
|------|-----------------|
| int  | 栈的大小，如果栈为空，返回 0 |

使用示例:

```C
int size = stackSize(stack);
```

### **stackSwap**

说明: 反转栈中的元素。

函数原型:

```C
void stackSwap(Stack *stack);
```

**Input**

| name  | type    | description | required |
|-------|---------|-------------|----------|
| stack | Stack * | 指向栈的指针      | 不可为NULL  |

使用示例:

```C
void main(void) {
 Stack *stack = stackInit();
 int arr[] = {1, 2, 3, 4, 5};
 for (int i = 0; i < 5; i++) {
  stackPush(stack, &arr[i], STACK_TYPE_SIZE_INT);
 }
 int *tmp = stackToArray(stack);
 if (tmp != NULL) {
  printf("Before swap:\n");
  for (int i = 0; i < 5; i++) {
   printf("%d\n", tmp[i]);
  }
  FREE(tmp);
  printf("After swap:\n");
  stackSwap(stack);
  tmp = stackToArray(stack);
  for (int i = 0; i < 5; i++) {
   printf("%d\n", tmp[i]);
  }
 }
}

// 输出结果如下：
Before swap:
5
4
3
2
1
After swap:
1
2
3
4
5
```

### **isStackEmpty**

说明: 判断栈是否为空。

函数原型:

```C
int isStackEmpty(Stack *stack);
```

**Input**

| name  | type    | description | required |
|-------|---------|-------------|----------|
| stack | Stack * | 指向栈的指针      | 不可为NULL  |

**Output**

| type | description                   |
|------|-------------------------------|
| int  | 1 表示栈为空，0 表示栈不为空，-1 表示栈为 NULL |

使用示例:

```C
int isEmpty = isStackEmpty(stack);
```

### **isStackMember**

说明: 判断栈中是否存在某个元素。

函数原型:

```C
int isStackMember(Stack *stack, stackElemWithSize elem, int (*cmp)(const void *, const void *));
```

**Input**

| name  | type                                | description                                     | required |
|-------|-------------------------------------|-------------------------------------------------|----------|
| stack | Stack *                             | 指向栈的指针                                          | 不可为NULL  |
| elem  | stackElemWithSize                   | 要判断的元素，包含元素大小                                   | 不可为NULL  |
| cmp   | int (*)(const void *, const void *) | 比较函数，需要用户自行实现，用于比较元素，如果返回值为 1 表示相等，返回值为 0 表示不相等 | 不可为NULL  |

**Output**

| type | description                           |
|------|---------------------------------------|
| int  | 1 表示栈中存在该元素，0 表示栈中不存在该元素，-1 表示栈为 NULL |

使用示例:

```C
int isMember = isStackMember(stack, &a, cmp);
```

## **stackToArray**

说明: 将栈转换为数组。

函数原型:

```C
void *stackToArray(Stack *stack);
```

**Input**

| name  | type    | description | required               |
|-------|---------|-------------|------------------------|
| stack | Stack * | 指向栈的指针      | 不可为NULL；要求栈中每一个元素的大小相同 |

**Output**

| type   | description                                      |
|--------|--------------------------------------------------|
| void * | 指向转换后的数组的指针，如果栈为空，返回 NULL;数组的顺序与出栈的顺序相同，与入栈的顺序相反 |

使用示例（上文亦有示例[stackSwap](/doc/stack_doc.md#stackSwap)）:

```C
int *arr = stackToArray(stack);
```

### **stackCopy**

说明: 将栈拷贝到另一个栈。

函数原型:

```C
Stack *stackCopy(Stack *stack);
```

**Input**

| name  | type    | description | required |
|-------|---------|-------------|----------|
| stack | Stack * | 指向栈的指针      | 不可为NULL  |

**Output**

| type    | description              |
|---------|--------------------------|
| Stack * | 指向拷贝后的栈的指针，如果栈为空，返回 NULL |

使用示例：

```C
Stack *newStack = stackCopy(stack);
```