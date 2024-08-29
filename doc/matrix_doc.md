# **注意**

因代码还在不断完善中，此文档有一定滞后性，仅作为参考。

# 说明

矩阵相关内容，以实现函数/方法及其说明如下：

```C
typedef struct _matrix_size {
    unsigned int rows; /// 矩阵行数
    unsigned int cols; /// 矩阵列数
} matrix_size;
```

```C
typedef struct _Matrix
{
    unsigned int rows; /// 矩阵行数
    unsigned int cols; /// 矩阵列数
    matrix_size size;  /// 矩阵的大小数据
    MATRIX_TYPE *data; /// 矩阵的数据
} Matrix;
```

**释义**:

|name|type|description|required|
|----|----|----|----|
|'rows'|unsigned int|矩阵行数|必须大于 0|
|'cols'|unsigned int|矩阵列数|必须大于 0|
|'data'|MATRIX_TYPE*|矩阵数据|MATRIX_TYPE 默认类型为 double, 暂不可自定义|

## 矩阵创建与销毁

### **matrix_gen**

说明: 由给定数据创建指定大小的矩阵，给定数据的长度必须小于等于指定矩阵的大小，长度不足时会自动补零。

函数原型:

```C
Matrix *matrix_gen(unsigned int rows, unsigned int cols, MATRIX_TYPE *data)
```

**Input**:

|name|type|description|required|
|----|----|----|----|
|'rows'|unsigned int|矩阵行数|必须大于 0|
|'cols'|unsigned int|矩阵列数|必须大于 0|
|'data'|MATRIX_TYPE*|矩阵数据|data 的长度必须<= rows * cols， 不足时会自动补零故可以为 NULL以创建全零矩阵|

**Output**:

|type|description|
|----|----|
|Matrix*|行数为 rows，列数为 cols 的矩阵|

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

|name|type|description|required|
|----|----|----|----|
|'rows'|unsigned int|生成的矩阵行数|必须大于 0|
|'cols'|unsigned int|生成的矩阵列数|必须大于 0|
|'data'|MATRIX_TYPE*|矩阵数据|MATRIX_TYPE 默认类型为 double, 暂不可自定义|
|'data_rows'|unsigned int|给定数据矩阵行数|必须大于 0且小于等于指定矩阵行数|
|'data_cols'|unsigned int|给定数据矩阵列数|必须大于 0且小于等于指定矩阵列数|

**Output**:

|type|description|
|----|----|
|Matrix*|生成的矩阵|

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

|name|type|description|required|
|----|----|----|----|
|'rows'|unsigned int|矩阵行数|必须大于 0|
|'cols'|unsigned int|矩阵列数|必须大于 0|

**Output**:

|type|description|
|----|----|
|Matrix*|行数为 rows，列数为 cols 的全 1 矩阵|

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

|name|type|description|required|
|----|----|----|----|
|'rows'|unsigned int|矩阵行数|必须大于 0；不可省略|
|'cols'|unsigned int|矩阵列数|必须大于 0；可以省略，若省略默认与 rows 取值相等|
|'value'|MATRIX_TYPE|矩阵数据|要求调用时必须显式指定数据为 MATRIX_TYPE(double) 类型， 否则可能会生成一个全零矩阵；可以省略，若省略默认则取值为 1|

**Output**:

|type|description|
|----|----|
|Matrix*|行数为 rows，列数为 cols 的值全为 value 的矩阵|

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

|name|type|description|required|
|----|----|----|----|
|'rows'|unsigned int|矩阵行数|必须大于 0；不可省略|
|'cols'|unsigned int|矩阵列数|必须大于 0；不可省略|

**Output**:

|type|description|
|----|----|
|Matrix*|行数为 rows，列数为 cols 的值全为 0 的矩阵|

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

|name|type|description|required|
|----|----|----|----|
|'rows'|unsigned int|矩阵行数|必须大于 0；不可省略|
|'cols'|unsigned int|矩阵列数|必须大于 0；不可省略|

**Output**:

|type|description|
|----|----|
|Matrix*|行数为 rows，列数为 cols 的主对角线全 1 的矩阵|

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

|name|type|description|required|
|----|----|----|----|
|'rows'|unsigned int|矩阵行数|必须大于 0；不可省略|
|'cols'|unsigned int|矩阵列数|必须大于 0；可以省略，若省略默认与 rows 取值相等|
|'value'|MATRIX_TYPE|矩阵数据|要求调用时必须显式指定数据为 MATRIX_TYPE(double) 类型， 否则可能会生成一个全零矩阵；可以省略，若省略默认则取值为 1|

**Output**:

|type|description|
|----|----|
|Matrix*|行数为 rows，列数为 cols 的主对角线全 1 的矩阵|

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

|name|type|description|required|
|----|----|----|----|
|'rows'|unsigned int|矩阵行数|必须大于 0；不可省略|
|'cols'|unsigned int|矩阵列数|必须大于 0；不可省略|
|'min'|MATRIX_TYPE|随机数最小值|不可省略|
|'max'|MATRIX_TYPE|随机数最大值|不可省略|

