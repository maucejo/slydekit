#import "../../src/slydekit.typ": *

#show: slydekit.with(
  title: "Slydekit",
  subtitle: "An example of a presentation template using Typst",
  author: "John Doe",
  date: "2024-06-01",
  institution: "Université de Typst",
  contact: "john.doe@univ.typst.fr",
  navigation-style: "minislide",
)

#title-slide

#tableofcontents

= First section <hide-toc>

#slide("Direct slide")[
  #lorem(10)
]

= Second section

== Another subsection

#lorem(10)

= Third section

== Yet another subsection

#lorem(10)
