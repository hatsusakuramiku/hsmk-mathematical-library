# hsmk-mathematical-library

多语言科学计算库，实现科学计算功能（排序算法、数据结构等）。

> [!NOTE]
> 1. 本项目仅支持实数域内的相关运算。
> 2. Matrix 和 Integral 模块正在重构中，暂时禁用。

---

## 项目结构

```
hsmk-mathematical-library/
├── C/                    # C11 实现
│   ├── include/          # 头文件 (.h)
│   ├── src/              # 源文件 (.c)
│   └── tests/            # 测试文件
├── Java/demo/            # Java 实现 (Maven)
│   ├── src/main/java/   # 源代码
│   └── pom.xml
├── delphi/               # Delphi/Pascal 实现
│   ├── src/              # 源代码 (.pas)
│   └── README.md         # 文档
├── matlab/               # MATLAB 脚本 (占位)
├── python/               # Python 实现 (占位)
└── build/                # 构建输出
```

---

## C (C11)

> **语言标准**: C11
> **文件编码**: UTF-8

### 排序算法

文档: [sort_doc.md](C/doc/sort_doc.md)

- [x] 冒泡排序
- [x] 插入排序
- [x] 选择排序
- [x] 归并排序
- [x] 堆排序
- [ ] 希尔排序
- [ ] 快速排序
- [ ] 基数排序

### 数据结构

- [x] 线性单链表: [list.h](C/include/List/list.h), [list.c](C/src/List/list.c)
- [x] 栈: [stack.h](C/include/Stack/stack.h), [stack.c](C/src/Stack/stack.c)
- [x] 线性队列: [queue.h](C/include/Queue/queue.h), [queue.c](C/src/Queue/queue.c)
- [ ] 完全二叉树
- [ ] 红黑树
- [ ] 集合
- [ ] 哈希表

### 核心定义

- [x] Result 类型: [result.h](C/include/StdDef/result.h), [result_types.h](C/include/StdDef/result_types.h) - Rust-like 错误处理
- [x] Exception 类型: [exception.h](C/include/StdDef/exception.h)

---

## Java (JDK 21+)

> **JDK**: JDK 21
> **文件编码**: UTF-8

### 排序算法

- [x] [BubbleSort](Java/demo/src/main/java/com/hsmkmathlib/sort/algorithm/BubbleSort.java)
- [x] [InsertionSort](Java/demo/src/main/java/com/hsmkmathlib/sort/algorithm/InsertionSort.java)
- [x] [SelectionSort](Java/demo/src/main/java/com/hsmkmathlib/sort/algorithm/SelectionSort.java)
- [x] [MergeSort](Java/demo/src/main/java/com/hsmkmathlib/sort/algorithm/MergeSort.java)
- [x] [HeapSort](Java/demo/src/main/java/com/hsmkmathlib/sort/algorithm/HeapSort.java)

### 排序工具类

```java
import com.hsmkmathlib.sort.Sorts;
import com.hsmkmathlib.sort.algorithm.BubbleSort;
import com.hsmkmathlib.sort.algorithm.MergeSort;

// 使用类类型
Integer[] arr = {5, 2, 8, 1, 9};
Sorts.sort(BubbleSort.class, arr);
Sorts.sort(MergeSort.class, arr, 0, arr.length, SortAlgorithm.DESCENDING);

// 使用实例
Sorts.sort(new BubbleSort(), arr, SortAlgorithm.ASCENDING);
```

### 构建命令

```bash
cd Java/demo
mvn compile          # 编译
mvn test             # 运行测试
mvn javadoc:javadoc  # 生成文档
```

---

## Delphi (XE4+)

> **版本**: Delphi XE4 (10.0) 或更高
> **文件编码**: UTF-8

### 模块

| 模块 | 文件 | 说明 |
|------|------|------|
| [GeneralTypeUnit](delphi/src/General/GeneralTypeUnit.pas) | 类型定义 | TIntegerArray, TStringArray, TExtendedArray 等 |
| [ArrayHelperUnit](delphi/src/Array/ArrayHelperUnit.pas) | 数组操作 | TArrayHelper 泛型类 |
| [SortFunctionToolUnit](delphi/src/Sort/SortFunctionToolUnit.pas) | 排序算法 | TArraySortUtils，支持 IDataAccessor |
| [CLikeFunctionToolsUnit](delphi/src/Sort/CLikeFunctionToolsUnit.pas) | C风格排序 | 指针操作，低级排序和搜索 |
| [MemoryUtils](delphi/src/General/MemoryUtils.pas) | 内存操作 | MemSwap, ReverseByte, ReverseArray |
| [RTTIMethodUtilsUnit](delphi/src/General/RTTIMethodUtilsUnit.pas) | RTTI工具 | 动态事件绑定，属性操作 |

### 排序算法

- [x] 冒泡排序 (BubbleSort)
- [x] 选择排序 (SelectionSort)
- [x] 插入排序 (InsertionSort)
- [x] 希尔排序 (ShellSort)
- [x] 快速排序 (QuickSort)
- [x] 归并排序 (MergeSort)
- [x] 堆排序 (HeapSort)
- [x] 内省排序 (IntroSort)
- [x] 混合排序 (HybridSort)

### 快速开始

```pascal
uses
  System.SysUtils, ArrayHelperUnit, SortFunctionToolUnit,
  System.Generics.Defaults;

var
  Numbers: TArray<Integer>;
begin
  SetLength(Numbers, 5);
  Numbers := [5, 2, 8, 1, 9];

  // 排序 (默认 QuickSort)
  TArraySortUtils.Sort<Integer>(Numbers, TComparer<Integer>.Default);

  // 转换为字符串
  WriteLn(TArrayHelper.ToString<Integer>(Numbers, IntToStr));
  // 输出: [1,2,5,8,9]
end;
```

详细文档: [delphi/README.md](delphi/README.md)

---

## 待实现功能

### 数值计算

- [ ] 曲线拟合 (线性回归、非线性回归)
- [ ] 插值 (拉格朗日、牛顿、线性、双线性)
- [ ] 微分方程数值解 (欧拉、龙格-库塔、有限差分)

### 数据结构

- [ ] 完全二叉树
- [ ] 红黑树
- [ ] 集合
- [ ] 哈希表

---

## 贡献

欢迎提交 Issue 和 Pull Request。