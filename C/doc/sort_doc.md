# **注意**

因代码还在不断完善中，此文档有一定滞后性，仅作为参考。

**本项目实现的所有排序算法，使用默认提供的比较函数，得到的结果均为升序**

# 说明

排序相关内容，以实现函数/方法及其说明如下：

## 排序说明

实现了一些简单的排序算法，尽可能保证可扩展性。
简单地比较了已实现的排序函数在不同数组规模下完成一次排序所需的时间，并不严谨，仅作参考，其图如下:

1. 在 $1~20\times 10^4$ 规模下，不同排序算法的完成一次排序所需时间，其中quickSort使用C的库函数 'qsort'：
   ![sortCmpAll1e4](/C/dococ/sortCmpAll1e4.jpg)
   ![sortCmpQuickPart1e4](/C/dococ/sortCmpQuickPart1e4.jpg)
2. 在 $1~20\times 10^5$ 规模下，几种较快的排序算法完成一次排序所需时间，其中quickSort使用C的库函数 'qsort'：
   ![sortCmpQuickPart1e5](/C/dococ/sortCmpQuickPart1e5.jpg)

## 排序比较函数

为保证可扩展性，针对不同类型的数据的比较函数需要用户自行实现，其基础类型定义如下：

```C
/**
 * @brief Function pointer type for a comparison function with an additional argument.
 *
 * This type represents a function that takes three arguments:
 *   - Two const void pointers to the elements to be compared
 *   - A void pointer to an additional argument (e.g., user data)
 * The function returns an integer indicating the result of the comparison.
 *
 * The return value is expected to be:
 *   - Negative if the first element is less than the second element
 *   - Zero if the elements are equal
 *   - Positive if the first element is greater than the second element
 */
 /**
 * @brief 带有附加参数的比较函数的函数指针类型。
 *
 * 此类型代表一个函数，该函数接受三个参数：
 *   1. 两个指向要比较的元素的 const void 指针
 *   2. 一个指向附加参数的 void 指针（例如，用户数据）
 * 该函数返回一个整数，表示比较的结果。
 *
 * 返回值预期为：
 *   - 如果第一个元素小于第二个元素，则返回负数
 *   - 如果元素相等，则返回零
 *   - 如果第一个元素大于第二个元素，则返回正数
 */
typedef int (*default_compare_s)(const void *, const void *, const void *);

/**
 * @brief Function pointer type for a comparison function.
 *
 * This type represents a function that takes two const void pointers to the elements to be compared.
 * The function returns an integer indicating the result of the comparison.
 *
 * The return value is expected to be:
 *   - Negative if the first element is less than the second element
 *   - Zero if the elements are equal
 *   - Positive if the first element is greater than the second element
 */
 /**
 * @brief 比较函数的函数指针类型。
 *
 * 此类型代表一个函数，该函数接受两个 const void 指针作为参数，指向要比较的元素。
 * 该函数返回一个整数，表示比较的结果。
 *
 * 返回值预期为：
 *   - 如果第一个元素小于第二个元素，则返回负数
 *   - 如果元素相等，则返回零
 *   - 如果第一个元素大于第二个元素，则返回正数
 */
typedef int (*default_compare)(const void *, const void *);
```

如果定义的比较函数的返回值符合上述要求，直接使用提供的排序函数进行排序，排序后的结果是从小到大排列的；如果排序函数的返回值满足：第一个元素小于第二个元素，则返回正数，如果元素相等，则返回零，如果第一个元素大于第二个元素，则返回负数。
则直接使用提供的排序函数进行排序，排序后的结果是从大到小排列的。

### 默认的比较函数

为方便使用，针对一维和二维的double 类型的数组，提供了默认的比较函数：

#### **default_compare_example**

说明： 将 double 类型的一维数组按照从小到大的顺序进行排序的比较函数。

函数原型：

```C
int default_compare_example(const void *a, const void *b);
```

**Input**:

| name | type  | description   | required |
|------|-------|---------------|----------|
| 'a'  | void* | 指向第一个被比较元素的指针 |          |
| 'b'  | void* | 指向第一个被比较元素的指针 |          |

**Output**:

| type | description                      |
|------|----------------------------------|
| int  | 比较结果，若a>b，值为1；若a=b，值为0；若a<b，值为-1 |

