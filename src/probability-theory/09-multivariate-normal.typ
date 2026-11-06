#import "../_shared/style.typ": definition

// Источник: с. 21.

#block(breakable: false, above: 1.5em)[
  == Многомерное нормальное распределение (8)

  === Определение и плотность

  Вектор случайных величин $bold(xi) = (xi_1, dots, xi_n)^T$ распределён нормально,
  если любая его линейная комбинация распределена нормально:
  $
    forall bold(a) in RR^n: F_(bold(a)^T bold(xi))(x) = Phi((x-mu_(dots))/sigma_(dots)).
  $
  Многоточия в параметрах сохранены из источника.

  Обозначим
  $
    bold(mu) = M(bold(xi)) = mat(M(xi_1); dots.v; M(xi_n)), quad C = op("Cov")(bold(xi)).
  $
  $C$ — матрица ковариации. При положительно определённой $C$ плотность вероятности:
  $
    f(bold(x)) = 1/sqrt((2 pi)^n abs(C))
    exp(-1/2 (bold(x)-bold(mu))^T C^(-1)(bold(x)-bold(mu))).
  $
]

=== Свойства многомерного нормального распределения

1. Если $bold(xi) tilde N(bold(mu), C)$, $bold(eta) = A bold(xi)+bold(b)$, то
$ bold(eta) tilde N(A bold(mu)+bold(b), A C A^T). $

#block(breakable: false)[
  2. Пусть вектор и математическое ожидание разбиты на блоки:
  $
    bold(xi) = mat(
      underbrace(mat(xi_1; dots.v; xi_q), bold(xi)_1);
      underbrace(mat(xi_(q+1); dots.v; xi_n), bold(xi)_2)
    ), quad
    bold(mu) = mat(mu_1; dots.v; mu_q; mu_(q+1); dots.v; mu_n)
    = mat(bold(mu)_1; bold(mu)_2),
  $
  $ C = mat(C_(1 1), C_(1 2); C_(2 1), C_(2 2)). $
  Размеры блоков: $C_(1 1)$ — $q times q$, $C_(1 2)$ — $q times (n-q)$,
  $C_(2 1)$ — $(n-q) times q$, $C_(2 2)$ — $(n-q) times (n-q)$.
  При обратимой $C_(2 2)$:
  $ (bold(xi)_1 divides bold(xi)_2) tilde N(tilde(bold(mu)), tilde(C)), $
  где

  // Источник: с. 22.

  $ tilde(bold(mu)) = bold(mu)_1+C_(1 2) C_(2 2)^(-1)(bold(xi)_2-bold(mu)_2), $
  $ tilde(C) = C_(1 1)-C_(1 2) C_(2 2)^(-1) C_(2 1). $
]

#block(breakable: false, above: 1.1em)[
  === Задача о наилучшем среднеквадратичном прогнозе

  $
    min_(bold(g)) M(norm(bold(Y)-bold(g)(bold(X)))^2)
    => bold(g)(bold(x)) = mat(M(Y_1 divides bold(X) = bold(x)); dots.v; M(Y_n divides bold(X) = bold(x))).
  $

  - В частности, если $X$, $Y$ — скалярные случайные величины:
    $ min_g M((Y-g(X))^2) => g(x) = M(Y divides X = x). $
  - Для $min_(c in RR) M((Y-c)^2)$ получаем $c = M(Y)$.
  - Для $min_(c in RR) M(abs(Y-c))$ получаем $c$ — медиана $Y$:
    $P(Y <= c) >= 0.5$ и $P(Y >= c) >= 0.5$.
]

=== Теорема Слуцкого

Если $xi_n arrow^d xi$ (по распределению),
$eta_n arrow^P c$ (по вероятности к константе $c$), то:
$
  cases(
    xi_n+eta_n arrow^d xi+c,
    xi_n eta_n arrow^d c xi,
    xi_n/eta_n arrow^d xi/c quad (c != 0),
  ).
$
