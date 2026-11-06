#let accent = rgb("#284b63")

#let definition(body) = text(weight: "bold", body)

#let style(body) = {
  show heading: set text(
    fill: black,
    weight: "bold",
    size: 9pt,
    hyphenate: false,
  )
  show heading: set block(above: 1.1em, below: 0.5em, sticky: true)
  show heading.where(level: 1): set text(fill: accent, size: 12pt)
  show heading.where(level: 1): set block(above: 0.8em, below: 1em)
  show heading.where(level: 2): set text(fill: accent, size: 10.5pt)
  show heading.where(level: 2): set block(above: 1.5em, below: 0.65em)
  show math.equation: set text(font: ("Latin Modern Math", "CMU Serif"))
  show math.equation.where(block: true): set block(above: 0.6em, below: 0.6em)
  show grid: it => block(breakable: false, it)
  show link: set text(fill: accent)
  show cite: set text(fill: accent)
  show ref: set text(fill: accent)

  set page(
    paper: "a5",
    margin: 12mm,
    numbering: "1",
    number-align: center + bottom,
  )
  set par(justify: true, leading: 0.58em, spacing: 0.6em)
  set text(font: "CMU Serif", size: 9pt, lang: "en")

  body
}
