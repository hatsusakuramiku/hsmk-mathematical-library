# **注意**

因代码还在不断完善中，此文档有一定滞后性，仅作为参考。

## 说明

1. 此文档列出的所有函数，接受的数组均为动态数组，不可直接传入静态数组。若要使用静态数组，请使用 [ARRAY2PTR](/C/doc/toolbox_doc.md#ARRAY2PTR)
   将静态数组转换为动态数组。

2. 此文档列出的所有函数均未经针对性优化，故不建议用于处理总规模超过 $10^6$ 的矩阵。

## 矩阵基础类型定义

### 矩阵数据基础类型 **MATRIX_TYPE**

```C
typedef double MATRIX_TYPE;
```

```C
// 矩阵元素位置
typedef struct _elem_pos {
    unsigned int row;/// 所在行索引
    unsigned int col;/// 所在列索引
    MATRIX_TYPE value;
} elem_pos;

// 矩阵元素位置数组
typedef struct _elem_pos_array {
    struct _elem_pos *elem_pos_arr;// 矩阵元素位置数组
    unsigned int size;// 数组大小
} elem_pos_array;

```

本项目将向量视作行数/列数为 1 的矩阵，所以若函数兼容矩阵，则同样兼容向量。
但在未特别说明情况下，支持向量的函数不能支持矩阵。

```C
// 矩阵类型定义
typedef struct _Matrix
{
    unsigned int rows; /// 矩阵行数
    unsigned int cols; /// 矩阵列数
    MATRIX_TYPE *data; /// 矩阵的数据
} Matrix;

/**
 * @typedef MVector
 * @brief Alias for Matrix, representing a vector.
 *
 * This type alias is used to distinguish between matrix and vector operations,
 * although the underlying data structure is the same.
 */
typedef Matrix MVector;
```

**释义**:

| name   | type          | description | required                                    |
| ------ | ------------- | ----------- | ------------------------------------------- |
| 'rows' | unsigned int  | 矩阵行数    | 必须大于 0                                  |
| 'cols' | unsigned int  | 矩阵列数    | 必须大于 0                                  |
| 'data' | MATRIX_TYPE\* | 矩阵数据    | MATRIX_TYPE 默认类型为 double, 暂不可自定义 |

## 普通矩阵创建与矩阵销毁

### **matrix_gen**

说明: 由给定数据创建指定大小的矩阵，给定数据的长度必须小于等于指定矩阵的大小，长度不足时会自动补零。

函数原型:

```C
Matrix *matrix_gen(unsigned int rows, unsigned int cols, MATRIX_TYPE *data)
```

**Input**:

| name   | type          | description | required                                                                         |
| ------ | ------------- | ----------- | -------------------------------------------------------------------------------- |
| 'rows' | unsigned int  | 矩阵行数    | 必须大于 0                                                                       |
| 'cols' | unsigned int  | 矩阵列数    | 必须大于 0                                                                       |
| 'data' | MATRIX_TYPE\* | 矩阵数据    | data 的长度必须<= rows \* cols， 不足时会自动补零,故可以使用 NULL 以创建全零矩阵 |

**Output**:

| type     | description                     |
| -------- | ------------------------------- |
| Matrix\* | 行数为 rows，列数为 cols 的矩阵 |

**使用示例**:

```C
Matrix *mat = matrix_gen(3, 3, NULL);//创建一个3*3的全零矩阵
MATRIX_TYPE * data = (MATRIX_TYPE*)malloc(sizeof(MATRIX_TYPE) * 9);
for (int i = 0; i < 9; i++){
    data[i] = i + 1;
}
Matrix *mat_gen = matrix_gen(3, 3, data);//创建一个3*3的矩阵，数据为 1 2 3 4 5 6 7 8 9
Matrix *mat_gen_matrix = matrix_gen(mat->rows, mat->cols, mat->data);//使用已有矩阵数据创建新矩阵

// 若输入的 data 长度小于等于指定矩阵的大小，不足时会依次自动补零，可能导致非预期结果
Matrix *mat_gen_matrix = matrix_gen(3, 3, data);//创建一个3*3的矩阵，数据为 1 2 3 4 5 6 7 8 9
Matrix *mat_gen_data_matrix = matrix_gen(4, 4, mat_gen_matrix->data);//以已有矩阵数据创建新矩阵，但行列数不匹配，可能导致非预期结果
matrix_print(mat_gen_matrix);//打印矩阵
printf("生成的矩阵为：\n");
matrix_print(mat_gen_data_matrix);//打印矩阵
//预览结果如下
|       1.000000        2.000000        3.000000        |
|       4.000000        5.000000        6.000000        |
|       7.000000        8.000000        9.000000        |
Matrix rows: 3, cols: 3
生成的矩阵为：
|       1.000000        2.000000        3.000000        4.000000        |
|       5.000000        6.000000        7.000000        8.000000        |
|       9.000000        0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        0.000000        |

//为修复这个问题可以使用下面的代码
Matrix *mat_gen_data_matrix = matrix_gen_(4, 4, data, 3, 3);
matrix_print(mat_gen_data_matrix);//打印矩阵
//预览结果如下
|       1.000000        2.000000        3.000000        0.000000        |
|       4.000000        5.000000        6.000000        0.000000        |
|       7.000000        8.000000        9.000000        0.000000        |
|       0.000000        0.000000        0.000000        0.000000        |
```

### **matrix*gen***

说明: 由给定数据创建指定大小的矩阵，必须指定给定数据对应的矩阵大小，给定数据的长度必须小于等于指定矩阵的大小，不足时会自动补零。

函数原型:

```C
Matrix *matrix_gen_(int rows, int cols, MATRIX_TYPE *data, int data_rows, int data_cols)
```

**Input**:

| name        | type          | description      | required                                    |
| ----------- | ------------- | ---------------- | ------------------------------------------- |
| 'rows'      | unsigned int  | 生成的矩阵行数   | 必须大于 0                                  |
| 'cols'      | unsigned int  | 生成的矩阵列数   | 必须大于 0                                  |
| 'data'      | MATRIX_TYPE\* | 矩阵数据         | MATRIX_TYPE 默认类型为 double, 暂不可自定义 |
| 'data_rows' | unsigned int  | 给定数据矩阵行数 | 必须大于 0 且小于等于指定矩阵行数           |
| 'data_cols' | unsigned int  | 给定数据矩阵列数 | 必须大于 0 且小于等于指定矩阵列数           |

**Output**:

| type     | description |
| -------- | ----------- |
| Matrix\* | 生成的矩阵  |

使用示例:

```C
Matrix *mat = rand_matrix(3, 3, 0, 10);//创建一个3*3的随机矩阵，随机数取值范围为 [0, 10]
Matrix *mat_ = matrix_gen_(4, 4, mat->data, 3, 3);
matrix_print(mat);//打印矩阵
printf("生成的矩阵为：\n");
matrix_print(mat_);//打印矩阵
//预览结果如下:
|       0.012512        5.635681        1.932983        |
|       8.087158        5.849915        4.798584        |
|       3.502808        8.959351        8.228149        |
Matrix rows: 3, cols: 3
生成的矩阵为：
|       0.012512        5.635681        1.932983        0.000000        |
|       8.087158        5.849915        4.798584        0.000000        |
|       3.502808        8.959351        8.228149        0.000000        |
|       0.000000        0.000000        0.000000        0.000000        |
Matrix rows: 4, cols: 4
```

### **matrix_free**

说明: 释放矩阵的内存并将指向矩阵的指针置为 NULL，释放的矩阵必须不为空。

函数原型:

```C
void matrix_free(Matrix **matrix)
```

**使用示例**:

```C
Matrix *mat = matrix_gen(3, 3, NULL);//创建一个3*3的全零矩阵
matrix_free(&mat);//释放矩阵
```

### **matrix_print**

说明: 打印矩阵，矩阵必须不为空。

函数原型:

```C
void matrix_print(const Matrix *matrix)
```

**Input**:

| name  | type     | description | required   |
| ----- | -------- | ----------- | ---------- |
| 'mat' | Matrix\* | 矩阵        | 必须不为空 |

**Output**:

| type | description |
| ---- | ----------- |
| void | 无返回值    |

**使用示例**:

```C
Matrix *mat = matrix_gen(3, 3, NULL);//创建一个3*3的全零矩阵
matrix_print(mat);//打印矩阵，默认打印格式为 'MATRIX_DEFAULT_PRECISION "%.6lf\t"'
//预览结果如下
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
Matrix rows: 3, cols: 3
```

当行列数大于默认的限制时会自动缩印

| name | 限制大小 |
| ---- | -------- |
| rows | 100      |
| cols | 20       |

```C
//当行列数大于默认的限制时会自动缩印，示例如下
Matrix *mat = matrix_gen(300, 30, NULL);
//预览结果如下
|       0.000000        0.000000        ...     0.000000        0.000000        |
|       0.000000        0.000000        ...     0.000000        0.000000        |
⋮               ⋮               ⋮               ⋮               ⋮               ⋮
|       0.000000        0.000000        ...     0.000000        0.000000        |
|       0.000000        0.000000        ...     0.000000        0.000000        |
Matrix rows: 300, cols: 30
```

### **matrix_print_P**

说明: 打印矩阵，矩阵必须不为空。

函数原型:

```C
void matrix_print_P(const Matrix *mat, const unsigned int rowsLimit, const unsigned int colsLimit)
```

**Input**:

| name        | type         | description                              | required       |
| ----------- | ------------ | ---------------------------------------- | -------------- |
| 'mat'       | Matrix\*     | 矩阵                                     | 必须不为空     |
| 'rowsLimit' | unsigned int | 打印行数限制，当行数超过限制时，自动缩印 | 必须大于等于 5 |
| 'colsLimit' | unsigned int | 打印列数限制，当列数超过限制时，自动缩印 | 必须大于等于 5 |

**Output**:

| type | description |
| ---- | ----------- |
| void | 无返回值    |

**使用示例**:

```C
Matrix *mat = matrix_gen(3, 3, NULL);//创建一个3*3的全零矩阵
matrix_print_P(mat, MATRIX_ROWS_OMIT_PRINT_LIMIT, MATRIX_COLS_OMIT_PRINT_LIMIT);//打印矩阵，默认打印格式为 'MATRIX_DEFAULT_PRECISION "%.6lf\t"'
//预览结果如下
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
```

## 特殊矩阵的创建

### **ones_matrix**

说明: 创建一个 rows \* cols 的全 1 矩阵。

函数原型:

```C
Matrix *ones_matrix(unsigned int rows, unsigned int cols)
```

**Input**:

| name   | type         | description | required   |
| ------ | ------------ | ----------- | ---------- |
| 'rows' | unsigned int | 矩阵行数    | 必须大于 0 |
| 'cols' | unsigned int | 矩阵列数    | 必须大于 0 |

**Output**:

| type     | description                          |
| -------- | ------------------------------------ |
| Matrix\* | 行数为 rows，列数为 cols 的全 1 矩阵 |

使用示例:

```C
Matrix *mat = ones_matrix(3, 3);//创建一个3*3的全 1 矩阵，与如下示例等效
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全1矩阵
```

### **ones_matrix_value**

说明: 创建一个 rows \* cols 的所有值相同的矩阵，数据为 value。

函数原型:

```C
Matrix *ones_matrix_value(unsigned int rows, unsigned int cols, MATRIX_TYPE value)
```

**Input**:

| name    | type         | description | required                                                                                                           |
| ------- | ------------ | ----------- | ------------------------------------------------------------------------------------------------------------------ |
| 'rows'  | unsigned int | 矩阵行数    | 必须大于 0；不可省略                                                                                               |
| 'cols'  | unsigned int | 矩阵列数    | 必须大于 0；可以省略，若省略默认与 rows 取值相等                                                                   |
| 'value' | MATRIX_TYPE  | 矩阵数据    | 要求调用时必须显式指定数据为 MATRIX_TYPE(double) 类型， 否则可能会生成一个全零矩阵；可以省略，若省略则默认取值为 1 |

**Output**:

| type     | description                                    |
| -------- | ---------------------------------------------- |
| Matrix\* | 行数为 rows，列数为 cols 的值全为 value 的矩阵 |

使用示例:

```C
// 下面几条语句的结果相同。都是创建一个3*3的全 1 矩阵
Matrix *mat = ones_matrix_value(3, 3, 1.0);
Matrix *mat = ones_matrix_value(3, 3, (MATRIX_TYPE)1);
Matrix *mat = ones_matrix_value(3, 3);
Matrix *mat = ones_matrix_value(3);
Matrix *mat = ones_matrix(3, 3);
```

### **zeros_matrix**

说明: 创建一个 rows \* cols 的全 0 矩阵。

函数原型:

```C
Matrix *zeros_matrix(unsigned int rows, unsigned int cols)
```

**Input**:

| name   | type         | description | required             |
| ------ | ------------ | ----------- | -------------------- |
| 'rows' | unsigned int | 矩阵行数    | 必须大于 0；不可省略 |
| 'cols' | unsigned int | 矩阵列数    | 必须大于 0；不可省略 |

**Output**:

| type     | description                                |
| -------- | ------------------------------------------ |
| Matrix\* | 行数为 rows，列数为 cols 的值全为 0 的矩阵 |

使用示例:

```C
Matrix *mat = zeros_matrix(3, 3);//创建一个3*3的全 0 矩阵，与如下示例等效
Matrix *mat = matrix_gen(3, 3, NULL);//创建一个3*3的全零矩阵
Matrix *mat = ones_matrix_value(3, 3, 0.0);//创建一个3*3的全0矩阵
```

### **eye_matrix**

说明: 创建一个 rows \* cols 的主对角线全 1 的矩阵，可以为方阵也可以不为方阵。

函数原型:

```C
Matrix *eye_matrix(unsigned int rows, unsigned int cols)
```

**Input**:

| name   | type         | description | required             |
| ------ | ------------ | ----------- | -------------------- |
| 'rows' | unsigned int | 矩阵行数    | 必须大于 0；不可省略 |
| 'cols' | unsigned int | 矩阵列数    | 必须大于 0；不可省略 |

**Output**:

| type     | description                                    |
| -------- | ---------------------------------------------- |
| Matrix\* | 行数为 rows，列数为 cols 的主对角线全 1 的矩阵 |

使用示例:

```C
Matrix *mat = eye_matrix(3, 3);//创建一个3*3的主对角线全 1 的矩阵
matrix_print(mat);
// 输出结果如下：
|       1.000000        0.000000        0.000000        |
|       0.000000        1.000000        0.000000        |
|       0.000000        0.000000        1.000000        |
Matrix rows: 3, cols: 3

Matrix* mat_ = eye_matrix(3, 4);//创建一个3*4的主对角线全 1 的矩阵
matrix_print(mat_);
// 输出结果如下：
|       1.000000        0.000000        0.000000        0.000000        |
|       0.000000        1.000000        0.000000        0.000000        |
|       0.000000        0.000000        1.000000        0.000000        |
Matrix rows: 3, cols: 4
```

### **eye_matrix_value**

说明: 创建一个 rows \* cols 的主对角线全 value 的矩阵，可以为方阵也可以不为方阵。

函数原型:

```C
Matrix *eye_matrix_value(unsigned int rows, unsigned int cols, MATRIX_TYPE value)
```

**Input**:

| name    | type         | description | required                                                                                                           |
| ------- | ------------ | ----------- | ------------------------------------------------------------------------------------------------------------------ |
| 'rows'  | unsigned int | 矩阵行数    | 必须大于 0；不可省略                                                                                               |
| 'cols'  | unsigned int | 矩阵列数    | 必须大于 0；可以省略，若省略默认与 rows 取值相等                                                                   |
| 'value' | MATRIX_TYPE  | 矩阵数据    | 要求调用时必须显式指定数据为 MATRIX_TYPE(double) 类型， 否则可能会生成一个全零矩阵；可以省略，若省略则默认取值为 1 |

**Output**:

| type     | description                                    |
| -------- | ---------------------------------------------- |
| Matrix\* | 行数为 rows，列数为 cols 的主对角线全 1 的矩阵 |

使用示例:

```C
// 下面几条语句的结果相同。都是创建一个3*3的主对角线全 1 的矩阵
Matrix *mat = eye_matrix_value(3, 3, 1.0);
Matrix *mat = eye_matrix_value(3, 3, (MATRIX_TYPE)1);
Matrix *mat = eye_matrix_value(3, 3);
Matrix *mat = eye_matrix_value(3);
Matrix *mat = eye_matrix(3, 3);
```

### **rand_matrix**

说明: 创建一个 rows \* cols 的随机数矩阵。

函数原型:

```C
Matrix *rand_matrix(unsigned int rows, unsigned int cols, MATRIX_TYPE min, MATRIX_TYPE max)
```

**Input**:

| name   | type         | description  | required             |
| ------ | ------------ | ------------ | -------------------- |
| 'rows' | unsigned int | 矩阵行数     | 必须大于 0；不可省略 |
| 'cols' | unsigned int | 矩阵列数     | 必须大于 0；不可省略 |
| 'min'  | MATRIX_TYPE  | 随机数最小值 | 不可省略             |
| 'max'  | MATRIX_TYPE  | 随机数最大值 | 不可省略             |

**Output**:

| type     | description                                                        |
| -------- | ------------------------------------------------------------------ |
| Matrix\* | 行数为 rows，列数为 cols 的随机数矩阵，随机数取值范围为 [min, max] |

使用示例:

```C
Matrix *mat = rand_matrix(3, 3, 0, 1);//创建一个3*3的随机数矩阵，随机数取值范围为 [0, 1]
matrix_print(mat);
// 输出结果如下：
|       0.001251        0.563568        0.193298        |
|       0.808716        0.584991        0.479858        |
|       0.350281        0.895935        0.822815        |
Matrix rows: 3, cols: 3
```

## 矩阵拷贝

### **matrix_copy**

说明: 拷贝矩阵，拷贝的矩阵必须不为空。

函数原型:

```C
Matrix *matrix_copy(Matrix *_source_mat)
```

**Input**:

| name           | type     | description  | required |
| -------------- | -------- | ------------ | -------- |
| '\_source_mat' | Matrix\* | 要拷贝的矩阵 | 不可省略 |

**Output**:

| type     | description |
| -------- | ----------- |
| Matrix\* | 拷贝的矩阵  |

使用示例:

```C
Matrix *mat = matrix_gen(3, 3, NULL);
Matrix *mat2 = matrix_copy(mat);
matrix_print(mat2);
// 输出结果如下：
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_copy_r**

说明: 拷贝矩阵，拷贝的矩阵必须不为空。将被拷贝的矩阵的存储空间移动到目标矩阵

函数原型:

```C
void matrix_copy_r(Matrix **dest, const Matrix *src)
```

**Input**:

| name   | type       | description | required |
| ------ | ---------- | ----------- | -------- |
| 'dest' | Matrix\*\* | 目标矩阵    | 不可省略 |
| 'src'  | Matrix\*   | 源矩阵      | 不可省略 |

使用示例:

```C
Matrix *mat = matrix_gen(3, 3, NULL);//创建一个3*3的全零矩阵
Matrix *mat2 =NULL;
matrix_copy_(&mat2, mat);//将mat拷贝到mat2
matrix_print(mat2);
// 输出结果如下：
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_copy_free**

说明: 将一个矩阵拷贝到另一个矩阵，并且销毁被拷贝的矩阵。

函数原型:

```C
void matrix_copy_free(Matrix **dest, Matrix **src);
```

**Input**:

| name   | type       | description | required |
| ------ | ---------- | ----------- | -------- |
| 'dest' | Matrix\*\* | 目标矩阵    | 不可省略 |
| 'src'  | Matrix\*   | 源矩阵      | 不可省略 |

使用示例:

```C
Matrix *mat = matrix_gen(3, 3, NULL);//创建一个3*3的全零矩阵
Matrix *mat2 =NULL;
matrix_copy_free(&mat2, &mat);//将mat拷贝到mat2
matrix_print(mat2);
// 输出结果如下：
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
Matrix rows: 3, cols: 3
```

## 矩阵运算

### **matrix_add**

说明: 矩阵加法。

函数原型:

```C
Matrix *matrix_add(Matrix *a, Matrix *b)
```

**Input**:

| name | type     | description | required                                        |
| ---- | -------- | ----------- | ----------------------------------------------- |
| 'a'  | Matrix\* | 矩阵 a      | 不可省略；不可为 NULL，要求'a'和'b'的行列数相等 |
| 'b'  | Matrix\* | 矩阵 b      | 不可省略；不可为 NULL，要求'a'和'b'的行列数相等 |

**Output**:

| type     | description            |
| -------- | ---------------------- |
| Matrix\* | 矩阵 a 加上矩阵 b 的和 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全零矩阵
Matrix *mat2 = ones_matrix_value(3, 3, 2.0);///创建一个3*3的全零矩阵
Matrix *mat3 = matrix_add(mat, mat2);
matrix_print(mat3);
// 输出结果如下：
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_add_void**

说明: 矩阵加法，矩阵加法结果保存在矩阵 a 中。

函数原型:

```C
void matrix_add_void(Matrix *a, Matrix *b)
```

**Input**:

| name | type     | description | required                                        |
| ---- | -------- | ----------- | ----------------------------------------------- |
| 'a'  | Matrix\* | 矩阵 a      | 不可省略；不可为 NULL，要求'a'和'b'的行列数相等 |
| 'b'  | Matrix\* | 矩阵 b      | 不可省略；不可为 NULL，要求'a'和'b'的行列数相等 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全零矩阵
Matrix *mat2 = ones_matrix_value(3, 3, 2.0);///创建一个3*3的全零矩阵
matrix_add_void(mat, mat2);
matrix_print(mat);
// 输出结果如下：
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_sub**

说明: 矩阵减法。

函数原型:

```C
Matrix *matrix_sub(Matrix *a, Matrix *b)
```

**Input**:

| name | type     | description | required                                        |
| ---- | -------- | ----------- | ----------------------------------------------- |
| 'a'  | Matrix\* | 被减矩阵    | 不可省略；不可为 NULL，要求'a'和'b'的行列数相等 |
| 'b'  | Matrix\* | 减矩阵      | 不可省略；不可为 NULL，要求'a'和'b'的行列数相等 |

**Output**:

| type     | description            |
| -------- | ---------------------- |
| Matrix\* | 矩阵 a 减去矩阵 b 的差 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全零矩阵
Matrix *mat2 = ones_matrix_value(3, 3, 2.0);///创建一个3*3的全零矩阵
Matrix *mat3 = matrix_sub(mat, mat2);
matrix_print(mat3);
// 输出结果如下：
|       -1.000000        -1.000000        -1.000000        |
|       -1.000000        -1.000000        -1.000000        |
|       -1.000000        -1.000000        -1.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_sub_void**

说明: 矩阵减法，矩阵减法结果保存在矩阵 a 中。

函数原型:

```C
void matrix_sub_void(Matrix *a, Matrix *b)
```

**Input**:

| name | type     | description | required                                        |
| ---- | -------- | ----------- | ----------------------------------------------- |
| 'a'  | Matrix\* | 矩阵 a      | 不可省略；不可为 NULL，要求'a'和'b'的行列数相等 |
| 'b'  | Matrix\* | 矩阵 b      | 不可省略；不可为 NULL，要求'a'和'b'的行列数相等 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全零矩阵
Matrix *mat2 = ones_matrix_value(3, 3, 2.0);///创建一个3*3的全零矩阵
matrix_sub_void(mat, mat2);
matrix_print(mat);
// 输出结果如下：
|       -1.000000        -1.000000        -1.000000        |
|       -1.000000        -1.000000        -1.000000        |
|       -1.000000        -1.000000        -1.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_eq**

说明: 判断矩阵是否相等。

函数原型:

```C
int matrix_eq(Matrix *a, Matrix *b)
```

**Input**:

| name | type     | description | required                                         |
| ---- | -------- | ----------- | ------------------------------------------------ |
| 'a'  | Matrix\* | 矩阵 a      | 不可省略；不可为 NULL，若为 NULL，直接返回 false |
| 'b'  | Matrix\* | 矩阵 b      | 不可省略；不可为 NULL，若为 NULL，直接返回 false |

**Output**:

| type | description                                 |
| ---- | ------------------------------------------- |
| int  | 1 为相等，0 为不相等,-1 为输入的矩阵为 NULL |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全零矩阵
Matrix *mat2 = ones_matrix_value(3, 3, 2.0);///创建一个3*3的全零矩阵
int result = matrix_eq(mat, mat2);/
printf("%s\n", result ? "true" : "false");
// 输出结果如下：
false
```

### **matrix_mul**

说明: 矩阵乘法。即$a \times b$

函数原型:

```C
Matrix *matrix_mul(Matrix *a, Matrix *b)
```

**Input**:

| name | type     | description | required                                          |
| ---- | -------- | ----------- | ------------------------------------------------- |
| 'a'  | Matrix\* | 矩阵 a      | 不可省略；不可为 NULL，要求'a'列数与'b'的行数相等 |
| 'b'  | Matrix\* | 矩阵 b      | 不可省略；不可为 NULL，要求'a'列数与'b'的行数相等 |

**Output**:

| type     | description                    |
| -------- | ------------------------------ |
| Matrix\* | 矩阵 a 左乘以矩阵 b 的结果矩阵 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全 1 矩阵
Matrix *mat2 = ones_matrix_value(3, 3, 2.0);///创建一个3*3的全 2 矩阵
Matrix *mat3 = matrix_mul(mat, mat2);
matrix_print(mat3);
// 输出结果如下：
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_right_mul**

说明: 矩阵乘法。即$b \times a$

函数原型:

```C
Matrix *matrix_right_mul(Matrix *a, Matrix *b)
```

**Input**:

| name | type     | description | required                                          |
| ---- | -------- | ----------- | ------------------------------------------------- |
| 'a'  | Matrix\* | 矩阵 a      | 不可省略；不可为 NULL，要求'a'行数与'b'的列数相等 |
| 'b'  | Matrix\* | 矩阵 b      | 不可省略；不可为 NULL，要求'a'行数与'b'的列数相等 |

**Output**:

| type     | description                    |
| -------- | ------------------------------ |
| Matrix\* | 矩阵 b 右乘以矩阵 a 的结果矩阵 |

使用示例:

```C
Matrix *mat = ones_matrix_value(2, 3, 1.0);//创建一个2*3的全 1 矩阵
Matrix *mat2 = ones_matrix_value(3, 2, 2.0);///创建一个3*2的全 2 矩阵
Matrix *mat3 = matrix_right_mul(mat, mat2);
matrix_print(mat3);
// 输出结果如下：
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_mul_void**

说明: 矩阵乘法，并将结果保存到矩阵 a。即 $a \times b$

函数原型:

```C
void matrix_mul_void(Matrix *a, Matrix *b)
```

**Input**:

| name | type     | description | required                                          |
| ---- | -------- | ----------- | ------------------------------------------------- |
| 'a'  | Matrix\* | 矩阵 a      | 不可省略；不可为 NULL，要求'a'列数与'b'的行数相等 |
| 'b'  | Matrix\* | 矩阵 b      | 不可省略；不可为 NULL，要求'a'列数与'b'的行数相等 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 2, 1.0);//创建一个3*2的全 1 矩阵
Matrix *mat2 = ones_matrix_value(2, 3, 2.0);///创建一个2*3的全 2 矩阵
matrix_mul_void(mat, mat2);
matrix_print(mat);
// 输出结果如下：
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_right_mul_void**

