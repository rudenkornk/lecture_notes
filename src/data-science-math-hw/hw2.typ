#import "@preview/cetz:0.4.2"


#show link: set text(fill: blue)
#show cite: set text(fill: blue)
#show ref: set text(fill: blue)

#let rank = math.op("rank")

#set page(
  paper: "a5",
  margin: (left: 1.5cm, right: 1.5cm, top: 1.0cm, bottom: 2.0cm),
  numbering: "1",
  number-align: center + bottom,
)
#set par(justify: true)

#let sidenote(body) = place(
  right,
  dx: 2cm,
  block(width: 3cm, text(size: 0.85em, fill: luma(100), rotate(
    90deg,
    reflow: false,
    body,
  ))),
)

#set text(
  size: 9pt,
  lang: "en",
)

#v(1.5em)


#set document(title: [Data science math HW 2])
#align(center, title())

= Problem 1

#let k4-graph = cetz.canvas(length: 0.5cm, {
  import cetz.draw: *

  let v1 = (-2, 2)
  let v2 = (2, 2)
  let v3 = (2, -2)
  let v4 = (-2, -2)

  set-style(stroke: (paint: black, thickness: 0.8pt))
  line(v1, v2)
  line(v1, v3)
  line(v1, v4)
  line(v2, v3)
  line(v2, v4)
  line(v3, v4)

  content((0, 2.35), $1$)
  content((-0.55, 1.0), $2$)
  content((-2.4, 0), $3$)
  content((2.4, 0), $4$)
  content((0.6, 1.0), $5$)
  content((0, -2.35), $6$)

  for (p, name) in ((v1, $1$), (v2, $2$), (v3, $3$), (v4, $4$)) {
    circle(p, radius: 0.50, fill: white, stroke: (thickness: 1pt))
    content(p, text(size: 11pt, name))
  }
})

#figure(k4-graph, caption: [])<graph>

== $E$ -- subspace

Consider linear combination of two arbitrary $E$ elements $z = alpha x + beta y$.\
If $alpha=0$ or $beta=0$, then $z in E$ ($z$ is either $0$, $x$, or $y$, all of which are in $E$).

If $alpha=beta=1$, then lets take a look at any of vertices (WLOG lets look at the $V_1$ vertex).\
$deg(V_1)$ in $x$ and $y$ could be either $0$ or $2$.
If either is $0$ then case is trivial (the second possibly-non-zero element just keeps its even number of edges).\
We need to check that resulting degree if both elements have $deg(V_1)=2$ also is even.
Looking at the @graph we can see only two possible subcases: either both edges from $x$ and $y$ overlap (and mutually "destroy" each other), or only one edge overlap, disappear, and the other two keep "existing".
Both subcases give even degree.

== Basis

Using method of intense gaze and some brute force we can see there is only two categories
of non-trivial $E$ elements: either triangles or quadrangles.

#sidenote([I know it's to vague, but I do not want to rigorously prove this ])

It is also easy to see that we can construct any element using triangles (_vertices_ notation) $x=1-2-4$, $y=2-3-4$ and $z=1-2-3$ (trust me, bro).

Thus the basis is three-dimensional, can be taken as
$
  x=vec(1, 0, 1, 0, 1, 0), y=vec(0, 0, 0, 1, 1, 1), z=vec(1, 1, 0, 1, 0, 0)
$

To make it to full basis, we can just add single-edge graphs like this one:
$
  t=vec(1, 0, 0, 0, 0, 0), g=vec(0, 1, 0, 0, 0, 0), h=vec(0, 0, 1, 0, 0, 0)
$

= Problem 2

== Case $U inter W$

These elements have equal rows and equal columns, i.e. all elements are equal.
Any element has the form of $alpha bb(1)$.
Space is unidimensional.

== Case $U + W$

$dim(U+W) = dim(U) + dim(W) - dim(U inter W) = n + m -1$

To describe this space lets find basis in $U inter W$ and then complete it to full basis separately in $U$ and $W$.
Trivially, this is just $bb(1)$, then $m-1$ matrices containing one non-zero homogeneous row, then $n-1$ matrices with one non-zero homogeneous column:
$
  mat(
    1, dots.h, 1;
    dots.v, dots.down, dots.v;
    1, dots.h, 1;
  ),
  mat(
    0, dots.h, 0;
    dots.v, dots.down, dots.v;
    1, dots.h, 1;
    dots.v, dots.down, dots.v;
    0, dots.h, 0;
  ) dots (m-1 "times"),
  mat(
    0, dots.h, 1, dots.h, 0;
    dots.v, dots.down, dots.v, dots.down, dots.v;
    0, dots.h, 1, dots.h, 0;
  ) dots (n-1 "times"),
$

= Problem 3

== Case $b$

Trivially coordinates $beta = vec(a_0, a_1, ..., a_n)$.

== Case $b'$

Consider $x=y+alpha$.
Then, $f(x) = a_0 + ... + a_n (y+alpha)^n = beta_0 + ... +beta_n y^n$.
Grouping same powers of $y$ on the left we get:
$ beta_i = sum_(k=i)^n a_k binom(k, i) alpha^(k-i) $

= Problem 4

