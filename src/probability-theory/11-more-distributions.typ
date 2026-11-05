#import "../_shared/style.typ": definition

// Источник: с. 24.
== Ещё распределения

=== 9. Отрицательное биномиальное распределение

$op("NegBin")$ — количество испытаний в схеме Бернулли до $n$-го успеха.
$ P{xi = k} = C_(k-1)^(n-1) p^n (1-p)^(k-n), $
$ M(xi) = n/p, quad D(xi) = (n(1-p))/p^2. $
$ xi = sum_(i=1)^n eta_i, $
где $eta_i$ — номер первого успеха в схеме Бернулли;
$eta_i$ независимы и имеют геометрическое распределение.

=== 10. Гамма-распределение

Время до наступления $n$-го события в потоке при условии, что события независимы
и их средняя интенсивность равна $lambda$.
Параметры $n > 0$, $lambda > 0$.
$
  p_(xi)(x) = cases(lambda^n/(Gamma(n)) x^(n-1) e^(-lambda x) quad & x >= 0, 0 quad & x < 0),
$
$ M(xi) = n/lambda, quad D(xi) = n/lambda^2. $
При $n in NN$ — #definition[распределение Эрланга], $Gamma(n) = (n-1)!$.
$ xi = sum_(i=1)^n eta_i, $
где $eta_i$ — время до первого события, $eta_i$ независимы.

=== 11. Гипергеометрическое распределение

$op("HGeom")$ — количество белых шаров среди вытащенных $n$ (без возвращения)
из урны с $N$ шарами всего и $M$ белыми шарами.
$ P{xi = k} = (C_M^k dot C_(N-M)^(n-k))/C_N^n, $
$ M(xi) = n dot M/N, quad D(xi) = n dot M/N dot (N-M)/N dot (N-n)/(N-1). $

// Источник: с. 25.
=== 12. Бета-распределение

Предполагаемая вероятность успеха ($xi$) в схеме Бернулли,
если уже произошло $alpha-1$ успехов и $beta-1$ неудач.
Параметры $alpha > 0$, $beta > 0$.
$ p_(xi)(x) = (x^(alpha-1)(1-x)^(beta-1))/(B(alpha, beta)), quad x in [0, 1]. $
$ B(alpha, beta) = (Gamma(alpha) Gamma(beta))/Gamma(alpha+beta) $
— #definition[бета-функция].
$ B(x, 1-x) = pi/sin(pi x), quad B(x, 1) = 1/x, quad B(x, 2) = 1/(x(x+1)). $
$
  M(xi) = alpha/(alpha+beta), quad D(xi) = (alpha beta)/((alpha+beta)^2(alpha+1+beta)).
$
Мода (наиболее вероятное значение) при $alpha, beta > 1$:
$ (alpha-1)/(alpha+beta-2). $

Асимптотическое нормальное приближение:
$ xi approx N(alpha/(alpha+beta), (alpha beta)/((alpha+beta)^2(alpha+beta+1))) $
при $alpha, beta arrow infinity$, $alpha tilde beta$ (одного порядка).

#align(center, image("images/beta-distributions.jpg", width: 130mm))

=== 13. Распределение Вейбулла

Время работы устройства до поломки, если известно, что мгновенный риск поломки
(интенсивность событий) равен
$ q(t) = k/lambda (t/lambda)^(k-1). $
$k > 0$ — параметр формы:
$k < 1$ — «приработка», $k > 1$ — износ, $k = 1$ — показательное распределение.
$lambda > 0$ — параметр масштаба (характерное время жизни).

$ p_(xi)(t) = k/lambda (t/lambda)^(k-1) exp(-(t/lambda)^k), quad t >= 0, $
$ F_(xi)(t) = 1-exp(-(t/lambda)^k) $
— вероятность отказа до времени $t$.
$ M(xi) = lambda Gamma(1+1/k), $
$ D(xi) = lambda^2 (Gamma(1+2/k)-(Gamma(1+1/k))^2). $
Это обобщение показательного распределения.
Мода при $k > 1$:
$ lambda ((k-1)/k)^(1/k). $
Если $eta = xi^alpha$, $alpha > 0$, то $eta$ тоже распределена по Вейбуллу:
$ k_eta = k/alpha, quad lambda_eta = lambda^alpha. $
