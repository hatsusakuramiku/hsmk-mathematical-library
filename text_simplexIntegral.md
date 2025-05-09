---
title: 单纯形数值积分
cover: "https://d1wrd97t08mf0f.cloudfront.net/hexo/img/background/58898355_p0.webp"
top_img: "https://d1wrd97t08mf0f.cloudfront.net/hexo/img/background/58898355_p0.webp"
tags:
  - 学习
categories: HSMK-MATH-LIB
description: 单纯形上的数值积分
swiper_index: 1
mathjax: true
comments: true
---

{% note info flat %}封面图片 PID:[58898355](https://www.pixiv.net/artworks/58898355){% endnote %}

高维空间中的数值积分依赖于区域的形状，对于规则区域如矩形、立方体等可以直接利用插值多项式构造数值积分公式进行计算。对于不规则的复杂区域需要使用规则网格对区域进行离散化，然后利用插值多项式构造数值积分公式进行计算。常用的网格有笛卡尔网格和单纯形网格。使用范围最广的网格是单纯形网格，其由若干个单纯形单元构成，对于复杂区域的离散化具有极好的效果。

$$
\begin{align*}
a_6&=f(A)\\
a_1x_B^2 + a_4x_B + a_6&=f(B)\\
a_1\left(\frac{x_B}{2}\right)^2 + a_4\frac{x_B}{2}+ a_6&=f(D)\\
a_1x_C^2 + a_2x_Cy_C + a_3y_C^2 + a_4x_C + a_5y_C + a_6&=f(C)\\
a_1\left(\frac{x_C}{2}\right)^2 + a_2\frac{x_Cy_C}{4}+ a_3\left(\frac{y_C}{2}\right)^2 + a_4\frac{x_C}{2}+ a_5\frac{y_C}{2}+ a_6&=f(F)\\
a_1\left(\frac{x_B + x_C}{2}\right)^2 + a_2\frac{(x_B + x_C)y_C}{4}+ a_3\left(\frac{y_C}{2}\right)^2 + a_4\frac{x_B + x_C}{2}+ a_5\frac{y_C}{2}+ a_6&=f(E)
\end{align*}
$$