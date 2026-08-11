#import "../src/slydekit.typ": *
#import "@preview/cetz:0.5.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

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
#slide[`#pause` example][
  I am #pause an important point that requires attention.

  #pause

  I am not as important as the previous point.
]

// Uncover / Only
#slide[`#uncover/#only` example][
  #only(1)[I am only visible on the first subslide]

  #uncover(2)[I am only visible on the second subslide]

  #only(1, 3)[I am only visible on the first and third subslides]
]

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

// Meanwhile
#slide[`#meanwhile` example][
  First

  #pause

  Second

  #meanwhile

  Third

  #pause

  Fourth
]

// Track
#slide[`#track` example][
  #grid(
    columns: (1fr, 1fr),
    align: top,
    column-gutter: 1em,
    track[
      First point #pause

      Second point #pause

      Third point
    ],
    track[
      First parallel #pause

      Second parallel
    ]
  )
]

// Alternatives
#slide[`#alternatives` example][
  #alternatives[Ann][Bob][Christopher]
  likes
  #alternatives[chocolate][strawberry][vanilla]
  ice cream.
]

// CeTZ integration
#slide("CeTZ integration", steps: 3)[
  #let reveal-cetz = reveal.with(hide-fn: cetz.draw.hide.with(bounds: true))

  #context {
    align(center)[
      #cetz.canvas({
        import cetz.draw: *

        scale(400%)
        grid((-1.5, -1.5), (1.5, 1.5), step: 0.5, stroke: gray + 0.2pt)

        reveal(from: 2, {
          line((-1.5, 0), (1.5, 0))
          line((0, -1.5), (0, 1.5))
        })

        reveal(3, circle((0, 0)))
      })
    ]
  }
]

// Fletcher integration
#slide("Fletcher integration", steps: 3)[
  #show raw: set text(size: 0.7em)
  #let reveal-fletcher = reveal.with(hide-fn: fletcher.hide.with(bounds: true))

  #context {
    align(center)[
    #diagram(
      node-stroke: .1em,
      node-fill: gradient.radial(blue.lighten(80%), blue, center: (30%, 20%), radius: 80%),
      spacing: 4em,
      edge((-1,0), "r", "-|>", `open(path)`, label-pos: 0, label-side: center),
      node((0,0), `reading`, radius: 2em),
      edge((0,0), (0,0), `read()`, "--|>", bend: 130deg),

      reveal-fletcher(from: 2, edge(`read()`, "-|>")),

      node((1,0), `eof`, radius: 2em),
      reveal-fletcher(3, edge(`close()`, "-|>")),
      node((2,0), `closed`, radius: 2em, extrude: (-2.5, 0)),
      reveal-fletcher(3, edge((0,0), (2,0), `close()`, "-|>", bend: -40deg)),
    )]
  }
]