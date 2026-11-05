#import "../_shared/style.typ": definition
#import "@preview/cetz:0.4.2"

// Источник: с. 16.
== Теорема Ляпунова и лемма Бореля — Кантелли

=== Абсолютный момент

$k$-й #definition[абсолютный момент] случайной величины $xi$:
$ mu_k = M[abs(xi-M(xi))^k]. $

=== Теорема Ляпунова

Пусть $xi_1, dots$ — независимые случайные величины с конечными третьими абсолютными моментами.
Положим
$
  a_k = M(xi_k), quad b_k^2 = M[(xi_k-M(xi_k))^2], quad c_k^3 = M[abs(xi_k-M(xi_k))^3],
$
$
  A_n = sum_(k=1)^n a_k, quad B_n^2 = sum_(k=1)^n b_k^2, quad C_n^3 = sum_(k=1)^n c_k^3.
$
Тогда, если $B_n > 0$ и $lim_(n arrow infinity) C_n/B_n = 0$, то
$ P{(xi_1+dots+xi_n-A_n)/B_n < x} arrow_(n arrow infinity) Phi(x). $

=== Лемма Бореля — Кантелли

Обозначим
$
  limsup_(n arrow infinity) A_n = inter_(N=1)^infinity union_(n=N)^infinity A_n.
$
#align(center, cetz.canvas(length: 5mm, {
  import cetz.draw: *
  set-style(stroke: 0.6pt + rgb("#283f8a"))
  for j in range(0, 4) {
    let x = j * 0.8
    let y = j * 0.35
    line((x, y + 0.3), (x, y), (6, y))
  }
  for j in range(0, 7) {
    line((j * 0.8 + 0.3, 1.4), (j * 0.8 + 0.3, 1.65))
  }
}))
Иначе говоря,
$
  limsup_(n arrow infinity) A_n = {omega in Omega: omega "принадлежит бесконечно многим" A_i}.
$

+ Если $sum_(n=1)^infinity P(A_n) < infinity$, то
  $ P(limsup_(n arrow infinity) A_n) = 0. $
  Почти наверное происходит конечное число $A_n$.
  $A_n$ не обязательно независимы.
+ Если $sum_(n=1)^infinity P(A_n) = infinity$, то
  $ P(limsup_(n arrow infinity) A_n) = 1. $
  Почти наверное происходит бесконечное число $A_n$.
  $A_n$ совместно независимы.

=== Асимптотическая нормальность

Если функции распределения случайных величин $(eta_n-A_n)/B_n$ при $n arrow infinity$
сходятся к $Phi(x)$, то говорят, что $eta_n$ #definition[асимптотически нормальна]
с параметрами $(A_n, B_n)$.