**使用示例**:

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    Matrix *mat = rand_matrix(4, 4, 0, 10);// 生成一个4行4列的值介于0~10的随机矩阵
    printf("before sort:\n");
    matrix_print(mat);// 打印矩阵
    quickSort(mat->data, mat->cols * mat->rows, sizeof(MATRIX_TYPE), default_compare_example);// 使用默认的比较函数进行排序
    printf("after sort:\n");
    matrix_print(mat);
}

//预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   0.149841   1.741028   1.932983 | 
|   3.039856   3.502808   4.798584   5.135193 | 
|   5.635681   5.849915   7.104797   7.465820 | 
|   8.087158   8.228149   8.589172   8.959351 | 
Matrix rows: 4, cols: 4
```

#### **default_compare_example_s**

说明： 将 double 类型的二维数组按照从大到小的顺序进行排序的比较函数。

函数原型：

```C
int default_compare_example_s(const void *a, const void *b, const void *c);
```

**Input**:

| name | type  | description   | required                                 |
|------|-------|---------------|------------------------------------------|
| 'a'  | void* | 指向第一个被比较元素的指针 |                                          |
| 'b'  | void* | 指向第一个被比较元素的指针 |                                          |
| 'c'  | void* | 指向附加参数的指针     | 值应为整数类型；其范围不可超过数组索引范围，否则可能导致程序崩溃或出现未定义行为 |

**Output**:

| type | description                      |
|------|----------------------------------|
| int  | 比较结果，若a>b，值为1；若a=b，值为0；若a<b，值为-1 |

**使用示例**:

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    // 设置标准输出缓冲区为无缓冲
    setbuf(stdout, NULL); // puts到输出台上

    // 生成一个4行4列的随机矩阵，值范围为0~10
    Matrix *mat = rand_matrix(4, 4, 0, 10);

    // 将矩阵转换为二维数组
    MATRIX_TYPE **mat_to_2D_array = matrix_to_2D_array(mat);

    // 打印矩阵排序前结果
    printf("before sort:\n");
    matrix_print(mat);

    // 以数组每一行第一个元素的值作为键对每一行进行排序
    quickSort_s(mat_to_2D_array, 0, mat->rows, sizeof(MATRIX_TYPE *), default_compare_example_s);

    // 打印矩阵排序后结果
    printf("after sort:\n");
    matrix_print(matrix_from_2D_array(mat_to_2D_array, 4, 4));
}

// 预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   7.104797   5.135193   3.039856   0.149841 | 
|   8.228149   7.465820   1.741028   8.589172 | 
Matrix rows: 4, cols: 4
```

## 排序函数

### **quickSort**

---
**暂时弃用**
---

说明： 快速排序，参考开源项目[glibc](https://github.com/bminor/glibc/blob/master)
的[实现](https://github.com/bminor/glibc/blob/master/stdlib/qsort.c)。这个排序算法非常快，平均时间复杂度为 O(n log
n)。

函数原型：

```C
void quickSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);
```

**Input**:

| name       | type            | description | required |
|------------|-----------------|-------------|----------|
| 'array'    | void*           | 指向待排序数组的指针  |          |
| 'elemNum'  | size_t          | 数组中元素的数量    |          |
| 'elemSize' | size_t          | 数组中每个元素的大小  |          |
| 'compare'  | default_compare | 比较函数        |          |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    Matrix *mat = rand_matrix(4, 4, 0, 10);// 生成一个4行4列的值介于0~10的随机矩阵
    printf("before sort:\n");
    matrix_print(mat);// 打印矩阵
    quickSort(mat->data, mat->cols * mat->rows, sizeof(MATRIX_TYPE), default_compare_example);// 使用默认的比较函数进行排序
    printf("after sort:\n");
    matrix_print(mat);
}

