#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Progress bars])
#metadata((tags: ("outline", "toc", "progressive outline"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Progress bars]

Slydekit provides progress bars to indicate either the progress of the section or the progress of the entire presentation. These function are intended to be used in a custom theme.

= Section progress bar

```typ
#let section-progress-bar(active-color, inactive-color)
```

#argument-callout("active-color", [color])[
The color used to fill the active section indicator.]

#argument-callout("inactive-color", [color])[
The color used to fill the inactive section indicators.]

For example, in the `metropolis` theme, `section-progress-bar` is used as follows:
```typ
#let color-theme = (
  primary: rgb("#eb811b"),
  secondary: rgb("#d6c6b7"),
  focus: rgb("#23373b"),
  background: rgb("#fafafa"),
  header: rgb("#23373b"),
  footer: rgb("#23373b").lighten(20%),
)

#show heading.where(level: 1): it => {
    // Formatting the content
    ...

    // Using the section progress bar
    stack(
      dir: ttb,
      spacing: 0.5em,
      [*#it.body*],
      block(
        height: 2pt,
        width: 100%,
        spacing: 0pt,
        section-progress-bar(colors-theme.primary, colors-theme.secondary)
      ),
    )
  }
```

= Presentation progress bar

```typ
#let progress-bar(active-color, inactive-color, height: 2pt)
```

#argument-callout("active-color", [color])[
The color used to fill the active slide indicator.]

#argument-callout("inactive-color", [color])[
The color used to fill the inactive slide indicators.]

#argument-callout("height", [number], default: [2pt])[
The height of the progress bar. The default value is `2pt`.]

For example, in the `metropolis` theme, `section-progress-bar` is used in the footer of the slide as follows:

```typ
let footer = context {
      // Footer content
      ...

      // Progress bar
      #full-width(anchor: bottom, progress-bar(colors-theme.primary, colors-theme.secondary, height: 2.5pt))
    ]
  }
```