# **注意**

因代码还在不断完善中，此文档有一定滞后性，仅作为参考。

# 说明

矩阵相关内容，以实现函数/方法及其说明如下：

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

```C
// 矩阵类型定义
typedef struct _Matrix
{
    unsigned int rows; /// 矩阵行数
    unsigned int cols; /// 矩阵列数
    MATRIX_TYPE *data; /// 矩阵的数据
} Matrix;
```

**释义**:

| name   | type         | description | required                         |
|--------|--------------|-------------|----------------------------------|
| 'rows' | unsigned int | 矩阵行数        | 必须大于 0                           |
| 'cols' | unsigned int | 矩阵列数        | 必须大于 0                           |
| 'data' | MATRIX_TYPE* | 矩阵数据        | MATRIX_TYPE 默认类型为 double, 暂不可自定义 |

### **__matrix_find_cmp_func**

说明: 用于查找矩阵元素的比较函数的类型定义，返回值为 1 代表符合条件，返回值为 0 代表不符合，需要用户自定义。

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
|------|--------|-------------|----------|
| 'a'  | double | 比较元素        |          |
| 'b'  | double | 比较元素        |          |

**Output**:

| type | description                        |
|------|------------------------------------|
| int  | 1 或 0,1 代表 $a = b$，0 代表 $a \neq b$ |

## 矩阵创建与销毁

### **matrix_gen**

说明: 由给定数据创建指定大小的矩阵，给定数据的长度必须小于等于指定矩阵的大小，长度不足时会自动补零。

函数原型:

```C
Matrix *matrix_gen(unsigned int rows, unsigned int cols, MATRIX_TYPE *data)
```

**Input**:

| name   | type         | description | required                                           |
|--------|--------------|-------------|----------------------------------------------------|
| 'rows' | unsigned int | 矩阵行数        | 必须大于 0                                             |
| 'cols' | unsigned int | 矩阵列数        | 必须大于 0                                             |
| 'data' | MATRIX_TYPE* | 矩阵数据        | data 的长度必须<= rows * cols， 不足时会自动补零故可以为 NULL以创建全零矩阵 |

**Output**:

| type    | description           |
|---------|-----------------------|
| Matrix* | 行数为 rows，列数为 cols 的矩阵 |

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

### **matrix_gen_**

说明: 由给定数据创建指定大小的矩阵，必须指定给定数据对应的矩阵大小，给定数据的长度必须小于等于指定矩阵的大小，不足时会自动补零。

函数原型:

```C
Matrix *matrix_gen_(int rows, int cols, MATRIX_TYPE *data, int data_rows, int data_cols)
```

**Input**:

| name        | type         | description | required                         |
|-------------|--------------|-------------|----------------------------------|
| 'rows'      | unsigned int | 生成的矩阵行数     | 必须大于 0                           |
| 'cols'      | unsigned int | 生成的矩阵列数     | 必须大于 0                           |
| 'data'      | MATRIX_TYPE* | 矩阵数据        | MATRIX_TYPE 默认类型为 double, 暂不可自定义 |
| 'data_rows' | unsigned int | 给定数据矩阵行数    | 必须大于 0且小于等于指定矩阵行数                |
| 'data_cols' | unsigned int | 给定数据矩阵列数    | 必须大于 0且小于等于指定矩阵列数                |

**Output**:

| type    | description |
|---------|-------------|
| Matrix* | 生成的矩阵       |

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

说明: 释放矩阵，释放的矩阵必须不为空。

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

**使用示例**:

```C
Matrix *mat = matrix_gen(3, 3, NULL);//创建一个3*3的全零矩阵
matrix_print(mat);//打印矩阵，打印默认格式为 'MATRIX_DEFAULT_PRECISION "%.6lf\t"'
//预览结果如下
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
|       0.000000        0.000000        0.000000        |
Matrix rows: 3, cols: 3
//当行列数大于默认的限制,即'MATRIX_COLS_OMIT_PRINT_LIMIT 20' 和 'MATRIX_ROWS_OMIT_PRINT_LIMIT 200 时会自动缩印，示例如下
Matrix *mat = matrix_gen(300, 30, NULL);
//预览结果如下
|       0.000000        0.000000        ...     0.000000        0.000000        |
|       0.000000        0.000000        ...     0.000000        0.000000        |
⋮               ⋮               ⋮               ⋮               ⋮               ⋮
|       0.000000        0.000000        ...     0.000000        0.000000        |
|       0.000000        0.000000        ...     0.000000        0.000000        |
Matrix rows: 300, cols: 30
```

### **ones_matrix**

