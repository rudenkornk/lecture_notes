#import "../_shared/style.typ": definition
#import "diagrams.typ": cells, tree
#import "@preview/cetz:0.4.2"

#let circled(body) = circle(inset: 1pt, stroke: 0.5pt, body)

#let sort-state(
  values,
  boundary,
  selected: none,
  target: none,
  swap: false,
) = box(
  baseline: 50%,
  cetz.canvas(length: 0.6cm, {
    import cetz.draw: *
    for (i, value) in values.enumerate() {
      content((i, 0), [#value])
    }
    let x = boundary - 0.5
    let tip = if boundary == values.len() { -0.15 } else { 0.15 }
    line((x + tip, 0.3), (x, 0.3), (x, -0.3), (x + tip, -0.3))
    if selected != none {
      circle((selected, 0), radius: 0.27)
      line((selected, -0.7), (target, -0.7))
      line((selected, -0.7), (selected, -0.35), mark: (
        end: if swap { ">" } else { none },
      ))
      line((target, -0.7), (target, -0.35), mark: (end: ">"))
    }
  }),
)

#let ramp(width) = cetz.canvas(length: 0.5cm, {
  import cetz.draw: *
  line((0, 0), (width, 0), (width, 0.6), close: true)
})

== Квадратичные сортировки

=== Сортировка выбором (SelectionSort)

$
  #sort-state((5, 3, 4, 1, 2), 0, selected: 3, target: 0, swap: true)
  arrow #sort-state((1, 3, 4, 5, 2), 1, selected: 4, target: 1, swap: true)
  arrow #sort-state((1, 2, 4, 5, 3), 2, selected: 4, target: 2, swap: true)
$
$
  arrow #sort-state((1, 2, 3, 5, 4), 3, selected: 4, target: 3, swap: true)
  arrow #sort-state((1, 2, 3, 4, 5), 4).
$

=== Сортировка вставками (InsertionSort)

$
  #sort-state((5, 3, 4, 1, 2), 0, selected: 0, target: -0.5)
  arrow #sort-state((5, 3, 4, 1, 2), 1, selected: 1, target: -0.5)
  arrow #sort-state((3, 5, 4, 1, 2), 2, selected: 2, target: 0.5)
$
$
  arrow #sort-state((3, 4, 5, 1, 2), 3, selected: 3, target: -0.5)
  arrow #sort-state((1, 3, 4, 5, 2), 4, selected: 4, target: 0.5)
  arrow #sort-state((1, 2, 3, 4, 5), 5).
$

=== Пузырьковая сортировка (BubbleSort)

$
  5 quad 3 quad underbrace(4 quad underbrace(1 quad 2, <), >)
  arrow 5 quad underbrace(3 quad underbrace(1 quad 4, >), >) quad 2
  arrow underbrace(5 quad underbrace(1 quad 3, <), >) quad 4 quad 2
$
$
  arrow 1 quad 5 quad underbrace(3 quad underbrace(4 quad 2, >), >)
  arrow 1 quad underbrace(5 quad underbrace(3 quad 2, >), >) quad 4
  arrow 1 quad 5 quad 2 quad underbrace(3 quad 4, <)
$
$
  arrow underbrace(1 quad 2, <) quad underbrace(5 quad underbrace(3 quad 4, <), >)
  arrow 1 quad underbrace(2 quad underbrace(3 quad 5, <), <) quad 4
  arrow 1 quad 2 quad 3 quad 4 quad 5.
$

#block(stroke: (paint: rgb("#9b2028"), dash: "dashed"), inset: 8pt)[
  === Dutch flag sort (обобщение Lomuto)

  Есть $f(x): X -> \{0, 1, dots, k\}$.
  Задача: отсортировать элементы по $k$ «классам».

  #align(center, image("images/dutch-flag.jpg", width: 85mm))

  + Составить массив $C[k] = \{\# x | f(x) = i\}$ — предподсчитываем границы множеств $i_s$.
  + $j_0 = i_0, dots, j_(k - 1) = i_(k - 1)$.
  + В цикле:
    $ cases(A_(j_0) = s != 0, "swap"(A_(j_0), A_(j_s)), ++j_s). $

  Время: $O(n + k)$. Память: $O(k)$.
]

== Сортировка двоичной кучей (HeapSort)

(Пирамидальная сортировка.)

+ Строим кучу на массиве, время $O(n)$.
+ $n$ раз извлекаем максимум, время $O(n log n)$.

Итого: время $O(n log n)$, память $O(1)$.

== Сортировка слиянием (MergeSort)

+ Разбить массив на 2 части.
+ Рекурсивно отсортировать каждую часть.
+ Слить отсортированные части.

#grid(
  columns: (1fr, 1fr),
  [Top Down $arrow.bl$],
  [Нерекурсивная Bottom Up $arrow.t$
    #tree(
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
    )],
)

