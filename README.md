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

部分完成，文档 [matrix_doc.md](/doc/matrix_doc.md),
头文件 [matrix.h](/include/Matrix/matrix.h),
源文件 [matrix.c](/src/Matrix/matrix.c).

- [x] 普通矩阵、随机矩阵、单位矩阵、对角矩阵的创建与销毁等
- [x] 矩阵乘积，包括 $A \times B, A \cdot B$
- [x] 矩阵转置
- [x] 矩阵拼接与分割
- [x] 矩阵简单四则运算
- [x] 矩阵与二维数组间的转换
- [x] 矩阵求逆
- [x] 矩阵求特征值
- [x] 矩阵求行列式
- [x] 高斯消元
- [x] 矩阵求秩
- [x] 线性方程组的求解
- [ ] 矩阵(P)LU分解

### 排序

部分完成，文档 [sort_doc.md](/doc/sort_doc.md),
头文件 [sort.h](/include/Sort/sort.h),
源文件 [sort.c](/src/Sort/sort.c).

- [x] 快速排序
- [x] 冒泡排序
- [x] 插入排序
- [x] 选择排序

### 其他数据结构

-[x] 线性单链表
-[x] 栈
-[x] 线性队列
-[ ] 二叉树
-[ ] 红黑树
-[ ] 集合
-[ ] 哈希表

### 数值积分

- [x] (复化)梯形积分
- [x] (复化)辛普森积分
- [x] 自适应辛普森积分
- [ ] 自适应高精度积分
- [ ] 高斯积分
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


