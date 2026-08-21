#import "../../src/slydekit.typ": *

#let my-theme = (
  theme: fancy.theme,
  toc: fancy.toc,
)


#show: slydekit.with(
  title: "Slydekit",
  subtitle: "An example of a presentation template using Typst",
  author: "John Doe",
  date: "2024-06-01",
  institution: "Université de Typst",
  contact: "john.doe@univ.typst.fr",
  theme: my-theme,
  title-logo: (image("../../src/resources/images/slydekit-full.svg", height: 2.5cm),),
  slide-logo: image("../../src/resources/images/slydekit-mini.svg", height: 1.25cm),
  navigation-style: "minislide",
)

#title-slide

= First section

== First slide

#lorem(25)

#focus-slide[This is important!]

= Second section

== Second slide

#lorem(10)