//预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   0.149841   1.741028   1.932983 | 
|   3.039856   3.502808   4.798584   5.135193 | 
|   5.635681   5.849915   7.104797   7.465820 | 
|   8.087158   8.228149   8.589172   8.959351 | 
Matrix rows: 4, cols: 4
```

### **quickSort_s**

---
**暂时弃用**
---


说明： 快速排序，参考开源项目[glibc](https://github.com/bminor/glibc/blob/master)
的[实现](https://github.com/bminor/glibc/blob/master/stdlib/qsort.c)。这个排序算法非常快，平均时间复杂度为 O(n log
n)。

函数原型：

```C
void quickSort_s(void *array, void *arg, size_t elemNum, size_t elemSize, default_compare_s compare);
```

**Input**:

| name       | type              | description | required |
|------------|-------------------|-------------|----------|
| 'array'    | void*             | 指向待排序数组的指针  |          |
| 'arg'      | void*             | 传递给比较函数的参数  |          |
| 'elemNum'  | size_t            | 数组中元素的数量    |          |
| 'elemSize' | size_t            | 数组中每个元素的大小  |          |
| 'compare'  | default_compare_s | 比较函数        |          |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    // 设置标准输出缓冲区为无缓冲
    setbuf(stdout, NULL); // puts到输出台上

    // 生成一个4行4列的随机矩阵，值范围为0~10
    Matrix *mat = rand_matrix(4, 4, 0, 10);

    // 将矩阵转换为二维数组
    MATRIX_TYPE **mat_to_2D_array = matrix_to_2D_array(mat);

    // 打印矩阵排序前结果
    printf("before sort:\n");
    matrix_print(mat);

    // 以数组每一行第一个元素的值作为键对每一行进行排序
    quickSort_s(mat_to_2D_array, 0, mat->rows, sizeof(MATRIX_TYPE *), default_compare_example_s);

    // 打印矩阵排序后结果
    printf("after sort:\n");
    matrix_print(matrix_from_2D_array(mat_to_2D_array, 4, 4));
}

// 预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   7.104797   5.135193   3.039856   0.149841 | 
|   8.228149   7.465820   1.741028   8.589172 | 
Matrix rows: 4, cols: 4
```

### **bubbleSort**

说明： 冒泡排序，时间复杂度为 $O(n^2)$。

函数原型：

```C
void bubbleSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);
```

**Input**:

| name       | type            | description | required |
|------------|-----------------|-------------|----------|
| 'array'    | void*           | 指向待排序数组的指针  |          |
| 'elemNum'  | size_t          | 数组中元素的数量    |          |
| 'elemSize' | size_t          | 数组中每个元素的大小  |          |
| 'compare'  | default_compare | 比较函数        |          |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    Matrix *mat = rand_matrix(4, 4, 0, 10);// 生成一个4行4列的值介于0~10的随机矩阵
    printf("before sort:\n");
    matrix_print(mat);// 打印矩阵
    bubbleSort(mat->data, mat->cols * mat->rows, sizeof(MATRIX_TYPE), default_compare_example);// 使用默认的比较函数进行排序
    printf("after sort:\n");
    matrix_print(mat);
}

//预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   0.149841   1.741028   1.932983 | 
|   3.039856   3.502808   4.798584   5.135193 | 
|   5.635681   5.849915   7.104797   7.465820 | 
|   8.087158   8.228149   8.589172   8.959351 | 
Matrix rows: 4, cols: 4
```

### **bubbleSort_s**

说明： 冒泡排序，时间复杂度为 $O(n^2)$。

函数原型：

```C
void bubbleSort_s(void *array, void *arg, size_t elemNum, size_t elemSize, default_compare_s compare);
```

**Input**:

| name       | type              | description | required |
|------------|-------------------|-------------|----------|
| 'array'    | void*             | 指向待排序数组的指针  |          |
| 'arg'      | void*             | 传递给比较函数的参数  |          |
| 'elemNum'  | size_t            | 数组中元素的数量    |          |
| 'elemSize' | size_t            | 数组中每个元素的大小  |          |
| 'compare'  | default_compare_s | 比较函数        |          |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    // 设置标准输出缓冲区为无缓冲
    setbuf(stdout, NULL); // puts到输出台上

    // 生成一个4行4列的随机矩阵，值范围为0~10
    Matrix *mat = rand_matrix(4, 4, 0, 10);

    // 将矩阵转换为二维数组
    MATRIX_TYPE **mat_to_2D_array = matrix_to_2D_array(mat);

    // 打印矩阵排序前结果
    printf("before sort:\n");
    matrix_print(mat);

    // 以数组每一行第一个元素的值作为键对每一行进行排序
    bubbleSort_s(mat_to_2D_array, 0, mat->rows, sizeof(MATRIX_TYPE *), default_compare_example_s);

    // 打印矩阵排序后结果
    printf("after sort:\n");
    matrix_print(matrix_from_2D_array(mat_to_2D_array, 4, 4));
}

// 预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   7.104797   5.135193   3.039856   0.149841 | 
|   8.228149   7.465820   1.741028   8.589172 | 
Matrix rows: 4, cols: 4
```

