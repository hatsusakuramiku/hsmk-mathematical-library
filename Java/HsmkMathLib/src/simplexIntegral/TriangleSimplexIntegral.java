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
package simplexIntegral;

import java.util.function.BiFunction;
import simplexIntegral.polygons.Triangle;

final public class TriangleSimplexIntegral implements SimplexIntegral {

        /**
         * Enum representing the integral formulas that can be used.
         * <p>
         * The formulas are identified by their order, number of points and the
         * version of the formula. The version is needed to distinguish between
         * different versions of the same formula.
         * 
         * <p>
         * The documentation of the formula is in the
         * <a href=
         * "https://hsmkhexo.s3.ap-northeast-1.amazonaws.com/other/%E7%A7%AF%E5%88%86%E5%85%AC%E5%BC%8F%E6%80%BB%E7%BB%93.pdf">TriangleSimplexIntegral</a>.
         */
        public static enum IntegralFormula {
                /**
                 * 1st order 3-point quadrature formula.
                 */
                ORDER1POINT3,
                /**
                 * 3rd order 7-point quadrature formula.
                 */
                ORDER3POINT7,
                /**
                 * 5th order 12-point quadrature formula.
                 */
                ORDER5POINT12,
                /**
                 * 7th order 18-point quadrature formula.
                 */
                ORDER7POINT18,
                /**
                 * 7th order 27-point quadrature formula.
                 */
                ORDER7POINT27,
                /**
                 * 10th order 30-point quadrature formula.
                 */
                ORDER10POINT30,
                /**
                 * 11th order 36-point quadrature formula, version 1.
                 */
                ORDER11POINT36_v1,
                /**
                 * 11th order 36-point quadrature formula, version 2.
                 */
                ORDER11POINT36_v2,
                /**
                 * 11th order 36-point quadrature formula, version 3.
                 */
                ORDER11POINT36_v3,
                /**
                 * 11th order 36-point quadrature formula, version 4.
                 */
                ORDER11POINT36_v4,
                /**
                 * 11th order 36-point quadrature formula, version 5.
                 */
                ORDER11POINT36_v5,
                /**
                 * 11th order 36-point quadrature formula, version 6.
                 */
                ORDER11POINT36_v6,
                /**
                 * 11th order 36-point quadrature formula, version 7.
                 */
                ORDER11POINT36_v7,
                /**
                 * 11th order 36-point quadrature formula, version 8.
                 */
                ORDER11POINT36_v8
        }