说明: 创建一个 rows * cols 的全 1 矩阵。

函数原型:

```C
Matrix *ones_matrix(unsigned int rows, unsigned int cols)
```

**Input**:

| name   | type         | description | required |
|--------|--------------|-------------|----------|
| 'rows' | unsigned int | 矩阵行数        | 必须大于 0   |
| 'cols' | unsigned int | 矩阵列数        | 必须大于 0   |

**Output**:

| type    | description               |
|---------|---------------------------|
| Matrix* | 行数为 rows，列数为 cols 的全 1 矩阵 |

使用示例:

```C
Matrix *mat = ones_matrix(3, 3);//创建一个3*3的全 1 矩阵，与如下示例等效
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全1矩阵
```

### **ones_matrix_value**

说明: 创建一个 rows * cols 的所有值相同的矩阵，数据为 value。

函数原型:

```C
Matrix *ones_matrix_value(unsigned int rows, unsigned int cols, MATRIX_TYPE value)
```

**Input**:

| name    | type         | description | required                                                              |
|---------|--------------|-------------|-----------------------------------------------------------------------|
| 'rows'  | unsigned int | 矩阵行数        | 必须大于 0；不可省略                                                           |
| 'cols'  | unsigned int | 矩阵列数        | 必须大于 0；可以省略，若省略默认与 rows 取值相等                                          |
| 'value' | MATRIX_TYPE  | 矩阵数据        | 要求调用时必须显式指定数据为 MATRIX_TYPE(double) 类型， 否则可能会生成一个全零矩阵；可以省略，若省略则默认取值为 1 |

**Output**:

| type    | description                      |
|---------|----------------------------------|
| Matrix* | 行数为 rows，列数为 cols 的值全为 value 的矩阵 |

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

说明: 创建一个 rows * cols 的全 0 矩阵。

函数原型:

```C
Matrix *zeros_matrix(unsigned int rows, unsigned int cols)
```

**Input**:

| name   | type         | description | required    |
|--------|--------------|-------------|-------------|
| 'rows' | unsigned int | 矩阵行数        | 必须大于 0；不可省略 |
| 'cols' | unsigned int | 矩阵列数        | 必须大于 0；不可省略 |

**Output**:

| type    | description                  |
|---------|------------------------------|
| Matrix* | 行数为 rows，列数为 cols 的值全为 0 的矩阵 |

使用示例:

```C
Matrix *mat = zeros_matrix(3, 3);//创建一个3*3的全 0 矩阵，与如下示例等效
Matrix *mat = matrix_gen(3, 3, NULL);//创建一个3*3的全零矩阵
Matrix *mat = ones_matrix_value(3, 3, 0.0);//创建一个3*3的全0矩阵
```

### **eye_matrix**

说明: 创建一个 rows * cols 的主对角线全 1 的矩阵，可以为方阵也可以不为方阵。

函数原型:

```C
Matrix *eye_matrix(unsigned int rows, unsigned int cols)
```

**Input**:

| name   | type         | description | required    |
|--------|--------------|-------------|-------------|
| 'rows' | unsigned int | 矩阵行数        | 必须大于 0；不可省略 |
| 'cols' | unsigned int | 矩阵列数        | 必须大于 0；不可省略 |

**Output**:

| type    | description                    |
|---------|--------------------------------|
| Matrix* | 行数为 rows，列数为 cols 的主对角线全 1 的矩阵 |

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

说明: 创建一个 rows * cols 的主对角线全 value 的矩阵，可以为方阵也可以不为方阵。

函数原型:

```C
Matrix *eye_matrix_value(unsigned int rows, unsigned int cols, MATRIX_TYPE value)
```

**Input**:

| name    | type         | description | required                                                              |
|---------|--------------|-------------|-----------------------------------------------------------------------|
| 'rows'  | unsigned int | 矩阵行数        | 必须大于 0；不可省略                                                           |
| 'cols'  | unsigned int | 矩阵列数        | 必须大于 0；可以省略，若省略默认与 rows 取值相等                                          |
| 'value' | MATRIX_TYPE  | 矩阵数据        | 要求调用时必须显式指定数据为 MATRIX_TYPE(double) 类型， 否则可能会生成一个全零矩阵；可以省略，若省略则默认取值为 1 |

**Output**:

| type    | description                    |
|---------|--------------------------------|
| Matrix* | 行数为 rows，列数为 cols 的主对角线全 1 的矩阵 |

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

说明: 创建一个 rows * cols 的随机数矩阵。

函数原型:

```C
Matrix *rand_matrix(unsigned int rows, unsigned int cols, MATRIX_TYPE min, MATRIX_TYPE max)
```

