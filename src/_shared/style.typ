#let style(body) = {
  show link: set text(fill: blue)
  show cite: set text(fill: blue)
  show ref: set text(fill: blue)

  set page(
    paper: "a5",
    margin: (left: 1.5cm, right: 1.5cm, top: 1.0cm, bottom: 2.0cm),
    numbering: "1",
    number-align: center + bottom,
  )
  set par(justify: true)
  set text(size: 9pt, lang: "en")

  body
}
