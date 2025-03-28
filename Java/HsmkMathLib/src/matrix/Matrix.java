package matrix;

public class Matrix {
    protected int rows;
    protected int cols;
    protected double[][] data;

    @Override
    public String toString() {
        return "Matrix{" +
                "rows=" + rows +
                ", cols=" + cols +
                ", data=" + data +
                '}';
    }

    public Matrix(int rows, int cols) {
        if (rows <= 0 || cols <= 0) {
            throw new IllegalArgumentException("Rows and columns must be positive integers");
        }
        this.rows = rows;
        this.cols = cols;
        this.data = new double[rows][cols]; // initialize all elements to 0
    }

    public Matrix(int rows, int cols, double defaultValue) {
        if (rows <= 0 || cols <= 0) {
            throw new IllegalArgumentException("Rows and columns must be positive integers");
        }
        this.rows = rows;
        this.cols = cols;
        this.data = new double[rows][cols];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                this.data[i][j] = defaultValue;
            }
        }
    }

    public Matrix(double[][] data) {
        if (data == null || data.length == 0 || data[0].length == 0) {
            throw new IllegalArgumentException("Data must be non-empty");
        }
        this.rows = data.length;
        this.cols = data[0].length;
        this.data = new double[rows][cols];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                this.data[i][j] = data[i][j];
            }
        }
    }

    public boolean equals(Matrix other) {
        if (other == null || rows != other.rows || cols != other.cols) {
            return false;
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (data[i][j] != other.data[i][j]) {
                    return false;
                }
            }
        }
        return true;
    }

    public void plus(Matrix other) {
        if (other == null || rows != other.rows || cols != other.cols) {
            throw new IllegalArgumentException("Matrices must have the same dimensions");
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] += other.data[i][j];
            }
        }
    }

    public void minus(Matrix other) {
        if (other == null || rows != other.rows || cols != other.cols) {
            throw new IllegalArgumentException("Matrices must have the same dimensions");
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] -= other.data[i][j];
            }
        }
    }

    public void times(double scalar) {
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] *= scalar;
            }
        }
    }

    public void times(Matrix other) {
        if (other == null || cols != other.rows) {
            throw new IllegalArgumentException("Matrices must be compatible for multiplication");
        }
        double[][] result = new double[rows][other.cols];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < other.cols; j++) {
                for (int k = 0; k < cols; k++) {
                    result[i][j] += data[i][k] * other.data[k][j];
                }
            }
        }
    }

    public void cdotTimes(Matrix other) {
        if (other == null || rows != other.rows || cols != other.cols) {
            throw new IllegalArgumentException("Matrices must have the same dimensions");
        }
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] *= other.data[i][j];
            }
        }
    }

    public void cdotDivide(Matrix other) {
        if (other == null || rows != other.rows || cols != other.cols) {
            throw new IllegalArgumentException("Matrices must have the same dimensions");
        }
        Matrix temp = new Matrix(other.data);
        try {
            for (int i = 0; i < rows; i++) {
                for (int j = 0; j < cols; j++) {
                    temp.data[i][j] /= other.data[i][j];
                }
            }
        } catch (ArithmeticException e) {
            System.out.println("Division by zero is not allowed.");
        }
        this.data = temp.data;
    }

    public void transpose() {
        double[][] result = new double[cols][rows];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                result[j][i] = data[i][j];
            }
        }
        data = result;
    }

    public Matrix diag(int index) {
        if (index >= cols || index <= -rows) {
            throw new IllegalArgumentException("Invalid value for index");
        }
        int min = Math.min(rows, cols);
        if (index >= 0) {
            int height = min - index;
            Matrix result = new Matrix(height, height);
            for (int i = 0; i < height; i++) {
                result.data[i][i] = data[i][i + index];
            }
            return result;
        } else {
            int height = min + index;
            Matrix result = new Matrix(height, height);
            for (int i = 0; i < height; i++) {
                result.data[i][i] = data[i - index][i];
            }
            return result;
        }
    }

    public Matrix diag() {
        return diag(0);
    }

    public void show() {
        System.out.printf("Matrix: rows = %d, cols = %d\n", rows, cols);
        for (int i = 0; i < rows; i++) {
            System.out.printf("|\t");
            for (int j = 0; j < cols; j++) {
                System.out.printf("%f\t", data[i][j]);
            }
            System.out.printf("|\t\n");
        }
        System.out.println();
    }
}
