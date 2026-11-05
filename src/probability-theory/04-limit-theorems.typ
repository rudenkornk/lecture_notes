#import "../_shared/style.typ": definition
#import "@preview/cetz:0.4.2"

// Источник: с. 9.
== Предельные теоремы

=== Биномиальное распределение (6)

$mu_n$ — случайная величина, определяющая количество успехов в $n$ испытаниях по схеме Бернулли.
Тогда её распределение — #definition[биномиальное]:
$ P{mu_n = m} = binom(n, m) p^m q^(n-m). $
$ M(mu_n) = M(sum_i xi_i) = sum_i M(xi_i) = n p, $
где $xi_i$ — случайная величина, равная 1, если $i$-е испытание закончилось успехом,
а все остальные независимы.
$
  D(mu_n) = D(sum_i xi_i) = sum_i D(xi_i) = sum_i (M(xi_i^2)-M(xi_i)^2) = n p q.
$

=== Неравенство Чебышёва

*Неравенство Маркова.* Пусть $xi$ — неотрицательная случайная величина, $x in RR_+$. Тогда
$ P{xi >= x} <= M(xi)/x. $

*Доказательство.* $I(A)$ — #definition[индикатор]: случайная величина, равная 1,
если $A$ произошло, и 0, если нет.
$ xi = xi(I(xi < x)+I(xi >= x)) >= xi I(xi >= x) >= x I(xi >= x), $
$ M(xi) >= M(x I(xi >= x)) = x P{xi >= x} => P{xi >= x} <= M(xi)/x. $
Заменяя $xi$ на $abs(xi-M(xi))^2$, $x$ на $Delta^2$, получаем:
$ P{abs(xi-M(xi)) >= Delta} <= D(xi)/Delta^2, $
$ P{abs(xi-M(xi)) < Delta} >= 1-D(xi)/Delta^2. $

=== Неравенство Йенсена

$f(x)$ — выпуклая вниз функция.
$ f(M(xi)) <= M(f(xi)). $
#align(center, cetz.canvas(length: 8mm, {
  import cetz.draw: *
  set-style(stroke: 0.6pt + rgb("#283f8a"))
  line((0, 0), (2.5, 0), mark: (end: ">"))
  line((0, 0), (0, 1.8), mark: (end: ">"))
  line(
    ..range(0, 41).map(j => {
      let x = 0.2 + j * 0.05
      (x, 0.35 + 0.85 * calc.pow(x - 1.15, 2))
    }),
  )
  content((2.5, -0.2), $x$)
  content((2.45, 1.2), $f(x)$)
}))

=== Виды сходимости

+ #definition[Сходимость almost surely]:
  $
    xi_n arrow^("a.s.") xi <=> P{omega: lim_(n arrow infinity) xi_(n)(omega) = xi(omega)} = 1.
  $
+ #definition[Сходимость по вероятности]:
  $
    xi_n arrow^P xi <=> forall epsilon > 0:
    lim_(n arrow infinity) P(abs(xi_n-xi) > epsilon) = 0.
  $
+ #definition[Сходимость в среднем порядка $p$] ($L^p$-сходимость):
  $ xi_n arrow^(L^p) xi <=> lim_(n arrow infinity) M(abs(xi_n-xi)^p) = 0. $
+ #definition[Сходимость по распределению]:
  $ xi_n arrow^d xi <=> lim_(n arrow infinity) F_(xi_n)(x) = F_(xi)(x) $
  во всех точках непрерывности $F_xi$.

$ "a.s." => P => d, quad L^p => P. $

// Источник: с. 10.
=== Закон больших чисел Чебышёва

Пусть ${xi_i}$ — последовательность попарно независимых случайных величин,
$exists C: forall i D(xi_i) <= C$. Тогда для любого $epsilon > 0$:
$
  lim_(n arrow infinity) P{abs((xi_1+dots+xi_n)/n - (M(xi_1)+dots+M(xi_n))/n) < epsilon} = 1.
$

*Доказательство.* Пусть
$
  overline(xi)_n = (xi_1+dots+xi_n)/n => M(overline(xi)_n) = (M(xi_1)+dots+M(xi_n))/n,
$
$ D(overline(xi)_n) = (D(xi_1)+dots+D(xi_n))/n^2. $
По неравенству Чебышёва:
$
  P{abs(overline(xi)_n-M(overline(xi)_n)) < epsilon}
  >= 1-D(overline(xi)_n)/epsilon^2 >= 1-C/(n epsilon^2) arrow 1.
$
Иначе говоря,
$ overline(xi)_n-M(overline(xi)_n) arrow^P 0. $

=== Закон больших чисел Бернулли

$mu_n$ — количество успехов в $n$ испытаниях в схеме Бернулли,
$p$ — вероятность успеха. Тогда
$ lim_(n arrow infinity) P{abs(mu_n/n-p) < epsilon} = 1. $

*Усиленный закон больших чисел.* Если $sum_i D(xi_i)/i^2 < infinity$, то
$ overline(xi)_n-M(overline(xi)_n) arrow^("a.s.") 0. $

=== Функция Гаусса