### **insertionSort**

说明： 插入排序，时间复杂度为 $O(n)$。

函数原型：

```C
void insertionSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);
```

**Input**:

| name       | type            | description | required |
|------------|-----------------|-------------|----------|
| 'array'    | void*           | 指向待排序数组的指针  |          |
| 'elemNum'  | size_t          | 数组中元素的数量    |          |
| 'elemSize' | size_t          | 数组中每个元素的大小  |          |
| 'compare'  | default_compare | 比较函数        |          |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    Matrix *mat = rand_matrix(4, 4, 0, 10);// 生成一个4行4列的值介于0~10的随机矩阵
    printf("before sort:\n");
    matrix_print(mat);// 打印矩阵
    insertionSort(mat->data, mat->cols * mat->rows, sizeof(MATRIX_TYPE), default_compare_example);// 使用默认的比较函数进行排序
    printf("after sort:\n");
    matrix_print(mat);
}

//预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   0.149841   1.741028   1.932983 | 
|   3.039856   3.502808   4.798584   5.135193 | 
|   5.635681   5.849915   7.104797   7.465820 | 
|   8.087158   8.228149   8.589172   8.959351 | 
Matrix rows: 4, cols: 4
```

### **insertionSort_s**

说明： 插入排序，时间复杂度为 $O(n)$。

函数原型：

```C
void insertionSort_s(void *array, void *arg, size_t elemNum, size_t elemSize, default_compare_s compare);
```

**Input**:

| name       | type              | description | required |
|------------|-------------------|-------------|----------|
| 'array'    | void*             | 指向待排序数组的指针  |          |
| 'arg'      | void*             | 传递给比较函数的参数  |          |
| 'elemNum'  | size_t            | 数组中元素的数量    |          |
| 'elemSize' | size_t            | 数组中每个元素的大小  |          |
| 'compare'  | default_compare_s | 比较函数        |          |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    // 设置标准输出缓冲区为无缓冲
    setbuf(stdout, NULL); // puts到输出台上

    // 生成一个4行4列的随机矩阵，值范围为0~10
    Matrix *mat = rand_matrix(4, 4, 0, 10);

    // 将矩阵转换为二维数组
    MATRIX_TYPE **mat_to_2D_array = matrix_to_2D_array(mat);

    // 打印矩阵排序前结果
    printf("before sort:\n");
    matrix_print(mat);

    // 以数组每一行第一个元素的值作为键对每一行进行排序
    insertionSort_s(mat_to_2D_array, 0, mat->rows, sizeof(MATRIX_TYPE *), default_compare_example_s);

    // 打印矩阵排序后结果
    printf("after sort:\n");
    matrix_print(matrix_from_2D_array(mat_to_2D_array, 4, 4));
}

// 预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   7.104797   5.135193   3.039856   0.149841 | 
|   8.228149   7.465820   1.741028   8.589172 | 
Matrix rows: 4, cols: 4
```

### **selectionSort**

说明： 选择排序，时间复杂度为 $O(n^2)$。

函数原型：

```C
void selectionSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);
```

**Input**:

| name       | type            | description | required |
|------------|-----------------|-------------|----------|
| 'array'    | void*           | 指向待排序数组的指针  |          |
| 'elemNum'  | size_t          | 数组中元素的数量    |          |
| 'elemSize' | size_t          | 数组中每个元素的大小  |          |
| 'compare'  | default_compare | 比较函数        |          |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    Matrix *mat = rand_matrix(4, 4, 0, 10);// 生成一个4行4列的值介于0~10的随机矩阵
    printf("before sort:\n");
    matrix_print(mat);// 打印矩阵
    selectionSort(mat->data, mat->cols * mat->rows, sizeof(MATRIX_TYPE), default_compare_example);// 使用默认的比较函数进行排序
    printf("after sort:\n");
    matrix_print(mat);
}