说明: 矩阵乘法，并将结果保存到矩阵 a。即 $b \times a$

函数原型:

```C
void matrix_right_mul_void(Matrix *a, Matrix *b)
```

**Input**:

| name | type     | description | required                                          |
| ---- | -------- | ----------- | ------------------------------------------------- |
| 'a'  | Matrix\* | 矩阵 a      | 不可省略；不可为 NULL，要求'a'行数与'b'的列数相等 |
| 'b'  | Matrix\* | 矩阵 b      | 不可省略；不可为 NULL，要求'a'行数与'b'的列数相等 |

使用示例:

```C
Matrix *mat = ones_matrix_value(2, 3, 1.0);//创建一个2*3的全 1 矩阵
Matrix *mat2 = ones_matrix_value(3, 2, 2.0);///创建一个3*2的全 2 矩阵
matrix_right_mul_void(mat, mat2);
matrix_print(mat);
// 输出结果如下：
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_cdot_mul_void**

说明: 矩阵乘法，并将结果保存到矩阵 a。即 $a \cdot b$

函数原型:

```C
Matrix *matrix_cdot_mul_void(const Matrix *a, const Matrix *b)
```

**Input**:

| name | type     | description | required                                        |
| ---- | -------- | ----------- | ----------------------------------------------- |
| 'a'  | Matrix\* | 矩阵 a      | 不可省略；不可为 NULL，要求'a'与'b'的行列数相等 |
| 'b'  | Matrix\* | 矩阵 b      | 不可省略；不可为 NULL，要求'a'与'b'的行列数相等 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.5);//创建一个3*3的全 1.5 矩阵
Matrix *mat2 = ones_matrix_value(3, 3, 2.0);///创建一个3*3的全 2 矩阵
matrix_cdot_mul_void(mat, mat2);
matrix_print(mat);
// 输出结果如下：
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_cdot_mul**

说明: 矩阵乘法。即 $a \cdot b$

函数原型:

```C
Matrix *matrix_cdot_mul(const Matrix *a, const Matrix *b)
```

**Input**:

| name | type     | description | required                                        |
| ---- | -------- | ----------- | ----------------------------------------------- |
| 'a'  | Matrix\* | 矩阵 a      | 不可省略；不可为 NULL，要求'a'与'b'的行列数相等 |
| 'b'  | Matrix\* | 矩阵 b      | 不可省略；不可为 NULL，要求'a'与'b'的行列数相等 |

**Output**：

| type     | description    |
| -------- | -------------- |
| Matrix\* | 矩阵乘法的结果 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.5);//创建一个3*3的全 1.5 矩阵
Matrix *mat2 = ones_matrix_value(3, 3, 2.0);///创建一个3*3的全 2 矩阵
matrix_cdot_mul(mat, mat2);
matrix_print(mat);
// 输出结果如下：
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_mul_single**

说明: 矩阵与一个常数相乘。即 $A \times b, b \in C$。

函数原型:

```C
Matrix *matrix_mul_single(Matrix *a, const MATRIX_TYPE b)
```

**Input**:

| name | type        | description | required              |
| ---- | ----------- | ----------- | --------------------- |
| 'a'  | Matrix\*    | 矩阵 a      | 不可省略；不可为 NULL |
| 'b'  | MATRIX_TYPE | 常数        | 不可省略              |

**Output**:

| type     | description      |
| -------- | ---------------- |
| Matrix\* | 矩阵与常数的乘积 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.5);//创建一个3*3的全 1.5 矩阵
Matrix *mat2 = matrix_mul_single(mat, 2.0);
matrix_print(mat2);
// 输出结果如下：
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_mul_single_void**

说明: 矩阵与一个常数相乘。即 $A \times b, b \in C$。

函数原型:

```C
void matrix_mul_single_void(Matrix *a, const MATRIX_TYPE b)
```

**Input**:

| name | type        | description | required              |
| ---- | ----------- | ----------- | --------------------- |
| 'a'  | Matrix\*    | 矩阵 a      | 不可省略；不可为 NULL |
| 'b'  | MATRIX_TYPE | 常数        | 不可省略              |

**Output**:

| type | description                   |
| ---- | ----------------------------- |
| void | 无返回值，直接在矩阵 a 上修改 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.5);//创建一个3*3的全 1.5 矩阵
matrix_mul_single_void(mat, 2.0);
matrix_print(mat);
// 输出结果如下：
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
|       3.000000        3.000000        3.000000        |
Matrix rows: 3, cols: 3
```

