#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Outlines])
#metadata((tags: ("outline", "toc", "progressive outline"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Outlines]

= Table of contents

In Slydekit, you can create an outline using the `tableofcontents` command.

```typ
#import "@preview/slydekit:0.3.0": *

#show: slydekit.with(...)

// Title slide
#title-slide

// Insert a table of contents
#tableofcontents
```

If you want to create a custom theme, Slydekit provides the `toc` command to create a simple table of contents with the current theme primary color. Actually, `tableofcontents` is just a wrapper around `toc`, that includes the title slide and the table of contents in a single slide.

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
  display-subsection: false,
  display-appendix: "auto",
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

#argument-callout("display-subsection", [boolean], default: [false])[
Whether to display subsections in the progressive outline. The default value is `false`. If set to `true`, the progressive outline will display subsections as well.]

A typical implementation of the `progressive-outline` command when creating a theme is as follows:
```typ
#show heading.where(level: 1): it => {
  // Formatting the content
  ...

  // Creating the progressive outline
  progressive-outline(it, active-color, inactive-color)
}
```

#argument-callout("display-appendix", [string], default: ["auto"])[
Whether to display the appendix in the progressive outline. The default value is `auto`, which means that the appendix outline will be displayed on a dedicated slide. If set to `true`, the appendix will always be displayed in the main outline. If set to `false`, the appendix will never be displayed.]

= Hide sections

Slydekit provides the `hide-new-section-slide` function to hide the slide that introduces a new section, while keeping the section in the outline. This is useful when you want to keep the outline clean and concise, but still want to have the section in the outline. To use this function, simply add the following line to your presentation:
```typ
#show: hide-new-section-slide
```

#calepin.elements.callout(kind: "warning")[
This function can't be used in conjunction with `progressive-outline`, since `hide-new-section-slide` hides level 1 heading slides. However, the section will still be present in the `tableofcontents`.
]

If you want to have a fine-grained control over which sections are hidden, you can use the label `<hide-toc>` command to hide specific sections.

== Without `<hide-toc>`

#calepin.elements.gallery(
  (
    ("../assets/navigation/no-hide-toc1.png", "No hide-toc - Outline slide", [No hide-toc - Outline slide]),
    ("../assets/navigation/no-hide-toc2.png", "No hide-toc - Progressive outline - Step 1", [No hide-toc - Progressive outline]),
    ("../assets/navigation/no-hide-toc3.png", "No hide-toc - Progressive outline - Step 2", [No hide-toc - Progressive outline]),
  ),
  columns: 3,
  max-width: 100%,
)

== With `<hide-toc>`

#calepin.elements.gallery(
  (
    ("../assets/navigation/with-hide-toc1.png", "Hide-toc - Outline slide", [Hide-toc - Outline slide]),
    ("../assets/navigation/with-hide-toc2.png", "Hide-toc - Progressive outline - Step 1", [Hide-toc - Progressive outline]),
    ("../assets/navigation/with-hide-toc3.png", "Hide-toc - Progressive outline - Step 2", [Hide-toc - Progressive outline]),
  ),
  columns: 3,
  max-width: 100%,
)

#calepin.elements.callout[
  The `<hide-toc>` label can also be used to hide a slide, defined with `#slide(..., label: <hide-toc>)` or `== Title <hide-toc>`, from the outlines (`tableofcontents`, `progressive-outline` and `mini-slides`). This can be useful for a bibliography slide for instance.
]