//预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   0.149841   1.741028   1.932983 | 
|   3.039856   3.502808   4.798584   5.135193 | 
|   5.635681   5.849915   7.104797   7.465820 | 
|   8.087158   8.228149   8.589172   8.959351 | 
Matrix rows: 4, cols: 4
```

### **selectionSort_s**

说明： 选择排序，时间复杂度为 $O(n^2)$。

函数原型：

```C
void selectionSort_s(void *array, void *arg, size_t elemNum, size_t elemSize, default_compare_s compare);
```

**Input**:

| name       | type              | description | required |
|------------|-------------------|-------------|----------|
| 'array'    | void*             | 指向待排序数组的指针  |          |
| 'arg'      | void*             | 传递给比较函数的参数  |          |
| 'elemNum'  | size_t            | 数组中元素的数量    |          |
| 'elemSize' | size_t            | 数组中每个元素的大小  |          |
| 'compare'  | default_compare_s | 比较函数        |          |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    // 设置标准输出缓冲区为无缓冲
    setbuf(stdout, NULL); // puts到输出台上

    // 生成一个4行4列的随机矩阵，值范围为0~10
    Matrix *mat = rand_matrix(4, 4, 0, 10);

    // 将矩阵转换为二维数组
    MATRIX_TYPE **mat_to_2D_array = matrix_to_2D_array(mat);

    // 打印矩阵排序前结果
    printf("before sort:\n");
    matrix_print(mat);

    // 以数组每一行第一个元素的值作为键对每一行进行排序
    selectionSort_s(mat_to_2D_array, 0, mat->rows, sizeof(MATRIX_TYPE *), default_compare_example_s);

    // 打印矩阵排序后结果
    printf("after sort:\n");
    matrix_print(matrix_from_2D_array(mat_to_2D_array, 4, 4));
}

// 预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   7.104797   5.135193   3.039856   0.149841 | 
|   8.228149   7.465820   1.741028   8.589172 | 
Matrix rows: 4, cols: 4
```

### **mergeSort_s**

说明: 归并排序，时间复杂度为 $O(n\log{n})
$。因为归并排序会使用较大量的临时空间，因此当可分配临时内存不足时，为保证排序完成，将使用[堆排序](/C/dococ/sort_doc.md#heapsort_s)。

函数原型：

```C
void mergeSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg)
```

**Input**:

| name       | type              | description   | required |
|------------|-------------------|---------------|----------|
| 'array'    | void*             | 指向待排序数组的指针    | 不可为NULL  |
| 'elemNum'  | size_t            | 数组中元素的数量      | 需要大于1    |
| 'elemSize' | size_t            | 数组中每个元素的大小    | 不可为0     |
| 'compare'  | default_compare_s | 比较函数，需要用户自行实现 | 不可为NULL  |
| 'arg'      | void*             | 传递给比较函数的参数    |          |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    // 设置标准输出缓冲区为无缓冲
    setbuf(stdout, NULL); // puts到输出台上

    // 生成一个4行4列的随机矩阵，值范围为0~10
    Matrix *mat = rand_matrix(4, 4, 0, 10);

    // 将矩阵转换为二维数组
    MATRIX_TYPE **mat_to_2D_array = matrix_to_2D_array(mat);

    // 打印矩阵排序前结果
    printf("before sort:\n");
    matrix_print(mat);

    // 以数组每一行第一个元素的值作为键对每一行进行排序
    mergeSort_s(mat_to_2D_array, 0, mat->rows, sizeof(MATRIX_TYPE *), default_compare_example_s);

    // 打印矩阵排序后结果
    printf("after sort:\n");
    matrix_print(matrix_from_2D_array(mat_to_2D_array, 4, 4));
}

// 预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   7.104797   5.135193   3.039856   0.149841 | 
|   8.228149   7.465820   1.741028   8.589172 | 
Matrix rows: 4, cols: 4
```

### **mergeSort**

说明： 归并排序，时间复杂度为 $O(n\log{n})$。

函数原型：

```C
void mergeSort(void *array, size_t elemNum, size_t elemSize, default_compare compare)
```

**Input**:

| name       | type            | description   | required |
|------------|-----------------|---------------|----------|
| 'array'    | void*           | 指向待排序数组的指针    | 不可为NULL  |
| 'elemNum'  | size_t          | 数组中元素的数量      | 需要大于1    |
| 'elemSize' | size_t          | 数组中每个元素的大小    | 不可为0     |
| 'compare'  | default_compare | 比较函数，需要用户自行实现 | 不可为NULL  |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    Matrix *mat = rand_matrix(4, 4, 0, 10);// 生成一个4行4列的值介于0~10的随机矩阵
    printf("before sort:\n");
    matrix_print(mat);// 打印矩阵
    mergeSort(mat->data, mat->cols * mat->rows, sizeof(MATRIX_TYPE), default_compare_example);// 使用默认的比较函数进行排序
    printf("after sort:\n");
    matrix_print(mat);
}

//预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   0.149841   1.741028   1.932983 | 
|   3.039856   3.502808   4.798584   5.135193 | 
|   5.635681   5.849915   7.104797   7.465820 | 
|   8.087158   8.228149   8.589172   8.959351 | 
Matrix rows: 4, cols: 4
```

