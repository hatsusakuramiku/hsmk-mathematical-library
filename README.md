# hsmk-mathematical-library

 HSMKの数学库

## 食用方法

### 1. TaylorSeries

例: 求 $f(x) = e^{x^{2}}$ 在 $x = 0$ 处的 $n = 2,4,6,8,10$ 阶泰勒展开

方法1：

```MATLAB
syms x
f = exp(x^2);
center = 0;
n = 2:2:10;
tay = TaylorSeries(f,center,n);
tay = tay.generatePolynomial();
polynomia = tay.getPolynomia();
remainder = tay.getRemainder();
fittingFunction = tay.getFittingFunction();
center = tay.getCenter();
order = tay.getOrder();

for i = 1:length(n)
    fprintf('公式 %s 在 %f 处的 %d 阶泰勒展开式为： %s , 余项为 %s\n',fittingFunction(i),center(i),order(i),polynomia(i),remainder(i));
end
```

输出结果:

```MATLAB OUTPUT
公式 exp(x^2) 在 0.000000 处的 2 阶泰勒展开式为： 2*x^2*exp(x^2) + (x^2*(2*exp(x^2) + 4*x^2*exp(x^2)))/2 + 1 , 余项为 x^3*((4*A^3*exp(A^2))/3 + 2*A*exp(A^2))
公式 exp(x^2) 在 0.000000 处的 4 阶泰勒展开式为： (x^4*(12*exp(x^2) + 48*x^2*exp(x^2) + 16*x^4*exp(x^2)))/24 + (x^3*(12*x*exp(x^2) + 8*x^3*exp(x^2)))/6 + 2*x^2*exp(x^2) + (x^2*(2*exp(x^2) + 4*x^2*exp(x^2)))/2 + 1 , 余项为 x^5*((4*A^3*exp(A^2))/3 + (4*A^5*exp(A^2))/15 + A*exp(A^2))
公式 exp(x^2) 在 0.000000 处的 6 阶泰勒展开式为： (x^4*(12*exp(x^2) + 48*x^2*exp(x^2) + 16*x^4*exp(x^2)))/24 + (x^3*(12*x*exp(x^2) + 8*x^3*exp(x^2)))/6 + 2*x^2*exp(x^2) + (x^6*(120*exp(x^2) + 720*x^2*exp(x^2) + 480*x^4*exp(x^2) + 64*x^6*exp(x^2)))/720 + (x^5*(120*x*exp(x^2) + 160*x^3*exp(x^2) + 32*x^5*exp(x^2)))/120 + (x^2*(2*exp(x^2) + 4*x^2*exp(x^2)))/2 + 1 , 余项为 x^7*((2*A^3*exp(A^2))/3 + (4*A^5*exp(A^2))/15 + (8*A^7*exp(A^2))/315 + (A*exp(A^2))/3)
公式 exp(x^2) 在 0.000000 处的 8 阶泰勒展开式为： (x^8*(1680*exp(x^2) + 13440*x^2*exp(x^2) + 13440*x^4*exp(x^2) + 3584*x^6*exp(x^2) + 256*x^8*exp(x^2)))/40320 + (x^7*(1680*x*exp(x^2) + 3360*x^3*exp(x^2) + 1344*x^5*exp(x^2) + 128*x^7*exp(x^2)))/5040 + (x^4*(12*exp(x^2) + 48*x^2*exp(x^2) + 16*x^4*exp(x^2)))/24 + (x^3*(12*x*exp(x^2) + 8*x^3*exp(x^2)))/6 + 2*x^2*exp(x^2) + (x^6*(120*exp(x^2) + 720*x^2*exp(x^2) + 480*x^4*exp(x^2) + 64*x^6*exp(x^2)))/720 + (x^5*(120*x*exp(x^2) + 160*x^3*exp(x^2) + 32*x^5*exp(x^2)))/120 + (x^2*(2*exp(x^2) + 4*x^2*exp(x^2)))/2 + 1 , 余项为 x^9*((2*A^3*exp(A^2))/9 + (2*A^5*exp(A^2))/15 + (8*A^7*exp(A^2))/315 + (4*A^9*exp(A^2))/2835 + (A*exp(A^2))/12)
公式 exp(x^2) 在 0.000000 处的 10 阶泰勒展开式为： (x^8*(1680*exp(x^2) + 13440*x^2*exp(x^2) + 13440*x^4*exp(x^2) + 3584*x^6*exp(x^2) + 256*x^8*exp(x^2)))/40320 + (x^7*(1680*x*exp(x^2) + 3360*x^3*exp(x^2) + 1344*x^5*exp(x^2) + 128*x^7*exp(x^2)))/5040 + (x^4*(12*exp(x^2) + 48*x^2*exp(x^2) + 16*x^4*exp(x^2)))/24 + (x^3*(12*x*exp(x^2) + 8*x^3*exp(x^2)))/6 + 2*x^2*exp(x^2) + (x^10*(30240*exp(x^2) + 302400*x^2*exp(x^2) + 403200*x^4*exp(x^2) + 161280*x^6*exp(x^2) + 23040*x^8*exp(x^2) + 1024*x^10*exp(x^2)))/3628800 + (x^9*(30240*x*exp(x^2) + 80640*x^3*exp(x^2) + 48384*x^5*exp(x^2) + 9216*x^7*exp(x^2) + 512*x^9*exp(x^2)))/362880 + (x^6*(120*exp(x^2) + 720*x^2*exp(x^2) + 480*x^4*exp(x^2) + 64*x^6*exp(x^2)))/720 + (x^5*(120*x*exp(x^2) + 160*x^3*exp(x^2) + 32*x^5*exp(x^2)))/120 + (x^2*(2*exp(x^2) + 4*x^2*exp(x^2)))/2 + 1 , 余项为 x^11*((A^3*exp(A^2))/18 + (2*A^5*exp(A^2))/45 + (4*A^7*exp(A^2))/315 + (4*A^9*exp(A^2))/2835 + (8*A^11*exp(A^2))/155925 + (A*exp(A^2))/60)
```

