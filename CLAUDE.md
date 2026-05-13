# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **multi-language mathematical library** implementing scientific computing functions (sorting algorithms, data structures, etc.). All implementations work with **real numbers only** (no complex domain support).

> [!NOTE]
> Matrix and Integral modules are temporarily disabled for refactoring with Result type pattern.

## Language-Specific Build Commands

### C (C11)
```bash
# Build with CMake (uses Visual Studio on Windows)
cd C && mkdir -p build && cd build
cmake .. -G "Visual Studio 17 2022"
cmake --build . --config Release

# Run tests
cd C/build/bin/Release
./hsmk_mathlib_test.exe
```

### Java (JDK 21+)
```bash
cd Java/demo
mvn compile          # Compile
mvn test             # Run tests
mvn javadoc:javadoc  # Generate Javadoc
mvn site             # Generate project site
```

### Delphi (XE4+)
```bash
# Delphi has no standard build command
# Add delphi/src to your project search path
# Compile with: dcc32 -N..\delphi\src yourproject.dpr
# Or open in Delphi IDE / Lazarus
```

## Architecture

```
hsmk-mathematical-library/
├── C/                    # C11 implementation
│   ├── include/          # Header files (.h)
│   │   ├── Sort/         # Sorting algorithms
│   │   ├── List/         # Linked list
│   │   ├── Stack/        # Stack data structure
│   │   ├── Queue/        # Queue data structure
│   │   ├── Pair/         # Key-value pair
│   │   ├── BinaryTree/   # Binary tree
│   │   ├── Random/       # Random number generation
│   │   ├── StdDef/       # Standard definitions (Result, Exception, etc.)
│   │   └── Toolbox/      # Utility macros/functions
│   ├── src/              # Source files (.c)
│   └── tests/            # Test files
├── Java/demo/            # Java implementation (Maven project)
│   ├── src/main/java/com/hsmkmathlib/
│   │   ├── sort/         # Sorting algorithms
│   │   │   ├── algorithm/  # BubbleSort, HeapSort, MergeSort, etc.
│   │   │   └── utils/     # SortAlgorithm interface
│   │   └── tools/        # Utility classes (ArrayTools)
│   ├── docs/             # Documentation assets (images)
│   └── pom.xml
├── delphi/               # Delphi/Pascal implementation
│   ├── src/
│   │   ├── General/       # Core utilities (ExceptionStrConsts, GeneralType, MemoryUtils, RTTIMethodUtils)
│   │   ├── Array/         # Array operations (ArrayHelperUnit)
│   │   └── Sort/          # Sorting algorithms (SortFunctionToolUnit, CLikeFunctionToolsUnit)
│   └── README.md          # Delphi documentation
├── matlab/               # MATLAB scripts
├── python/               # Python implementation (placeholder)
└── build/                # Build outputs (organized by language)
    ├── c/                # C build artifacts (CMake/VS)
    └── java/             # Java build artifacts (Maven target/)
```

### Key Implementation Notes

- **File encoding**: UTF-8 throughout all languages
- **Java package**: `com.hsmkmathlib` under `Java/demo/src/main/java/`
- **C module structure**: Each module (Sort, Stack, List, etc.) has separate header/source pairs
- **C Result type** (`StdDef/result.h`): Rust-like error handling pattern with `HSMK_RESULT`, `HSMK_RESULT_OK()`, `HSMK_RESULT_ERR()`
- **Design patterns**: Singleton (INSTANCE), Strategy (SortAlgorithm interface), Template Method (base classes)
