#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Alternatives])
#metadata((tags: ("animations", "alternatives"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Alternatives]

The `alternatives` function allows you to display different content per step.

#calepin.elements.callout[
  The implementation of `alternatives` has been borrowed from the #link("https://polylux.dev/book/dynamic/alternatives.html", "Polylux") package, with some adaptations to fit the Slydekit framework.
]

```typ
#let alternatives(
  start: 1,
  repeat-last: false,
  ..options
)
```

#argument-callout("start", "int", default: 1)[The starting step for the reveal. The first element will be revealed on this step.]

#argument-callout("repeat-last", "bool", default: [false])[If set to `true`, the last element will be repeated for all subsequent steps. If set to `false`, the last element will only be shown on its designated step.]

#argument-callout("..options", "list")[The list of options to be displayed.]

```typ
== `#alternatives` example

#alternatives[Ann][Bob][Christopher]
likes
#alternatives[chocolate][strawberry][vanilla]
ice cream.
```

#calepin.elements.gallery(
  (
    ("../assets/animations/alternatives1.png", "Step 1"),
    ("../assets/animations/alternatives2.png", "Step 2"),
    ("../assets/animations/alternatives3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)