## 矩阵变换

### **matrix_transpose**

说明: 矩阵转置

函数原型:

```C
void matrix_transpose(Matrix *mat)
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 2, 1.0);//创建一个3*2的全 1 矩阵
matrix_print(mat);
// 输出结果如下：
|       1.000000        1.000000        |
|       1.000000        1.000000        |
|       1.000000        1.000000        |
Matrix rows: 3, cols: 2

Matrix *mat2 = matrix_transpose(mat);
matrix_print(mat2);
// 输出结果如下：
|       1.000000        1.000000        1.000000       |
|       1.000000        1.000000        1.000000       |
Matrix rows: 2, cols: 3
```

### **matrix_transpose_r**

说明: 矩阵转置，并输出转置后的矩阵

函数原型:

```C
Matrix *matrix_transpose_r(Matrix *mat)
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

**Output**:

| type     | description  |
| -------- | ------------ |
| Matrix\* | 转置后的矩阵 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 2, 1.0);//创建一个3*2的全 1 矩阵
matrix_print(mat);
// 输出结果如下：
|       1.000000        1.000000        |
|       1.000000        1.000000        |
|       1.000000        1.000000        |
Matrix rows: 3, cols: 2

matrix_transpose_r(mat);
matrix_print(mat);
// 输出结果如下：
|       1.000000        1.000000        1.000000       |
|       1.000000        1.000000        1.000000       |
Matrix rows: 2, cols: 3
```

### **matrix_to_2D_array**

说明: 将矩阵转换为二维数组

函数原型:

```C
MATRIX_TYPE **matrix_to_2D_array(Matrix *mat)
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

**Output**:

| type            | description |
| --------------- | ----------- |
| MATRIX_TYPE\*\* | 二维数组    |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全 1 矩阵
MATRIX_TYPE **array = matrix_to_2D_array(mat);
for (int i = 0; i < mat->rows; i++){
    for (int j = 0; j < mat->cols; j++){
        printf("%f ", array[i][j]);
    }
    printf("\n");
}
// 输出结果如下：
1.000000 1.000000 1.000000
1.000000 1.000000 1.000000
1.000000 1.000000 1.000000
```

### **matrix_from_2D_array**

说明: 将二维数组转换为矩阵

函数原型:

```C
Matrix *matrix_from_2D_array(MATRIX_TYPE *array,unsigned int rows,unsigned int cols)
```

**Input**:

| name    | type            | description | required                          |
| ------- | --------------- | ----------- | --------------------------------- |
| 'array' | MATRIX_TYPE\*\* | 二维数组    | 不可省略；不可为 NULL             |
| 'rows'  | unsigned int    | 行数        | 不可省略；必须与 array 的行数相等 |
| 'cols'  | unsigned int    | 列数        | 不可省略；必须与 array 的列数相等 |

**Output**:

| type     | description         |
| -------- | ------------------- |
| Matrix\* | 由 array 生成的矩阵 |

使用示例:

