#import "../_shared/style.typ": definition

// Источник: с. 12 (продолжение).
== Непрерывные случайные величины

=== Функция распределения

В вероятностном пространстве $(Omega, F, P)$ случайная величина $xi$ такова, что
$ {omega in Omega: xi(omega) <= x} in F. $
Функция
$ F_(xi)(x) = P{xi <= x} $
— #definition[функция распределения] $xi$.
$F_(xi)(x)$ непрерывна справа в каждой точке.

=== Плотность распределения

Пусть $p_(xi)(x)$ — #definition[плотность распределения] $xi$ и
$
  P{xi in B} = integral_B p_(xi)(x) dif x => F_(xi)(x) = integral_(-infinity)^x p_(xi)(t) dif t.
$
Тогда
$ M(xi) = integral_(-infinity)^infinity x p_(xi)(x) dif x. $

=== Функция случайной величины

Пусть $eta = f(xi)$, где $f: RR arrow RR$ — непрерывно дифференцируемая,
строго возрастающая функция с $f'(x) > 0$.
Тогда
$
  F_(eta)(x) = F_(xi)(f^(-1)(x)), quad p_(eta)(x) = p_(xi)(f^(-1)(x)) dot (f^(-1))'(x),
$
$ M(eta) = integral_(-infinity)^infinity f(x) p_(xi)(x) dif x. $

*Доказательство.*
$
  F_(eta)(x) = P{eta <= x} = P{f(xi) <= x} = P{xi <= f^(-1)(x)} = F_(xi)(f^(-1)(x)),
$
$ p_(eta)(x) = F'_(eta)(x) = p_(xi)(f^(-1)(x)) dot (f^(-1))'(x). $
$
  M(eta) = integral_(-infinity)^infinity x p_(eta)(x) dif x
  = integral_(-infinity)^infinity x p_(xi)(f^(-1)(x)) (f^(-1))'(x) dif x
$
$ = integral_(-infinity)^infinity f(t) p_(xi)(t) dif t, quad t = f^(-1)(x). $

// Источник: с. 13.
== Основные распределения

=== 1. Равномерное распределение

$ p_(xi)(x) = cases(1/(b-a) quad & a <= x <= b, 0 quad & x in.not [a, b]), $
$
  F_(xi)(x) = cases(0 quad & x < a, (x-a)/(b-a) quad & a <= x <= b, 1 quad & x > b),
$
$ M(xi) = (b+a)/2, quad D(xi) = (b-a)^2/12. $

=== 2. Показательное распределение

Экспоненциальное распределение, $op("Exp")(lambda)$, $lambda > 0$:
$ p_(xi)(x) = cases(lambda exp(-lambda x) quad & x >= 0, 0 quad & x < 0), $
$ F_(xi)(x) = cases(1-e^(-lambda x) quad & x >= 0, 0 quad & x < 0), $
$ M(xi) = 1/lambda, quad D(xi) = 1/lambda^2, quad "медиана" = (ln 2)/lambda. $
*Memorylessness*, $x, t >= 0$:
$ P{xi > x+t divides xi > x} = P{xi > t}. $

=== 3. Нормальное (гауссовское) распределение

$sigma > 0$:
$
  p_(xi)(x) = 1/(sqrt(2 pi) sigma) exp(-(x-a)^2/(2sigma^2)) = 1/sigma phi((x-a)/sigma),
$
$ F_(xi)(x) = Phi((x-a)/sigma), quad M(xi) = a, quad D(xi) = sigma^2. $
Переходит в #definition[стандартное нормальное распределение] при $a = 0$, $sigma = 1$.
Обозначается $xi tilde N(a, sigma^2)$.

*Формула Миллса:*
$ 1-Phi(x) approx e^(-x^2/2)/(sqrt(2 pi) x) (1-1/x^2+3/x^4 dots). $

Показательное распределение отвечает на вопрос, с какой вероятностью следующее событие произойдёт через $x$,
если события происходят независимо с интенсивностью $lambda$.

=== 4. Геометрическое распределение

Число независимых испытаний в схеме Бернулли до первого успеха:
$ P{xi = k} = (1-p)^(k-1) p, quad P{xi <= k} = 1-(1-p)^k, $
$ M(xi) = 1/p, quad D(xi) = (1-p)/p^2. $
*Memorylessness*, целые $x >= 0$, $k >= 1$:
$ P{xi > x+k divides xi > x} = P{xi > k}, $
$ P{xi >= x+k divides xi > x} = P{xi >= k}. $
