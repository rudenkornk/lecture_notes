#import "../_shared/style.typ": definition

// Источник: с. 23.
== Свёртка случайных величин

Пусть $xi$, $eta$ независимы. Тогда:

=== 1. Математическое ожидание и дисперсия суммы

$ M(xi+eta) = M(xi)+M(eta), quad D(xi+eta) = D(xi)+D(eta). $

=== 2. Дискретный случай

$ P{xi+eta = x} = sum_t P{xi = t} dot P{eta = x-t}. $

=== 3. Непрерывный случай

$ p_(xi+eta)(x) = integral_t p_(xi)(t) p_(eta)(x-t) dif t. $

=== 4. Сумма биномиальных величин

$ xi tilde op("Bin")(n_xi, p), quad P{xi = k} = C_(n_xi)^k p^k (1-p)^(n_xi-k), $
$ eta tilde op("Bin")(n_eta, p) => xi+eta tilde op("Bin")(n_xi+n_eta, p). $

=== 5. Сумма пуассоновских величин

$
  xi tilde op("Poiss")(lambda_1), quad eta tilde op("Poiss")(lambda_2)
  => xi+eta tilde op("Poiss")(lambda_1+lambda_2).
$

=== 6. Сумма нормальных величин

$
  xi tilde N(mu_1, sigma_1^2), quad eta tilde N(mu_2, sigma_2^2)
  => xi+eta tilde N(mu_1+mu_2, sigma_1^2+sigma_2^2).
$

=== 7. Функция двух случайных величин

$f(xi, eta)$ — некоторая функция.
$ M(f(xi, eta)) = sum_(i,j) f(x_i, y_j) dot P{xi = x_i} dot P{eta = y_j} $
$
  = integral_(-infinity)^infinity integral_(-infinity)^infinity f(x, y) p_(xi)(x) p_(eta)(y) dif x dif y.
$

=== 8. Максимум и минимум

$ F_(max(xi, eta))(x) = F_(xi)(x) dot F_(eta)(x), $
$
  F_(min(xi, eta))(x) = 1-(1-F_(xi)(x))(1-F_(eta)(x)) = F_(xi)(x)+F_(eta)(x)-F_(xi)(x) F_(eta)(x).
$