```C
MATRIX_TYPE **array = (MATRIX_TYPE **)malloc(sizeof(MATRIX_TYPE *) * 3);
for (int i = 0; i < 3; i++){
    array[i] = (MATRIX_TYPE *)malloc(sizeof(MATRIX_TYPE) * 3);
    for (int j = 0; j < 3; j++){
        array[i][j] = (i + 1) * (j + 1);
    }
}
Matrix *mat = matrix_from_2D_array(array, 3, 3);
matrix_print(mat);
// 输出结果如下：
|       1.000000        2.000000        3.000000        |
|       2.000000        4.000000        6.000000        |
|       3.000000        6.000000        9.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_splicing**

说明: 矩阵拼接

函数原型:

```C
Matrix *matrix_splicing(Matrix *mat1, Matrix *mat2, unsigned int aix)
```

**Input**:

| name   | type         | description                                           | required                        |
| ------ | ------------ | ----------------------------------------------------- | ------------------------------- |
| 'mat1' | Matrix\*     | 第一个矩阵                                            | 不可省略；不可为 NULL           |
| 'mat2' | Matrix\*     | 第二个矩阵                                            | 不可省略；不可为 NULL           |
| 'aix'  | unsigned int | 拼接的方向，以 a 为参考，1,3：纵向拼接，2,4：横向拼接 | 不可省略；必须为 1~4 中某个整数 |

| aix 的值 | 拼接的方向                     | required                |
| -------- | ------------------------------ | ----------------------- |
| 1        | 矩阵 b 纵向拼接到矩阵 a 的上方 | 矩阵 a,b 的列数必须相等 |
| 2        | 矩阵 b 横向拼接到矩阵 a 的右侧 | 矩阵 a,b 的行数必须相等 |
| 3        | 矩阵 b 纵向拼接到矩阵 a 的下方 | 矩阵 a,b 的列数必须相等 |
| 4        | 矩阵 b 横向拼接到矩阵 a 的左侧 | 矩阵 a,b 的行数必须相等 |

**Output**:

| type     | description  |
| -------- | ------------ |
| Matrix\* | 拼接后的矩阵 |

使用示例:

```C
Matrix *mat_a = ones_matrix_value(3, 3, 1.0);
Matrix *mat_b = ones_matrix_value(3, 3, 2.0);
Matrix *mat_splicing_1 = matrix_splicing(mat_a, mat_b, 1);
Matrix *mat_splicing_2 = matrix_splicing(mat_a, mat_b, 2);
Matrix *mat_splicing_3 = matrix_splicing(mat_a, mat_b, 3);
Matrix *mat_splicing_4 = matrix_splicing(mat_a, mat_b, 4);
printf("aix = 1, 纵向拼接，拼接后的矩阵为:\n");
matrix_print(mat_splicing_1);
printf("aix = 2, 横向拼接，拼接后的矩阵为:\n");
matrix_print(mat_splicing_2);
printf("aix = 3, 纵向拼接，拼接后的矩阵为:\n");
matrix_print(mat_splicing_3);
printf("aix = 4, 横向拼接，拼接后的矩阵为:\n");
matrix_print(mat_splicing_4);
// 输出结果如下：
aix = 1, 纵向拼接，拼接后的矩阵为:
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
Matrix rows: 6, cols: 3
aix = 2, 横向拼接，拼接后的矩阵为:
|       1.000000        1.000000        1.000000        2.000000        2.000000        2.000000        |
|       1.000000        1.000000        1.000000        2.000000        2.000000        2.000000        |
|       1.000000        1.000000        1.000000        2.000000        2.000000        2.000000        |
Matrix rows: 3, cols: 6
aix = 3, 纵向拼接，拼接后的矩阵为:
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
Matrix rows: 6, cols: 3
aix = 4, 横向拼接，拼接后的矩阵为:
|       2.000000        2.000000        2.000000        1.000000        1.000000        1.000000        |
|       2.000000        2.000000        2.000000        1.000000        1.000000        1.000000        |
|       2.000000        2.000000        2.000000        1.000000        1.000000        1.000000        |
Matrix rows: 3, cols: 6
```

### **matrix_cat**

说明: 矩阵裁切

函数原型:

```C
Matrix *matrix_cat(Matrix *a, unsigned int begin_row, unsigned int end_row, unsigned int begin_col, unsigned int end_col)
```

**Input**:

| name        | type         | description                              | required              |
| ----------- | ------------ | ---------------------------------------- | --------------------- |
| 'a'         | Matrix\*     | 矩阵                                     | 不可省略；不可为 NULL |
| 'begin_row' | unsigned int | 裁切起始行的实际行数，非索引，比索引大 1 | 必须小于等于矩阵行数  |
| 'end_row'   | unsigned int | 裁切结束行的实际行数，非索引，比索引大 1 | 必须小于等于矩阵行数  |
| 'begin_col' | unsigned int | 裁切起始列的实际列数，非索引，比索引大 1 | 必须小于等于矩阵列数  |
| 'end_col'   | unsigned int | 裁切结束列的实际列数，非索引，比索引大 1 | 必须小于等于矩阵列数  |

**Output**:

| name | type     | description    |
| ---- | -------- | -------------- |
| 'a'  | Matrix\* | 裁切得到的矩阵 |

使用示例:

```C
Matrix *a = rand_matrix(3, 6, 0, 10);//生成一个 3 行 6 列的随机矩阵
/* 裁切矩阵 a 的第 1 行到第 2 行，第 1 列到第 3 列 */
matrix_print(a);//输出原始矩阵
// 输出结果如下：
|       0.012512        5.635681        1.932983        8.087158        5.849915        4.798584        |
|       3.502808        8.959351        8.228149        7.465820        1.741028        8.589172        |
|       7.104797        5.135193        3.039856        0.149841        0.914001        3.644409        |
Matrix rows: 3, cols: 6

Matrix *cat_mat = matrix_cat(a, 1, 2, 1, 3);
matrix_print(cat_mat);//输出裁切后的矩阵
// 输出结果如下：
|       0.012512        5.635681        1.932983        |
|       3.502808        8.959351        8.228149        |
Matrix rows: 2, cols: 3
```

### **matrix_swap**

说明: 交换矩阵中的行/列

函数原型:

```C
void matrix_swap(Matrix *a, unsigned int aix, unsigned int select_index, unsigned int aim_index)
```

**Input**:

| name           | type         | description                    | required               |
| -------------- | ------------ | ------------------------------ | ---------------------- |
| 'a'            | Matrix\*     | 矩阵                           | 不可省略；不可为 NULL  |
| 'aix'          | unsigned int | 交换方式，0：行交换，1：列交换 | 只能为 0 或 1          |
| 'select_index' | unsigned int | 被交换的行/列的索引            | 必须小于矩阵行数或列数 |
| 'aim_index'    | unsigned int | 目标行/列的索引                | 必须小于矩阵行数或列数 |

使用示例:

```C
Matrix *a = rand_matrix(3, 6, 0, 10);//生成一个 3 行 6 列的随机矩阵
matrix_print(a);//输出原始矩阵
// 输出结果如下：
|       0.012512        5.635681        1.932983        8.087158        5.849915        4.798584        |
|       3.502808        8.959351        8.228149        7.465820        1.741028        8.589172        |
|       7.104797        5.135193        3.039856        0.149841        0.914001        3.644409        |
Matrix rows: 3, cols: 6

matrix_swap(a, 0, 2, 1);//交换第 2 行和第 3 行
matrix_print(a);//输出交换后的矩阵
// 输出结果如下：
|       0.012512        5.635681        1.932983        8.087158        5.849915        4.798584        |
|       7.104797        5.135193        3.039856        0.149841        0.914001        3.644409        |
|       3.502808        8.959351        8.228149        7.465820        1.741028        8.589172        |
Matrix rows: 3, cols: 6

matrix_swap(a, 1, 2, 1);//交换第 3 列和第 2 列
matrix_print(a);//输出交换后的矩阵
// 输出结果如下：
|       0.012512        1.932983        5.635681        8.087158        5.849915        4.798584        |
|       7.104797        3.039856        5.135193        0.149841        0.914001        3.644409        |
|       3.502808        8.228149        8.959351        7.465820        1.741028        8.589172        |
Matrix rows: 3, cols: 6
```

### **matrix_swap_p**

说明: 交换矩阵中的行/列中指定索引范围的元素。

函数原型:

```C
void matrix_swap_p(const Matrix *a, const unsigned int aix, const unsigned int select_index,
                   const unsigned int aim_index, const unsigned int begin_index, const unsigned int end_index)
```

**Input**:

| name           | type         | description                    | required               |
| -------------- | ------------ | ------------------------------ | ---------------------- |
| 'a'            | Matrix\*     | 矩阵                           | 不可省略；不可为 NULL  |
| 'aix'          | unsigned int | 交换方式，0：行交换，1：列交换 | 只能为 0 或 1          |
| 'select_index' | unsigned int | 被交换的行/列的索引            | 必须小于矩阵行数或列数 |
| 'aim_index'    | unsigned int | 目标行/列的索引                | 必须小于矩阵行数或列数 |
| 'begin_index'  | unsigned int | 起始索引                       | 必须小于矩阵行数或列数 |
| 'end_index'    | unsigned int | 结束索引                       | 必须小于矩阵行数或列数 |

使用示例:

```C
Matrix *a = rand_matrix(3, 6, 0, 10);//生成一个 3 行 6 列的随机矩阵
printf("原始矩阵为：\n");
matrix_print(a);//输出原始矩阵
matrix_swap_p(a, 0, 1, 2, 1, 3);//交换第 2 行和第 3 行中第 1 列到第 3 列的元素
printf("交换后的矩阵为：\n");
matrix_print(a);//输出交换后的矩阵
// 输出结果如下：
原始矩阵为：
|   4.616699   6.903381   4.155273   4.552917   8.437195   1.938782 |
|   9.813232   4.524231   9.971924   6.130981   1.412964   5.496521 |
|   4.839172   2.885437   2.962341   7.774963   0.135193   1.873169 |
Matrix rows: 3, cols: 6
交换后的矩阵为：
|   4.616699   6.903381   4.155273   4.552917   8.437195   1.938782 |
|   9.813232   2.885437   9.971924   6.130981   1.412964   5.496521 |
|   4.839172   4.524231   2.962341   7.774963   0.135193   1.873169 |
Matrix rows: 3, cols: 6
```

### **matrix_gauss_elimination**

说明: 矩阵高斯消元，经初等行变换将矩阵转换为上三角矩阵

函数原型:

```C
void matrix_gauss_elimination(const Matrix *mat);
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    matrix_gauss_elimination(a); //高斯消元
    printf("高斯消元后的矩阵为：\n");
    matrix_print(a); //输出高斯消元后的矩阵
// 输出结果如下：
原始矩阵为：
|   0.012512   5.635681   1.932983 |
|   8.087158   5.849915   4.798584 |
|   3.502808   8.959351   8.228149 |
Matrix rows: 3, cols: 3
高斯消元后的矩阵为：
|   8.087158   5.849915   4.798584 |
|   0.000000   6.425565   6.149729 |
|   0.000000   0.000000  -3.459532 |
Matrix rows: 3, cols: 3
```

### **matrix*gauss_elimination***

说明: 高斯消元，即一次初等行变换

函数原型:

```C
void matrix_gauss_elimination_(const Matrix *mat, const unsigned int select_index, const unsigned int aim_index,
                               const int
                               begin_index,
                               const MATRIX_TYPE value);
```

**Input**:

| name           | type         | description                 | required               |
| -------------- | ------------ | --------------------------- | ---------------------- |
| 'mat'          | Matrix\*     | 矩阵                        | 不可省略；不可为 NULL  |
| 'select_index' | unsigned int | 选定行/列的索引             | 必须小于矩阵行数或列数 |
| 'aim_index'    | unsigned int | 目标行/列的索引             | 必须小于矩阵行数或列数 |
| 'begin_index'  | unsigned int | 起始索引                    | 必须小于矩阵行数或列数 |
| 'value'        | MATRIX_TYPE  | 默认是目标行-=选定行\*value | 必须小于矩阵行数或列数 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    matrix_gauss_elimination_(a, 0, 2, 0, 1.0); //高斯消元
    printf("高斯消元后的矩阵为：\n");
    matrix_print(a); //输出高斯消元后的矩阵
// 输出结果如下：
原始矩阵为：
|   5.071411   2.653198   0.136108 |
|   3.207397   3.815002   8.383179 |
|   2.942505   7.164307   7.727356 |
Matrix rows: 3, cols: 3
高斯消元后的矩阵为：
|   5.071411   2.653198   0.136108 |
|   3.207397   3.815002   8.383179 |
|  -2.128906   4.511108   7.591248 |
Matrix rows: 3, cols: 3
```

### **matrix_sort_by_cols_values**

说明: 以矩阵的指定列的数据作为键值进行排序，使用默认提供的比较函数进行排序，结果为升序。

函数原型:

```C
void matrix_sort_by_cols_values(const Matrix *mat, const unsigned int keyColIndex, const unsigned int aix)
```

**Input**:

