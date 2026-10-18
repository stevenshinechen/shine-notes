// Shared document template and front-matter helpers.
#import "notes-style.typ": figure-base, statement-counter

#let book(body, title: "Book Title", author: "Author Name") = {
  set document(
    title: title,
    author: author,
  )
  set page(
    margin: (x: 1.3in, top: 1.6in, bottom: 1.6in),
  )
  set text(font: "New Computer Modern", size: 11pt)
  set par(justify: true)
  set heading(numbering: "1.1.1")
  show math.equation: set text(font: "New Computer Modern Math")
  set math.equation(numbering: n => context {
    let chapter = counter(heading).get().at(0)
    [ (#chapter.#n) ]
  })
  set figure(numbering: n => context {
    let chapter = counter(heading).get().at(0)
    [#chapter.#(n - figure-base.get())]
  })
  show figure.caption: set align(left)

  let hidden-equation-label = counter("hidden-equation-label")
  show math.equation: it => {
    if it.block and not it.has("label") [
      #counter(math.equation).update(v => v - 1)
      #hidden-equation-label.step()
      #math.equation(it.body, block: true, numbering: none)#label(
        "hidden-equation-" + str(hidden-equation-label.get().first()),
      )
    ] else {
      it
    }
  }

  // Reset chapter-scoped numbering from the chapter heading itself.
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure).update(0)
    statement-counter.update(0)
    figure-base.update(0)
    pagebreak(weak: true)
    v(30mm)
    context {
      let chapter = counter(heading).get().at(0)
      if it.numbering == none {
        text(size: 24pt, weight: "bold")[#it.body]
      } else {
        text(size: 24pt, weight: "bold")[Chapter #chapter]
        v(18pt)
        text(size: 24pt, weight: "bold")[#it.body]
      }
    }
    v(18pt)
  }

  show heading.where(level: 2): it => block(
    breakable: false,
    above: 7.5mm,
    below: 4.5mm,
  )[
    #set text(size: 14pt, weight: "bold")
    #set par(justify: false)
    #counter(heading).display()#h(1em)#it.body
  ]
  show heading.where(level: 3): it => block(
    breakable: false,
    above: 6mm,
    below: 4.5mm,
  )[
    #set text(size: 12pt, weight: "bold")
    #set par(justify: false)
    #counter(heading).display()#h(1em)#it.body
  ]

  body
}

#let cover-page(title: "Book Title", author: "Author Name", date: datetime.today()) = [
  #v(63mm)
  #align(center)[
    #text(size: 21pt, weight: "bold")[#title]
    #v(18pt)
    #text(size: 14pt)[#author]
    #v(18pt)
    #text(size: 12pt)[#date.display("[month repr:long] [day], [year]")]
  ]
  #pagebreak()
]

#let contents-page = {
  set page(
    numbering: "i",
    footer: context [#align(center)[#counter(page).display("i")]],
  )
  align(center)[#text(size: 25pt, weight: "bold")[Contents]]
  v(18pt)
  show outline.entry: set text(size: 11pt)
  show outline.entry.where(level: 1): set text(weight: "bold")
  show outline.entry.where(level: 1): set block(above: 1.2em)
  show outline.entry.where(level: 2): set block(above: 0.4em)
  outline(title: none, depth: 2)
  pagebreak()
}

#let mainmatter(body) = {
  set page(
    numbering: "1",
    footer: context [#align(center)[#counter(page).display("1")]],
  )
  counter(page).update(1)
  body
}
