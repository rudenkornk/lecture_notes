#let keep-sections(body) = {
  let sections = ()
  let current = []
  for child in body.children {
    if child.func() == heading and current != [] {
      sections.push(current)
      current = []
    }
    current += child
  }
  sections.push(current)
  for section in sections {
    let only-heading = section.children.all(child => (
      child.func() in (heading, parbreak) or child == [ ]
    ))
    block(width: 100%, breakable: false, sticky: only-heading, section)
  }
}
