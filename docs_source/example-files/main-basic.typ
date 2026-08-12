#import "../../src/slydekit.typ": *

#show: slydekit.with(
  title: "Slydekit",
  subtitle: "An example of a presentation template using Typst",
  author: "John Doe",
  date: "2024-06-01",
  institution: "Université de Typst",
  contact: "john.doe@univ.typst.fr",
)

#title-slide

= First section

== First slide

Hello Typst!

#slide("Second slide")[
  I am #pause an animated slide

  $
    #uncover(2)[$y = f(x)$]
  $
]