$ phi(x) = 1/sqrt(2 pi) exp(-x^2/2). $

=== Формула Стирлинга

$ x! approx sqrt(2 pi) x^(x+0.5) e^(-x). $

=== Локальная теорема Муавра — Лапласа

В схеме Бернулли при фиксированном $0 < p < 1$, $q = 1-p$, $n arrow infinity$
и целочисленном $m$, для которого $abs(m-n p) = O(sqrt(n))$:
$ P{mu_n = m} tilde 1/sigma(mu_n) phi((m-M(mu_n))/sigma(mu_n)). $
$ M(mu_n) = n p, quad sigma(mu_n) = sqrt(n p q). $
Пометка источника: «$n > 100$» — практический ориентир, а не достаточное условие теоремы.

*Доказательство.*
$ P{mu_n = m} = n!/(m! (n-m)!) p^m q^(n-m) approx $
$
  approx (sqrt(2 pi) n^n sqrt(n))/(sqrt(2 pi) m^m sqrt(m) sqrt(2 pi) (n-m)^(n-m) sqrt(n-m)) p^m q^(n-m)
$
$ = 1/sqrt(2 pi) sqrt(n/((n-m)m)) ((p n)/m)^m ((q n)/(n-m))^(n-m). $
Положим $Delta_m = m/n-p$.

// Источник: с. 11.
$
  ((p n)/m)^m ((q n)/(n-m))^(n-m)
  = (1+Delta_m/p)^(-n(p+Delta_m)) (1-Delta_m/q)^(-n(q-Delta_m)) = T.
$
$
  T = exp(ln T) = exp(-n(p+Delta_m) ln(1+Delta_m/p)-n(q-Delta_m) ln(1-Delta_m/q)).
$
Так как $abs(m-n p) = O(sqrt(n))$, то $Delta_m = O(1/sqrt(n)) arrow 0$ и
$ Delta_m/q arrow 0, quad Delta_m/p arrow 0. $
Отсюда
$
  ln T approx -n[(p+Delta_m)(Delta_m/p-Delta_m^2/(2p^2))
    +(q-Delta_m)(-Delta_m/q-Delta_m^2/(2q^2))]
$
$
  approx -n[Delta_m-Delta_m^2/(2p)+Delta_m^2/p-Delta_m-Delta_m^2/(2q)+Delta_m^2/q]
$
$ = -n[Delta_m^2/(p q)-Delta_m^2/(2p q)] = -(n Delta_m^2)/(2p q). $
$ T approx exp(-(n Delta_m^2)/(2p q)) = exp(-1/2 ((m-M(mu_n))/sigma(mu_n))^2). $
$
  P{mu_n = m} approx 1/sqrt((p+Delta_m)(q-Delta_m)n) phi((m-M(mu_n))/sigma(mu_n))
$
$ approx 1/sqrt(n p q) phi((m-M(mu_n))/sigma(mu_n)). $

=== Распределение Пуассона (7)

Для дискретной неотрицательной случайной величины $xi$ распределение
$ P{xi = m} = lambda^m/m! e^(-lambda) $
называется #definition[распределением Пуассона].
$lambda$ — параметр распределения.
$ M(xi) = lambda, quad D(xi) = lambda. $

=== Теорема Пуассона

В схеме Бернулли при $n arrow infinity$, $n p arrow lambda$ для любого фиксированного $m$:
$ P{mu_n = m} arrow lambda^m/m! e^(-lambda). $
Пометка в источнике: «или $sum_(i=1)^n p_(i n) = lambda$».
Для независимых испытаний с разными вероятностями достаточно условий
$sum_(i=1)^n p_(i n) arrow lambda$ и $max_i p_(i n) arrow 0$.

*Доказательство.* Пусть $lambda = n p$. Тогда
$ P{mu_n = m} = C_n^m lambda^m/n^m (1-lambda/n)^(n-m) $
$
  = underbrace((1-lambda/n)^n, arrow e^(-lambda))
  underbrace((1-lambda/n)^(-m), arrow 1) lambda^m/m!
  underbrace(n!/(n^m (n-m)!), arrow 1)
  arrow lambda^m/m! e^(-lambda).
$

Иначе говоря, распределение Пуассона отвечает за вероятность того,
что в течение фиксированного интервала произойдёт ровно $m$ событий,
при условии, что они независимы и происходят со средней интенсивностью $lambda$.

// Источник: с. 12.
=== Интегральная теорема Муавра — Лапласа

$ Phi(x) = integral_(-infinity)^x phi(t) dif t $
— функция стандартного нормального распределения.
Тогда при $n arrow infinity$ в схеме Бернулли с фиксированным $0 < p < 1$:
$ P{a <= mu_n <= b} = sum_(m=ceil(a))^(floor(b)) P{mu_n = m} $
$
  approx integral_a^b 1/sigma(mu_n) phi((x-M(mu_n))/sigma(mu_n)) dif x
  = integral_alpha^beta phi(t) dif t
$
$ = Phi((b-M(mu_n))/sigma(mu_n)) - Phi((a-M(mu_n))/sigma(mu_n)). $
