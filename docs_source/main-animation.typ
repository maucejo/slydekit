#import "../src/slydekit.typ": *

#show: slydekit.with(
  title: "Slydekit",
  subtitle: "An example of a presentation template using Typst",
  author: "John Doe",
  date: "2024-06-01",
  institution: "Université de Typst",
  contact: "john.doe@univ.typst.fr",
  title-logo: (image("../src/resources/images/slydekit-full.svg", height: 2.5cm),),
  slide-logo: image("../src/resources/images/slydekit-mini.svg", height: 1.25cm),
)

#show raw: set text(size: 1.18em)

// Pause
// #slide[`#pause` example][
//   I am #pause an important point that requires attention.

//   #pause

//   I am not as important as the previous point.
// ]

// Uncover / Only
// #slide[`#uncover/#only` example][
//   #only(1)[I am only visible on the first subslide]

//   #uncover(2)[I am only visible on the second subslide]

//   #only(1, 3)[I am only visible on the first and third subslides]
// ]

// One-by-one
#slide[`#one-by-one` example][
  #one-by-one[I am ][not a ][ robot]
]

// Item-by-item
#slide[`#item-by-item` example][
  #item-by-item[
    - I am the first item, visible on the first subslide
    - I am the second item, visible on the second subslide
    - I am the third item, visible on the third subslide
  ]
]