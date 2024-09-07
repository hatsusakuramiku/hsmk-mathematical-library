# 最低版本要求
cmake_minimum_required(VERSION 3.28)
# 项目名称
project(hsmk_mathematical_library C)

# C 语言标准
set(CMAKE_C_STANDARD 11)

# Define source and include directories
set(SRC_DIR ${PROJECT_SOURCE_DIR}/src)
set(INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)

# Check if directories exist
if (NOT EXISTS ${SRC_DIR})
    message(FATAL_ERROR "Source directory '${SRC_DIR}' does not exist.")
endif ()
if (NOT EXISTS ${INCLUDE_DIR})
    message(FATAL_ERROR "Include directory '${INCLUDE_DIR}' does not exist.")
endif ()

# 整合源文件
file(GLOB SUB_SRC_DIR RELATIVE ${SRC_DIR} ${SRC_DIR}/*)
foreach (SUB_DIR ${SUB_SRC_DIR})
    if (IS_DIRECTORY ${SRC_DIR}/${SUB_DIR})
        aux_source_directory(${SRC_DIR} SRC_LIST)
        #        include_directories(${SRC_DIR}/${SUB_SRC_DIR})
    endif ()
endforeach ()
#aux_source_directory(${SRC_DIR} SRC_LIST)

# 引入头文件
# Include subdirectories
file(GLOB INCLUDE_SUBDIRS RELATIVE ${INCLUDE_DIR} ${INCLUDE_DIR}/*)
foreach (SUBDIR ${INCLUDE_SUBDIRS})
    if (IS_DIRECTORY ${INCLUDE_DIR}/${SUBDIR})
        include_directories(${INCLUDE_DIR}/${SUBDIR})
    endif ()
endforeach ()
#include_directories(RECURSE ${INCLUDE_DIR})
# 生成库文件
add_library(HMLib_Static STATIC ${SRC_LIST}
        src/Matrix/matrix.c
        include/StdDef/constDef.h
        include/Matrix/matrix.h
        src/Matrix/vector.c
        include/StdDef/memswap.h
        include/List/list.h
        include/List/list.h
        include/Stack/stack.h
        include/Stack/stack.h
        include/Pair/pair.h
        include/Pair/pair.h
        src/List/list.c
        src/Pair/pair.c
        src/Stack/stack.c
        src/Stack/stack.c
        src/Stack/stack.c
        src/List/list.c
        src/Sort/sort.c
        include/Sort/sort.h
        src/Queue/queue.c
        include/Queue/queue.h
        include/Random/random.h
        src/Toolbox/toolbox.c
        include/Toolbox/toolbox.h
        src/Integral/integral.c
        include/Integral/integral.h
)
add_library(HMLib_Dynamic SHARED ${SRC_LIST}
        src/Matrix/matrix.c
        include/StdDef/constDef.h
        include/Matrix/matrix.h
        include/Matrix/vector.h
        src/Matrix/vector.c
        include/StdDef/memswap.h
        include/List/list.h
        include/List/list.h
        include/Stack/stack.h
        include/Stack/stack.h
        include/Pair/pair.h
        include/Pair/pair.h
        src/List/list.c
        src/Pair/pair.c
        src/Stack/stack.c
        src/Stack/stack.c
        src/Stack/stack.c
        src/List/list.c
        src/Sort/sort.c
        include/Sort/sort.h
        src/Queue/queue.c
        include/Queue/queue.h
        include/Random/random.h
        src/Toolbox/toolbox.c
        include/Toolbox/toolbox.h
        src/Integral/integral.c
        include/Integral/integral.h
)

# 设置最终生成的库文件名
set_target_properties(HMLib_Static PROPERTIES OUTPUT_NAME "HMLib")
set_target_properties(HMLib_Dynamic PROPERTIES OUTPUT_NAME "HMLib")

# 设置库文件输出路径
set_target_properties(HMLib_Static PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/../lib)
set_target_properties(HMLib_Dynamic PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/../lib)


add_executable(test ./test.c
        src/Matrix/matrix.c
        include/StdDef/constDef.h
        include/Matrix/matrix.h
        src/Matrix/vector.c
        include/StdDef/memswap.h
        include/List/list.h
        include/List/list.h
        include/Stack/stack.h
        include/Stack/stack.h
        include/Pair/pair.h
        include/Pair/pair.h
        src/List/list.c
        src/Pair/pair.c
        src/Stack/stack.c
        src/Stack/stack.c
        src/Stack/stack.c
        src/List/list.c
        src/Sort/sort.c
        include/Sort/sort.h
        src/Queue/queue.c
        include/Queue/queue.h
        include/Random/random.h
        src/Toolbox/toolbox.c
        include/Toolbox/toolbox.h
        src/Integral/integral.c
        include/Integral/integral.h
)
