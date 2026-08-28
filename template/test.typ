#import "../src/slydekit.typ": *
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

TEST

== Second slide

#{
  set text(0.4em)
  [TEST]
}

== Third slide
TEST

#{
  set text(0.4em)
  [TEST]
}