**Input**:

| name   | type         | description | required    |
|--------|--------------|-------------|-------------|
| 'rows' | unsigned int | 矩阵行数        | 必须大于 0；不可省略 |
| 'cols' | unsigned int | 矩阵列数        | 必须大于 0；不可省略 |
| 'min'  | MATRIX_TYPE  | 随机数最小值      | 不可省略        |
| 'max'  | MATRIX_TYPE  | 随机数最大值      | 不可省略        |

**Output**:

| type    | description                                  |
|---------|----------------------------------------------|
| Matrix* | 行数为 rows，列数为 cols 的随机数矩阵，随机数取值范围为 [min, max] |

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

### **matrix_copy**

说明: 拷贝矩阵，拷贝的矩阵必须不为空。

函数原型:

```C
Matrix *matrix_copy(Matrix *_source_mat)
```

**Input**:

| name          | type    | description | required |
|---------------|---------|-------------|----------|
| '_source_mat' | Matrix* | 要拷贝的矩阵      | 不可省略     |

**Output**:

| type    | description |
|---------|-------------|
| Matrix* | 拷贝的矩阵       |

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

### **matrix_copy_**

说明: 拷贝矩阵，拷贝的矩阵必须不为空。将被拷贝的矩阵的存储空间移动到目标矩阵

函数原型:

```C
void matrix_copy_(Matrix *a, Matrix *b)
```

**Input**:

| name | type    | description | required |
|------|---------|-------------|----------|
| 'a'  | Matrix* | 目标矩阵        | 不可省略     |
| 'b'  | Matrix* | 源矩阵         | 不可省略     |

使用示例:

```C
Matrix *mat = matrix_gen(3, 3, NULL);//创建一个3*3的全零矩阵
Matrix *mat2;
matrix_copy_(mat2, mat);//将mat拷贝到mat2
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

| name | type    | description | required                     |
|------|---------|-------------|------------------------------|
| 'a'  | Matrix* | 矩阵 a        | 不可省略；不可为NULL，要求'a'和'b'的行列数相等 |
| 'b'  | Matrix* | 矩阵 b        | 不可省略；不可为NULL，要求'a'和'b'的行列数相等 |

**Output**:

| type    | description    |
|---------|----------------|
| Matrix* | 矩阵 a 加上矩阵 b 的和 |

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

| name | type    | description | required                     |
|------|---------|-------------|------------------------------|
| 'a'  | Matrix* | 矩阵 a        | 不可省略；不可为NULL，要求'a'和'b'的行列数相等 |
| 'b'  | Matrix* | 矩阵 b        | 不可省略；不可为NULL，要求'a'和'b'的行列数相等 |

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

| name | type    | description | required                     |
|------|---------|-------------|------------------------------|
| 'a'  | Matrix* | 被减矩阵        | 不可省略；不可为NULL，要求'a'和'b'的行列数相等 |
| 'b'  | Matrix* | 减矩阵         | 不可省略；不可为NULL，要求'a'和'b'的行列数相等 |

**Output**:

| type    | description    |
|---------|----------------|
| Matrix* | 矩阵 a 减去矩阵 b 的差 |

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

| name | type    | description | required                     |
|------|---------|-------------|------------------------------|
| 'a'  | Matrix* | 矩阵 a        | 不可省略；不可为NULL，要求'a'和'b'的行列数相等 |
| 'b'  | Matrix* | 矩阵 b        | 不可省略；不可为NULL，要求'a'和'b'的行列数相等 |

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
bool matrix_eq(Matrix *a, Matrix *b)
```

**Input**:

| name | type    | description | required                      |
|------|---------|-------------|-------------------------------|
| 'a'  | Matrix* | 矩阵 a        | 不可省略；不可为NULL，若为NULL，直接返回false |
| 'b'  | Matrix* | 矩阵 b        | 不可省略；不可为NULL，若为NULL，直接返回false |

**Output**:

| type | description                     |
|------|---------------------------------|
| bool | 矩阵 a 是否等于矩阵 b，true为相等，false为不相等 |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全零矩阵
Matrix *mat2 = ones_matrix_value(3, 3, 2.0);///创建一个3*3的全零矩阵
bool result = matrix_eq(mat, mat2);// bool 由 <stdbool.h> 头文件提供>
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

| name | type    | description | required                      |
|------|---------|-------------|-------------------------------|
| 'a'  | Matrix* | 矩阵 a        | 不可省略；不可为NULL，要求'a'列数与'b'的行数相等 |
| 'b'  | Matrix* | 矩阵 b        | 不可省略；不可为NULL，要求'a'列数与'b'的行数相等 |

