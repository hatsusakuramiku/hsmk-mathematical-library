package simplexIntegral.polygon;

public abstract class Polygon {
    protected double[][] vertices;

    protected double measure;

    /**
     * Constructs a new polygon with the given vertices.
     * 
     * <p>
     * The vertices must form a valid polygon. If the vertices are invalid, an
     * error is thrown.
     * 
     * @param vertices the vertices of the polygon
     */
    public Polygon(double[][] vertices) {
        if (!isRightVertices(vertices)) {
            throw new IllegalArgumentException("Invalid vertices");
        }
        this.vertices = vertices;
        this.measure = caculateMeasure();
    }

    public Polygon() {
    }

    /**
     * Sets the vertices of the polygon and recalculates its area.
     *
     * <p>
     * The vertices must form a valid polygon. If the vertices are invalid, an
     * error is thrown.
     *
     * @param vertices the new vertices to set
     * @throws error if the vertices do not form a valid polygon
     */
    public void setVertices(double[][] vertices) {
        if (!isRightVertices(vertices)) {
            throw new IllegalArgumentException("Invalid vertices");
        }
        this.vertices = vertices;
        this.measure = caculateMeasure();
    }

    /**
     * Returns the vertices of the polygon.
     * 
     * @return the vertices of the polygon
     */
    public double[][] getVertices() {
        return vertices;
    }

    /**
     * Returns the measure of the polygon.
     * 
     * @return the measure of the polygon
     */
    public double getMeasure() {
        return measure;
    }

    /**
     * Calculates the measure of the polygon.
     * 
     * @return the measure of the polygon
     */
    protected abstract double caculateMeasure();

    /**
     * Checks if the given vertices are valid for a polygon.
     * 
     * @param vertices
     * @return true if the vertices are valid, false otherwise
     */
    protected abstract boolean isRightVertices(double[][] vertices);
}