Итого: время $O(n log n)$, память $O(n)$.

== Быстрая сортировка (QuickSort)

(Сортировка Хоара.)

1. Выбираем середину — pivot.

#block(stroke: (left: 0.5pt), inset: (left: 8pt))[
  Функция Partition:

  2. #cells[][][][][]
    $i arrow.r quad quad arrow.l j$\
    Двигаем $i$, $j$ до тех пор, пока оба не будут указывать на элементы: $a[i] > "pivot"$, $a[j] < "pivot"$.
  3. Меняем $a[i]$ и $a[j]$ местами.
  4. Повторяем шаги 2, 3, пока $i != j$.
]

5. Переходим к шагу 1 для подмассивов: $a[i] < "pivot"$ и $a[i] > "pivot"$.

Время работы $O(n^2)$, но в среднем $O(n log n)$.
Память $O(1)$.

#definition[$k$-ая порядковая статистика] — элемент, который окажется на $k$-ой позиции после сортировки массива.

Алгоритм поиска методом «Разделяй и властвуй»:
+ Выбираем Pivot.
+ Запускаем Partition.
+ Пусть $p$ — позиция Pivot-а (после шага 2).
  - $p = k =>$ ответ $p$.
  - $p > k =>$ переходим к шагу 1 для подмассива $a[i] < "Pivot"$.
  - $p < k =>$ переходим к шагу 1 для подмассива $a[i] > "Pivot"$.

Время $O(n^2)$, но в среднем $O(n)$.
Память $O(1)$.

#block(stroke: 0.5pt, inset: 8pt)[
  Алгоритм за гарантированное время поиска порядковой статистики — $O(n)$.
  «Медиана медиан».
  #align(right, table(
    columns: 5,
    inset: 3pt,
    [], [], [], [], [],
    [], [], [], [], [],
    [], [], [$times$], [], [],
    [], [], [], [], [],
  ))
]

#definition[Сортировка стабильная] — если сохраняет относительный порядок следования равных элементов.

#definition[Сортировка локальная] — если не требует дополнительной памяти.

== Сортировка подсчётом 1 (CountingSort)

Есть $A[]$: $forall i => 0 <= A[i] <= K$.

+ Создадим массив $C[K]$ и запишем в $C[i]$ количество вхождений элемента $i$ в $A[]$.
+ Выведем числа $i$, начиная с 0, по $C[i]$ раз.

Время работы $O(n)$, память $O(K + n)$.

== Сортировка подсчётом 2 (стабильная)

Есть $A[]$: $forall i => 0 <= A[i] <= K$.

+ Создадим $C[K]$ и запишем количество вхождений элемента $e$ в $A[]$ в $C[e]$.
+ Пересчитаем $C$: в $C[e]$ запишем позицию, с которой будут начинаться элементы «$e$»
  в отсортированном массиве: $C[e + 1] = C[e + 1] + C[e]$.
+ Создадим $B[N]$. Переберём $A[]$:
  будем записывать $A[i]$ в $B[C[A[i]]]$, а $C[A[i]]$ увеличивать на 1.
+ Скопируем $B$ в $A$.

Время работы $O(n + K)$, память $O(n + K)$.

== Поразрядная сортировка LSD

LSD = Least Significant Digit.

