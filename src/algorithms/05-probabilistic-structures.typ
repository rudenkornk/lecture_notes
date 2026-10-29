#import "../_shared/style.typ": definition
#import "diagrams.typ": cells
#import "@preview/cetz:0.4.2"

== Множество с потерями. Lossy set

Insert($k$).\
Contains($k$): True — $k in^? A$, False — $k in.not A$.

Если Contains($k$) = false, то ключа точно нет.\
Если Contains($k$) = true, то, наверное, ключ есть.

=== Фильтр Блума (Bloom filter)

$ B = #cells[0][0][][][][][][][][0]^(N - 1). $

Изначально все нули.
Пусть имеется $t$ хеш-функций $h_1(k), dots, h_(t)(k)$.
Они задают индексы бит для ключей, которые нужно проверять.

$ "Contains"(k) = and.big_(i = 1)^t B[h_(i)(k)]. $

==== Вероятность ошибки
Пусть мы вставили ключи $k_1, dots, k_m$.
Тогда в массив $B$ попало $approx t m$ бит.
Какова вероятность, что случайные $t$ бит подняты?

#align(center)[$overbrace(#rect(width: 5cm, height: 5mm), 0 #h(4cm) (N - 1))$\
  $arrow.t quad quad quad arrow.t$\ $t m quad quad quad t$]

Точнее: вероятность того, что в случайном бите 1, — это $1 - P[B[i] = 0]$,
то есть 1 − вероятность того, что там 0.

Вероятность того, что за $t m$ попыток туда никто не записал:
$ (1 - 1 / N)^(t m). $

$ => P_"err" = (1 - (1 - 1 / N)^(t m))^t approx (1 - e^(-t m / N))^t. $

== Lossy map. Bloomier filter

Допустим, нужно отобразить $f: K -> \{0, 1\}$.

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  cetz.canvas(length: 0.65cm, {
    import cetz.draw: *
    rect((0, 0), (6, 3.2))
    content((-0.2, 3.5), [$K$])
    circle((1.5, 1.7), radius: (1, 1.2))
    circle((4.5, 1.7), radius: (1, 1.2))
    content((1.5, 2.5), [0])
    content((4.5, 2.5), [1])
    line((1.5, 0.5), (1, -0.5), mark: (end: ">"))
    line((4.5, 0.5), (5, -0.5), mark: (end: ">"))
    content((1, -0.8), [0])
    content((5, -0.8), [1])
    content((3, -1.5), [Фильтры Блума для 0 и 1])
  }),
  [Get($k$):\
    $arrow.tr "null"$ — функция не определена.\
    $arrow.br v$ — функция не определена либо определена и значение правильное.],
)

#table(
  columns: (auto, auto, 1fr),
  stroke: none,
  column-gutter: 1em,
  [$B_0$], [$B_1$], [],
  [0], [0], [$arrow "null"$],
  [0], [1], [$arrow 1$],
  [1], [0], [$arrow 0$],
  [1], [1], [$arrow$ Коллизия; для таких храним список правильных ответов.],
)

== Задача set reconciliation. Invertible Bloom Filter

Имеются два датацентра, хранящие два почти одинаковых множества числовых ключей $A$ и $B$.
Требуется синхронизировать их за время/память обмена $O(abs(A triangle B))$
(то есть $o(abs(A) + abs(B))$).

#align(center, cetz.canvas(length: 0.65cm, {
  import cetz.draw: *
  circle((0, 2), radius: (1.1, 0.6))
  circle((4, 2), radius: (1.1, 0.6))
  content((0, 2), [ДЦ A])
  content((4, 2), [ДЦ B])
  line((1.2, 2.2), (2.8, 2.2), mark: (end: ">"))
  line((2.8, 1.8), (1.2, 1.8), mark: (end: ">"))
  content((2, 2.6), [link])
  circle((1, -0.2), radius: (1.5, 0.7))
  circle((2.5, -0.2), radius: (1.5, 0.7))
  content((0.1, -0.2), [▧])
  content((3.4, -0.2), [▧])
  content((0.7, -1.1), [$A$])
  content((2.8, -1.1), [$B$])
  line((0, 1.4), (0.7, 0.5))
  line((4, 1.4), (2.8, 0.5))
}))

Строим Invertible Bloom Filter (IBF) размера $m$:
+ Выбирается $k$ хеш-функций.
+ Используется counting-вариант (считаем число попаданий в бит).
+ Храним сумму ключей и сумму подписей $H$ (SHA-1 и тому подобное).

Каждый датацентр передаёт свой фильтр другому и вычисляет
$D = "IBF"(A) - "IBF"(B)$, который содержит в силу линейности только информацию о $A triangle B$.

#align(center, table(
  columns: (auto, auto, auto, auto, auto, auto, auto),
  stroke: 0.5pt,
  inset: 6pt,
  [$sum H("key")$], [], [], [], [], [], [],
  [$sum "key"$], [], [], [], [], [], [],
  [count], [], [], [], [], [], [],
  table.hline(stroke: none),
  [], [1], [2], [3], [4], [$dots$], [$m$],
))
#align(center)[IBF]

Восстановление:
+ Находим ячейку с $"count" = 1$ и $H("key") = H("key")$.
+ Делаем peeling — запоминаем её и удаляем из фильтра. Повторяем.

Данные и размеры $A triangle B$.
