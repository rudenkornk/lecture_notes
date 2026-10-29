#import "@preview/cetz:0.4.2"

#let subtree(label) = cetz.canvas(length: 0.6cm, {
  import cetz.draw: *
  line((0, 0), (-0.7, -1), (0.7, -1), close: true, stroke: 0.65pt)
  content((0, -0.72), label)
})

#let tree(nodes, edges, unit: 0.65cm, y-scale: 1) = box(
  baseline: 50%,
  cetz.canvas(
    length: unit,
    {
      import cetz.draw: *
      set-style(stroke: 0.65pt)
      let nodes = nodes.map(((pos, label)) => (
        (pos.at(0), pos.at(1) * y-scale),
        label,
      ))
      for (a, b) in edges {
        line(nodes.at(a).at(0), nodes.at(b).at(0))
      }
      for (pos, label) in nodes {
        if label == [] { continue }
        content(
          pos,
          label,
          frame: "rect",
          fill: white,
          stroke: none,
          padding: 0.08,
        )
      }
    },
  ),
)

#let cells(..items) = table(
  columns: items.pos().len(),
  inset: (x: 5pt, y: 3pt),
  stroke: 0.5pt,
  align: center,
  ..items.pos(),
)