| name          | type         | description                    | required               |
| ------------- | ------------ | ------------------------------ | ---------------------- |
| 'mat'         | Matrix\*     | 矩阵                           | 不可省略；不可为 NULL  |
| 'keyColIndex' | unsigned int | 指定列的索引                   | 必须小于矩阵行数或列数 |
| 'aix'         | unsigned int | 排序的顺序，0 为升序，1 为降序 | 必须为 0 或 1          |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    matrix_sort_by_cols_values(a, 0, 0); //以第0列的数据作为键值进行升序排序
    printf("排序后的矩阵为：\n");
    matrix_print(a); //输出排序后的矩阵
// 输出结果如下：
原始矩阵为：
|   8.659973   4.485168   1.752930 |
|   7.297058   8.892517   3.615723 |
|   3.333130   0.270691   2.941284 |
Matrix rows: 3, cols: 3
排序后的矩阵为：
|   3.333130   0.270691   2.941284 |
|   7.297058   8.892517   3.615723 |
|   8.659973   4.485168   1.752930 |
Matrix rows: 3, cols: 3
```

### **matrix_sort_by_cols_values_s**

说明: 以矩阵的指定列的数据作为键值进行排序，使用自定义比较函数进行排序，结果为升序。

函数原型:

```C
void matrix_sort_by_cols_values_s(Matrix *mat, unsigned int keyColIndex, unsigned int aix, unsigned int beginRowIndex,
                                  unsigned int endRowIndex)
```

**Input**:

| name            | type         | description                    | required                     |
| --------------- | ------------ | ------------------------------ | ---------------------------- |
| 'mat'           | Matrix\*     | 矩阵                           | 不可省略；不可为 NULL        |
| 'keyColIndex'   | unsigned int | 指定列的索引                   | 必须小于矩阵行数或列数       |
| 'aix'           | unsigned int | 排序的顺序，0 为升序，1 为降序 | 必须为 0 或 1                |
| 'beginRowIndex' | unsigned int | 指定排序的开始行索引           | 不可省略，必须小于矩阵的行数 |
| 'endRowIndex'   | unsigned int | 指定排序的结束行索引           | 不可省略，必须小于矩阵的行数 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    matrix_sort_by_cols_values_s(a, 0, 0, 1, 2); //以第0列的数据作为键值进行升序排序，从第1行到第2行
    printf("排序后的矩阵为：\n");
    matrix_print(a); //输出排序后的矩阵
// 输出结果如下：
原始矩阵为：
|   4.229736   8.634033   8.748169 |
|   6.935425   6.253357   3.255615 |
|   2.590027   2.933960   3.750610 |
Matrix rows: 3, cols: 3
排序后的矩阵为：
|   4.229736   8.634033   8.748169 |
|   2.590027   2.933960   3.750610 |
|   6.935425   6.253357   3.255615 |
Matrix rows: 3, cols: 3
```

### **matrix_swap_elem**

说明: 交换矩阵中的两个元素

函数原型:

```C
void matrix_swap_elem(Matrix *mat, elem_pos pos1, elem_pos pos2);
```

**Input**:

| name   | type     | description      | required              |
| ------ | -------- | ---------------- | --------------------- |
| 'mat'  | Matrix\* | 矩阵             | 不可省略；不可为 NULL |
| 'pos1' | elem_pos | 第一个元素的位置 | 不可省略；不可为 NULL |
| 'pos2' | elem_pos | 第二个元素的位置 | 不可省略；不可为 NULL |

使用示例:

```C
    Matrix *a = rand_matrix(3, 6, 0, 10); //生成一个 3 行 6 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    elem_pos pos1 = {1, 2, a->data[IDX(a->cols, 1, 2)]}; //定义一个元素位置
    elem_pos pos2 = {2, 3, a->data[IDX(a->cols, 2, 3)]}; //定义另一个元素位置
    matrix_swap_elem(a, pos1, pos2); //交换两个元素
    printf("交换后的矩阵为：\n");
    matrix_print(a); //输出交换后的矩阵
// 输出结果如下：
原始矩阵为：
|   0.012512   5.635681   1.932983   8.087158   5.849915   4.798584 |
|   3.502808   8.959351   8.228149   7.465820   1.741028   8.589172 |
|   7.104797   5.135193   3.039856   0.149841   0.914001   3.644409 |
Matrix rows: 3, cols: 6
交换后的矩阵为：
|   0.012512   5.635681   1.932983   8.087158   5.849915   4.798584 |
|   3.502808   8.959351   0.149841   7.465820   1.741028   8.589172 |
|   7.104797   5.135193   3.039856   8.228149   0.914001   3.644409 |
Matrix rows: 3, cols: 6
```

### **matrix_sort_by_zeros_num**

说明: 以矩阵每一行从第一位开始到第一位非零元素的个数作为键值进行排序。

函数原型:

```C
void matrix_sort_by_zeros_num(const Matrix *mat, const unsigned int aix)
```

**Input**:

| name  | type         | description | required              |
| ----- | ------------ | ----------- | --------------------- |
| 'mat' | Matrix\*     | 矩阵        | 不可省略；不可为 NULL |
| 'aix' | unsigned int | 排序方式    | 0:升序；1:降序        |

**Output**:

| type | description                      |
| ---- | -------------------------------- |
| void | 无返回值，直接在原矩阵上进行排序 |

使用示例:

```C
    Matrix *a = eye_matrix(4, 4); //生成一个 4 行 4 列的单位矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    matrix_swap(a, 0, 1, 0); //交换第1行和第2行
    matrix_swap(a, 0, 2, 3); //交换第4行和第3行
    printf("交换后的矩阵为：\n");
    matrix_print(a); //输出交换后的矩阵
    matrix_sort_by_zeros_num(a, 0); //以每一行从第一位开始到第一位非零元素的个数作为键值进行升序排序
    printf("排序后的矩阵为：\n");
    matrix_print(a); //输出排序后的矩阵
// 输出结果如下：
原始矩阵为：
|   1.000000   0.000000   0.000000   0.000000 |
|   0.000000   1.000000   0.000000   0.000000 |
|   0.000000   0.000000   1.000000   0.000000 |
|   0.000000   0.000000   0.000000   1.000000 |
Matrix rows: 4, cols: 4
交换后的矩阵为：
|   0.000000   1.000000   0.000000   0.000000 |
|   1.000000   0.000000   0.000000   0.000000 |
|   0.000000   0.000000   0.000000   1.000000 |
|   0.000000   0.000000   1.000000   0.000000 |
Matrix rows: 4, cols: 4
排序后的矩阵为：
|   1.000000   0.000000   0.000000   0.000000 |
|   0.000000   1.000000   0.000000   0.000000 |
|   0.000000   0.000000   1.000000   0.000000 |
|   0.000000   0.000000   0.000000   1.000000 |
Matrix rows: 4, cols: 4
```

## 查找矩阵中特定元素

### **matrix_min**

说明: 查找矩阵中的最小值

函数原型:

```C
MATRIX_TYPE matrix_min(const Matrix *mat);
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

**Output**:

| type        | description    |
| ----------- | -------------- |
| MATRIX_TYPE | 矩阵中的最小值 |

使用示例:

```C
Matrix *a = rand_matrix(3, 6, 0, 10);//生成一个 3 行 6 列的随机矩阵
matrix_print(a);//输出原始矩阵
MATRIX_TYPE min = matrix_min(a);//查找矩阵中的最小值
printf("The min value in matrix is: %.6lf\n", min);
// 输出结果如下：
|   0.012512   5.635681   1.932983   8.087158   5.849915   4.798584 |
|   3.502808   8.959351   8.228149   7.465820   1.741028   8.589172 |
|   7.104797   5.135193   3.039856   0.149841   0.914001   3.644409 |
Matrix rows: 3, cols: 6
The min value in matrix is: 0.012512
```

### **matrix_max**

说明: 查找矩阵中的最大值

函数原型:

```C
MATRIX_TYPE matrix_max(const Matrix *mat);
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

**Output**:

| type        | description    |
| ----------- | -------------- |
| MATRIX_TYPE | 矩阵中的最大值 |

使用示例:

```C
Matrix *a = rand_matrix(3, 6, 0, 10);//生成一个 3 行 6 列的随机矩阵
matrix_print(a);//输出原始矩阵
MATRIX_TYPE max = matrix_max(a);//查找矩阵中的最大值
printf("The max value in matrix is: %.6lf\n", max);
// 输出结果如下：
|   0.012512   5.635681   1.932983   8.087158   5.849915   4.798584 |
|   3.502808   8.959351   8.228149   7.465820   1.741028   8.589172 |
|   7.104797   5.135193   3.039856   0.149841   0.914001   3.644409 |
Matrix rows: 3, cols: 6
The max value in matrix is: 8.959351
```

### **matrix_min_array**

说明: 查找矩阵中的最小值并返回其在矩阵中的位置

函数原型:

```C
elem_pos_array *matrix_min_array(const Matrix *mat);
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

**Output**:

| type             | description                                                                      |
| ---------------- | -------------------------------------------------------------------------------- |
| elem_pos_array\* | 先行后列，从左到右，从上到下查找矩阵中的最小值及位置信息，包括行号和列号的索引值 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 6, 0, 10); //生成一个 3 行 6 列的随机矩阵
    matrix_print(a); //输出原始矩阵
    elem_pos_array *min_array = matrix_min_array(a); //查找矩阵中的最小值
    printf("The number of min value in matrix is: %d, the min value is: %.6lf\n", min_array->size,
           min_array->elem_pos_arr[0].value);
    for (int i = 0; i < min_array->size; i++) {
        printf("The %dth min value is: %.6lf, at row_index: %d, col_index: %d\n", i + 1,
               min_array->elem_pos_arr[i].value,
               min_array->elem_pos_arr[i].row, min_array->elem_pos_arr[i].col);
    }
// 输出结果如下：
|   0.012512   5.635681   1.932983   8.087158   5.849915   4.798584 |
|   3.502808   8.959351   8.228149   7.465820   1.741028   8.589172 |
|   7.104797   5.135193   3.039856   0.149841   0.914001   3.644409 |
Matrix rows: 3, cols: 6
The number of min value in matrix is: 1, the min value is: 0.012512
The 1th min value is: 0.012512, at row_index: 0, col_index: 0
```

### **matrix_max_array**

说明: 查找矩阵中的最大值并返回其在矩阵中的位置

函数原型:

```C
elem_pos_array *matrix_max_array(const Matrix *mat);
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

**Output**:

| type             | description                                                                      |
| ---------------- | -------------------------------------------------------------------------------- |
| elem_pos_array\* | 先行后列，从左到右，从上到下查找矩阵中的最大值及位置信息，包括行号和列号的索引值 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 6, 0, 10); //生成一个 3 行 6 列的随机矩阵
    matrix_print(a); //输出原始矩阵
    elem_pos_array *max_array = matrix_max_array(a); //查找矩阵中的最大值
    printf("The number of max value in matrix is: %d, the max value is: %.6lf\n", max_array->size, max_array->elem_pos_arr[0].value);
    for (int i = 0; i < max_array->size; i++) {
        printf("The %dth max value is: %.6lf, at row_index: %d, col_index: %d\n", i + 1, max_array->elem_pos_arr[i].value,
               max_array->elem_pos_arr[i].row, max_array->elem_pos_arr[i].col);
    }
// 输出结果如下：
|   0.012512   5.635681   1.932983   8.087158   5.849915   4.798584 |
|   3.502808   8.959351   8.228149   7.465820   1.741028   8.589172 |
|   7.104797   5.135193   3.039856   0.149841   0.914001   3.644409 |
Matrix rows: 3, cols: 6
The number of max value in matrix is: 1, the max value is: 8.959351
The 1th max value is: 8.959351, at row_index: 1, col_index: 1
```

### **matrix_find**

说明: 查找矩阵中符合要求的元素的值和其位置

函数原型:

```C
elem_pos_array *matrix_find(const Matrix *mat, MATRIX_TYPE value, __matrix_find_cmp_func cmp_func);
```

**Input**:

| name       | type                     | description        | required              |
| ---------- | ------------------------ | ------------------ | --------------------- |
| 'mat'      | Matrix\*                 | 矩阵               | 不可省略；不可为 NULL |
| 'value'    | MATRIX_TYPE              | 要查找的元素参考值 | 不可省略；不可为 NULL |
| 'cmp_func' | \_\_matrix_find_cmp_func | 比较函数           | 不可省略；不可为 NULL |

**Output**:

| type             | description                |
| ---------------- | -------------------------- |
| elem_pos_array\* | 符合要求的元素的值和其位置 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    elem_pos_array *pos = matrix_find(a, 5.0, matrix_default_find_cmp); //查找矩阵中值为 5 的元素
    if (pos != NULL) {
        printf("找到的元素及其位置为：\n");
        for (int i = 0; i < pos->size; i++) {
            printf("元素值：%f，位置：%d, %d\n", pos->elem_pos_arr[i].value, pos->elem_pos_arr[i].row,
                   pos->elem_pos_arr[i].col);
        }
    } else {
        printf("未找到符合条件的元素\n");
    }
// 输出结果如下：
原始矩阵为：
|   0.012512   5.635681   1.932983 |
|   8.087158   5.849915   4.798584 |
|   3.502808   8.959351   8.228149 |
Matrix rows: 3, cols: 3
未找到符合条件的元素
```

### **matrix_find_unique**

说明: 查找矩阵中符合要求的唯一元素的值和其位置。若矩阵中有多个符合要求的唯一元素，只返回第一个所在位置。

函数原型:

```C
elem_pos_array *matrix_find_unique(const Matrix *mat)
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

**Output**:

| type             | description                |
| ---------------- | -------------------------- |
| elem_pos_array\* | 符合要求的元素的值和其位置 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    elem_pos_array *pos = matrix_find_unique(a); //查找矩阵中唯一的元素
    if (pos != NULL) {
        printf("找到的元素及其位置为：\n");
        for (int i = 0; i < pos->size; i++) {
            printf("元素值：%f，位置索引：(%d, %d)\n", pos->elem_pos_arr[i].value, pos->elem_pos_arr[i].row,
                   pos->elem_pos_arr[i].col);
        }
    } else {
        printf("未找到符合条件的元素\n");
    }
// 输出结果如下：
原始矩阵为：
|   6.030579   3.717346   4.639587 |
|   8.045654   9.947510   0.962219 |
|   3.512878   6.807556   5.896912 |
Matrix rows: 3, cols: 3
找到的元素及其位置为：
元素值：6.030579，位置索引：(0, 0)
元素值：3.717346，位置索引：(0, 1)
元素值：4.639587，位置索引：(0, 2)
元素值：8.045654，位置索引：(1, 0)
元素值：9.947510，位置索引：(1, 1)
元素值：0.962219，位置索引：(1, 2)
元素值：3.512878，位置索引：(2, 0)
元素值：6.807556，位置索引：(2, 1)
元素值：5.896912，位置索引：(2, 2)
```

## 矩阵性质计算

### **matrix_invert**

说明: 构造输入矩阵的增广矩阵，使用高斯消元法求出矩阵的逆矩阵。

函数原型:

```C
Matrix *matrix_invert(Matrix *mat)
```

**Input**:

| name  | type     | description | required                                                                       |
| ----- | -------- | ----------- | ------------------------------------------------------------------------------ |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL；必须为方阵，如果矩阵不为方阵或为非奇异矩阵，就返回 NULL |

**Output**:

| type     | description                                               |
| -------- | --------------------------------------------------------- |
| Matrix\* | 矩阵的逆矩阵，如果矩阵不为方阵或为非奇异矩阵，就返回 NULL |

使用示例:

```C
    Matrix *a = eye_matrix_value(3, 3, 0.5); //生成一个 3 行 3 列的主对角线全 0.5 ，其余元素全 0的矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    Matrix *b = matrix_invert(a); //求矩阵的逆矩阵
    if (b != NULL) {
        printf("矩阵的逆矩阵为：\n");
        matrix_print(b); //输出矩阵的逆矩阵
    } else {
        printf("矩阵不为方阵或为非奇异矩阵，不能求逆矩阵\n");
    }
// 输出结果如下：
原始矩阵为：
|   0.500000   0.000000   0.000000 |
|   0.000000   0.500000   0.000000 |
|   0.000000   0.000000   0.500000 |
Matrix rows: 3, cols: 3
矩阵的逆矩阵为：
|   2.000000   0.000000   0.000000 |
|   0.000000   2.000000   0.000000 |
|   0.000000   0.000000   2.000000 |
Matrix rows: 3, cols: 3
```

### **isUpTriangleMatrix**

说明: 判断输入矩阵是否为上三角矩阵。

函数原型:

```C
int isUpTriangleMatrix(const Matrix *mat);
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

**Output**:

| type | description                                                      |
| ---- | ---------------------------------------------------------------- |
| int  | 1 表示是上三角矩阵，0 表示不是上三角矩阵，-1 表示输入矩阵为 NULL |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    if (isUpTriangleMatrix(a) == 1) {
        printf("矩阵是上三角矩阵\n");
    } else if (isUpTriangleMatrix(a) == 0) {
        printf("矩阵不是上三角矩阵\n");
    } else {
        printf("矩阵为NULL，不能判断\n");
    }
// 输出结果如下：
原始矩阵为：
|   8.424683   9.682922   1.461487 |
|   5.926208   8.751831   9.755859 |
|   8.882141   8.345642   4.658203 |
Matrix rows: 3, cols: 3
矩阵不是上三角矩阵
```

### **isLowerTriangleMatrix**

说明: 判断输入矩阵是否为下三角矩阵。

函数原型:

```C
int isLowerTriangleMatrix(const Matrix *mat);
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

**Output**:

| type | description                                                      |
| ---- | ---------------------------------------------------------------- |
| int  | 1 表示是下三角矩阵，0 表示不是下三角矩阵，-1 表示输入矩阵为 NULL |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    if (isLowerTriangleMatrix(a) == 1) {
        printf("矩阵是下三角矩阵\n");
    } else if (isLowerTriangleMatrix(a) == 0) {
        printf("矩阵不是下三角矩阵\n");
    } else {
        printf("矩阵为NULL，不能判断\n");
    }
// 输出结果如下：
原始矩阵为：
|   8.424683   9.682922   1.461487 |
|   5.926208   8.751831   9.755859 |
|   8.882141   8.345642   4.658203 |
Matrix rows: 3, cols: 3
矩阵不是下三角矩阵
```

### **isMatrixMember**

说明: 判断输入数据是否是矩阵中的元素。

函数原型:

```C
int isMatrixMember(const Matrix *mat, MATRIX_TYPE value)
```

**Input**:

| name    | type        | description  | required              |
| ------- | ----------- | ------------ | --------------------- |
| 'mat'   | Matrix\*    | 矩阵         | 不可省略；不可为 NULL |
| 'value' | MATRIX_TYPE | 要判断的数据 | 不可省略              |

**Output**:

| type | description                                                          |
| ---- | -------------------------------------------------------------------- |
| int  | 1 表示是矩阵中的元素，0 表示不是矩阵中的元素，-1 表示输入矩阵为 NULL |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    const MATRIX_TYPE value = 5.926208;
    printf("要判断的数据为：%.6lf 是否是矩阵中的元素：%s\n", value, isMatrixMember(a, value) ? "是" : "不是");
// 输出结果如下：
原始矩阵为：
|   6.412354   0.015869   2.645569 |
|   0.621643   5.538940   9.927673 |
|   7.303162   4.660645   5.809937 |
Matrix rows: 3, cols: 3
要判断的数据为：5.926208 是否是矩阵中的元素：不是
```

### **matrix_det**

说明: 计算输入矩阵的行列式。

函数原型:

```C
MATRIX_TYPE matrix_det(Matrix *mat)
```

**Input**:

| name  | type     | description | required                                                      |
| ----- | -------- | ----------- | ------------------------------------------------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL；必须为方阵，如果矩阵不为方阵就终止程序 |

**Output**:

| type        | description  |
| ----------- | ------------ |
| MATRIX_TYPE | 矩阵的行列式 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    MATRIX_TYPE b = matrix_det(a); //计算矩阵的行列式
    printf("矩阵的行列式为：%.6lf\n", b);
// 输出结果如下：
原始矩阵为：
|   0.129089   8.745117   3.889771 |
|   3.380432   1.418457   8.922119 |
|   3.116455   0.745544   1.241150 |
Matrix rows: 3, cols: 3
矩阵的行列式为：-198.446993
```

### **matrix_eigen_matrix**

说明: 计算输入矩阵的特征矩阵，返回值由输入矩阵的特征值组成的 $1\times n$ 向量，其中 $n$ 为输入矩阵的列数。

函数原型:

```C
MVector *matrix_eigen_matrix(Matrix *mat)
```

**Input**:

| name  | type     | description | required                                                      |
| ----- | -------- | ----------- | ------------------------------------------------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL；必须为方阵，如果矩阵不为方阵就终止程序 |

**Output**:

| type      | description                  |
| --------- | ---------------------------- |
| MVector\* | 由输入矩阵的特征值组成的向量 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    MVector *b = matrix_eigen_matrix(a); //计算矩阵的特征矩阵
    printf("矩阵的特征矩阵为：\n");
    mvector_print(b); //输出特征矩阵
// 输出结果如下：
原始矩阵为：
|   7.439880   1.853943   3.361206 |
|   1.812134   0.877991   5.419006 |
|   6.593018   3.634033   0.954285 |
Matrix rows: 3, cols: 3
矩阵的特征矩阵为：
|   7.439880   0.426425 -23.504713 |
Matrix rows: 1, cols: 3
```

### **matrix_rank**

说明: 使用高斯消元，将矩阵转换为上三角矩阵后，求矩阵的秩

函数原型:

```C
int matrix_rank(const Matrix *mat);
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL |

**Output**:

| type | description |
| ---- | ----------- |
| int  | 矩阵的秩    |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    printf("矩阵的秩为：%d\n", matrix_rank(a)); //输出矩阵的秩
// 输出结果如下：
原始矩阵为：
|   0.012512   5.635681   1.932983 |
|   8.087158   5.849915   4.798584 |
|   3.502808   8.959351   8.228149 |
Matrix rows: 3, cols: 3
矩阵的秩为：3
```

### **matrixPLUDecDiagCard**

说明: 以输入矩阵的主对角线元素作为主元，对矩阵进行 PLU 分解，返回值由矩阵的 P、L、U 和源矩阵的四个矩阵组成。

函数原型:

```C
PLUMatrix *matrixPLUDecDiagCard(Matrix *mat)
```

**Input**:

| name  | type     | description | required                          |
| ----- | -------- | ----------- | --------------------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL；必须为方阵 |

**Output**:

| type        | description                                      |
| ----------- | ------------------------------------------------ |
| PLUMatrix\* | 由矩阵的 P、L、U 和源矩阵组成的 PLUMatrix 结构体 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    PLUMatrix *b = matrixPLUDecDiagCard(a); //对矩阵进行PLU分解
    printf("矩阵的P为：\n");
    matrix_print(b->PMatrix); //输出矩阵的P
    printf("矩阵的L为：\n");
    matrix_print(b->LMatrix); //输出矩阵的L
    printf("矩阵的U为：\n");
    matrix_print(b->UMatrix); //输出矩阵的U