**Output**:

|type|description|
|----|----|
|Matrix*|行数为 rows，列数为 cols 的随机数矩阵，随机数取值范围为 [min, max]|

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
Matrix *matrix_copy(Matrix *_sourse_mat)
```

**Input**:

|name|type|description|required|
|----|----|----|----|
|'_sourse_mat'|Matrix*|要拷贝的矩阵|不可省略|

**Output**:

|type|description|
|----|----|
|Matrix*|拷贝的矩阵|

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

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|目标矩阵|不可省略|
|'b'|Matrix*|源矩阵|不可省略|

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

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵 a|不可省略；不可为NULL，要求'a'和'b'的行列数相等|
|'b'|Matrix*|矩阵 b|不可省略；不可为NULL，要求'a'和'b'的行列数相等|

**Output**:

|type|description|
|----|----|
|Matrix*|矩阵 a 加上矩阵 b 的和|

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

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵 a|不可省略；不可为NULL，要求'a'和'b'的行列数相等|
|'b'|Matrix*|矩阵 b|不可省略；不可为NULL，要求'a'和'b'的行列数相等|

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

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|被减矩阵|不可省略；不可为NULL，要求'a'和'b'的行列数相等|
|'b'|Matrix*|减矩阵|不可省略；不可为NULL，要求'a'和'b'的行列数相等|

**Output**:

|type|description|
|----|----|
|Matrix*|矩阵 a 减去矩阵 b 的差|

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

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵 a|不可省略；不可为NULL，要求'a'和'b'的行列数相等|
|'b'|Matrix*|矩阵 b|不可省略；不可为NULL，要求'a'和'b'的行列数相等|

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

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵 a|不可省略；不可为NULL，若为NULL，直接返回false|
|'b'|Matrix*|矩阵 b|不可省略；不可为NULL，若为NULL，直接返回false|

**Output**:

|type|description|
|----|----|
|bool|矩阵 a 是否等于矩阵 b，true为相等，false为不相等|

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

说明: 矩阵乘法。ab(即a左乘b)

函数原型:

```C
Matrix *matrix_mul(Matrix *a, Matrix *b)
```

**Input**:

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵 a|不可省略；不可为NULL，要求'a'列数与'b'的行数相等|
|'b'|Matrix*|矩阵 b|不可省略；不可为NULL，要求'a'列数与'b'的行数相等|

**Output**:

|type|description|
|----|----|
|Matrix*|矩阵 a 左乘以矩阵 b 的结果矩阵|

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

说明: 矩阵乘法。ba(即a右乘b)

函数原型:

```C
Matrix *matrix_right_mul(Matrix *a, Matrix *b)
```

**Input**:

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵 a|不可省略；不可为NULL，要求'a'行数与'b'的列数相等|
|'b'|Matrix*|矩阵 b|不可省略；不可为NULL，要求'a'行数与'b'的列数相等|

**Output**:

|type|description|
|----|----|
|Matrix*|矩阵 b 右乘以矩阵 a 的结果矩阵|

使用示例:

```C
Matrix *mat = ones_matrix_value(2, 3, 1.0);//创建一个3*3的全 1 矩阵
Matrix *mat2 = ones_matrix_value(3, 2, 2.0);///创建一个3*3的全 2 矩阵
Matrix *mat3 = matrix_right_mul(mat, mat2);
matrix_print(mat3);
// 输出结果如下：
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_mul_void**

说明: 矩阵乘法，并将结果保存到矩阵 a。ab(即a左乘b)

函数原型:

```C
void matrix_mul_void(Matrix *a, Matrix *b)
```

**Input**:

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵 a|不可省略；不可为NULL，要求'a'列数与'b'的行数相等|
|'b'|Matrix*|矩阵 b|不可省略；不可为NULL，要求'a'列数与'b'的行数相等|

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 2, 1.0);//创建一个3*3的全 1 矩阵
Matrix *mat2 = ones_matrix_value(2, 3, 2.0);///创建一个3*3的全 2 矩阵
matrix_mul_void(mat, mat2);
matrix_print(mat);
// 输出结果如下：
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_right_mul_void**

说明: 矩阵乘法，并将结果保存到矩阵 a。ba(即a右乘b)

函数原型:

```C
void matrix_right_mul_void(Matrix *a, Matrix *b)
```

**Input**:

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵 a|不可省略；不可为NULL，要求'a'行数与'b'的列数相等|
|'b'|Matrix*|矩阵 b|不可省略；不可为NULL，要求'a'行数与'b'的列数相等|

使用示例:

```C
Matrix *mat = ones_matrix_value(2, 3, 1.0);//创建一个3*3的全 1 矩阵
Matrix *mat2 = ones_matrix_value(3, 2, 2.0);///创建一个3*3的全 2 矩阵
matrix_right_mul_void(mat, mat2);
matrix_print(mat);
// 输出结果如下：
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
|       4.000000        4.000000        4.000000        |
Matrix rows: 3, cols: 3
```

### **matrix_transpose**

说明: 矩阵转置

