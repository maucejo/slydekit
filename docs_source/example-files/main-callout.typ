#import "../../src/slydekit.typ": *

#show: slydekit.with(
  title: "Slydekit",
  subtitle: "An example of a presentation template using Typst",
  author: "John Doe",
  date: "2024-06-01",
  institution: "Université de Typst",
  contact: "john.doe@univ.typst.fr",
  // theme: metropolis,
  // theme: fancy,
  // theme: simple,
  // theme: cambfurt,
  theme: chalkboard
)

== Callout boxes

#info-box[#lorem(10)]

#tip-box[#lorem(10)]

#warning-box[#lorem(10)]

==

#important-box[#lorem(10)]

#proof-box[#lorem(10)]

==

#question-box[#lorem(10)]

#code-box[#lorem(10)]