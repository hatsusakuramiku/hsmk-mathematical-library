# Sorting Algorithms (C)

> [!NOTE]
> This documentation reflects the current implementation in `sort.h` and `sort.c`.
> All sorting functions produce **ascending order** results by default.

## Comparison Functions

### Types

```c
/**
 * @brief Comparison function type (without context argument).
 * @param a Pointer to first element.
 * @param b Pointer to second element.
 * @return Negative if a < b, 0 if equal, positive if a > b.
 */
typedef int (*default_compare)(const void *, const void *);

/**
 * @brief Comparison function type (with context argument).
 * @param a Pointer to first element.
 * @param b Pointer to second element.
 * @param arg User-provided context argument.
 * @return Negative if a < b, 0 if equal, positive if a > b.
 */
typedef int (*default_compare_s)(const void *, const void *, void *);
```

### Built-in Examples

```c
// Ascending order comparison for double
int default_compare_example(const void *a, const void *b);

// With context argument
int default_compare_example_s(const void *a, const void *b, const void *arg);
```

## Algorithms

### bubbleSort

```c
void bubbleSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);
void bubbleSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);
```

| Parameter | Type | Description |
|-----------|------|-------------|
| array | void\* | Pointer to array to sort |
| elemNum | size_t | Number of elements |
| elemSize | size_t | Size of each element in bytes |
| compare | default_compare / default_compare_s | Comparison function |
| arg | void\* | Context argument (for _s variant) |

**Complexity:** O(n²) time, O(1) space

---

### insertionSort

```c
void insertionSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);
void insertionSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);
```

**Complexity:** O(n²) worst/average, O(n) best, O(1) space

---

### selectionSort

```c
void selectionSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);
void selectionSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);
```

**Complexity:** O(n²) all cases, O(1) space

---

### quickSort

```c
void quickSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);
void quickSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);
```

**Complexity:** O(n log n) average, O(n²) worst, O(log n) space

---

### mergeSort

```c
void mergeSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);
void mergeSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);
```

> [!NOTE]
> Uses O(n) temporary space. If memory allocation fails, behavior depends on implementation.

**Complexity:** O(n log n) all cases, O(n) space

---

### heapSort

```c
void heapSort(void *array, size_t elemNum, size_t elemSize, default_compare compare);
void heapSort_s(void *array, size_t elemNum, size_t elemSize, default_compare_s compare, void *arg);
```

**Complexity:** O(n log n) all cases, O(1) space

---

## Usage Example

```c
#include "sort.h"
#include <stdio.h>

int cmp_double(const void *a, const void *b) {
    double da = *(const double *)a;
    double db = *(const double *)b;
    return (da > db) - (da < db);  // Safe comparison
}

int main(void) {
    double arr[] = {5.0, 2.0, 8.0, 1.0, 9.0};
    size_t n = sizeof(arr) / sizeof(arr[0]);

    // Sort in ascending order
    quickSort(arr, n, sizeof(double), cmp_double);

    for (size_t i = 0; i < n; i++) {
        printf("%.1f ", arr[i]);
    }
    // Output: 1.0 2.0 5.0 8.0 9.0

    return 0;
}
```

## Algorithm Comparison

| Algorithm | Best | Average | Worst | Space | Stable |
|-----------|------|---------|-------|-------|--------|
| bubbleSort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| insertionSort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| selectionSort | O(n²) | O(n²) | O(n²) | O(1) | No |
| quickSort | O(n log n) | O(n log n) | O(n²) | O(log n) | No |
| mergeSort | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| heapSort | O(n log n) | O(n log n) | O(n log n) | O(1) | No |