**Output**:

| type    | description        |
|---------|--------------------|
| Matrix* | 矩阵 a 左乘以矩阵 b 的结果矩阵 |

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

| name | type    | description | required                      |
|------|---------|-------------|-------------------------------|
| 'a'  | Matrix* | 矩阵 a        | 不可省略；不可为NULL，要求'a'行数与'b'的列数相等 |
| 'b'  | Matrix* | 矩阵 b        | 不可省略；不可为NULL，要求'a'行数与'b'的列数相等 |

**Output**:

| type    | description        |
|---------|--------------------|
| Matrix* | 矩阵 b 右乘以矩阵 a 的结果矩阵 |

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

| name | type    | description | required                      |
|------|---------|-------------|-------------------------------|
| 'a'  | Matrix* | 矩阵 a        | 不可省略；不可为NULL，要求'a'列数与'b'的行数相等 |
| 'b'  | Matrix* | 矩阵 b        | 不可省略；不可为NULL，要求'a'列数与'b'的行数相等 |

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

| name | type    | description | required                      |
|------|---------|-------------|-------------------------------|
| 'a'  | Matrix* | 矩阵 a        | 不可省略；不可为NULL，要求'a'行数与'b'的列数相等 |
| 'b'  | Matrix* | 矩阵 b        | 不可省略；不可为NULL，要求'a'行数与'b'的列数相等 |

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

| name | type    | description | required                     |
|------|---------|-------------|------------------------------|
| 'a'  | Matrix* | 矩阵 a        | 不可省略；不可为NULL，要求'a'与'b'的行列数相等 |
| 'b'  | Matrix* | 矩阵 b        | 不可省略；不可为NULL，要求'a'与'b'的行列数相等 |

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

| name | type    | description | required                     |
|------|---------|-------------|------------------------------|
| 'a'  | Matrix* | 矩阵 a        | 不可省略；不可为NULL，要求'a'与'b'的行列数相等 |
| 'b'  | Matrix* | 矩阵 b        | 不可省略；不可为NULL，要求'a'与'b'的行列数相等 |

**Output**

| type    | description |
|---------|-------------|
| Matrix* | 矩阵乘法的结果     |

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

### **matrix_transpose**

说明: 矩阵转置

函数原型:

```C
void matrix_transpose(Matrix *mat)
```

**Input**:

| name  | type    | description | required     |
|-------|---------|-------------|--------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 2, 1.0);//创建一个3*2的全 1 矩阵
matrix_print(mat);
// 输出结果如下：
|       1.000000        1.000000        |
|       1.000000        1.000000        |
|       1.000000        1.000000        |
Matrix rows: 3, cols: 2

matrix_transpose(mat);
matrix_print(mat);
// 输出结果如下：
|       1.000000        1.000000        1.000000       |
|       1.000000        1.000000        1.000000       |
Matrix rows: 2, cols: 3
```

### **matrix_transpose_**

说明: 矩阵转置，并输出转置后的矩阵

函数原型:

```C
Matrix *matrix_transpose_(Matrix *mat)
```

**Input**:

| name  | type    | description | required     |
|-------|---------|-------------|--------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL |

**Output**:

| type    | description |
|---------|-------------|
| Matrix* | 转置后的矩阵      |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 2, 1.0);//创建一个3*2的全 1 矩阵
matrix_print(mat);
// 输出结果如下：
|       1.000000        1.000000        |
|       1.000000        1.000000        |
|       1.000000        1.000000        |
Matrix rows: 3, cols: 2

matrix_transpose(mat);
matrix_print(mat);
// 输出结果如下：
|       1.000000        1.000000        1.000000       |
|       1.000000        1.000000        1.000000       |
Matrix rows: 2, cols: 3
```

### **matrix_mul_single_int_void**

说明: 矩阵乘以一个整数

函数原型:

```C
void matrix_mul_single_int_void(Matrix *a, int b)
```

**Input**:

| name | type    | description | required     |
|------|---------|-------------|--------------|
| 'a'  | Matrix* | 矩阵          | 不可省略；不可为NULL |
| 'b'  | int     | 整数          | 不可省略         |

使用示例:

