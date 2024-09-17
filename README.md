# 说明

这个项目目的是使用不同语言实现一些科学计算功能等，如（偏）微分方程数值解、曲线拟合等。

> [!NOTE]
> 为方便开发，本项目仅支持实数域内的相关运算。

> [!NOTE]
> 下文所提到的语言标准/版本均为我使用的标准/版本，不代表运行/使用项目所要求的最低/高版本。
> 因项目仍在不断完善中，在发布第一个可用版本前，本项目临时推荐与我相同的语言标准/版本。

## C （C 语言）

> **语言标准**: C11
> **编译器**: gcc.exe (x86_64-posix-sjlj-rev0, Built by MinGW-W64 project) 8.1.0
> **文件编码**: UTF-8
> **字符集**: UTF-8

<details>
<summary>欲实现功能如下</summary>

### 矩阵运算

部分完成，文档 [matrix_doc.md](C/doc/matrix_doc.md),
头文件 [matrix.h](C/include/Matrix/matrix.h),
源文件 [matrix.c](C/src/Matrix/matrix.c).

#### 主要功能

- [x] [普通矩阵](C/doc/matrix_doc.md#matrix_gen), [随机矩阵](C/doc/matrix_doc.md#rand_matrix), [单位矩阵](C/doc/matrix_doc.md#eye_matrix), [对角矩阵](C/doc/matrix_doc.md#diagMatrix)
  的创建
- [x] 
  矩阵的复制: [matrix_copy](C/doc/matrix_doc.md#matrix_copy), [matrix_copy_](C/doc/matrix_doc.md#matrix_copy_r)
- [x] 
  矩阵乘积: [$A \times B$](C/doc/matrix_doc.md#matrix_mul), [$A \cdot B$](C/doc/matrix_doc.md#matrix_cdot_mul),
  [$a \cdot B, a \in C$](C/doc/matrix_doc.md#matrix_mul_single)
- [x] [矩阵转置](C/doc/matrix_doc.md#matrix_transpose)
- [x] 矩阵[拼接](C/doc/matrix_doc.md#matrix_splicing)与[分割](C/doc/matrix_doc.md#matrix_cat)
- [x] 矩阵[加法](C/doc/matrix_doc.md#matrix_add)与[减法](C/doc/matrix_doc.md#matrix_sub)
- [x] 矩阵与二维数组间的转换: [矩阵转二维数组](C/doc/matrix_doc.md#matrix_to_2d_array), [二维数组转矩阵](C/doc/matrix_doc.md#matrix_from_2d_array)
- [x] [求逆矩阵](C/doc/matrix_doc.md#matrix_invert)
- [x] [矩阵求特征值](C/doc/matrix_doc.md#matrix_eigen_matrix)
- [x] [矩阵求行列式](C/doc/matrix_doc.md#matrix_det)
- [x] 
  高斯消元:[单步消元](C/doc/matrix_doc.md#matrix_gauss_elimination_), [直接消元成上三角矩阵](C/doc/matrix_doc.md#matrix_gauss_elimination)
- [x] [矩阵求秩](C/doc/matrix_doc.md#matrix_rank)
- [x] [线性方程组的求解](C/doc/matrix_doc.md)
- [x] [矩阵(P)LU分解](C/doc/matrix_doc.md)

#### 辅助功能

-[x] [查找矩阵中符合条件的元素](C/doc/matrix_doc.md)
-[x] 矩阵中元素的[最大值](C/doc/matrix_doc.md), [最小值](C/doc/matrix_doc.md)
-[x] [求矩阵的行列式](C/doc/matrix_doc.md)

### 排序

部分完成，文档 [sort_doc.md](C/doc/sort_doc.md),
头文件 [sort.h](C/include/Sort/sort.h),
源文件 [sort.c](C/src/Sort/sort.c).

- [ ] 快速排序
- [x] [冒泡排序](C/doc/sort_doc.md#bubblesort)
- [x] [插入排序](C/doc/sort_doc.md#insertionsort)
- [x] [选择排序](C/doc/sort_doc.md#selectionsort)
- [x] [归并排序](C/doc/sort_doc.md#mergesort)
- [x] [堆排序](C/doc/sort_doc.md#heapsort)

### 其他数据结构

- [x] 线性单链表
- [x] 栈
- [x] 线性队列
- [ ] 二叉树
- [ ] 红黑树
- [ ] 集合
- [ ] 哈希表

### 数值积分

#### 一维积分

- [x] (复化)梯形积分
- [x] (复化)辛普森积分
- [x] 自适应辛普森积分
- [ ] 自适应高精度积分
- [x] 高斯勒让德积分

#### 二维积分

- [ ] 龙格-库塔积分

### 曲线拟合

- [ ] 线性回归
- [ ] 非线性回归

### 插值

- [ ] 拉格朗日插值
- [ ] 牛顿插值
- [ ] 线性插值
- [ ] 双线性插值

### 微分方程数值解

- [ ] 欧拉方法
- [ ] 龙格-库塔方法
- [ ] 高斯方法
- [ ] 有限差分法

</details>