// 输出结果如下：
原始矩阵为：
|   5.128174   8.236694   3.322754 |
|   7.227478   5.833130   0.634155 |
|   4.644775   1.566772   6.356812 |
Matrix rows: 3, cols: 3
矩阵的P为：
|   1.000000   0.000000   0.000000 |
|   0.000000   1.000000   0.000000 |
|   0.000000   0.000000   1.000000 |
Matrix rows: 3, cols: 3
矩阵的L为：
|   1.000000   0.000000   0.000000 |
|   1.409367   1.000000   0.000000 |
|   0.905737   1.020451   1.000000 |
Matrix rows: 3, cols: 3
矩阵的U为：
|   5.128174   8.236694   3.322754 |
|   0.000000  -5.775394  -4.048824 |
|   0.000000   0.000000   7.478896 |
Matrix rows: 3, cols: 3
```

### **matrixPLUDecMaxCard**

说明: 以输入矩阵的每列的最大值作为主元，对矩阵进行 PLU 分解，返回值由矩阵的 P、L、U 和源矩阵的四个矩阵组成。

函数原型:

```C
PLUMatrix *matrixPLUDecMaxCard(Matrix *mat)
```

**Input**:

| name  | type     | description | required                          |
| ----- | -------- | ----------- | --------------------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略；不可为 NULL；必须为方阵 |

**Output**:

| type        | description                                      |
| ----------- | ------------------------------------------------ |
| PLUMatrix\* | 由矩阵的 P、L、U 和源矩阵组成的 PLUMatrix 结构体 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    PLUMatrix *b = matrixPLUDecMaxCard(a); //对矩阵进行PLU分解
    printf("矩阵的P为：\n");
    matrix_print(b->PMatrix); //输出矩阵的P
    printf("矩阵的L为：\n");
    matrix_print(b->LMatrix); //输出矩阵的L
    printf("矩阵的U为：\n");
    matrix_print(b->UMatrix); //输出矩阵的U
// 输出结果如下：
原始矩阵为：
|   5.261841   7.777405   3.852234 |
|   1.261902   7.632751   1.212158 |
|   1.923828   1.860046   1.574707 |
Matrix rows: 3, cols: 3
矩阵的P为：
|   1.000000   0.000000   0.000000 |
|   0.000000   1.000000   0.000000 |
|   0.000000   0.000000   1.000000 |
Matrix rows: 3, cols: 3
矩阵的L为：
|   1.000000   0.000000   0.000000 |
|   0.239821   1.000000   0.000000 |
|   0.365619  -0.170526   1.000000 |
Matrix rows: 3, cols: 3
矩阵的U为：
|   5.261841   7.777405   3.852234 |
|   0.000000   5.767564   0.288310 |
|   0.000000   0.000000   0.215422 |
Matrix rows: 3, cols: 3
```

## 向量相关

### **rangeVector**

说明: 由给定范围创建一个向量。

函数原型:

```C
MVector *rangeVector(const double begin, const double end, const unsigned int nodeNum)
```

**Input**:

| name      | type         | description                                    | required                 |
| --------- | ------------ | ---------------------------------------------- | ------------------------ |
| 'begin'   | double       | 向量的起始值                                   | 不可省略                 |
| 'end'     | double       | 向量的结束值                                   | 不可省略，必须大于起始值 |
| 'nodeNum' | unsigned int | 向量的节点数，即除了起始值和结束值之外的节点数 | 不可省略,大于等于 1      |

**Output**:

| type      | description          |
| --------- | -------------------- |
| MVector\* | 由给定范围创建的向量 |

使用示例:

```C
    MVector *a = rangeVector(0, 10, 5); //创建一个从 0 到 10 的向量，节点数为 5
    printf("向量 a 为：\n");
    matrix_print(a); //输出向量 a
// 输出结果如下：
向量 a 为：
|   0.000000   1.666667   3.333333   5.000000   6.666667   8.333333  10.000000 |
Matrix rows: 1, cols: 7
```

### **genMVector**

说明: 由给定数据生成给定大小的向量，长度不足就用 0 填充。

函数原型:

```C
MVector *genMVector(unsigned int length, unsigned int aix, MATRIX_TYPE *arr)
```

**Input**:

| name     | type          | description                            | required                          |
| -------- | ------------- | -------------------------------------- | --------------------------------- |
| 'length' | unsigned int  | 向量的长度                             | 不可省略，必须大于等于 arr 的长度 |
| 'aix'    | unsigned int  | 生成的向量的方向，0：行向量，1：列向量 | 不可省略，必须为 0 或 1           |
| 'arr'    | MATRIX_TYPE\* | 向量的数据                             | 不可省略，可为 NULL               |

**Output**:

| type      | description          |
| --------- | -------------------- |
| MVector\* | 由给定数据生成的向量 |

使用示例:

```C
    MATRIX_TYPE arr[] = {1, 2, 3, 4, 5}; //定义一个数组
    // 调用 "matrix.h" 中的函数时请将静态数组转为动态数组
    MVector *a = genMVector(5, 0, ARRAY2PTR(MATRIX_TYPE,arr, 5)); //生成一个 5 行 1 列的向量
    printf("向量 a 为：\n");
    matrix_print(a); //输出向量 a
// 输出结果如下：
向量 a 为：
|   1.000000   2.000000   3.000000   4.000000   5.000000 |
Matrix rows: 1, cols: 5
```

### **isMVector**

说明: 判断给定的矩阵是否是向量。

函数原型:

```C
int isMVector(const Matrix *vec)
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'vec' | Matrix\* | 矩阵        | 不可省略，不可为 NULL |

**Output**:

| type | description                                           |
| ---- | ----------------------------------------------------- |
| int  | 1 表示是向量，0 表示不是向量， -1 表示输入矩阵为 NULL |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("矩阵 a 为：\n");
    matrix_print(a); //输出矩阵 a
    printf("矩阵 a 是否是向量：%s\n", isMVector(a) ? "是" : "不是"); //输出矩阵 a 是否是向量
// 输出结果如下：
矩阵 a 为：
|   8.430176   2.326355   2.363281 |
|   1.291199   9.749756   6.571960 |
|   0.738831   5.660706   9.658203 |
Matrix rows: 3, cols: 3
矩阵 a 是否是向量：不是
```

### **getMatrixRowVector**

说明: 提取输入矩阵的某一行。

函数原型:

```C
MVector *getMatrixRowVector(Matrix *mat, unsigned int row_index)
```

**Input**:

| name        | type         | description    | required                           |
| ----------- | ------------ | -------------- | ---------------------------------- |
| 'mat'       | Matrix\*     | 矩阵           | 不可省略，不可为 NULL              |
| 'row_index' | unsigned int | 要提取的行索引 | 不可省略，不可超出矩阵的行索引范围 |

**Output**:

| type      | description  |
| --------- | ------------ |
| MVector\* | 提取的行向量 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("矩阵 a 为：\n");
    matrix_print(a); //输出矩阵 a
    MVector *row = getMatrixRowVector(a, 1); //提取矩阵 a 的第 2 行
    printf("矩阵 a 的第 2 行为：\n");
    matrix_print(row); //输出矩阵 a 的第 2 行
// 输出结果如下：
矩阵 a 为：
|   2.175598   9.142456   9.898682 |
|   8.316650   9.025269   9.944458 |
|   0.255127   8.513794   5.985107 |
Matrix rows: 3, cols: 3
矩阵 a 的第 2 行为：
|   8.316650   9.025269   9.944458 |
Matrix rows: 1, cols: 3
```

### **getMatrixColVector**

说明: 提取输入矩阵的某一列。

函数原型:

```C
MVector *getMatrixColVector(Matrix *mat, unsigned int col_index)
```

**Input**:

| name        | type         | description    | required                           |
| ----------- | ------------ | -------------- | ---------------------------------- |
| 'mat'       | Matrix\*     | 矩阵           | 不可省略，不可为 NULL              |
| 'col_index' | unsigned int | 要提取的列索引 | 不可省略，不可超出矩阵的列索引范围 |

**Output**:

| type      | description  |
| --------- | ------------ |
| MVector\* | 提取的列向量 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("矩阵 a 为：\n");
    matrix_print(a); //输出矩阵 a
    MVector *col = getMatrixColVector(a, 2); //提取矩阵 a 的第 3 列
    printf("矩阵 a 的第 3 列为：\n");
    matrix_print(col); //输出矩阵 a 的第 3 列
// 输出结果如下：
矩阵 a 为：
|   2.433472   8.702393   1.892395 |
|   0.293884   4.294739   0.315247 |
|   6.264648   7.140503   1.069946 |
Matrix rows: 3, cols: 3
矩阵 a 的第 3 列为：
|   1.892395 |
|   0.315247 |
|   1.069946 |
Matrix rows: 3, cols: 1
```

### **getMatrixDiagonalVector**

说明: 提取输入矩阵的主对角线向量，支持方阵与非方阵。

函数原型:

```C
MVector *getMatrixDiagonalVector(Matrix *mat)
```

**Input**:

| name  | type     | description | required              |
| ----- | -------- | ----------- | --------------------- |
| 'mat' | Matrix\* | 矩阵        | 不可省略，不可为 NULL |

**Output**:

| type      | description        |
| --------- | ------------------ |
| MVector\* | 提取的主对角线向量 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("矩阵 a 为：\n");
    matrix_print(a); //输出矩阵 a
    MVector *diag = getMatrixDiagonalVector(a); //提取矩阵 a 的主对角线向量
    printf("矩阵 a 的主对角线向量为：\n");
    matrix_print(diag); //输出矩阵 a 的主对角线向量
// 输出结果如下：
矩阵 a 为：
|   2.648926   7.215271   9.462280 |
|   6.498413   4.210510   9.157104 |
|   1.431274   4.180298   9.480591 |
Matrix rows: 3, cols: 3
矩阵 a 的主对角线向量为：
|   2.648926   4.210510   9.480591 |
Matrix rows: 1, cols: 3
```

### **getMatrixDiagonalVector_p**

说明: 提取输入矩阵的对角线向量，支持方阵与非方阵。

函数原型:

```C
MVector *getMatrixDiagonalVector_p(Matrix *mat, int aix);
```

**Input**:

| name  | type     | description                                                                      | required                             |
| ----- | -------- | -------------------------------------------------------------------------------- | ------------------------------------ |
| 'mat' | Matrix\* | 矩阵                                                                             | 不可省略，不可为 NULL                |
| 'aix' | int      | 对角线索引，0 表示主对角线，小于 0 表示主对角线下方向，大于 0 表示主对角线上方向 | 不可省略，不可超出矩阵的维度索引范围 |

**Output**:

| type      | description      |
| --------- | ---------------- |
| MVector\* | 提取的对角线向量 |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("矩阵 a 为：\n");
    matrix_print(a); //输出矩阵 a
    MVector *diag = getMatrixDiagonalVector_p(a, 0); //提取矩阵 a 的主对角线向量
    MVector *diag1 = getMatrixDiagonalVector_p(a, 1); //提取矩阵 a 的主对角线上方向的第一条对角线向量
    Matrix *diag2 = getMatrixDiagonalVector_p(a, -1); //提取矩阵 a 的主对角线下方向的第一条对角线向量
    printf("矩阵 a 的主对角线向量为：\n");
    matrix_print(diag); //输出矩阵 a 的主对角线向量
    printf("矩阵 a 的主对角线上方向的第一条对角线向量为：\n");
    matrix_print(diag1); //输出矩阵 a 的主对角线上方向的第一条对角线向量
    printf("矩阵 a 的主对角线下方向的第一条对角线向量为：\n");
    matrix_print(diag2); //输出矩阵 a 的主对角线下方向的第一条对角线向量
// 输出结果如下：
矩阵 a 为：
|   2.879944   8.211060   4.259644 |
|   0.199890   4.490356   7.172852 |
|   1.795044   6.926880   8.514099 |
Matrix rows: 3, cols: 3
矩阵 a 的主对角线向量为：
|   2.879944   4.490356   8.514099 |
Matrix rows: 1, cols: 3
矩阵 a 的主对角线上方向的第一条对角线向量为：
|   8.211060   7.172852 |
Matrix rows: 1, cols: 2
矩阵 a 的主对角线下方向的第一条对角线向量为：
|   0.199890   6.926880 |
Matrix rows: 1, cols: 2
```

### **diagMatrix**

说明: 以输入向量作为主对角线创建对角矩阵，其余元素为 0。

函数原型:

```C
Matrix *diagMatrix(MVector *vec);
```

**Input**:

| name  | type    | description | required              |
| ----- | ------- | ----------- | --------------------- |
| 'vec' | MVector | 输入向量    | 不可省略，不可为 NULL |

**Output**:

