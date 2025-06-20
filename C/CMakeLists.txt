cmake_minimum_required(VERSION 3.10)
project(hsmk-mathematical-library C)

# 包含头文件目录
include_directories(
    include
    include/Matrix
    include/Stack
    include/Toolbox
    include/Queue
    include/Sort
    include/Pair
    include/List
    include/BinaryTree
    include/Integral
    include/StdDef
    include/Random
)

# 收集所有源文件
set(SRC_FILES
    src/Matrix/matrix.c
    src/Matrix/vector.c
    src/Stack/stack.c
    src/Toolbox/toolbox.c
    src/Queue/queue.c
    src/Sort/sort.c
    src/Pair/pair.c
    src/List/list.c
    src/BinaryTree/compBinaryTree.c
    src/Integral/integral.c
)

set(TEST_FILES
    tests/main.c
)

# 生成静态库
add_library(hsmk_mathlib STATIC ${SRC_FILES})

# 可选：设置C标准
set_target_properties(hsmk_mathlib PROPERTIES C_STANDARD 11 C_STANDARD_REQUIRED YES)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_executable(hsmk_mathlib_test ${TEST_FILES})