#import "/.calepin/calepin.typ" as calepin

#set document(title: [Custom themes])
#metadata((tags: ("theming", "custom themes"))) <website-metadata>


#html.elem("p", attrs: (style: "font-size: 2em; font-weight: bold;"))[Custom themes]

Using one of the built-in themes, presented in #link("/theming/built-in-themes.html")[Built-in Themes] is a great way to get started with Slydekit, but you may want to create your own custom theme to match your branding or personal style. This section will guide you through the process of creating a custom theme and applying it to your presentation.

= Theming system

Polylux treats theming primarily as an application-level concern, while Touying treats a theme as a configurable framework built around a dynamic `self` context. Slydekit sits between the two, using a small, explicit theme contract represented by a dictionary.

Slydekit's theming system is designed to be flexible, modular, and composable. It is inspired by the theming system of #link("https://typst.app/universe/package/bookly")[Bookly], a Typst package for book creation developed by the author of Slydekit. Each theme is represented as a dictionary of standardized functions that define the visual appearance and behavior of key presentation elements. This common interface allows themes to be used interchangeably and customized by overriding their colors, fonts, and individual components.

== Common interface

Basically, any theme exposes the same conceptual interface, which is a dictionary of functions defined as:
```typ
#let custom = (
  theme: custom-theme,
  title: custom-title,
  toc: custom-toc,
  focus-slide: custom-focus-slide,
  link-box: custom-link-box,
  boxeq: custom-boxeq,
  box: custom-custom-box,
)
```

The elements of the dictionary are:
- `theme`: A function that defines the overall theme of the presentation, including colors, fonts, and other visual elements.
- `title`: A function that defines the appearance of the title slide.
- `toc`: A function that defines the appearance of the table of contents slide.
- `focus-slide`: A function that defines the appearance of a focus slide, which is used to highlight important content.
- `link-box`: A function that defines the appearance of a link box, which is used to display links to other slides.
- `boxeq`: A function that defines the appearance of a box equation.
- `box`: A function that defines the appearance of a custom callout box.

This design allows to define generic high-level functions that can be used whatever the theme is.

#calepin.elements.callout(kind: "note")[
  The dictionary-based design of Slydekit's theming system offers several advantages:

  - *Easy theme composition.* Themes can be composed by combining functions from different themes, allowing specific components to be reused or replaced without having to duplicate an entire theme.

  - *Partial theme definitions.* A custom theme does not need to implement the complete theme contract. Functions that are not defined in the custom theme fall back to those provided by the default theme, which is `simple` in Slydekit. This makes it straightforward to customize individual elements without redefining the entire theme.

  - *A coherent and interchangeable ecosystem.* The fixed theme contract provides a common interface shared by all themes, making them consistent and interchangeable within the Slydekit framework.

  At first sight, the fixed nature of the contract may appear to be a limitation, as it cannot be directly extended with additional theme functions. However, Slydekit does not prevent users from defining additional functions for use in their presentations, and these functions can be included in a custom theme. This makes it possible to extend the theming system without modifying or breaking existing themes. Such additional functions, however, remain outside the standard theme contract and therefore cannot be expected to be available or interchangeable across themes.
]

= Shared states

= Setting up a custom theme

= Theme composition

= Partial theme definition








