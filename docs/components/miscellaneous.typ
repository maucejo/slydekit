#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Miscellaneous])
#metadata((tags: ("misc", "miscellaneous"))) <website-metadata>


#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Miscellaneous]

Slydekit provides a set of additional functions that can be useful in various scenarios, particularly when creating your own theme.

= Row image layout

The `row-img`function allows you to display a set of images in a row. It is particularly useful for aligning logos or other images in a horizontal layout.

```typ
#let row-img(logos)
```

#argument-callout("logos", "array")[An array of images to be displayed in a row.]

```typ
#let logos = (
  image("../assets/logo1.png"),
  image("../assets/logo2.png"),
  image("../assets/logo3.png"),
)

#row-img(logos)
```

= Full-width block

The `full-width` function allows you to create a block that spans the entire width of the page. This can be useful for creating sections with a distinct background color or for highlighting important content.

```typ
#let full-width(
  fill: none,
  anchor: top,
  body
)
```

#argument-callout("fill", "color")[The background color of the full-width block. Default is `none`.]

#argument-callout("anchor", "alignment", default: [top])[The anchor point of the full-width block.]

#argument-callout("body", "content")[The content to be displayed in the full-width block.]

```typ
#full-width(anchor: bottom, progress-bar(rgb("#eb811b"), rgb("#d6c6b7"), height: 2.5pt))
```

= Adaptive column layout

The `adaptive-columns` function allows you to create a column layout that adapts to the available space. This function is borrowed from the #link("https://touying-typ.github.io/docs/reference/components/adaptive-columns", "Touying")

```typ
#let adaptive-columns(
  gutter: 4%,
  max-count: 3,
  start: none,
  end: none,
  body,
)
```

#argument-callout("gutter", "length", default: [4%])[The space between columns.]

#argument-callout("max-count", "integer", default: [3])[The maximum number of columns.]

#argument-callout("start", "content", default: [none])[Content to be displayed before the columns.]

#argument-callout("end", "content", default: [none])[Content to be displayed after the columns.]

#argument-callout("body", "content")[The content to be displayed in the columns.]

```typ
#set align(horizon)
#adaptive-columns(text(size: 1.2em, strong(outline(title:none, indent: 1em, depth: 1))))
```

= Short or long title

Sometimes, you may want to provide both a short and a long title for your sections. For instance, you might want to display a long title on the `tableof contents` or `progressive-outline`, while using a shorter version in the mini-slides navigation style. The `short-or-long` function allows you to specify both versions of the title.

```typ
#let short-or-long(
  short,
  long
)
```

#argument-callout("short", "string | content")[The short version of the title.]

#argument-callout("long", "string | content")[The long version of the title.]

```typ
#import "@preview/slydekit:0.4.0": *

#show: slydekit.with(
  navigation-style: "minislide",
)

= #short-or-long[My short title][My long long long title]

== First slide

#lorem(10)
```

#calepin.elements.gallery(
  (
    ("../assets/components/short-long1.png", "Topbar navigation style - Simple theme", [Short-or-long example - Long title]),
    ("../assets/components/short-long2.png", "Topbar navigation style - Metropolis theme", [Short-or-long example - Short title]),
  ),
  columns: 2,
  max-width: 100%,
)