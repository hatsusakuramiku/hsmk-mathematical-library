# Matrix Operations (C)

> [!WARNING]
> **Matrix module is temporarily disabled for refactoring with Result type pattern.**
>
> The matrix functionality is being redesigned to use the new `HSMK_RESULT` error handling pattern.
> Refer to [result.h](../include/StdDef/result.h) and [result_types.h](../include/StdDef/result_types.h) for the new error handling approach.

## Planned Implementation

Once refactoring is complete, this module will provide:

### Matrix Types

```c
// Matrix element type (currently double)
typedef double MATRIX_TYPE;

// Matrix structure
typedef struct _Matrix {
    unsigned int rows;      // Number of rows
    unsigned int cols;      // Number of columns
    MATRIX_TYPE *data;     // Matrix data (row-major)
} Matrix;

// Vector alias (row or column vector)
typedef Matrix MVector;
```

### Planned Features

| Feature | Status |
|---------|--------|
| matrix_gen / rand_matrix / eye_matrix / diag_matrix | Planned |
| matrix_copy / matrix_copy_r | Planned |
| matrix_mul / matrix_cdot_mul / matrix_mul_single | Planned |
| matrix_transpose | Planned |
| matrix_splicing / matrix_cat | Planned |
| matrix_add / matrix_sub | Planned |
| matrix_to_2D_array / matrix_from_2D_array | Planned |
| matrix_invert | Planned |
| matrix_eigen_matrix | Planned |
| matrix_det | Planned |
| matrix_gauss_elimination / matrix_gauss_elimination_ | Planned |
| matrix_rank | Planned |
| matrix_equation (linear systems) | Planned |
| matrix_plu_dec (LU decomposition) | Planned |

### Result Type Pattern

The refactored matrix functions will use the `HSMK_RESULT` pattern for error handling:

```c
#include "StdDef/result.h"

// Example usage (future)
HSMK_RESULT_MATRIX result = matrix_invert(&A, &A_inv);
if (!HSMK_RESULT_IS_OK(result)) {
    // Handle error
    HSMK_RESULT_DESTROY(result);
}
```

See [result_types.h](../include/StdDef/result_types.h) for predefined result types.

---

## Current Temporary Workaround

For immediate needs, the legacy matrix implementation remains in:
- Header: [matrix.h](../include/Matrix/matrix.h) *(if exists)*
- Source: [matrix.c](../src/Matrix/matrix.c) *(if exists)*

> [!NOTE]
> This legacy code does not use the Result pattern and may have limited error handling.