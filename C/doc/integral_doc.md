# 说明

本文件是[integral.c](/C/src/Integral/integral.c)和[integral.h](/C/include/Integral/integral.h)
的简要说明文档。简要说明其中可供外部调用的函数/宏定义的功能和用法。

## 基础类型与宏

### 误差限

```C
#define EPS 1e-6
```

### 区间

区间左端点必须小于区间右端点。

```C
typedef struct _Interval {
    double a;// 区间左端点
    double b;// 区间右端点
} Interval;
```

### 被积函数

#### **\_\_integral_func**

说明: 一维被积函数类型定义。

```C
typedef double (*__integral_func)(const double)
```

#### **\_\_iintegral_func**

说明: 二维被积函数类型定义。

```C
typedef double (*__iintegral_func)(const double, const double)
```

## 一维积分

## **trapezoid**

说明: 梯形法求一维定积分。

函数原型：

```C
double trapezoid(const Interval interval, const unsigned int intervalNum, const __integral_func func)
```

**Input**:

| name        | type              | description      | required   |
| ----------- | ----------------- | ---------------- | ---------- |
| interval    | Interval          | 被积函数积分区间 |            |
| intervalNum | unsigned int      | 积分区间划分数量 | 不能小于 1 |
| func        | \_\_integral_func | 被积函数         |            |

**Output**:

| type   | description |
| ------ | ----------- |
| double | 积分结果    |

**使用示例**:

```C
double f(const double x) {
    return x * x;
}
void main(void){
    Interval interval = {0, 1};
    double result = trapezoid(interval, 1000, f);
    printf("result = %.6lf\n", result);
}
// 预览结果如下:
result = 0.333333
```

### **simpson**

说明: 辛普森法求一维定积分。

函数原型：

```C
double simpson(const Interval interval, const unsigned int intervalNum, const __integral_func func);
```

**Input**:

| name        | type              | description      | required   |
| ----------- | ----------------- | ---------------- | ---------- |
| interval    | Interval          | 被积函数积分区间 |            |
| intervalNum | unsigned int      | 积分区间划分数量 | 不能小于 3 |
| func        | \_\_integral_func | 被积函数         |            |

**Output**:

| type   | description |
| ------ | ----------- |
| double | 积分结果    |

**使用示例**:

```C
double f(const double x) {
    return x * x;
}
void main(void){
    Interval interval = {0, 1};
    double result = simpson(interval, 1000, f);
    printf("result = %.6lf\n", result);
}
// 预览结果如下:
result = 0.333333
```

### **adaptiveSimpson**

说明: 自适应辛普森法求一维定积分。

函数原型：

```C
double adaptiveSimpson(const Interval interval, const double error, const __integral_func func);
```

**Input**:

| name     | type              | description      | required   |
| -------- | ----------------- | ---------------- | ---------- |
| interval | Interval          | 被积函数积分区间 |            |
| error    | double            | 积分误差上限     | 必须大于 0 |
| func     | \_\_integral_func | 被积函数         |            |

**Output**:

| type   | description |
| ------ | ----------- |
| double | 积分结果    |

**使用示例**:

```C
double f(const double x) {
    return x * x;
}
void main(void){
    Interval interval = {0, 1};
    double result = adaptiveSimpson(interval, EPS, f);
    printf("result = %.6lf\n", result);
}
// 预览结果如下:
result = 0.333333
```

### **gaussLegendre2PointIntegral**

说明: 高斯-勒让德积分法两点格式求一维定积分。

函数原型：

```C
double gaussLegendre2PointIntegral(const Interval interval, const unsigned int intervalNum, const __integral_func func)
```

**Input**:

| name        | type              | description      | required   |
| ----------- | ----------------- | ---------------- | ---------- |
| interval    | Interval          | 被积函数积分区间 |            |
| intervalNum | unsigned int      | 积分区间划分数量 | 不能小于 1 |
| func        | \_\_integral_func | 被积函数         |            |

**Output**:

| type   | description |
| ------ | ----------- |
| double | 积分结果    |

**使用示例**:

```C
double f(const double x) {
    return x * x;
}
void main(void){
    Interval interval = {0, 1};
    double result = gaussLegendre2PointIntegral(interval, 1000, f);
    printf("result = %.6lf\n", result);
}
// 预览结果如下:
result = 0.333333
```

### **gaussLegendre3PointIntegral**

说明: 高斯-勒让德积分法三点格式求一维定积分。

函数原型：

```C
double gaussLegendre3PointIntegral(const Interval interval, const unsigned int intervalNum, const __integral_func func)
```

**Input**:

| name        | type              | description      | required   |
| ----------- | ----------------- | ---------------- | ---------- |
| interval    | Interval          | 被积函数积分区间 |            |
| intervalNum | unsigned int      | 积分区间划分数量 | 不能小于 2 |
| func        | \_\_integral_func | 被积函数         |            |

**Output**:

| type   | description |
| ------ | ----------- |
| double | 积分结果    |

**使用示例**:

```C
double f(const double x) {
    return x * x;
}
void main(void){
    Interval interval = {0, 1};
    double result = gaussLegendre3PointIntegral(interval, 1000, f);
    printf("result = %.6lf\n", result);
}
// 预览结果如下:
result = 0.333333
```

### **newtonRaphsonIntegral**

说明: 牛顿-拉夫逊法求一维定积分。

函数原型：

```C
double newtonRaphsonIntegral(const Interval interval, const unsigned int intervalNum, unsigned int order, const
                             __integral_func func)
```

**Input**:

| name        | type              | description       | required             |
| ----------- | ----------------- | ----------------- | -------------------- |
| interval    | Interval          | 被积函数积分区间  |                      |
| intervalNum | unsigned int      | 积分区间划分数量  | 不能小于 1           |
| order       | unsigned int      | 牛顿-拉夫逊法阶数 | 最小 1 阶，最大 8 阶 |
| func        | \_\_integral_func | 被积函数          |                      |

**Output**:

| type   | description |
| ------ | ----------- |
| double | 积分结果    |

**使用示例**:

```C
double f(const double x) {
    return x * x;
}
void main(void){
    Interval interval = {0, 1};
    double result = newtonRaphsonIntegral(interval, 1000, 1, f);
    printf("result = %.6lf\n", result);
}
// 预览结果如下:
result = 0.333333
```
