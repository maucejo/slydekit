#import "../src/slydekit.typ": *

#show heading.where(level: 1): it => {
  pagebreak(weak: true)

  set page(header: none, footer: none)

  progressive-outline(it, luma(80%), slide-level: 2)
}

#show heading.where(level: 2): it => {
  pagebreak(weak: true)
  set page(header: none, footer: none)

  progressive-outline(it, luma(80%), slide-level: 3)
}

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
  theme: cambfurt,
  // theme: chalkboard,
  // fonts: (body: "New Computer Modern"),
  // colors: chalkboard-colors-variant,
  lang: "en",
  // navigation-style: "minislide",
  title-logo: (image("images/slydekit-full.svg", height: 2.5cm),),
  slide-logo: image("images/slydekit-mini.svg", height: 1.25cm),
  slide-level: 4,
  // handout: true
  section-numbering: true,
  // numbering-pattern: (section: "I.1.1.", appendix: "A.1.1."),
)

#title-slide

= First part

== First section

#tableofcontents

=== First subsection

==== Test

#lorem(5)


==== section

ergergerg

// == Second section

=== Second subsection

==== test

efre

= Second part

== Second section

=== Second subsection

==== Third subsection

ererfer