$
  D = mat(
    (x_1 - x_1)^2, dots, (x_1-x_n)^2;
    (x_2 - x_1)^2, dots, (x_2-x_n)^2;
    dots, dots, dots;
    (x_n - x_1)^2, dots, (x_n-x_n)^2;
  )=
  mat(
    x_1^2 -2x_1x_1 + x_1^2, dots, x_1^2 -2x_1x_n + x_n^2;
    x_2^2 -2x_2x_1 + x_1^2, dots, x_2^2 -2x_2x_n + x_n^2;
    dots, dots, dots;
    x_n^2 -2x_n x_1 + x_1^2, dots, x_n^2 -2x_n x_n + x_n^2;
  ) = \
  mat(
    x_1^2, dots, x_1^2;
    x_2^2, dots, x_2^2;
    dots, dots, dots;
    x_n^2, dots, x_n^2;
  )+
  mat(
    x_1^2, dots, x_n^2;
    x_1^2, dots, x_n^2;
    dots, dots, dots;
    x_1^2, dots, x_n^2;
  ) -2 vec(x_1, dots, x_n) mat(x_1, ..., x_n) =\
  A + B -2C C^T
$
#sidenote([I think this was on some old variant of shad exam... ])

$
  rank(D) = rank(A + B -2C C^T) <=\
  rank(A) + rank(B) + rank(C C^T) <= \
  rank(A) + rank(B) + min(rank(C), rank(C^T)) =\
  1 + 1 + 1 = 3
$

On the other hand, $rank(D) >= 3$.
We prove this by computing determinant of the top left $3 times 3$ submatrix:
$
  det mat(
    0, (x_1 - x_2)^2, (x_1-x_3)^2;
    (x_2 - x_1)^2, 0, (x_2-x_3)^2;
    (x_3 - x_1)^2, (x_3-x_2)^2, 0;
  ) =\
  -(x_1-x_2)^2(-1)(x_2-x_3)^2(x_3-x_1)^2 + (x_1-x_3)^2(x_2-x_1)^2(x_3-x_2)^2 =\
  2(x_1-x_2)^2(x_2-x_3)^2(x_3-x_1)^2 != 0
$

= Problem 5

With best intentions, I do not want to compute eigenvectors and eigenvalues by hand (I had enough computing Jordan form in the previous HW...).
Using calculator we get:
$
  P_A (lambda) = -lambda^3 + lambda^2 + lambda - 1 = -(lambda - 1)^2 (lambda + 1)
$
Eigenvectors:
$
  vec(2, 1, 0), vec(-1, 0, 1) "for" lambda_1 = 1 \
  vec(3, 5, 6) "for" lambda_2 = -1 \
$
Thus, geometric multiplicity matches algebraic one and matrix is diagonalizable, and
$
  rank(A-lambda E) = cases(
    1 "if" lambda = 1,
    2 "if" lambda = -1,
    3 "if" lambda in.not {1, -1},
  )
$
(using the fact that $rank(A-lambda E) = dim(V) - dim ker(A-lambda E)$).

Transition matrix and inverse
$
  P = mat(
    2, -1, 3;
    1, 0, 5;
    0, 1, 6;
  ),
  P^(-1) = mat(
    5, -9, 5;
    6, -12, 7;
    -1, 2, -1;
  )
$

$
  A^n = P mat(
    1, 0, 0;
    0, 1, 0;
    0, 0, -1;
  )^n
  P^(-1) = P mat(
    1, 0, 0;
    0, 1, 0;
    0, 0, (-1)^n;
  )
  P^(-1) =\
  cases(
    E "if" n "is even",
    mat(
      7, -12, 6;
      10, -19, 10;
      12, -24, 13;
    ) "if" n "is odd"
  )
$

= Problem 6

== Case $"finite" X => "finite" F$

Let's enumerate all elements in $X$ and then construct a finite basis in $F$ like this:
$
  g_(i)(x) = cases(
    1 "if" x = x_i,
    0 "otherwise",
  )
$

Using that, any function $f in F$ can be expressed in this basis:
$
  f(x) = k_1 g_1 + ... + k_n g_n, "where" k_i = f(x_i)
$

$dim F = n$, where $n$ is number of elements in $X$.

== Case $"finite" F => "finite" X$

Let's just show that it is not possible to construct finite basis if $X$ is infinite.
Indeed, consider an infinite sequence of elements from $X$: $x_1, x_2, ...$ and a set of functions,
similar to the previous case:
$
  g_(i)(x) = cases(
    1 "if" x = x_i,
    0 "otherwise",
  )
$

Obviously we got and infinite sequence of linearly independent functions, thus $dim F$ is infinite.

= Problem 7

Let's compute how much elements in our vector space.
Each element can be expressed as $x = alpha_1 v_1 + ... + alpha_n v_n$, where ${v_i}$ is the vector space basis,
and $alpha_i$ are field elements.
Each coordinate can take one of $q$ values, thus we get $q^n$ total possible vectors.

Any proper subspace has dimension $< n$ and thus no more than $q^(n-1)$ unique vectors.
Thus, if we need exactly $q$ proper non-intersecting subspaces to get $q dot q^(n-1) = q^n$ elements in original space.\
The problem is that all of these spaces have one intersecting element -- a zero, which means that in any case we get strictly less than $q^n$ elements from $q$ proper subspaces.
Thus we need at least $q+1$ of them.
