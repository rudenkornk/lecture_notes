#import "../_shared/style.typ": definition

// Источник: с. 14.
== Производящие и характеристические функции

=== Производящая функция

Функция
$ Psi_(xi)(t) = M(exp(t xi)) $
— #definition[производящая].
Ниже предполагается, что она конечна в некоторой окрестности нуля.

Свойства:

+ $Psi_(xi)(t) = integral_(-infinity)^infinity e^(t x) p_(xi)(x) dif x$.
+ $Psi_(xi)(0) equiv 1$.
+ Множество производящих функций и функций распределения изоморфны.
+ $Psi_(a xi)(t) = Psi_(xi)(a t)$.
+ $Psi_(xi+eta)(t) = Psi_(xi)(t) Psi_(eta)(t)$ для независимых $xi$ и $eta$.

Также из формулы
$ Psi_(xi)(t) = sum_(k=1)^infinity e^(t x_k) P{xi = x_k} $
видно, что
$ M(xi^n) = lr((dif^n)/(dif t^n) Psi_(xi)(t))|_(t=0). $

=== Характеристическая функция

#definition[Характеристическая функция] $xi$:
$ phi_(xi)(t) = M(e^(i t xi)). $

а) Для равномерного распределения $(-a, a)$:
$ phi_(xi)(t) = sin(a t)/(a t), quad phi_(xi)(0) = 1. $

б) Для распределения Пуассона с параметром $lambda$:
$ phi_(xi)(t) = e^(lambda(exp(i t)-1)). $

в) Для нормального распределения $N(a, sigma^2)$:
$ phi_(xi)(t) = e^(a i t-sigma^2 t^2/2). $

г) Для распределения Бернулли:
$ phi_(xi)(t) = (1-p)+p e^(i t). $

=== Свойства характеристических функций

+ $phi_(xi)(t) = integral_(-infinity)^infinity e^(i t x) p_(xi)(x) dif x$;
  $phi_(xi)(t) = sum_(k=1)^infinity e^(i t x_k) P{xi = x_k}$.
+ $forall t: abs(phi_(xi)(t)) <= 1$.
+ Множество характеристических функций и функций распределения изоморфны.
+ $phi_(a+b xi)(t) = exp(i t a) phi_(xi)(t b)$.
+ $phi_(xi+eta)(t) = phi_(xi)(t) phi_(eta)(t)$ для независимых $xi$ и $eta$.
+ Если $integral_(-infinity)^infinity abs(phi_(xi)(t)) dif t < infinity$, то
  $p_(xi)(x) = 1/(2 pi) integral_(-infinity)^infinity e^(-i t x) phi_(xi)(t) dif t$.

$
  P{xi = x} = lim_(T arrow infinity) 1/(2T) integral_(-T)^T e^(-i t x) phi_(xi)(t) dif t.
$

// Источник: с. 15.
=== Среднее независимых нормальных величин

*Теорема.* Независимые $xi_1, dots, xi_n$ имеют нормальное распределение $N(a, sigma^2)$.
Тогда $overline(xi) = (sum_i xi_i)/n$ имеет нормальное распределение $N(a, sigma^2/n)$.

$
  phi_(overline(xi))(t) = phi_(xi_1+dots+xi_n)(t/n)
  = phi_(xi_1)(t/n) dots phi_(xi_n)(t/n)
$
$ = (e^(a i t/n-sigma^2 (t/n)^2/2))^n = e^(a i t-(sigma^2/n)t^2/2). $

=== Слабая сходимость

Последовательность ${xi_n}$ #definition[сходится слабо] (по распределению), если
для любого $x$, в котором $F_xi$ непрерывна, $F_(xi_n)(x) arrow F_(xi)(x)$.
Обозначение: $xi_n arrow xi$.

*Теорема.*
$ xi_n arrow xi <=> forall t in RR: phi_(xi_n)(t) arrow phi_(xi)(t). $

=== Центральная предельная теорема для одинаково распределённых величин

Пусть $xi_1, dots, xi_n, dots$ независимы и одинаково распределены,
$M(xi_i) = a$, $0 < D(xi_i) = sigma^2 < infinity$. Тогда
$ P{(xi_1+dots+xi_n-n a)/(sigma sqrt(n)) < x} arrow_(n arrow infinity) Phi(x). $

*Доказательство.* Пусть
$ eta_i = (xi_i-a)/sigma => M(eta_i) = 0, quad D(eta_i) = 1. $
Требуется показать, что $(sum_i eta_i)/sqrt(n) arrow N(0, 1)$.
$ phi_((sum_i eta_i)/sqrt(n))(t) = (phi_(eta_1)(t/sqrt(n)))^n. $
Иначе говоря,
$ sqrt(n) (overline(xi)_n-a)/sigma arrow^d N(0, 1), $
или, в смысле асимптотического нормального приближения,
$ overline(xi)_n approx N(a, sigma^2/n), $
или
$ sqrt(n) (overline(xi)_n-a) arrow^d N(0, sigma^2). $