```C
Matrix *mat = ones_matrix_value_void(3, 3, 1.0);//创建一个3*3的全 1 矩阵
matrix_print(mat);
// 输出结果如下：
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
Matrix rows: 3, cols: 3

matrix_mul_single_int_void(mat, 2);
matrix_print(mat);
// 输出结果如下：
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_mul_single_double_void**

说明: 矩阵乘以一个浮点数

函数原型:

```C
void matrix_mul_single_double_void(Matrix *a, double b)
```

**Input**:

| name | type    | description | required     |
|------|---------|-------------|--------------|
| 'a'  | Matrix* | 矩阵          | 不可省略；不可为NULL |
| 'b'  | double  | 浮点数         | 不可省略         |

使用示例:

```C
Matrix *mat = ones_matrix_value_void(3, 3, 1.0);//创建一个3*3的全 1 矩阵
matrix_print(mat);
// 输出结果如下：
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
Matrix rows: 3, cols: 3

matrix_mul_single_double_void(mat, 2.0);
matrix_print(mat);
// 输出结果如下：
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_mul_single_int**

说明: 矩阵乘以一个整数，并返回结果矩阵

函数原型:

```C
Matrix *matrix_mul_single_int(Matrix *a, int b)
```

**Input**:

| name | type    | description | required     |
|------|---------|-------------|--------------|
| 'a'  | Matrix* | 矩阵          | 不可省略；不可为NULL |
| 'b'  | int     | 整数          | 不可省略         |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全 1 矩阵
matrix_print(mat);
// 输出结果如下：
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
Matrix rows: 3, cols: 3

Matrix *mat2 = matrix_mul_single_int(mat, 2);
matrix_print(mat2);
// 输出结果如下：
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_mul_single_double**

说明: 矩阵乘以一个浮点数，并返回结果矩阵

函数原型:

```C
Matrix *matrix_mul_single_double(Matrix *a, double b)
```

**Input**:

| name | type    | description | required     |
|------|---------|-------------|--------------|
| 'a'  | Matrix* | 矩阵          | 不可省略；不可为NULL |
| 'b'  | double  | 浮点数         | 不可省略         |

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全 1 矩阵
matrix_print(mat);
// 输出结果如下：
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
|       1.000000        1.000000        1.000000        |
Matrix rows: 3, cols: 3

Matrix *mat2 = matrix_mul_single_double(mat, 2.0);
matrix_print(mat2);
// 输出结果如下：
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
|       2.000000        2.000000        2.000000        |
Matrix rows: 3, cols: 3
```

## 矩阵变换

### **matrix_to_2D_array**

说明: 将矩阵转换为二维数组

函数原型:

```C
MATRIX_TYPE **matrix_to_2D_array(Matrix *mat)
```

**Input**:

| name  | type    | description | required     |
|-------|---------|-------------|--------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL |

**Output**:

| type          | description |
|---------------|-------------|
| MATRIX_TYPE** | 二维数组        |

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

| name    | type          | description | required             |
|---------|---------------|-------------|----------------------|
| 'array' | MATRIX_TYPE** | 二维数组        | 不可省略；不可为NULL         |
| 'rows'  | unsigned int  | 行数          | 不可省略；必须与 array 的行数相等 |
| 'cols'  | unsigned int  | 列数          | 不可省略；必须与 array 的列数相等 |

**Output**:

| type    | description   |
|---------|---------------|
| Matrix* | 由 array 生成的矩阵 |

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

| name   | type         | description                   | required          |
|--------|--------------|-------------------------------|-------------------|
| 'mat1' | Matrix*      | 第一个矩阵                         | 不可省略；不可为NULL      |
| 'mat2' | Matrix*      | 第二个矩阵                         | 不可省略；不可为NULL      |
| 'aix'  | unsigned int | 拼接的方向，以a为参考，1,3：纵向拼接，2,4：横向拼接 | 不可省略；必须为 1~4中某个整数 |

| aix的值 | 拼接的方向          | required     |
|-------|----------------|--------------|
| 1     | 矩阵b纵向拼接到矩阵a的上方 | 矩阵a,b的列数必须相等 |
| 2     | 矩阵b横向拼接到矩阵a的右侧 | 矩阵a,b的行数必须相等 |
| 3     | 矩阵b纵向拼接到矩阵a的下方 | 矩阵a,b的列数必须相等 |
| 4     | 矩阵b横向拼接到矩阵a的左侧 | 矩阵a,b的行数必须相等 |

**Output**:

| type    | description |
|---------|-------------|
| Matrix* | 拼接后的矩阵      |

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

| name        | type         | description           | required     |
|-------------|--------------|-----------------------|--------------|
| 'a'         | Matrix*      | 矩阵                    | 不可省略；不可为NULL |
| 'begin_row' | unsigned int | 裁切起始行的实际行数，非索引，比索引大 1 | 必须小于等于矩阵行数   |
| 'end_row'   | unsigned int | 裁切结束行的实际行数，非索引，比索引大 1 | 必须小于等于矩阵行数   |
| 'begin_col' | unsigned int | 裁切起始列的实际列数，非索引，比索引大 1 | 必须小于等于矩阵列数   |
| 'end_col'   | unsigned int | 裁切结束列的实际列数，非索引，比索引大 1 | 必须小于等于矩阵列数   |

**Output**:

| name | type    | description |
|------|---------|-------------|
| 'a'  | Matrix* | 裁切得到的矩阵     |

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

| name           | type         | description               | required      |
|----------------|--------------|---------------------------|---------------|
| 'a'            | Matrix*      | 矩阵                        | 不可省略；不可为NULL  |
| 'aix'          | unsigned int | 交换方式，1：行交换，2：列交换          | 只能为 1 或 2     |
| 'select_index' | unsigned int | 被交换的行/列的实际行/列数，非索引，比索引大 1 | 必须小于等于矩阵行数或列数 |
| 'aim_index'    | unsigned int | 目标行/列的实际行/列数，非索引，比索引大 1   | 必须小于等于矩阵行数或列数 |

使用示例:

```C
Matrix *a = rand_matrix(3, 6, 0, 10);//生成一个 3 行 6 列的随机矩阵
matrix_print(a);//输出原始矩阵
// 输出结果如下：
|       0.012512        5.635681        1.932983        8.087158        5.849915        4.798584        |
|       3.502808        8.959351        8.228149        7.465820        1.741028        8.589172        |
|       7.104797        5.135193        3.039856        0.149841        0.914001        3.644409        |
Matrix rows: 3, cols: 6

