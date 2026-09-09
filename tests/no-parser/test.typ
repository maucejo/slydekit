#import "../../src/slydekit.typ": *

// activate-parser: false turns every slide-level heading into a title-only
// slide via `slide(it.body)[]`. The empty body must not crash slide()
// (resolve-nested-pauses returns `none` for empty content).
#show: slydekit.with(
  title: "Slydekit",
  subtitle: "An example of a presentation template using Typst",
  author: "John Doe",
  date: "2024-06-01",
  institution: "Université de Typst",
  contact: "john.doe@univ.typst.fr",
  activate-parser: false,
)

= First section

== Title-only slide

== Slide with content

#lorem(10)