函数原型:

```C
void matrix_transpose(Matrix *mat)
```

**Input**:

|name|type|description|required|
|----|----|----|----|
|'mat'|Matrix*|矩阵|不可省略；不可为NULL|

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

|name|type|description|required|
|----|----|----|----|
|'mat'|Matrix*|矩阵|不可省略；不可为NULL|

**Output**:

|type|description|
|----|----|
|Matrix*|转置后的矩阵|

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

1### **matrix_mul_single_int_void**

说明: 矩阵乘以一个整数

函数原型:

```C
void matrix_mul_single_int_void(Matrix *a, int b)
```

**Input**:

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵|不可省略；不可为NULL|
|'b'|int|整数|不可省略|

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

1### **matrix_mul_single_double_void**

说明: 矩阵乘以一个浮点数

函数原型:

```C
void matrix_mul_single_double_void(Matrix *a, double b)
```

**Input**:

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵|不可省略；不可为NULL|
|'b'|double|浮点数|不可省略|

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

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵|不可省略；不可为NULL|
|'b'|int|整数|不可省略|

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

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵|不可省略；不可为NULL|
|'b'|double|浮点数|不可省略|

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

### **matrixTo2Array**

说明: 将矩阵转换为二维数组

函数原型:

```C
MATRIX_TYPE **matrixTo2Array(Matrix *mat)
```

**Input**:

|name|type|description|required|
|----|----|----|----|
|'mat'|Matrix*|矩阵|不可省略；不可为NULL|

**Output**:

|type|description|
|----|----|
|MATRIX_TYPE**|二维数组|

使用示例:

```C
Matrix *mat = ones_matrix_value(3, 3, 1.0);//创建一个3*3的全 1 矩阵
MATRIX_TYPE **array = matrixTo2Array(mat);
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

### **twoArrayToMatrix**

说明: 将二维数组转换为矩阵

函数原型:

```C
Matrix *arrayToMatrix(MATRIX_TYPE *array,unsigned int rows,unsigned int cols)
```

**Input**:

|name|type|description|required|
|----|----|----|----|
|'array'|MATRIX_TYPE**|二维数组|不可省略；不可为NULL|
|'rows'|unsigned int|行数|不可省略；必须与 array 的行数相等|
|'cols'|unsigned int|列数|不可省略；必须与 array 的列数相等|

**Output**:

|type|description|
|----|----|
|Matrix*|由 array 生成的矩阵|

使用示例:

```C
MATRIX_TYPE **array = (MATRIX_TYPE **)malloc(sizeof(MATRIX_TYPE *) * 3);
for (int i = 0; i < 3; i++){
    array[i] = (MATRIX_TYPE *)malloc(sizeof(MATRIX_TYPE) * 3);
    for (int j = 0; j < 3; j++){
        array[i][j] = (i + 1) * (j + 1);
    }
}
Matrix *mat = arrayToMatrix(array, 3, 3);
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

|name|type|description|required|
|----|----|----|----|
|'mat1'|Matrix*|第一个矩阵|不可省略；不可为NULL|
|'mat2'|Matrix*|第二个矩阵|不可省略；不可为NULL|
|'aix'|unsigned int|拼接的方向，以a为参考，1,3：纵向拼接，2,4：横向拼接|不可省略；必须为 1~4中某个整数|

|aix的值|拼接的方向|required|
|----|----|----|
|1|矩阵b纵向拼接到矩阵a的上方|矩阵a,b的列数必须相等|
|2|矩阵b横向拼接到矩阵a的右侧|矩阵a,b的行数必须相等|
|3|矩阵b纵向拼接到矩阵a的下方|矩阵a,b的列数必须相等|
|4|矩阵b横向拼接到矩阵a的左侧|矩阵a,b的行数必须相等|

**Output**:

|type|description|
|----|----|
|Matrix*|拼接后的矩阵|

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

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵|不可省略；不可为NULL|
|'begin_row'|unsigned int|裁切起始行的实际行数，非索引，比索引大 1|必须小于等于矩阵行数|
|'end_row'|unsigned int|裁切结束行的实际行数，非索引，比索引大 1|必须小于等于矩阵行数|
|'begin_col'|unsigned int|裁切起始列的实际列数，非索引，比索引大 1|必须小于等于矩阵列数|
|'end_col'|unsigned int|裁切结束列的实际列数，非索引，比索引大 1|必须小于等于矩阵列数|

**Output**:

|name|type|description|
|----|----|----|
|'a'|Matrix*|裁切得到的矩阵|

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

|name|type|description|required|
|----|----|----|----|
|'a'|Matrix*|矩阵|不可省略；不可为NULL|
|'aix'|unsigned int|交换方式，1：行交换，2：列交换|只能为 1 或 2|
|'select_index'|unsigned int|被交换的行/列的实际行/列数，非索引，比索引大 1|必须小于等于矩阵行数或列数|
|'aim_index'|unsigned int|目标行/列的实际行/列数，非索引，比索引大 1|必须小于等于矩阵行数或列数|

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
