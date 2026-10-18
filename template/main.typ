#import "@preview/shine-notes:0.1.0": book, cover-page, contents-page, mainmatter

#let book-title = "A New Book"
#let book-author = "Your Name"

#show: book.with(title: book-title, author: book-author)

#cover-page(title: book-title, author: book-author)
#contents-page

#mainmatter[
  #include "content/chapters/introduction/main.typ"
  #bibliography("content/meta/references.bib")
]
