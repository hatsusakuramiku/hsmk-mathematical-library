/*
 * Copyright  2024 hatsusakuramiku
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package com.hsmkmathlib.simplexIntegral.polygon;

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
