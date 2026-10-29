#import "../_shared/style.typ": definition
#import "diagrams.typ": cells, tree

Несколько видов деревьев:
+ #definition[Детерминированные] (RB-дерево).
+ #definition[Амортизированные] (Splay-дерево).
+ #definition[Рандомизированные] (Cartesian tree).

== Декартовы деревья. Cartesian trees

#definition[Декартово дерево] — гибрид дерева и кучи — «дуча» или treap.
Состоит из пар ключей и приоритетов, причём ключи образуют дерево поиска, а приоритеты — кучу.

$k_i$ — key — BST.\
$p_i$ — priority — HEAP.

#align(center, tree(
  (
    ((0, 0), []),
    ((-1, -1), []),
    ((1, -1), []),
    ((-1.5, -2), []),
    ((-0.5, -2), []),
    ((0.5, -2), []),
    ((1.5, -2), []),
  ),
  ((0, 1), (0, 2), (1, 3), (1, 4), (2, 5), (2, 6)),
))

Если выбирать $p_i$ случайно, то дерево является в среднем сбалансированным: $bb(E)["height"] = O(log n)$.

Для любого набора $k, p$ дуча существует.
Доказательство: в корне лежит наибольший приоритет, и ключ разбивает оставшиеся вершины на два поддерева.
Каждое из них строится аналогично.

#grid(
  columns: (auto, 1fr),
  column-gutter: 2em,
  tree(
    (
      ((0, 0), [$p -> max$\ $(k, p)$]),
      ((-1, -1.5), [$triangle (<k)$]),
      ((1, -1.5), [$triangle (>k)$]),
    ),
    ((0, 1), (0, 2)),
  ),
  [Рандомизированное построение. Похоже на QuickSort.],
)

На дереве определяются операции:

#block(stroke: 0.5pt, inset: 8pt)[
  Все ключи $T_1 <=$ ключей $T_2$; $T_1 <= T_2$.

  $"Merge"(T_1, T_2) = T_3$.\
  $"Split"(T, lambda) = (underbrace(T_1, <lambda), underbrace(lambda, "ключ"), underbrace(T_2, >lambda))$.
]

Тогда,
$
  "Insert"(T, lambda) = "Split"(T, lambda)
  arrow underbrace(underbrace(T_1 quad lambda, "merge") quad T_2, "merge").
$
$
  "Remove"(T, lambda) = "Split"(T, lambda)
  arrow (T_1, underbrace(lambda, "remove"), T_2) arrow "merge"(T_1, T_2).
$

=== Merge($T_1, T_2$)

$O(log n)$. Ключи в $T_2 >=$ ключей в $T_1$!

1. $"Merge"(T, "null") = T$.

2. $"Merge"(T_1, T_2) =$\
  #align(center)[$
    "Merge"(
      #tree((((0, 0), [$u$]), ((-0.7, -0.8), [$alpha$]), ((0.7, -0.8), [$beta$])), ((0, 1), (0, 2))),
      #tree((((0, 0), [$v$]), ((-0.7, -0.8), [$gamma$]), ((0.7, -0.8), [$delta$])), ((0, 1), (0, 2)))
    ) =
    cases(
      #tree((((0, 0), [$u$]), ((-1, -1), [$alpha$]), ((1, -1), [$"merge"(beta, T_2)$])), ((0, 1), (0, 2))) & "если" p(u) >= p(v),
      #tree((((0, 0), [$v$]), ((-1, -1), [$"merge"(T_1, gamma)$]), ((1, -1), [$delta$])), ((0, 1), (0, 2))) & "если" p(u) < p(v),
    ).
  $]

=== Split($T, lambda$)

$"Split"(T, lambda) = (underbrace(T_1, <lambda), lambda, underbrace(T_2, >lambda))$.
$O(log n)$.

1. #tree(
    (((0, 0), [$v$]), ((-0.7, -0.8), [$alpha$]), ((0.7, -0.8), [$beta$])),
    ((0, 1), (0, 2)),
  )
  $K(v) = lambda => (alpha, v, beta)$.
  $lambda$ в корне.

2. #tree(
    (((0, 0), [$v$]), ((-0.7, -0.8), [$alpha$]), ((0.7, -0.8), [$beta$])),
    ((0, 1), (0, 2)),
  )
  $K(v) < lambda =>$ рекурсия $"Split"(beta, lambda) = (gamma, x, delta)$.
  $=> (#tree((((0, 0), [$v$]), ((-0.7, -0.8), [$alpha$]), ((0.7, -0.8), [$gamma$])), ((0, 1), (0, 2))), x, delta)$.

=== Построение декартова дерева

Пусть наборы $(k_i, p_i)$ отсортированы: $k_1 < k_2 < dots < k_n$.
Тогда дерево строится за линейное время $O(n)$.

Индукция: $T_i arrow^(+(k, p)) T_(i + 1)$; $(k, p)$ — новая пара из упорядоченного набора.

#align(center, grid(
  columns: (auto, auto, auto),
  column-gutter: 1em,
  align: horizon,
  image("images/cartesian-build-before.jpg", width: 45mm),
  [$arrow$],
  image("images/cartesian-build-after.jpg", width: 52mm),
))

