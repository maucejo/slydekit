#import "../src/slydekit.typ": *

#show: slydekit.with(
  title: "Slydekit",
  subtitle: "An example of a presentation template using Typst",
  author: "John Doe",
  date: "2024-06-01",
  // theme: metropolis,
  // theme: fancy,
  // theme: simple,
  // theme: cambfurt,
  theme: chalkboard,
  institution: "Université de Typst",
  contact: "john.doe@univ.typst.fr",
  title-logo: (image("../src/resources/images/slydekit-full.svg", height: 2.5cm),),
  slide-logo: image("../src/resources/images/slydekit-mini.svg", height: 1.25cm),
)

#tableofcontents

= First section

= Second section