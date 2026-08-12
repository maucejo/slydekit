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