matrix_swap(a, 1, 2, 3);//交换第 2 行和第 3 行
matrix_print(a);//输出交换后的矩阵
// 输出结果如下：
|       0.012512        5.635681        1.932983        8.087158        5.849915        4.798584        |
|       7.104797        5.135193        3.039856        0.149841        0.914001        3.644409        |
|       3.502808        8.959351        8.228149        7.465820        1.741028        8.589172        |
Matrix rows: 3, cols: 6

matrix_swap(a, 2, 3, 2);//交换第 3 列和第 2 列
matrix_print(a);//输出交换后的矩阵
// 输出结果如下：
|       0.012512        1.932983        5.635681        8.087158        5.849915        4.798584        |
|       7.104797        3.039856        5.135193        0.149841        0.914001        3.644409        |
|       3.502808        8.228149        8.959351        7.465820        1.741028        8.589172        |
Matrix rows: 3, cols: 6
```

### **matrix_min**

说明: 查找矩阵中的最小值

函数原型:

```C
MATRIX_TYPE matrix_min(const Matrix *mat);
```

**Input**:

| name  | type    | description | required     |
|-------|---------|-------------|--------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL |

**Output**:

| type        | description |
|-------------|-------------|
| MATRIX_TYPE | 矩阵中的最小值     |

使用示例:

```C
Matrix *a = rand_matrix(3, 6, 0, 10);//生成一个 3 行 6 列的随机矩阵
matrix_print(a);//输出原始矩阵
MATRIX_TYPE min = matrix_min(a);//查找矩阵中的最小值
printf("The min value in matrix is: %.6lf\n", min);
// 输出结果如下：
|	  0.012512	  5.635681	  1.932983	  8.087158	  5.849915	  4.798584	|	
|	  3.502808	  8.959351	  8.228149	  7.465820	  1.741028	  8.589172	|	
|	  7.104797	  5.135193	  3.039856	  0.149841	  0.914001	  3.644409	|	
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

| name  | type    | description | required     |
|-------|---------|-------------|--------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL |

**Output**:

| type        | description |
|-------------|-------------|
| MATRIX_TYPE | 矩阵中的最大值     |

使用示例:

```C
Matrix *a = rand_matrix(3, 6, 0, 10);//生成一个 3 行 6 列的随机矩阵
matrix_print(a);//输出原始矩阵
MATRIX_TYPE max = matrix_max(a);//查找矩阵中的最大值
printf("The max value in matrix is: %.6lf\n", max);
// 输出结果如下：
|	  0.012512	  5.635681	  1.932983	  8.087158	  5.849915	  4.798584	|	
|	  3.502808	  8.959351	  8.228149	  7.465820	  1.741028	  8.589172	|	
|	  7.104797	  5.135193	  3.039856	  0.149841	  0.914001	  3.644409	|	
Matrix rows: 3, cols: 6
The max value in matrix is: 8.959351
```

### **matrix_min_array**

说明: 查找矩阵中的最小值并放回其在矩阵中的位置

函数原型:

```C
elem_pos_array *matrix_min_array(const Matrix *mat);
```

**Input**:

| name  | type    | description | required     |
|-------|---------|-------------|--------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL |

**Output**:

| type            | description                              |
|-----------------|------------------------------------------|
| elem_pos_array* | 先行后列，从左到右，从上到下查找矩阵中的最小值及位置信息，包括行号和列号的索引值 |

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
|	  0.012512	  5.635681	  1.932983	  8.087158	  5.849915	  4.798584	|	
|	  3.502808	  8.959351	  8.228149	  7.465820	  1.741028	  8.589172	|	
|	  7.104797	  5.135193	  3.039856	  0.149841	  0.914001	  3.644409	|	
Matrix rows: 3, cols: 6
The number of min value in matrix is: 1, the min value is: 0.012512
The 1th min value is: 0.012512, at row_index: 0, col_index: 0
```

### **matrix_max_array**

说明: 查找矩阵中的最大值并放回其在矩阵中的位置

函数原型:

```C
elem_pos_array *matrix_max_array(const Matrix *mat);
```

**Input**:

| name  | type    | description | required     |
|-------|---------|-------------|--------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL |

**Output**:

| type            | description                              |
|-----------------|------------------------------------------|
| elem_pos_array* | 先行后列，从左到右，从上到下查找矩阵中的最大值及位置信息，包括行号和列号的索引值 |

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
|	  0.012512	  5.635681	  1.932983	  8.087158	  5.849915	  4.798584	|	
|	  3.502808	  8.959351	  8.228149	  7.465820	  1.741028	  8.589172	|	
|	  7.104797	  5.135193	  3.039856	  0.149841	  0.914001	  3.644409	|	
Matrix rows: 3, cols: 6
The number of max value in matrix is: 1, the max value is: 8.959351
The 1th max value is: 8.959351, at row_index: 1, col_index: 1
```

### **matrix_swap_elem**

说明: 交换矩阵中的两个元素

函数原型:

```C
void matrix_swap_elem(Matrix *mat, elem_pos pos1, elem_pos pos2);
```

**Input**:

| name   | type     | description | required     |
|--------|----------|-------------|--------------|
| 'mat'  | Matrix*  | 矩阵          | 不可省略；不可为NULL |
| 'pos1' | elem_pos | 第一个元素的位置    | 不可省略；不可为NULL |
| 'pos2' | elem_pos | 第二个元素的位置    | 不可省略；不可为NULL |

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
|	  0.012512	  5.635681	  1.932983	  8.087158	  5.849915	  4.798584	|	
|	  3.502808	  8.959351	  8.228149	  7.465820	  1.741028	  8.589172	|	
|	  7.104797	  5.135193	  3.039856	  0.149841	  0.914001	  3.644409	|	
Matrix rows: 3, cols: 6
交换后的矩阵为：
|	  0.012512	  5.635681	  1.932983	  8.087158	  5.849915	  4.798584	|	
|	  3.502808	  8.959351	  0.149841	  7.465820	  1.741028	  8.589172	|	
|	  7.104797	  5.135193	  3.039856	  8.228149	  0.914001	  3.644409	|	
Matrix rows: 3, cols: 6
```

### **matrix_gauss_elimination**

说明: 矩阵高斯消元，经初等行变换将矩阵转换为上三角矩阵

函数原型:

```C
void matrix_gauss_elimination(const Matrix *mat);
```

**Input**:

| name  | type    | description | required     |
|-------|---------|-------------|--------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL |

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
|	  0.012512	  5.635681	  1.932983	|	
|	  8.087158	  5.849915	  4.798584	|	
|	  3.502808	  8.959351	  8.228149	|	
Matrix rows: 3, cols: 3
高斯消元后的矩阵为：
|	  8.087158	  5.849915	  4.798584	|	
|	  0.000000	  6.425565	  6.149729	|	
|	  0.000000	  0.000000	 -3.459532	|	
Matrix rows: 3, cols: 3
```

### **matrix_rank**

说明: 使用高斯消元，将矩阵转换为上三角矩阵后，求矩阵的秩

函数原型:

```C
int matrix_rank(const Matrix *mat);
```

**Input**:

| name  | type    | description | required     |
|-------|---------|-------------|--------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL |

**Output**:

| type | description |
|------|-------------|
| int  | 矩阵的秩        |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    printf("矩阵的秩为：%d\n", matrix_rank(a)); //输出矩阵的秩
// 输出结果如下：
原始矩阵为：
|	  0.012512	  5.635681	  1.932983	|	
|	  8.087158	  5.849915	  4.798584	|	
|	  3.502808	  8.959351	  8.228149	|	
Matrix rows: 3, cols: 3
矩阵的秩为：3
```

### **matrix_find**

说明: 查找矩阵中符合要求的元素的值和其位置

函数原型:

```C
elem_pos_array *matrix_find(const Matrix *mat, MATRIX_TYPE value, __matrix_find_cmp_func cmp_func);
```

**Input**:

| name       | type                   | description | required     |
|------------|------------------------|-------------|--------------|
| 'mat'      | Matrix*                | 矩阵          | 不可省略；不可为NULL |
| 'value'    | MATRIX_TYPE            | 要查找的元素参考值   | 不可省略；不可为NULL |
| 'cmp_func' | __matrix_find_cmp_func | 比较函数        | 不可省略；不可为NULL |

**Output**:

| type            | description   |
|-----------------|---------------|
| elem_pos_array* | 符合要求的元素的值和其位置 |

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
|	  0.012512	  5.635681	  1.932983	|	
|	  8.087158	  5.849915	  4.798584	|	
|	  3.502808	  8.959351	  8.228149	|	
Matrix rows: 3, cols: 3
未找到符合条件的元素
```

### **matrix_invert**

说明: 构造输入矩阵的增广矩阵，使用高斯消元法求出矩阵的逆矩阵。

函数原型:

```C
Matrix *matrix_invert(Matrix *mat)
```

**Input**:

| name  | type    | description | required                                   |
|-------|---------|-------------|--------------------------------------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL；必须为方阵，如果矩阵不为方阵或为非奇异矩阵，就返回NULL |

**Output**:

| type    | description                    |
|---------|--------------------------------|
| Matrix* | 矩阵的逆矩阵，如果矩阵不为方阵或为非奇异矩阵，就返回NULL |

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
|	  0.500000	  0.000000	  0.000000	|	
|	  0.000000	  0.500000	  0.000000	|	
|	  0.000000	  0.000000	  0.500000	|	
Matrix rows: 3, cols: 3
矩阵的逆矩阵为：
|	  2.000000	  0.000000	  0.000000	|	
|	  0.000000	  2.000000	  0.000000	|	
|	  0.000000	  0.000000	  2.000000	|	
Matrix rows: 3, cols: 3
```

### **isUpTriangleMatrix**

说明: 判断输入矩阵是否为上三角矩阵。

函数原型:

```C
int isUpTriangleMatrix(const Matrix *mat);
```

**Input**:

| name  | type    | description | required     |
|-------|---------|-------------|--------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL |

**Output**:

| type | description                           |
|------|---------------------------------------|
| int  | 1 表示是上三角矩阵，0 表示不是上三角矩阵，-1 表示输入矩阵为NULL |

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
|	  8.424683	  9.682922	  1.461487	|	
|	  5.926208	  8.751831	  9.755859	|	
|	  8.882141	  8.345642	  4.658203	|	
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

| name  | type    | description | required     |
|-------|---------|-------------|--------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL |

**Output**:

| type | description                           |
|------|---------------------------------------|
| int  | 1 表示是下三角矩阵，0 表示不是下三角矩阵，-1 表示输入矩阵为NULL |

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
|	  8.424683	  9.682922	  1.461487	|	
|	  5.926208	  8.751831	  9.755859	|	
|	  8.882141	  8.345642	  4.658203	|	
Matrix rows: 3, cols: 3
矩阵不是下三角矩阵
```

### **matrix_det**

说明: 计算输入矩阵的行列式。

函数原型:

```C
MATRIX_TYPE matrix_det(Matrix *mat)
```

**Input**:

| name  | type    | description | required                         |
|-------|---------|-------------|----------------------------------|
| 'mat' | Matrix* | 矩阵          | 不可省略；不可为NULL；必须为方阵，如果矩阵不为方阵就终止程序 |

**Output**:

| type        | description |
|-------------|-------------|
| MATRIX_TYPE | 矩阵的行列式      |

使用示例:

```C
    Matrix *a = rand_matrix(3, 3, 0, 10); //生成一个 3 行 3 列的随机矩阵
    printf("原始矩阵为：\n");
    matrix_print(a); //输出原始矩阵
    MATRIX_TYPE b = matrix_det(a); //计算矩阵的行列式
    printf("矩阵的行列式为：%.6lf\n", b);
// 输出结果如下：
原始矩阵为：
|	  0.129089	  8.745117	  3.889771	|	
|	  3.380432	  1.418457	  8.922119	|	
|	  3.116455	  0.745544	  1.241150	|	
Matrix rows: 3, cols: 3
矩阵的行列式为：-198.446993
```
