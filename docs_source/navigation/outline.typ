#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Outlines])
#metadata((tags: ("animations", "outline", "toc", "progressive outline"))) <website-metadata>

#html.elem("p", attrs: (style: "font-size: 2em; font-weight: bold;"))[Outlines]

In Slydekit, you can create an outline using the `tableofcontents` command.

```typ
#import "@preview/slydekit:0.1.0": *

#show: slydekit.with(...)

// Title slide
#title-slide

// Insert a table of contents
#tableofcontents
```

If you want to create a custom theme, Slydekit provides two helper functions to create a table of contents.

= TOC command

The `toc` command creates a simple table of contents with the current theme primary color. Actually, `tableofcontents` is just a wrapper around `toc`, that includes the title slide and the table of contents in a single slide.

#calepin.elements.gallery(
  (
    ("../assets/navigation/toc-progress-simple1.png", "Table of contents - Simple theme", [Table of contents - Simple theme]),
    ("../assets/navigation/toc-progress-metropolis1.png", "Table of contents - Metropolis theme", [Table of contents - Metropolis theme]),
    ("../assets/navigation/toc-progress-fancy1.png", "Table of contents - Fancy theme", [Table of contents - Fancy theme]),
    ("../assets/navigation/toc-progress-cambfurt1.png", "Table of contents - Cambfurt theme", [Table of contents - Cambfurt theme]),
    ("../assets/navigation/toc-progress-chalkboard1.png", "Table of contents - Chalkboard theme", [Table of contents - Chalkboard theme]),
  ),
  columns: 3,
  max-width: 100%,
)

You can see the #link("https://github.com/maucejo/slydekit/blob/main/src/slydekit-outline.typ#L29-L37", "source code") of the `toc` command to see implementation details.


= Progressive outline

Slydekit provides a `progressive-outline` command that creates a progressive outline, where each section is revealed one by one. This function is inspired by #link("https://typst.app/universe/package/touying/", "Touying") but is implemented in a different way. Only the `simple` and `cambfurt` built-in themes support progressive outlines.

#calepin.elements.gallery(
  (
    ("../assets/navigation/toc-progress-simple2.png", "Progressive outline - Simple theme", [Progressive outline - Simple theme]),
    ("../assets/theming/cambfurt/CambfurtTheme_Page2.png", "Progressive outline - Metropolis theme", [Progressive outline - Metropolis theme]),
  ),
  columns: 2,
  max-width: 100%,
)

```typ
#let progressive-outline(
  it,
  active-color,
  inactive-color,
  entry-size: 0.8575em,
  gutter: 4%,
  section-numbering: "1.1.",
  appendix-numbering: "A.1.",
)
```

#argument-callout("it", [content])[
The content of the slide.]

#argument-callout("active-color", [color])[
The color used to fill the active slide indicator.]

#argument-callout("inactive-color", [color])[
The color used to fill the inactive slide indicators.]

#argument-callout("entry-size", [number], default: [0.8575em])[
The size of the text used for the outline entries. The default value is `0.8575em`, which is a good size for most presentations.]

#argument-callout("gutter", [number], default: [4%])[
The space between the outline entries. The default value is `4%`.]

#argument-callout("section-numbering", [string], default: ["1.1."])[
The numbering format for sections. The default value is `"1.1."`.]

#argument-callout("appendix-numbering", [string], default: ["A.1."])[
The numbering format for appendices. The default value is `"A.1."`.]

A typical implementation of the `progressive-outline` command when creating a theme is as follows:
```typ
#show heading.where(level: 1): it => {
  // Formatting the content
  ...

  // Creating the progressive outline
  progressive-outline(it, active-color, inactive-color)
}
```