| type     | description    |
| -------- | -------------- |
| Matrix\* | 创建的对角矩阵 |

使用示例:

```C
    MVector *vec = rand_matrix(3, 1, 0, 10); //生成一个 3 个元素的随机向量
    printf("向量 vec 为：\n");
    vector_print(vec); //输出向量 vec
    Matrix *diag = diagMatrix(vec); //以向量 vec 作为主对角线创建对角矩阵
    printf("以向量 vec 作为主对角线创建的对角矩阵为：\n");
    matrix_print(diag); //输出对角矩阵
// 输出结果如下：
向量 vec 为：
|   3.531799 |
|   3.431091 |
|   9.679565 |
Matrix rows: 3, cols: 1
以向量 vec 作为主对角线创建的对角矩阵为：
|   3.531799   0.000000   0.000000 |
|   0.000000   3.431091   0.000000 |
|   0.000000   0.000000   9.679565 |
Matrix rows: 3, cols: 3
```

### **diagMatrix_p**

说明: 以输入向量作为对角线创建对角矩阵，其余元素为 0。

函数原型:

```C
Matrix *diagMatrix_p(MVector *vec, const int aix)
```

**Input**:

| name  | type    | description                                                                      | required              |
| ----- | ------- | -------------------------------------------------------------------------------- | --------------------- |
| 'vec' | MVector | 输入向量                                                                         | 不可省略，不可为 NULL |
| 'aix' | int     | 对角线索引，0 表示主对角线，小于 0 表示主对角线下方向，大于 0 表示主对角线上方向 | 不可省略，不可为 NULL |

**Output**:

| type     | description    |
| -------- | -------------- |
| Matrix\* | 创建的对角矩阵 |

使用示例:

```C
    MVector *vec = rand_matrix(3, 1, 0, 10); //生成一个 3 个元素的随机向量
    printf("向量 vec 为：\n");
    vector_print(vec); //输出向量 vec
    Matrix *diag = diagMatrix_p(vec, 1); //以向量 vec 作为主对角线上方向的第一条对角线创建对角矩阵
    printf("以向量 vec 作为主对角线上方向的第一条对角线创建的对角矩阵为：\n");
    matrix_print(diag); //输出对角矩阵
// 输出结果如下：
向量 vec 为：
|   4.541321 |
|   6.226501 |
|   2.264099 |
Matrix rows: 3, cols: 1
以向量 vec 作为主对角线上方向的第一条对角线创建的对角矩阵为：
|   0.000000   4.541321   0.000000   0.000000 |
|   0.000000   0.000000   6.226501   0.000000 |
|   0.000000   0.000000   0.000000   2.264099 |
|   0.000000   0.000000   0.000000   0.000000 |
Matrix rows: 4, cols: 4
```

### **matrixEquation**

说明: 解线性方程组。

函数原型:

```C
Matrix *matrixEquation(Matrix *aMat, Matrix *bMat)
```

**Input**:

| name   | type   | description | required              |
| ------ | ------ | ----------- | --------------------- |
| 'aMat' | Matrix | 系数矩阵    | 不可省略，不可为 NULL |
| 'bMat' | Matrix | 结果矩阵    | 不可省略，不可为 NULL |

**Output**:

| type     | description |
| -------- | ----------- |
| Matrix\* | 解的矩阵    |

使用示例:

```C
    Matrix *aMat = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    Matrix *bMat = rand_matrix(3, 1, 0, 10); //生成一个 3 行 1 列的随机矩阵
    printf("系数矩阵 aMat 为：\n");
    matrix_print(aMat); //输出系数矩阵 aMat
    printf("结果矩阵 bMat 为：\n");
    matrix_print(bMat); //输出结果矩阵 bMat
    Matrix *xMat = matrixEquation(aMat, bMat); //解线性方程组
    printf("解的矩阵 xMat 为：\n");
    matrix_print(xMat); //输出解的矩阵 xMat
// 输出结果如下：
系数矩阵 aMat 为：
|   4.714661   6.973267   0.862122 |
|   9.658203   9.513550   3.321838 |
|   0.459290   2.300110   5.197754 |
Matrix rows: 3, cols: 3
结果矩阵 bMat 为：
|   1.706848 |
|   0.182800 |
|   4.922180 |
Matrix rows: 3, cols: 1
解的矩阵 xMat 为：
|   0.362030 |
|   0.694488 |
|   0.643413 |
Matrix rows: 3, cols: 1
```

## 其余辅助函数

### **matrix_default_cmp_for_qsort_s**

说明: 使用 C 库函数 qsort_s 排序矩阵时的比较函数，用于比较矩阵中的元素，顺序为升序。

函数原型:

```C
int matrix_default_cmp_for_qsort_s(void *index, const void *a, const void *b)
```

**Input**:

| name    | type        | description         | required                             |
| ------- | ----------- | ------------------- | ------------------------------------ |
| 'index' | int         | 进行比较的列/行索引 | 不可省略，不可超出矩阵的维度索引范围 |
| 'a'     | MATRIX_TYPE | 比较的第一个元素    | 不可省略，不可为 NULL                |
| 'b'     | MATRIX_TYPE | 比较的第二个元素    | 不可省略，不可为 NULL                |

**Output**:

| type | description                                        |
| ---- | -------------------------------------------------- |
| int  | 1 表示 a 大于 b，0 表示 a 等于 b，-1 表示 a 小于 b |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    qsort_s(a->data, a->rows, sizeof(MATRIX_TYPE)*a->cols, matrix_default_cmp_for_qsort_s, (void *) 0); //以每一行的第一个元素进行比较，升序排列
    printf("排序后的矩阵为：\n");
    matrix_print(a); //输出排序后的矩阵
// 输出结果如下：
原始矩阵为：
|   4.142151   7.826538   3.644409 |
|   2.036133   4.945679   0.102539 |
|   3.557129   9.674377   7.110291 |
Matrix rows: 3, cols: 3
排序后的矩阵为：
|   2.036133   4.945679   0.102539 |
|   3.557129   9.674377   7.110291 |
|   4.142151   7.826538   3.644409 |
Matrix rows: 3, cols: 3
```

### **matrix_default_cmp_for_qsort_s_down**

说明: 使用 C 库函数 qsort_s 排序矩阵时的比较函数，用于比较矩阵中的元素，顺序为降序。

函数原型:

```C
int matrix_default_cmp_for_qsort_s_down(void *index, const void *a, const void *b)
```

**Input**:

| name    | type        | description         | required                             |
| ------- | ----------- | ------------------- | ------------------------------------ |
| 'index' | int         | 进行比较的列/行索引 | 不可省略，不可超出矩阵的维度索引范围 |
| 'a'     | MATRIX_TYPE | 比较的第一个元素    | 不可省略，不可为 NULL                |
| 'b'     | MATRIX_TYPE | 比较的第二个元素    | 不可省略，不可为 NULL                |

**Output**:

| type | description                                        |
| ---- | -------------------------------------------------- |
| int  | -1 表示 a 大于 b，0 表示 a 等于 b，1 表示 a 小于 b |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    qsort_s(a->data, a->rows, sizeof(MATRIX_TYPE)*a->cols, matrix_default_cmp_for_qsort_s_down, (void *) 0); //以每一行的第一个元素进行比较，降序排列
    printf("排序后的矩阵为：\n");
    matrix_print(a); //输出排序后的矩阵
// 输出结果如下：
原始矩阵为：
|   4.334412   0.896301   5.824890 |
|   9.339600   2.463074   1.382751 |
|   6.877136   7.261047   9.625244 |
Matrix rows: 3, cols: 3
排序后的矩阵为：
|   9.339600   2.463074   1.382751 |
|   6.877136   7.261047   9.625244 |
|   4.334412   0.896301   5.824890 |
Matrix rows: 3, cols: 3
```

### **matrix_default_cmp_for_sort**

说明: 使用本项目实现的排序[函数](/C/doc/sort_doc.md)进行矩阵排序，用于比较矩阵中的元素，顺序为升序。因为与 C 库函数 qsort_s
的实现不同，所以比较函数亦不同。

函数原型:

```C
int matrix_default_cmp_for_sort(const void *a, const void *b, void *index)
```

**Input**:

| name    | type        | description         | required                             |
| ------- | ----------- | ------------------- | ------------------------------------ |
| 'a'     | MATRIX_TYPE | 比较的第一个元素    | 不可省略，不可为 NULL                |
| 'b'     | MATRIX_TYPE | 比较的第二个元素    | 不可省略，不可为 NULL                |
| 'index' | int         | 进行比较的列/行索引 | 不可省略，不可超出矩阵的维度索引范围 |

**Output**:

| type | description                                        |
| ---- | -------------------------------------------------- |
| int  | 1 表示 a 大于 b，0 表示 a 等于 b，-1 表示 a 小于 b |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    //以每一行的第一个元素进行比较，升序排列
    mergeSort_s(a->data, a->rows, sizeof(MATRIX_TYPE)*a->cols, matrix_default_cmp_for_sort, (void *) 0);
    printf("排序后的矩阵为：\n");
    matrix_print(a); //输出排序后的矩阵
// 输出结果如下：
原始矩阵为：
|   4.706116   4.393311   9.313660 |
|   8.480225   6.576843   8.364563 |
|   1.169128   4.047546   9.148865 |
Matrix rows: 3, cols: 3
排序后的矩阵为：
|   1.169128   4.047546   9.148865 |
|   4.706116   4.393311   9.313660 |
|   8.480225   6.576843   8.364563 |
Matrix rows: 3, cols: 3
```

### **matrix_default_cmp_for_sort_down**

说明: 使用本项目实现的排序[函数](/C/doc/sort_doc.md)进行矩阵排序，用于比较矩阵中的元素，顺序为降序。因为与 C 库函数 qsort_s
的实现不同，所以比较函数亦不同。

函数原型:

```C
int matrix_default_cmp_for_sort_down(const void *a, const void *b, void *index)
```

**Input**:

| name    | type        | description         | required                             |
| ------- | ----------- | ------------------- | ------------------------------------ |
| 'a'     | MATRIX_TYPE | 比较的第一个元素    | 不可省略，不可为 NULL                |
| 'b'     | MATRIX_TYPE | 比较的第二个元素    | 不可省略，不可为 NULL                |
| 'index' | int         | 进行比较的列/行索引 | 不可省略，不可超出矩阵的维度索引范围 |

**Output**:

| type | description                                        |
| ---- | -------------------------------------------------- |
| int  | -1 表示 a 大于 b，0 表示 a 等于 b，1 表示 a 小于 b |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    //以每一行的第一个元素进行比较，降序排列
    mergeSort_s(a->data, a->rows, sizeof(MATRIX_TYPE)*a->cols, matrix_default_cmp_for_sort_down, (void *) 0);
    printf("排序后的矩阵为：\n");
    matrix_print(a); //输出排序后的矩阵
// 输出结果如下：
原始矩阵为：
|   4.925232   6.027222   8.690491 |
|   4.059143   9.083557   2.000122 |
|   0.135193   7.514343   7.715149 |
Matrix rows: 3, cols: 3
排序后的矩阵为：
|   4.925232   6.027222   8.690491 |
|   4.059143   9.083557   2.000122 |
|   0.135193   7.514343   7.715149 |
Matrix rows: 3, cols: 3
```

### **\_\_matrix_find_cmp_func**

说明: 用于查找矩阵元素的比较函数的类型定义，返回值为 1 代表符合条件，返回值为 0 代表不符合，需要用户自行实现。

定义如下：

```C
typedef int (*__matrix_find_cmp_func)(const void *, const void *);
```

为方便使用，提供一个默认的比较函数，其原函数如下：

```C
int matrix_default_find_cmp(const void *a, const void *b)
```

**Input**:

| name | type   | description | required |
| ---- | ------ | ----------- | -------- |
| 'a'  | double | 比较元素    |          |
| 'b'  | double | 比较元素    |          |

**Output**:

| type | description                              |
| ---- | ---------------------------------------- |
| int  | 1 或 0,1 代表 $a = b$，0 代表 $a \neq b$ |