方法2：

```MATLAB
syms x
f = exp(x ^ 2);
center = 0;
n = 2:2:10;
taylorSeries = TaylorSeries(f, center, n);
tayCell = taylorSeries.getTayVector();

for i = 1:length(tayCell)
    tay = tayCell{i}.generatePolynomial();
    polynomia = tay.getPolynomia();
    remainder = tay.getRemainder();
    fittingFunction = tay.getFittingFunction();
    center = tay.getCenter();
    order = tay.getOrder();
    fprintf('公式 %s 在 %f 处的 %d 阶泰勒展开式为： %s , 余项为 %s\n', fittingFunction, center, order, polynomia, remainder);
end
```

输出结果:

```MATLAB OUTPUT
公式 exp(x^2) 在 0.000000 处的 2 阶泰勒展开式为： 2*x^2*exp(x^2) + (x^2*(2*exp(x^2) + 4*x^2*exp(x^2)))/2 + 1 , 余项为 x^3*((4*A^3*exp(A^2))/3 + 2*A*exp(A^2))
公式 exp(x^2) 在 0.000000 处的 4 阶泰勒展开式为： (x^4*(12*exp(x^2) + 48*x^2*exp(x^2) + 16*x^4*exp(x^2)))/24 + (x^3*(12*x*exp(x^2) + 8*x^3*exp(x^2)))/6 + 2*x^2*exp(x^2) + (x^2*(2*exp(x^2) + 4*x^2*exp(x^2)))/2 + 1 , 余项为 x^5*((4*A^3*exp(A^2))/3 + (4*A^5*exp(A^2))/15 + A*exp(A^2))
公式 exp(x^2) 在 0.000000 处的 6 阶泰勒展开式为： (x^4*(12*exp(x^2) + 48*x^2*exp(x^2) + 16*x^4*exp(x^2)))/24 + (x^3*(12*x*exp(x^2) + 8*x^3*exp(x^2)))/6 + 2*x^2*exp(x^2) + (x^6*(120*exp(x^2) + 720*x^2*exp(x^2) + 480*x^4*exp(x^2) + 64*x^6*exp(x^2)))/720 + (x^5*(120*x*exp(x^2) + 160*x^3*exp(x^2) + 32*x^5*exp(x^2)))/120 + (x^2*(2*exp(x^2) + 4*x^2*exp(x^2)))/2 + 1 , 余项为 x^7*((2*A^3*exp(A^2))/3 + (4*A^5*exp(A^2))/15 + (8*A^7*exp(A^2))/315 + (A*exp(A^2))/3)
公式 exp(x^2) 在 0.000000 处的 8 阶泰勒展开式为： (x^8*(1680*exp(x^2) + 13440*x^2*exp(x^2) + 13440*x^4*exp(x^2) + 3584*x^6*exp(x^2) + 256*x^8*exp(x^2)))/40320 + (x^7*(1680*x*exp(x^2) + 3360*x^3*exp(x^2) + 1344*x^5*exp(x^2) + 128*x^7*exp(x^2)))/5040 + (x^4*(12*exp(x^2) + 48*x^2*exp(x^2) + 16*x^4*exp(x^2)))/24 + (x^3*(12*x*exp(x^2) + 8*x^3*exp(x^2)))/6 + 2*x^2*exp(x^2) + (x^6*(120*exp(x^2) + 720*x^2*exp(x^2) + 480*x^4*exp(x^2) + 64*x^6*exp(x^2)))/720 + (x^5*(120*x*exp(x^2) + 160*x^3*exp(x^2) + 32*x^5*exp(x^2)))/120 + (x^2*(2*exp(x^2) + 4*x^2*exp(x^2)))/2 + 1 , 余项为 x^9*((2*A^3*exp(A^2))/9 + (2*A^5*exp(A^2))/15 + (8*A^7*exp(A^2))/315 + (4*A^9*exp(A^2))/2835 + (A*exp(A^2))/12)
公式 exp(x^2) 在 0.000000 处的 10 阶泰勒展开式为： (x^8*(1680*exp(x^2) + 13440*x^2*exp(x^2) + 13440*x^4*exp(x^2) + 3584*x^6*exp(x^2) + 256*x^8*exp(x^2)))/40320 + (x^7*(1680*x*exp(x^2) + 3360*x^3*exp(x^2) + 1344*x^5*exp(x^2) + 128*x^7*exp(x^2)))/5040 + (x^4*(12*exp(x^2) + 48*x^2*exp(x^2) + 16*x^4*exp(x^2)))/24 + (x^3*(12*x*exp(x^2) + 8*x^3*exp(x^2)))/6 + 2*x^2*exp(x^2) + (x^10*(30240*exp(x^2) + 302400*x^2*exp(x^2) + 403200*x^4*exp(x^2) + 161280*x^6*exp(x^2) + 23040*x^8*exp(x^2) + 1024*x^10*exp(x^2)))/3628800 + (x^9*(30240*x*exp(x^2) + 80640*x^3*exp(x^2) + 48384*x^5*exp(x^2) + 9216*x^7*exp(x^2) + 512*x^9*exp(x^2)))/362880 + (x^6*(120*exp(x^2) + 720*x^2*exp(x^2) + 480*x^4*exp(x^2) + 64*x^6*exp(x^2)))/720 + (x^5*(120*x*exp(x^2) + 160*x^3*exp(x^2) + 32*x^5*exp(x^2)))/120 + (x^2*(2*exp(x^2) + 4*x^2*exp(x^2)))/2 + 1 , 余项为 x^11*((A^3*exp(A^2))/18 + (2*A^5*exp(A^2))/45 + (4*A^7*exp(A^2))/315 + (4*A^9*exp(A^2))/2835 + (8*A^11*exp(A^2))/155925 + (A*exp(A^2))/60)
```