        /**
         * Predefined integral points and weights for the 1st order 3-point formula.
         */
        private static final IntegralPointWithWeight[] ORDER1POINT3 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE, 1.0 / 6.0)
        };
        /**
         * 3rd order 7-point quadrature formula.
         */
        private static final IntegralPointWithWeight[] ORDER3POINT7 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE, 1.0 / 40.0),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_2_MIDOFEDGE, 1.0 / 15.0),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_3_CENTRE, 9.0 / 40.0)
        };
        /**
         * 5th order 12-point quadrature formula.
         */
        private static final IntegralPointWithWeight[] ORDER5POINT12 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE, (8.0 - Math.sqrt(7)) / 720.0),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        (7.0 + 4.0 * Math.sqrt(7)) / 720.0,
                                        new double[] { (21.0 - Math.sqrt(441.0 - 84.0 * (7.0 - Math.sqrt(7.0))))
                                                        / 42.0 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        (98.0 - 7.0 * Math.sqrt(7)) / 720.0,
                                        new double[] { (7.0 - Math.sqrt(7)) / 21.0 })
        };
        /**
         * 7th order 18-point quadrature formula.
         */
        private static final IntegralPointWithWeight[] ORDER7POINT18 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE, 1.0 / 315.0),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_2_MIDOFEDGE, 4.0 / 315.0),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE, 3.0 / 328.0,
                                        new double[] { (3.0 - Math.sqrt(3)) / 6.0 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        (1141.0 + 94.0 * Math.sqrt(7)) / 17640.0,
                                        new double[] { (5.0 + Math.sqrt(7)) / 18.0 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        (1141.0 - 94.0 * Math.sqrt(7)) / 17640.0,
                                        new double[] { (5.0 - Math.sqrt(7)) / 18.0 })
        };
        /**
         * 7th order 27-point quadrature formula.
         */
        private static final IntegralPointWithWeight[] ORDER7POINT27 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE,
                                        0.7425845258035245E-03),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_2_MIDOFEDGE,
                                        0.5228925775971095E-03),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.5780744536385346E-02, new double[] { 0.1044413784858067E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.3143086701106134E-01, new double[] { 0.1124612712776796E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2670516378072029E-01,
                                        new double[] { 0.3964634972921077E-01, 0.3373407414205641E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.3449925295899670E-01,
                                        new double[] { 0.1868572380229495E-00, 0.3156575833835992E-00 }) };
        /**
         * 10th order 30-point quadrature formula.
         */
        private static final IntegralPointWithWeight[] ORDER10POINT30 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE,
                                        0.7425845258035245E-03),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.6190565003676629E-02, new double[] { 0.3632980741536860E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.3480578640489211E-02, new double[] { 0.1322645816327140E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.3453043037728279E-01, new double[] { 0.4578368380791611E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.4590123763076286E-01, new double[] { 0.2568591072619591E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.1162613545961757E-01, new double[] { 0.5752768441141011E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2727857596999626E-01,
                                        new double[] { 0.7819258362551702E-01, 0.2210012187598900E-00 }) };
        /**
         * 11th order 36-point quadrature formula, version 1.
         */
        private static final IntegralPointWithWeight[] ORDER11POINT36_v1 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE,
                                        0.6082563295533433E-03),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.4862551311214688E-02, new double[] { 0.3064211565289040E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.2877488812209360E-02, new double[] { 0.9055112635267585E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.2423831099156024E-01, new double[] { 0.4771441370462489E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.1229878329128456E-01, new double[] { 0.6877574115942409E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.3302578307250388E-01, new double[] { 0.3924791119734775E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.1754479406987699E-01,
                                        new double[] { 0.7265336385659892E-00, 0.2115723052694821E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2296293229758128E-01,
                                        new double[] { 0.5850352547280820E-00, 0.1437555396489239E-00 }) };
        /**
         * 11th order 36-point quadrature formula, version 2.
         */
        private static final IntegralPointWithWeight[] ORDER11POINT36_v2 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE,
                                        0.4583058548765858E-03),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.4697276305236619E-02, new double[] { 0.3729607034612477E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.3367070457223120E-02, new double[] { 0.1553066665135477E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.2849177084300189E-01, new double[] { 0.2117511055315521E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.8948103929621387E-02, new double[] { 0.4482616793714728E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.3275210436109946E-01, new double[] { 0.3943145502141118E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2135074610440116E-01,
                                        new double[] { 0.6757028284160587E-01, 0.3686932305165343E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.1859309797217277E-01,
                                        new double[] { 0.7474371355107266E-00, 0.1845656598467499E-00 }) };
        /**
         * 11th order 36-point quadrature formula, version 3.
         */
        private static final IntegralPointWithWeight[] ORDER11POINT36_v3 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE,
                                        0.6582643475372946E-03),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.2887997749452224E-02, new double[] { 0.9690885505427367E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.4963909456227002E-02, new double[] { 0.3096278562392895E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.3153470767800203E-01, new double[] { 0.3916553803852403E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.1195547103823643E-01, new double[] { 0.6609927286952901E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.2438923490441436E-01, new double[] { 0.4765910774305102E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.1905592143754818E-01,
                                        new double[] { 0.2119280804570003E-00, 0.6549274992240129E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2215666570601087E-01,
                                        new double[] { 0.1482693720952231E-00, 0.2753149271480059E-00 }) };
        /**
         * 11th order 36-point quadrature formula, version 4.
         */
        private static final IntegralPointWithWeight[] ORDER11POINT36_v4 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE,
                                        0.6977749977819948E-03),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.2929845918662817E-02, new double[] { 0.1042032950377326E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.5039500082674611E-02, new double[] { 0.3145461912846608E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.2457088105214646E-01, new double[] { 0.4758221914754834E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.2972585619925110E-01, new double[] { 0.3906745108966545E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.1178089444287955E-01, new double[] { 0.6375763489822163E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2052399059209480E-01,
                                        new double[] { 0.6856705032286132E-01, 0.2129399133002941E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2145229339387155E-01,
                                        new double[] { 0.5668085553115408E-00, 0.1535990892761941E-00 }) };
        /**
         * 11th order 36-point quadrature formula, version 5.
         */
        private static final IntegralPointWithWeight[] ORDER11POINT36_v5 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE,
                                        0.7843097667098473E-03),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.5360806770285871E-02, new double[] { 0.3544815779297824E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.3612423945705114E-02, new double[] { 0.1398215631416714E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.2935538218715718E-01, new double[] { 0.2398646683066885E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.1259016943796081E-01, new double[] { 0.5939841826003461E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.2477162854391181E-01, new double[] { 0.3982780592047566E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2637983755607086E-01,
                                        new double[] { 0.7938836834591467E-01, 0.2240733927557592E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.1422952009340166E-01,
                                        new double[] { 0.4365216866929358E-00, 0.4976858328596177E-00 }) };
        /**
         * 11th order 36-point quadrature formula, version 6.
         */
        private static final IntegralPointWithWeight[] ORDER11POINT36_v6 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE,
                                        0.4762675286979898E-03),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.2897841311190826E-02, new double[] { 0.7993870924925773E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.4491124346734268E-02, new double[] { 0.3055529243612937E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.3517078577575594E-01, new double[] { 0.3935851990719148E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.1350590535760379E-01, new double[] { 0.7473300699993817E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.2387982403384744E-01, new double[] { 0.4778706061592321E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2498014209662454E-01,
                                        new double[] { 0.2645456108709536E-00, 0.1360625094869939E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.1444783423083112E-01,
                                        new double[] { 0.1360625094869939E-00, 0.5194908177061736E-01 }) };
        /**
         * 11th order 36-point quadrature formula, version 7.
         */
        private static final IntegralPointWithWeight[] ORDER11POINT36_v7 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE,
                                        0.1203429728164228E-03),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.5648070482775567E-02, new double[] { 0.3022257440499967E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.1434742885973307E-02, new double[] { 0.4292407100635661E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.2450497451803485E-01, new double[] { 0.4762621668242898E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2591187746397450E-01,
                                        new double[] { 0.2030717695662224E-00, 0.4673667678466049E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.1112690810816592E-01,
                                        new double[] { 0.3635255445202758E-01, 0.1150656775801793E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2689907564701840E-01,
                                        new double[] { 0.3635255445202758E-01, 0.1150656775801793E-00 }) };
        /**
         * 11th order 36-point quadrature formula, version 8.
         */
        private static final IntegralPointWithWeight[] ORDER11POINT36_v8 = new IntegralPointWithWeight[] {
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_1_VERTICE,
                                        0.7892941754415492E-03),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.2438106746957435E-02, new double[] { 0.1484823026200776E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_4_INTERIOROFEDGE,
                                        0.5477346210172896E-02, new double[] { 0.3388501069491062E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_5_INTERIOR,
                                        0.2656035113426609E-01, new double[] { 0.4701249674269392E-00 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2721390945227405E-01,
                                        new double[] { 0.2246917714197549E-00, 0.8454313312796995E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.7684436539507441E-02,
                                        new double[] { 0.8481558435195644E-01, 0.3631639883870029E-01 }),
                        new IntegralPointWithWeight(TrianglePointClass.CLASS_6_INTERIOR,
                                        0.2684471172956770E-01,
                                        new double[] { 0.3148364616424038E-00, 0.4785704481357608E-00 }) };

        /**
         * Enum representing the classes of points that can be used in the integral.
         */
        private static enum TrianglePointClass implements PointClass {
                /** The three vertices of the triangle. */
                CLASS_1_VERTICE,
                /** The midpoints of the three edges of the triangle. */
                CLASS_2_MIDOFEDGE,
                /** The centroid of the triangle. */
                CLASS_3_CENTRE,
                /** Points in the interior of the edges of the triangle. */
                CLASS_4_INTERIOROFEDGE,
                /** Points in the interior of the triangle with one extra parameter. */
                CLASS_5_INTERIOR,
                /** Points in the interior of the triangle with two extra parameters. */
                CLASS_6_INTERIOR;

        }

        /**
         * Evaluates the integral of the given function over the given triangle using
         * the given integral points.
         * <p>
         * The given function is the function to integrate, the given triangle is the
         * triangle to integrate over, and the given integral points are the points to
         * use for the integral.
         * <p>
         * The integral is calculated using the given formula, which can be
         * {@link IntegralFormula#ORDER1POINT3} or any other supported formula.
         * <p>
         * If the given formula is not supported, an
         * {@link IllegalArgumentException} is thrown.
         * <p>
         * 
         * @param triangle the triangle to integrate over
         * @param f        the function to integrate
         * @param formula  the integral points to use
         * @return the integral of the function over the triangle
         */
        public static <T extends BiFunction<Double, Double, Double>> double integrate(Triangle triangle, T f,
                        IntegralFormula formula) {
                switch (formula) {
                        case ORDER1POINT3 -> {
                                return integrate(triangle, f, ORDER1POINT3);
                        }
                        case ORDER3POINT7 -> {
                                return integrate(triangle, f, ORDER3POINT7);
                        }
                        case ORDER5POINT12 -> {
                                return integrate(triangle, f, ORDER5POINT12);
                        }
                        case ORDER7POINT18 -> {
                                return integrate(triangle, f, ORDER7POINT18);
                        }
                        case ORDER7POINT27 -> {
                                return integrate(triangle, f, ORDER7POINT27);
                        }
                        case ORDER10POINT30 -> {
                                return integrate(triangle, f, ORDER10POINT30);
                        }

                        case ORDER11POINT36_v1 -> {
                                return integrate(triangle, f, ORDER11POINT36_v1);
                        }

                        case ORDER11POINT36_v2 -> {
                                return integrate(triangle, f, ORDER11POINT36_v2);
                        }

                        case ORDER11POINT36_v3 -> {
                                return integrate(triangle, f, ORDER11POINT36_v3);
                        }

                        case ORDER11POINT36_v4 -> {
                                return integrate(triangle, f, ORDER11POINT36_v4);
                        }

                        case ORDER11POINT36_v5 -> {
                                return integrate(triangle, f, ORDER11POINT36_v5);
                        }

                        case ORDER11POINT36_v6 -> {
                                return integrate(triangle, f, ORDER11POINT36_v6);
                        }

                        case ORDER11POINT36_v7 -> {
                                return integrate(triangle, f, ORDER11POINT36_v7);
                        }

                        case ORDER11POINT36_v8 -> {
                                return integrate(triangle, f, ORDER11POINT36_v8);
                        }

                        default -> {
                                throw new IllegalArgumentException("Unknown formula: " + formula);
                        }
                }
        }

        /**
         * Evaluates the integral of the given function over the given triangle using
         * the given integral points.
         * <p>
         * The given integral points are the coordinates of the points in the integral,
         * and the weights are the weights of the points in the integral.
         * <p>
         * The integral is calculated as the sum of the function values at the points
         * multiplied by the weights.
         * <p>
         * 
         * @param triangle the triangle to integrate over
         * @param f        the function to integrate
         * @param points   the integral points
         * @return the integral of the function over the triangle
         */
        private static <T extends BiFunction<Double, Double, Double>> double integrate(Triangle triangle, T f,
                        IntegralPointWithWeight[] points) {
                IntegralPointsWithWeight[] pointsWithWeights = getIntegralPointWithWeights(points);
                double result = 0.0;
                for (IntegralPointsWithWeight point : pointsWithWeights) {
                        result += point.weight * applyArray(f, transformPoints(triangle, point.points));
                }
                return result * 2 * triangle.getArea();
        }

        /**
         * Applies the given function to each point in the given array of points
         * and returns the sum of the results.
         * <p>
         * The given points are in the form of an array of double arrays, where
         * each double array is a point in the integral.
         * <p>
         * The function is applied to each point in the array, and the results are
         * summed and returned.
         * <p>
         * 
         * @param f      the function to apply
         * @param points the points to apply the function to
         * @return the sum of the results of applying the function to the points
         */
        private static <T extends BiFunction<Double, Double, Double>> double applyArray(T f, double[][] points) {
                double result = 0.0;
                for (double[] point : points) {
                        result += f.apply(point[0], point[1]);
                }
                return result;
        }

        /**
         * Transforms the given points from the integral coordinates to the real
         * coordinates of the given triangle.
         * <p>
         * The integral coordinates are the coordinates of the points in the integral,
         * and the real coordinates
         * are the coordinates of the points in the triangle.
         * <p>
         * The transformation is done with the following formulas:
         * <p>
         * x = x3 + li * (x1 - x3) + lj * (x2 - x3)
         * y = y3 + li * (y1 - y3) + lj * (y2 - y3)
         * <p>
         * where (x1, y1), (x2, y2), and (x3, y3) are the coordinates of the vertices of
         * this triangle, and
         * (li, lj) are the coordinates of the point in the integral.
         * <p>
         * 
         * @param triangle       the triangle to transform the points to
         * @param IntegralPoints the points to transform
         * @return the transformed points
         */
        private static double[][] transformPoints(Triangle triangle, double[][] IntegralPoints) {
                double[][] vertices = triangle.getVertices();
                double[][] result = new double[IntegralPoints.length][2];
                for (int i = 0; i < IntegralPoints.length; i++) {
                        result[i][0] = vertices[2][0] + IntegralPoints[i][0] * (vertices[0][0] - vertices[2][0])
                                        + IntegralPoints[i][1] * (vertices[1][0] - vertices[2][0]); // x
                        result[i][1] = vertices[2][1] + IntegralPoints[i][0] * (vertices[0][1] - vertices[2][1])
                                        + IntegralPoints[i][1] * (vertices[1][1] - vertices[2][1]); // y
                }
                return result;
        }

        /**
         * Converts the given points to the integral points with weights.
         * <p>
         * The given points are the coordinates of the points in the integral, and the
         * weights are the weights of the points in the integral.
         * <p>
         * The integral points with weights are the points in the integral, and the
         * weights of the points in the integral.
         * <p>
         * 
         * @param points the points to convert
         * @return the integral points with weights
         */
        private static IntegralPointsWithWeight[] getIntegralPointWithWeights(IntegralPointWithWeight[] points) {
                IntegralPointsWithWeight[] result = new IntegralPointsWithWeight[points.length];
                for (int i = 0; i < points.length; i++) {
                        result[i] = new IntegralPointsWithWeight(getIntegralPoints(points[i]), points[i].weight);
                }
                return result;
        }

        /**
         * Returns the integral points in the triangle, given the point class and extra
         * parameters.
         * <p>
         * The integral points are the coordinates of the points in the integral, and
         * the
         * extra parameters are the parameters of the points in the integral.
         * <p>
         * The integral points are returned as an array of double arrays, where each
         * double array is the coordinates of a point in the integral.
         * <p>
         * The following are the supported point classes, and the corresponding integral
         * points and extra parameters:
         * <ul>
         * <li>CLASS_1_VERTICE: The three vertices of the triangle, with no extra
         * parameters.</li>
         * <li>CLASS_2_MIDOFEDGE: The midpoints of the three edges of the triangle, with
         * no extra parameters.</li>
         * <li>CLASS_3_CENTRE: The centroid of the triangle, with no extra
         * parameters.</li>
         * <li>CLASS_4_INTERIOROFEDGE: The points in the interior of the edges of the
         * triangle, with one extra parameter, which is the parameter of the point in
         * the
         * integral.</li>
         * <li>CLASS_5_INTERIOR: The points in the interior of the triangle, with one
         * extra parameter, which is the parameter of the point in the integral.</li>
         * <li>CLASS_6_INTERIOR: The points in the interior of the triangle, with two
         * extra parameters, which are the parameters of the point in the integral.</li>
         * </ul>
         * <p>
         * If the point class is not supported, an IllegalArgumentException is thrown.
         * <p>
         * 
         * @param points the point class and extra parameters
         * @return the integral points in the triangle
         * 
         * @throws IllegalArgumentException if the point class is not supported
         */
        private static double[][] getIntegralPoints(IntegralPointWithWeight points) {
                switch (points.pointClass) {
                        case TrianglePointClass.CLASS_1_VERTICE -> {
                                return new double[][] { { 0.0, 0.0 }, { 1.0, 0.0 }, { 0.0, 1.0 } };
                        }
                        case TrianglePointClass.CLASS_2_MIDOFEDGE -> {
                                return new double[][] { { 0.5, 0.0 }, { 0.0, 0.5 }, { 0.5, 0.5 }, { 1.0, 0.5 },
                                                { 0.5, 1.0 } };
                        }
                        case TrianglePointClass.CLASS_3_CENTRE -> {
                                return new double[][] { { 1.0 / 3.0, 1.0 / 3.0 } };
                        }
                        case TrianglePointClass.CLASS_4_INTERIOROFEDGE -> {
                                double param = points.extParams[0];
                                return new double[][] { { param, 0.0 }, { 0.0, param }, { 1.0 - param, param },
                                                { param, 1.0 - param },
                                                { 0.0, 1.0 - param }, { 1.0 - param, 0.0 } };
                        }
                        case TrianglePointClass.CLASS_5_INTERIOR -> {
                                double param = points.extParams[0];
                                return new double[][] { { param, param }, { 1.0 - 2 * param, param },
                                                { param, 1.0 - 2 * param } };
                        }
                        case TrianglePointClass.CLASS_6_INTERIOR -> {
                                double param1 = points.extParams[0];
                                double param2 = points.extParams[1];
                                return new double[][] { { param1, param2 }, { param2, param1 },
                                                { 1.0 - param1 - param2, param2 },
                                                { param2, 1.0 - param1 - param2 }, { param1, 1.0 - param1 - param2 },
                                                { 1.0 - param1 - param2, param1 } };
                        }
                        default -> {
                                throw new IllegalArgumentException("pointClass is not supported");
                        }
                }
        }

}