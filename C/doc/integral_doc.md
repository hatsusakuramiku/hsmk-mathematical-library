# Numerical Integration (C)

> [!NOTE]
> This documentation covers `integral.h` and `integral.c`.

## Basic Types

### Error Tolerance

```c
#define EPS 1e-6
```

### Interval

```c
typedef struct _Interval {
    double a;  // Left endpoint
    double b;  // Right endpoint
} Interval;
```

> [!NOTE]
> Interval left endpoint must be less than right endpoint (a < b).

### Function Types

```c
// One-dimensional integrand
typedef double (*__integral_func)(double x);

// Two-dimensional integrand
typedef double (*__iintegral_func)(double x, double y);
```

---

## One-Dimensional Integration

### trapezoid

```c
double trapezoid(const Interval interval, unsigned int intervalNum,
                const __integral_func func);
```

Composite trapezoidal rule for numerical integration.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| interval | Interval | Integration interval [a, b] |
| intervalNum | unsigned int | Number of subintervals (must be >= 1) |
| func | __integral_func | Integrand function |

**Returns:** Approximate integral value.

**Example:**
```c
double f(double x) { return x * x; }

Interval I = {0, 1};
double result = trapezoid(I, 1000, f);  // ≈ 0.333333
```

**Complexity:** O(n) time, O(1) space

---

### simpson

```c
double simpson(const Interval interval, unsigned int intervalNum,
               const __integral_func func);
```

Composite Simpson's rule for numerical integration.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| interval | Interval | Integration interval [a, b] |
| intervalNum | unsigned int | Number of subintervals (must be >= 3 and odd) |
| func | __integral_func | Integrand function |

**Returns:** Approximate integral value.

**Example:**
```c
double f(double x) { return x * x; }

Interval I = {0, 1};
double result = simpson(I, 1001, f);  // ≈ 0.333333
```

**Complexity:** O(n) time, O(1) space

---

### adaptiveSimpson

```c
double adaptiveSimpson(const Interval interval, double error,
                      const __integral_func func);
```

Adaptive Simpson's method with automatic error control.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| interval | Interval | Integration interval [a, b] |
| error | double | Error tolerance (must be > 0) |
| func | __integral_func | Integrand function |

**Returns:** Approximate integral value meeting error tolerance.

**Example:**
```c
double f(double x) { return x * x; }

Interval I = {0, 1};
double result = adaptiveSimpson(I, EPS, f);  // ≈ 0.333333
```

---

### gaussLegendre2PointIntegral

```c
double gaussLegendre2PointIntegral(const Interval interval,
                                    unsigned int intervalNum,
                                    const __integral_func func);
```

Two-point Gauss-Legendre quadrature.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| interval | Interval | Integration interval [a, b] |
| intervalNum | unsigned int | Number of evaluation points (must be >= 1) |
| func | __integral_func | Integrand function |

**Returns:** Approximate integral value.

**Example:**
```c
double f(double x) { return x * x; }

Interval I = {0, 1};
double result = gaussLegendre2PointIntegral(I, 10, f);  // ≈ 0.333333
```

---

### gaussLegendre3PointIntegral

```c
double gaussLegendre3PointIntegral(const Interval interval,
                                    unsigned int intervalNum,
                                    const __integral_func func);
```

Three-point Gauss-Legendre quadrature.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| interval | Interval | Integration interval [a, b] |
| intervalNum | unsigned int | Number of evaluation points (must be >= 2) |
| func | __integral_func | Integrand function |

**Returns:** Approximate integral value.

---

### newtonRaphsonIntegral

```c
double newtonRaphsonIntegral(const Interval interval, unsigned int intervalNum,
                            unsigned int order, const __integral_func func);
```

Newton-Raphson integration method.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| interval | Interval | Integration interval [a, b] |
| intervalNum | unsigned int | Number of subintervals (must be >= 1) |
| order | unsigned int | Method order (1-8) |
| func | __integral_func | Integrand function |

**Returns:** Approximate integral value.

---

## Algorithm Comparison

| Method | Complexity | Notes |
|--------|------------|-------|
| trapezoid | O(n) | Simple, converges slowly |
| simpson | O(n) | Better accuracy than trapezoid |
| adaptiveSimpson | O(log ε) | Automatic error control |
| gaussLegendre2Point | O(n) | High accuracy per point |
| gaussLegendre3Point | O(n) | Even higher accuracy |
| newtonRaphson | O(n·order) | Configurable order |