#import "../_shared/style.typ": definition

// Источник: с. 3.
== Вероятностное пространство

=== Аксиоматика Колмогорова

Множество $Omega = {omega}$ — #definition[пространство элементарных событий].

Множество (класс) $F$ подмножеств $Omega$, содержащее $Omega$ и такое, что для любых $A, B in F$:

+ $A+B equiv A union B in F$;
+ $A B equiv A inter B in F$;
+ $A without B in F$,

называется #definition[алгеброй событий].

$A, B$ — события; $Omega$ — достоверное событие; $emptyset$ — невозможное событие.
$overline(A) = Omega without A$ — противоположное $A$ событие.
Если $A B = emptyset$, то $A$ и $B$ #definition[несовместны].

=== Сигма-алгебра

Алгебра событий $F$, для которой:

+ $Omega in F$;
+ $forall A in F => overline(A) in F$;
+ Для любой последовательности $A_1, A_2, dots in F$: $union_(i=1)^infinity A_i in F$,

называется #definition[$sigma$-алгеброй].

*Теорема.* Если $F_1, F_2$ — $sigma$-алгебры, то $F_1 inter F_2$ — тоже $sigma$-алгебра.
Доказательство очевидно.

=== Свойства событий

$
  overline(overline(A)) = A, quad A A = A, quad A+A = A, quad A overline(A) = emptyset,
$
$
  A emptyset = emptyset, quad A Omega = A, quad A+overline(A) = Omega, quad A+Omega = Omega,
$
$ A(B+C) = A B + A C, quad A+B C = (A+B)(A+C), $
$
  overline(A+B) = overline(A) dot overline(B), quad overline(A B) = overline(A)+overline(B),
$
$ A = A B + (A without B). $

// Источник: с. 4.
=== Вероятность

Числовая функция $P$ на $sigma$-алгебре $F$ называется #definition[вероятностью], если:

+ $forall A in F => P(A) >= 0$ — положительная определённость;
+ $P(Omega) = 1$ — нормированность;
+ $forall A, B in F: A B = emptyset => P(A+B) = P(A)+P(B)$ — аддитивность;
+ Для $A_i in F$, $i != j => A_i A_j = emptyset$:
  $ P(sum_(i=1)^infinity A_i) = sum_(i=1)^infinity P(A_i) $
  — расширенная аддитивность.

Тогда #definition[вероятностное пространство] — тройка $(Omega, F, P)$,
где $Omega$ — пространство элементарных событий,
$F$ — $sigma$-алгебра этого пространства, $P$ — вероятность на $F$.

=== Свойства вероятности

$ P(overline(A)) = 1-P(A), $
так как $1 = P(Omega) = P(A+overline(A)) = P(A)+P(overline(A))$.
$ P(A+B) = P(A)+P(B)-P(A B). $

// Источник: с. 5.
=== Дискретное вероятностное пространство

$Omega = {omega_1, dots, omega_n}$, $n in NN$ — #definition[конечная схема].
Пусть $P(omega_i) >= 0$, $sum_i P(omega_i) = 1$, $P(emptyset) = 0$.
Тогда вероятность события $A$:
$ P(A) = sum_(omega in A) P(omega). $

Классическое определение вероятности:
$ P(A) = abs(A)/abs(Omega) <=> P(omega_i) = 1/n quad forall i. $
Для счётной схемы аналогично.

=== Непрерывное вероятностное пространство

$G$ — измеримая по Лебегу область в $RR^n$ (квадрируемая).
$sigma$-алгебра $F$ содержит все квадрируемые подмножества $G$.

#definition[Плотность вероятности] — измеримая функция $rho: G arrow RR$:
$
  forall x in G: rho(x) >= 0, quad integral_G dots integral rho(x) dif x_1 dots dif x_n = 1.
$
Тогда
$ P(A) = integral_A dots integral rho(x) dif x_1 dots dif x_n. $
Если $rho(x) equiv 1/m(G)$, где $m$ — мера Лебега и $0 < m(G) < infinity$, то
$ P(A) = m(A)/m(G). $

// Источник: с. 6.
=== Условная вероятность

Пусть $A, B in F$, $P(A) > 0$.
$ P(B divides A) = P(A B)/P(A) $
— #definition[условная вероятность] события $B$ при событии $A$.
Отсюда
$ P(A B) = P(B divides A) dot P(A). $

=== Формула полной вероятности

Пусть ${B_i}$ — разбиение $Omega$, $P(B_i) > 0$. Тогда
$ P(A) = sum_i P(A divides B_i) dot P(B_i). $
Пометка на полях: $M(P(A divides xi_B))$.

=== Формула Байеса

При $P(A) > 0$:
$
  P(B_k divides A) = (P(A divides B_k) dot P(B_k))/(sum_i P(A divides B_i) dot P(B_i))
  = (P(A divides B_k) dot P(B_k))/P(A).
$

=== Независимость событий

События $A_1, dots, A_n$ #definition[взаимно независимы], если для каждого $k = 1, dots, n$:
$
  forall 1 <= i_1 < dots < i_k <= n:
  P(A_(i_1) dots A_(i_k)) = P(A_(i_1)) dots P(A_(i_k)).
$
Если верно только $forall i != k: P(A_i A_k) = P(A_i) P(A_k)$,
то события #definition[попарно независимы].
Для независимых $A$, $B$ при $P(A) > 0$ верно $P(B divides A) = P(B)$.

=== Полиномиальная схема

В эксперименте может наступить $k$ исходов с вероятностями $p_1, dots, p_k$.
Вероятность того, что первый исход случится $m_1$ раз, второй — $m_2$ раз, …,
$k$-й — $m_k$ раз, равна
$ P_(n)(m_1, dots, m_k) = n!/(m_1! dots m_k!) p_1^(m_1) dots p_k^(m_k). $
Такая схема независимых испытаний называется #definition[полиномиальной].

=== Схема Бернулли

Вероятность $m$ успехов в $n$ испытаниях с вероятностью успеха $p$:
$ P_(n)(m) = C_n^m p^m (1-p)^(n-m). $
$ mu_n = sum_(i=1)^n xi_i $ — число успехов;
$M(mu_n) = n p$, $D(mu_n) = n p(1-p)$.
