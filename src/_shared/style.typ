#let definition(body) = text(fill: rgb("#176b37"), weight: "bold", body)

#let style(body) = {
  show heading: set text(fill: rgb("#9b2028"), weight: "bold")
  show math.equation: set text(font: "New Computer Modern Math")
  show link: set text(fill: blue)
  show cite: set text(fill: blue)
  show ref: set text(fill: blue)

  set page(
    paper: "a4",
    margin: 10mm,
    numbering: "1",
    number-align: center + bottom,
  )
  set par(justify: true)
  set text(font: "New Computer Modern", size: 10pt, lang: "en")

  body
}