$p(x_1) > p(x_2) > dots > p(x_l)$.\
$p(x_i) > p > p(x_(i + 1))$.

Точку вставки нужно искать с конца правого пути.
Если далеко от конца, тем сильнее сократится правый путь и следующая вставка будет дешевле.
Поэтому сложность тут — амортизированная $O(n)$.

== Структура данных «B-деревья»

Используются для данных большого размера, не укладывающихся в оперативную память.

#grid(
  columns: (auto, 1fr),
  column-gutter: 2em,
  tree(
    (
      ((0, 0), [$k_1, dots, k_(d - 1)$]),
      ((-3, -2), [$1$\ $(-infinity; k_1]$]),
      ((-1, -2), [$2$\ $(k_1; k_2]$]),
      ((1, -2), [$dots$]),
      ((3, -2), [$d$\ $(k_(d - 1); +infinity)$]),
    ),
    ((0, 1), (0, 2), (0, 3), (0, 4)),
  ),
  [Ключи и данные хранятся в листьях.
    На нелистовых уровнях хранятся копии ключей.

    Разделяющими ключами могут выступать, например, максимальные в поддеревьях.],
)

#grid(
  columns: (auto, 1fr),
  column-gutter: 2em,
  image("images/b-tree-levels.jpg", width: 70mm),
  [Ключи с данными хранятся все на одном уровне.
    Причём, чтобы не иметь множество висячих вершин, реально все хранятся на предпоследнем уровне,
    а последний есть только «виртуально».
    Поэтому предпоследний уровень хранит число ключей, равное числу потомков,
    в отличие от всех остальных уровней!],
)

#grid(
  columns: (auto, 1fr),
  column-gutter: 2em,
  image("images/b-tree-linked-leaves.jpg", width: 90mm),
  [$d approx 1000$, $alpha in (0; 1 / 2)$.

    Корень хранит от 1 до $d$ ключей.
    Все уровни, кроме корневого и последнего, — от $alpha d$ до $d$ ключей.

    Тогда высота — это $h = O(log_(alpha d) n)$.],
)

FindRange — выписывает подряд идущие ключи.
Для эффективности предпоследний уровень связан.

=== Insert

Если ключей $< d$ в вершине, то просто вставляем.
Если ключей $d$, то нужно разделить на две вершины.

#align(center)[$
  #tree((((0, 2), []), ((0, -1), [#ellipse(inset: 5pt)[$bullet bullet bullet bullet$]\ $d$ ключей])), ((0, 1),))
  arrow^(+(k, v))
  #tree((((0, 2), []), ((-1.5, -1), [#ellipse(inset: 5pt)[$bullet bullet bullet$]\ $ceil((d + 1) / 2)$]), ((1.5, -1), [#ellipse(inset: 5pt)[$bullet bullet bullet$]\ $floor((d + 1) / 2)$])), ((0, 1), (0, 2)))
$]

Переполнение на уровне выше решается аналогично.
Переполнение в корне создаёт новый уровень.

=== Remove

#ellipse(inset: 5pt)[$bullet bullet times bullet$]

Если ключей $> alpha d$, то всё готово и закончено.
Если ключей ровно $alpha d$, то можно позаимствовать у соседа:

#align(center)[$
  #ellipse(inset: 5pt)[$bullet bullet bullet$] _(alpha d)
  arrow.l
  #ellipse(inset: 5pt)[$bullet bullet bullet bullet bullet$] _(>alpha d)
$]

Sharing — выравнивание размера.

Если у соседа также $alpha d$ ключей, то необходимо выполнить объединение.
Обе вершины объединяем в одну, так как $alpha < 1 / 2$.
Удаление ключа выше аналогично.

#align(center)[$
  #tree((((0, 2), []), ((-1.5, -1), [#ellipse(inset: 5pt)[$bullet times bullet$]\ $alpha d$]), ((1.5, -1), [#ellipse(inset: 5pt)[$bullet bullet bullet$]\ $alpha d$])), ((0, 1), (0, 2)))
  arrow^(-(k, v))_("fuse")
  #tree((((0, 2), []), ((0, -1), [#ellipse(inset: 5pt)[$bullet bullet bullet bullet bullet$]\ $2 alpha d - 1$])), ((0, 1),))
$]

B-деревья используются в базах данных, например BDB (Berkeley).
