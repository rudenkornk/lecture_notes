#import "../_shared/style.typ": definition

// Источник: с. 7.

== Случайные величины в счётной схеме

=== Распределение случайной величины

$xi$ — #definition[случайная величина]: числовая функция на $Omega$.
$P{xi = x_k}$ — вероятность того, что $xi$ примет значение $x_k$.
Тогда её распределение можно задать таблицей.
Верно, что
$ sum_k P{xi = x_k} = 1. $

Задав несколько таких величин $bold(xi) = (xi_1, dots, xi_n)$,
можно ввести многомерное распределение:
$ P_(bold(xi))(B) = P{bold(xi) in B}, quad B subset RR^n. $

=== Независимость случайных величин

Случайные величины $xi_i$ #definition[независимы], если для любых измеримых $B_1, dots, B_n$:
$ P{xi_1 in B_1, dots, xi_n in B_n} = P{xi_1 in B_1} dots P{xi_n in B_n}. $

=== Математическое ожидание

$ M(xi) = sum_(omega in Omega) xi(omega) P(omega) $
— #definition[математическое ожидание] дискретной $xi$.
Легко проверить, что
$ M(xi+eta) = M(xi)+M(eta), quad M(c xi) = c M(xi), $
$
  M(a_1 xi_1 + dots + a_n xi_n) = a_1 M(xi_1) + dots + a_n M(xi_n), quad M(c) = c.
$
Используя распределение $xi$:
$ M(xi) = sum_k x_k P{xi = x_k}. $
Для независимых $eta$ и $xi$:
$ M(xi eta) = M(xi) dot M(eta). $

=== Формулы для математического ожидания

Если $xi$ — неотрицательная целочисленная случайная величина, то
$ M(xi) = sum_(k=1)^infinity P{xi >= k} $
— «формула выживания».

Для $RR$:
$ M(xi) = integral x f(x) dif x. $
#block(breakable: false)[
  Если $xi >= 0$, то
  $
    M(xi) = integral_0^infinity P{xi >= x} dif x = integral_0^infinity (1-F(x)) dif x.
  $
]

#block(breakable: false)[
  #definition[Формула полного математического ожидания]:
  $
    M(xi) = M(M(xi divides eta)) = sum_i M(xi divides eta = y_i) dot P{eta = y_i}.
  $
]

// Источник: с. 8.

#block(breakable: false, above: 1.1em)[
  === Дисперсия случайной величины

  $ D(xi) = M[(xi-M(xi))^2] = M(xi^2)-M(xi)^2. $
  #definition[Формула полной дисперсии]:
  $ D(xi) = M(D(xi divides eta)) + D(M(xi divides eta)). $

  Свойства:

  + $D(xi) >= 0$; $D(xi) = 0 <=> xi$ — вырожденная величина.
  + $D(a xi) = a^2 D(xi)$.
  + Если $xi$ и $eta$ независимы, то $D(xi+eta) = D(xi)+D(eta)$.
  + $D(xi+eta) = D(xi)+D(eta)+2 op("cov")(eta, xi)$.
    $ D(xi+eta) = D(xi)+D(eta)+2 M(xi eta)-2 M(xi) M(eta). $
  + $D(sum_i xi_i) = sum_i D(xi_i) + sum_(i != j) op("cov")(xi_i, xi_j)$.

]

=== Ковариация

#definition[Ковариация] случайных величин:
$ op("cov")(xi, eta) = M((xi-M(xi))(eta-M(eta))) = M(xi eta)-M(xi) M(eta). $
Ясно, что:

+ $op("cov")(xi, xi) = D(xi)$.
+ $op("cov")(xi, eta) = op("cov")(eta, xi)$.
+ $op("cov")(c_1 xi_1+c_2 xi_2, eta) = c_1 op("cov")(xi_1, eta) + c_2 op("cov")(xi_2, eta)$.
+ Если $xi$, $eta$ независимы, то $op("cov")(xi, eta) = 0$.

=== Ковариационная матрица

#definition[Ковариационная матрица] вектора $bold(xi) = (xi_1, dots, xi_n)^T$:
$
  op("Cov")(bold(xi)) = mat(
    op("cov")(xi_1, xi_1), dots, op("cov")(xi_1, xi_n);
    dots.v, dots.down, dots.v;
    op("cov")(xi_n, xi_1), dots, op("cov")(xi_n, xi_n);
  ) = M[(bold(xi)-bold(mu))(bold(xi)^T-bold(mu)^T)].
$

=== Коэффициент корреляции

При $D(xi) > 0$, $D(eta) > 0$ величина
$ rho(xi, eta) = (op("cov")(xi, eta))/sqrt(D(xi) D(eta)) $
— #definition[коэффициент корреляции].
$xi$, $eta$ — #definition[некоррелированные], если $rho(xi, eta) = 0$.

$
  rho(xi, eta) = plus.minus 1 => cases(
    xi = a eta+b quad "на почти всех" omega,
    op("sgn")(a) = op("sgn")(rho),
  ), quad a, b in RR.
$

=== Неравенство Коши — Буняковского — Шварца

$ M(xi eta)^2 <= M(xi^2) dot M(eta^2), $
$ op("cov")(xi, eta)^2 <= D(xi) dot D(eta). $

#block(breakable: false, above: 1.1em)[
  === Свойства матрицы ковариации

  + Симметричная.
  + Неотрицательно определённая.
  + Диагональные элементы $>= 0$.
  + $lambda_i >= 0$ — собственные числа.

  $ bold(a)^T op("Cov")(bold(xi)) bold(a) = D(bold(a)^T bold(xi)) >= 0. $
]
