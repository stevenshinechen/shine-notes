// Shared callouts for definitions, theorems, examples, and remarks.
#let statement-counter = counter("statement")
#let figure-base = state("figure-base", 0)
#let book-colors = (
  curveblue: rgb("2F6FDB"),
  tanred: rgb("E4572E"),
  tealone: rgb("2A9D8F"),
  gray: rgb("808080"),
  violet: rgb("8000FF"),
)

#let statement(kind, body) = block(
  width: 100%,
  fill: luma(95%),
  stroke: 0.15mm + luma(80%),
  inset: 3mm,
  radius: 0.65mm,
  breakable: true,
  above: 10pt,
  below: 10pt,
  align(left)[
    #context {
      statement-counter.step()
      strong[#kind #counter(heading).get().at(0).#statement-counter.display("1")]
    }.
    #h(0.2em)#body
  ],
)

#let definition(body) = statement("Definition", body)
#let theorem(body) = statement("Theorem", body)
#let example(body) = statement("Example", body)
#let remark(body) = statement("Remark", body)

#let proof(body) = block(
  inset: (left: 4mm, y: 1mm),
  stroke: (left: 0.3mm + luma(60%)),
  above: 10pt,
  below: 10pt,
)[
  _Proof._ #h(0.2em)#body #h(1fr) $square$
]