### **heapSort_s**

说明： 堆排序，时间复杂度为 $O(n\log{n})$。

函数原型：

```C
void heapSort_s(void *array, size_t elemNum, size_t elemSize, default_compare compare, void *arg);
```

**Input**:

| name       | type            | description      | required |
|------------|-----------------|------------------|----------|
| 'array'    | void*           | 指向待排序数组的指针       | 不可为NULL  |
| 'elemNum'  | size_t          | 数组中元素的数量         | 需要大于1    |
| 'elemSize' | size_t          | 数组中每个元素的大小       | 不可为0     |
| 'compare'  | default_compare | 比较函数，需要用户自行实现    | 不可为NULL  |
| 'arg'      | void*           | 比较函数的参数，需要用户自行实现 | 可以为NULL  |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    // 设置标准输出缓冲区为无缓冲
    setbuf(stdout, NULL); // puts到输出台上

    // 生成一个4行4列的随机矩阵，值范围为0~10
    Matrix *mat = rand_matrix(4, 4, 0, 10);

    // 将矩阵转换为二维数组
    MATRIX_TYPE **mat_to_2D_array = matrix_to_2D_array(mat);

    // 打印矩阵排序前结果
    printf("before sort:\n");
    matrix_print(mat);

    // 以数组每一行第一个元素的值作为键对每一行进行排序
    heapSort_s(mat_to_2D_array, 0, mat->rows, sizeof(MATRIX_TYPE *), default_compare_example_s);

    // 打印矩阵排序后结果
    printf("after sort:\n");
    matrix_print(matrix_from_2D_array(mat_to_2D_array, 4, 4));
}

// 预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   7.104797   5.135193   3.039856   0.149841 | 
|   8.228149   7.465820   1.741028   8.589172 | 
Matrix rows: 4, cols: 4
```

### **heapSort**

说明： 堆排序，时间复杂度为 $O(n\log{n})$。

函数原型：

```C
void heapSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);
```

**Input**:

| name       | type   | description | required |
|------------|--------|-------------|----------|
| 'array'    | void*  | 指向待排序数组的指针  | 不可为NULL  |
| 'elemNum'  | size_t | 数组中元素的数量    | 需要大于1    |
| 'elemSize' | size_t | 数组中每个元素的大小  | 不可为0     |

**Output**:

| type | description        |
|------|--------------------|
| void | 无返回值，排序结果直接在原数组上修改 |

**使用示例**：

```C
#include "matrix.h"
#include  "sort.h"
void main(int argc, char *argv[]) {
    Matrix *mat = rand_matrix(4, 4, 0, 10);// 生成一个4行4列的值介于0~10的随机矩阵
    printf("before sort:\n");
    matrix_print(mat);// 打印矩阵
    heapSort(mat->data, mat->cols * mat->rows, sizeof(MATRIX_TYPE), default_compare_example);// 使用默认的比较函数进行排序
    printf("after sort:\n");
    matrix_print(mat);
}

//预览结果如下
before sort:
|   0.012512   5.635681   1.932983   8.087158 | 
|   5.849915   4.798584   3.502808   8.959351 | 
|   8.228149   7.465820   1.741028   8.589172 | 
|   7.104797   5.135193   3.039856   0.149841 | 
Matrix rows: 4, cols: 4
after sort:
|   0.012512   0.149841   1.741028   1.932983 | 
|   3.039856   3.502808   4.798584   5.135193 | 
|   5.635681   5.849915   7.104797   7.465820 | 
|   8.087158   8.228149   8.589172   8.959351 | 
Matrix rows: 4, cols: 4
```