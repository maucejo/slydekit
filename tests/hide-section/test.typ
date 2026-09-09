#import "../../src/slydekit.typ": *

#show: slydekit.with(
  title: "Slydekit",
  subtitle: "An example of a presentation template using Typst",
  author: "John Doe",
  date: "2024-06-01",
  institution: "Université de Typst",
  contact: "john.doe@univ.typst.fr",
)

// hide-new-section-slide must stay transparent to slide-parser: every `==`
// heading below still becomes its own slide, and the deferred anim-label label
// is still emitted (and therefore linkable).
#show: hide-new-section-slide

= First section

== First slide

Content #pause and more content.

#anim-label(<mark>, step: 1)

== Second slide

Back to #link(<mark>, "the mark").

= Second section

== Third slide

#lorem(10)
