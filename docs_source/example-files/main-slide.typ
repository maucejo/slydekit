#import "../../src/slydekit.typ": *

#show: slydekit.with(
  title: "Slydekit",
  subtitle: "An example of a presentation template using Typst",
  author: "John Doe",
  date: "2024-06-01",
  institution: "Université de Typst",
  contact: "john.doe@univ.typst.fr",
  // navigation-style: "minislide",
)


#let my-focus-slide(..args) = {
  set align(center + horizon)
  set text(fill: white, size: 5em)
  set page(header: none, footer: none, fill: rgb("#5E8B65"))

  slide(..args)

  // Freeze the slide number to avoid incrementing it for focus slides
  sk-states.slide-number.update(n => n - 1)
}


#my-focus-slide[
  *Heigh* #pause *ho!*
]

// == Test

// efefe

// #tableofcontents

// = First section

// == A subsection

// #lorem(10)

// = Second section

// == Another subsection

// #lorem(10)

// #show: appendix

// = Appendix <hide-toc>

// == A subsection in the appendix

// #lorem(10)