$
  #math.mat(delim: none, ($3$, $5$, circled[$9$]), ($3$, $4$, $7$), ($4$, $1$, $7$))
  arrow mat(delim: #none, 3, #circled[$4$], 7; 4, 1, 7; 3, 5, 9)
  arrow mat(delim: #none, #circled[$4$], 1, 7; 3, 4, 7; 3, 5, 9)
  arrow mat(delim: #none, 3, 4, 7; 3, 5, 9; 4, 1, 7).
$

Важно, что сортировка конкретного разряда стабильна.

Время работы $O(underbrace(r, "количество разрядов")
  (n + underbrace(K, "размер алфавита")))$, память $O(n + K)$.

- Сортировать лучше побайтово (через CountingSort).

== Поразрядная сортировка MSD (Radix sort)

MSD = Most Significant Digit.

$
  underbrace(mat(delim: #none, 2, 3, 7; 3, 1, 8; 2, 1, 6; 4, 6, 2; 2, 1, 1; 4, 6, 0), arrow.t)
  arrow underbrace(mat(delim: #none, 2, 3, 7; 2, 1, 6; 2, 1, 1; 3, 1, 8; 4, 6, 2; 4, 6, 0), arrow.t)
  arrow underbrace(mat(delim: #none, 2, 1, 6; 2, 1, 1; 2, 3, 7; 3, 1, 8; 4, 6, 2; 4, 6, 0), arrow.t)
  arrow mat(delim: #none, 2, 1, 1; 2, 1, 6; 2, 3, 7; 3, 1, 8; 4, 6, 0; 4, 6, 2).
$

Время работы $O(r dot n dot K)$, память $O(n + r K)$.

=== Binary QuickSort

Время работы $underbrace(O(r dot n), arrow.b O(n log_2 n))$, память $O(1)$.

Нестабильная, локальная.

=== Partition (в QuickSort)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  [
    ==== Разбиение Хоара («оригинал»)

    #image("images/partition-hoare.jpg", width: 80mm)

    $A_i < lambda => ++i$\
    $A_i >= lambda => "stop"$\
    $A_j > lambda => j--$\
    $A_j <= lambda => "stop"$\
    $"swap"(A_i, A_j); ++i; --j$

    Стоп по условию «неправильного порядка» $i$, $j$.
  ],
  [
    ==== Разбиение Lomuto

    #image("images/partition-lomuto.jpg", width: 80mm)

    init: $i = j = 0$\
    stop: $j = n$\
    step: $A_j >= lambda => ++j$\
    $A_j < lambda => cases("swap"(A_j, A_i), ++i ";" ++j)$
  ],
)

== Сравнение сортировок

#table(
  columns: (1.3fr, 1fr, 1fr, 1fr, 0.9fr, 1.1fr, 1.2fr),
  inset: 5pt,
  table.header(
    [Алгоритм],
    [В лучшем],
    [В среднем],
    [В худшем],
    [Память],
    [Стабильность],
    [Метод],
  ),
  [QuickSort], [$n log n$], [$n log n$], [$n^2$], [1], [−], [Partitioning],
  [MergeSort], [$n log n$], [$n log n$], [$n log n$], [$n$], [+], [Merging],
  [In-place MergeSort], [], [], [$n log^2 n$], [1], [+], [Merging],
  [HeapSort], [$n log n$], [$n log n$], [$n log n$], [1], [−], [Selection],
  [InsertionSort], [$n$], [$n^2$], [$n^2$], [1], [+], [Insertion],
  [SelectionSort], [$n^2$], [$n^2$], [$n^2$], [1], [−], [Selection],
  [TimSort], [$n$], [$n log n$], [$n log n$], [$n$], [+], [Insertion & Merging],
  [LSD], [$r(n + k)$], [$r(n + k)$], [$r(n + k)$], [$k + n$], [+], [Radix],
  [MSD], [$n log n$], [$n log n$], [$r n k$], [$r k + n$], [+], [Radix],
  [Binary QuickSort], [$n log n$], [$n log n$], [$r n$], [1], [−], [Radix],
)

=== Заметки про некоторые сортировки

1. Слияние в MergeSort — ключевой шаг.
  Он должен работать быстро в типичных случаях:
  $#ramp(1) + #ramp(1) = #ramp(2)$.
  В особенности, когда идёт слияние массивов разных размеров:
  $underbrace(#ramp(2), n) + underbrace(#ramp(0.7), m) = #ramp(2.7)$.
  Для этого используется ExpSearch.

  Для каждого элемента из $underbrace(#ramp(0.7), m)$ ищем индекс в $underbrace(#ramp(2), n)$:
  $\{i, i + 1, i + 2, i + 4, dots\}$ —
  «экспоненциальный» поиск индекса подходящей вставки.
  Далее — точный бинарный поиск внутри диапазона.

  #align(center, cetz.canvas(length: 0.65cm, {
    import cetz.draw: *
    line((0, 0), (5, 0), (5, 0.8), close: true)
    for (x, label) in ((0, [1]), (0.5, [2]), (1.5, [4]), (3, [$n$])) {
      line((x, -0.1), (x, x * 0.16))
      content((x, -0.4), label)
    }
    line((2, 0), (2, 0.32), stroke: rgb("#9b2028"))
    line((4, 0), (4, 0.64), stroke: rgb("#9b2028"))
    line((6, 0), (7, 0), (7, 0.6), close: true)
    content((5.5, 0.3), [+])
    content((6, -0.3), [$i$])
    content((6.5, -0.3), [$j$])
    content((6.5, -0.8), [$m$])
  }))

  Время слияния — $O(M log(N / M))$, что асимптотически сходится с прежним при $M = 1$ ($log n$)
  и $M = N$ ($O(M + N)$).

2. В QuickSort при реализации одну из рекурсий нужно заменить на while (ручной tail call elimination).
  Оставшуюся рекурсию нужно вызвать для меньшего массива.
  Маленькие массивы $=>$ InsertionSort.

  #block(stroke: (top: 0.5pt), inset: 6pt)[
    Если QuickSort «обнаруживает» в процессе, что уже не укладывается в $n log n$ $=>$ fallback на HeapSort.
  ]
