#let ink = rgb("203246")
#let accent = rgb("16697a")
#let muted = rgb("596977")
#let pale = rgb("edf4f5")

#let setup(body) = {
  set document(
    title: "АКОС — краткий конспект лекций",
    author: "Конспект по материалам курса АКОС, осень 2026",
  )
  set page(
    paper: "a4",
    margin: (top: 17mm, bottom: 17mm, left: 19mm, right: 19mm),
    header: text(
      size: 8pt,
      fill: muted,
    )[
      АКОС #h(1fr) Архитектура компьютера и операционные системы
      #linebreak()
      Сгенерировано ИИ · Не проверено автором.
    ],
    footer: context {
      line(length: 100%, stroke: 0.4pt + rgb("cbd8dc"))
      v(2mm)
      text(
        size: 8pt,
        fill: muted,
      )[Осень 2026 · Краткий конспект #h(1fr) #counter(page).display()]
    },
  )
  set text(font: "PT Sans", size: 10.5pt, lang: "ru", fill: ink)
  set par(justify: false, leading: 0.5em, spacing: 0.6em)
  set heading(numbering: none)
  show heading.where(level: 1): set text(size: 22pt, fill: ink, weight: "bold")
  show heading.where(level: 2): set text(
    size: 14pt,
    fill: accent,
    weight: "bold",
  )
  show heading.where(level: 3): set text(
    size: 11pt,
    fill: accent,
    weight: "bold",
  )
  show heading: set block(above: 0.9em, below: 0.45em)
  set list(indent: 11pt, body-indent: 4pt, spacing: 0.35em)
  set enum(indent: 12pt, body-indent: 4pt, spacing: 0.35em)
  show raw: set text(font: "DejaVu Sans Mono", size: 8.7pt)
  show raw.where(block: true): it => block(
    width: 100%,
    fill: pale,
    inset: 8pt,
    radius: 3pt,
    it,
  )
  set table(stroke: 0.4pt + rgb("cbd8dc"), inset: 5pt)
  set figure(gap: 4pt)
  show figure.caption: set text(size: 8.5pt, fill: muted)
  body
}

#let chapter(id, date, title, summary) = {
  pagebreak(weak: true)
  text(size: 9pt, weight: "bold", fill: accent)[ЛЕКЦИЯ #id #h(1fr) #date]
  heading(level: 1, title)
  context [#metadata((
    id: id,
    edge: "start",
    page: counter(page).get().first(),
  )) <lecture-boundary>]
  block(width: 100%, fill: pale, inset: 9pt, radius: 3pt, summary)
}

#let finish(id) = context {
  [#metadata((
    id: id,
    edge: "end",
    page: counter(page).get().first(),
  )) <lecture-boundary>]
}

#let nextpage(title) = {
  pagebreak()
  text(size: 9pt, weight: "bold", fill: muted)[#title · ПРОДОЛЖЕНИЕ]
  v(2mm)
}

#let takeaway(body) = block(
  width: 100%,
  inset: (left: 9pt, right: 9pt, top: 6pt, bottom: 6pt),
  stroke: (left: 2pt + accent),
  fill: pale,
  body,
)

#let pic(name, caption, width: 100%) = figure(
  image("assets/" + name + ".png", width: width),
  caption: caption,
  numbering: none,
)

#let source(body) = block[
  #text(size: 8pt, fill: muted)[*Источники:* #body]
]

#let gridtable(columns, ..cells) = {
  set text(size: 9.5pt)
  table(columns: columns, ..cells.pos())
}

#let flow(..steps) = block(width: 100%, fill: pale, inset: 9pt, radius: 3pt)[
  #align(center)[#steps.pos().join([ #text(fill: accent)[→] ])]
]
