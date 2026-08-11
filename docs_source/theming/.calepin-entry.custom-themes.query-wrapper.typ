#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element



#let _raw-chunk-langs = ("python", "r", "mermaid", "dot", "tikz", "d2")
#show raw.where(block: true, lang: "typ", theme: auto): it => _without-raw-chunk-transforms(() => _html-themed-raw-block(it))
#show raw.where(block: true, lang: "typst", theme: auto): it => _without-raw-chunk-transforms(() => _html-themed-raw-block(it))
#show raw.where(block: true, lang: "python", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("python", it) }
#show raw.where(block: true, lang: "r", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("r", it) }
#show raw.where(block: true, lang: "mermaid", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("mermaid", it) }
#show raw.where(block: true, lang: "dot", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("dot", it) }
#show raw.where(block: true, lang: "tikz", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("tikz", it) }
#show raw.where(block: true, lang: "d2", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { chunk_from_raw_plain("d2", it) }

#show raw.where(block: true, theme: auto): it => {
  if _is-query() {
    it
  } else if _disable-raw-chunk-transforms.get() {
    _html-themed-raw-block(it)
  } else if it.has("lang") and it.lang != none and _raw-chunk-langs.contains(it.lang) and _fenced-chunks-runs(
    it.lang,
    _resolve-options(it.lang, _call-defaults).at("fenced-chunks"),
  ) {
    chunk_from_raw_plain(it.lang, it)
  } else {
    _html-themed-raw-block(it)
  }
}

#show heading: it => {
  if _is-html() and "label" in it.fields() {
    std.html.elem("calepin-heading-anchor", attrs: (data-id: str(it.label)))
  }
  it
}

// Notebook theme
#import "/.calepin/calepin.typ": _html-themed-raw-block, _is-query, chunk_from_raw_plain

// Body text size, captured below at document-body level. Code blocks are sized
// relative to this rather than to `1em`, which would compound: a literal
// ```typ block is rendered by replacing its source `raw` element, so it renders
// inside Typst's already-reduced raw text context, whereas executed chunks are
// emitted as ordinary calls at body size. Anchoring to the captured body size
// gives both paths a single, matching reduction instead of shrinking twice.
#let _calepin-body-size = std.state("calepin-body-size", 11pt)

#show raw.where(block: true): it => {
  if it.theme != auto {
    context {
      set text(size: _calepin-body-size.get() * 0.8)
      it
    }
  } else if it.lang != none and (_is-query() or _raw-chunk-langs.contains(it.lang)) and _fenced-chunks-runs(
    it.lang,
    _resolve-options(it.lang, _call-defaults).at("fenced-chunks"),
  ) {
    chunk_from_raw_plain(it.lang, it)
  } else {
    _html-themed-raw-block(it)
  }
}

#context _calepin-body-size.update(text.size)

#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Custom themes])
#metadata((tags: ("theming", "custom themes"))) <website-metadata>


#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Custom themes]

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
  outline: custom-outline,
  focus-slide: custom-focus-slide,
  link-box: custom-link-box,
  boxeq: custom-boxeq,
  box: custom-custom-box,
)
```

The elements of the dictionary are:
- `theme`: A function that defines the overall theme of the presentation, including colors, fonts, and other visual elements.
- `title`: A function that defines the appearance of the title slide.
- `outline`: A function that defines the appearance of the outline slide.
- `focus-slide`: A function that defines the appearance of a focus slide, which is used to highlight important content.
- `link-box`: A function that defines the appearance of a link box, which is used to display links to other slides.
- `boxeq`: A function that defines the appearance of a box equation.
- `box`: A function that defines the appearance of a custom callout box.

This design allows to define generic high-level functions that can be used whatever the theme is.

The dictionary-based design of Slydekit's theming system offers several advantages:

- *Easy theme composition.* Themes can be composed by combining functions from different themes, allowing specific components to be reused or replaced without having to duplicate an entire theme.

- *Partial theme definitions.* A custom theme does not need to implement the complete theme contract. Functions that are not defined in the custom theme fall back to those provided by the default theme, which is `simple` in Slydekit. This makes it straightforward to customize individual elements without redefining the entire theme.

- *A coherent and interchangeable ecosystem.* The fixed theme contract provides a common interface shared by all themes, making them consistent and interchangeable within the Slydekit framework.

At first sight, the fixed nature of the contract may appear to be a limitation, as it cannot be directly extended with additional theme functions. However, Slydekit does not prevent users from extending the theming dictionary to include additional features. Users can define their own functions and include them in a custom theme, allowing for greater flexibility and customization. This means that users can create their own unique presentation styles while still adhering to the standard theme contract. Such additional functions, however, remain outside the standard theme contract and therefore cannot be expected to be available or interchangeable across themes.

That being said, because standard Typst function can be used directly without needing wrapping them into the theme dictionary, users can still use any Typst function in their custom theme, even if it is not part of the standard theme contract. This allows for a high degree of flexibility and creativity in designing custom themes.

#calepin.elements.callout(kind: "note")[
  If you extend the theme dictionary with additional functions, you have to define an interface for them, so that they can be used consistently across your presentation.

  Let's imagine you want to add a new function to your custom theme, called `custom-function`, which is not part of the standard theme contract. You can add it to the theme dictionary and define the interface to access it in your presentation as follows (see #link("https://github.com/maucejo/slydekit/blob/main/src/slydekit-themes.typ", "Source code")):
  ```typ
  #let custom-function(..args) = context (sk-states.theme.get().custom-function)(..args)
  ```

  This is not a requirement of the Slydekit framework, but it is a good practice to ensure that your custom theme remains coherent and maintainable. In the general case, it is recommended to not extend the theme dictionary with additional functions, as they can directly be defined using regular Typst functions, which are more flexible and do not require a fixed interface.

  However, if you choose to extend the theme dictionary, it is important to define a clear interface for your custom functions to ensure consistency and maintainability in your presentation.
]

= Shared states

To enable theme composition and partial theme definitions, Slydekit uses a shared state mechanism to manage the presentation. The shared states are collected in a dictionary, named `sk-states`, that contains the following keys:

#argument-callout(kind: "State", "app-slide-number", [counter])[
  Tracks the number of appendix slides in the presentation. It is used to display the current slide number in the footer of appendix slides.
]

#argument-callout(kind: "State", "appendix", [bool], default: [false])[
  Boolean state that indicates whether the current slide is part of the appendix. It is used to determine the numbering format for slides in the appendix.
]

#argument-callout(kind: "State", "colors", [dictionary])[
  Dictionary that defines the color scheme of the presentation.
]

#argument-callout(kind: "State", "current-slide-title", [string | content])[
  String or content that represents the title of the current slide. It is used to display the title in the header or footer of the slide.
]

#argument-callout(kind: "State", "fonts", [dictionary])[
  Dictionary that defines the fonts of the presentation.
]

#argument-callout(kind: "State", "handout", [bool], default: [false])[
  Boolean that indicates whether the presentation is being generated as a handout. It is useful to adjust the layout and formatting of slides for printing or distribution.
]

#argument-callout(kind: "State", "is-footcite", [bool], default: [false])[
  Boolean used to discriminate between footnotes generated by `footcite` and other footnotes.
]

#argument-callout(kind: "State", "logo", [image | content])[
  Image or content that represents the logo of the presentation. It is used to display the logo in the header or footer of the slide.
]

#argument-callout(kind: "State", "localization", [dictionary])[
  Dictionary of terms used for localization of the presentation. It allows to customize the text displayed in different languages.
]

#argument-callout(kind: "State", "navigation", [string], default: ["topbar"])[
  String that indicates the navigation style of the presentation. It can be "topbar" or "minislide". It is used to determine the layout of the header.
]

#argument-callout(kind: "State", "pause-index", [counter])[
  Tracks the index of the current pause in the presentation. It is used to manage the timing and sequencing of slides.
]

#argument-callout(kind: "State", "pres-info", [dictionary])[
  Dictionary that contains information about the presentation, such as title, subtitle, author, date, institution, contact, and title-logo. It is used to display the presentation information in the title slide and other relevant places.
]

#argument-callout(kind: "State", "slide-number", [counter])[
  Tracks the number of slides in the presentation. It is used to display the current slide number in the footer of slides.
]

#argument-callout(kind: "State", "subslide-step", [counter])[
  Tracks the animation capacity in a slide. It is used to determine the total number of subslides in a slide.
]

#argument-callout(kind: "State", "subslide-total", [counter])[
  the current step in a subslide. It is the current cursor actually consumed by the animation logic.
]

#argument-callout(kind: "State", "theme", [dictionary])[
  Dictionary that contains the contract of the current theme. It is used to access the functions defined in the theme and apply them to the presentation (See #link("/theming/custom-themes.html#theming-system", "Theming System")).
]

The shared states are given here for reference, but they are generally not meant to be used directly in the presentation. Instead, they are used internally by the Slydekit framework to manage the presentation and apply the theme. The only exception is the `fonts` and `colors` states, which can be used to customize the fonts and colors of a custom theme, as described in #link("/theming/fonts-colors.html", "Fonts and Colors Customization"), and the `localization` and `navigation` states.

= Setting up a custom theme

To implement a custom theme, you have to define a function that includes the `show` and `set` rules defining the style of the document (headings, footnotes, references, #sym.dots). Basically, a theme should be structured as follows:

```typ
// my-theme.typ

// Theme function
#let my-theme(body) = context {
  // Equivalent to new-section-slide in Touying
  show heading.where(level: 1): it => { ... }

  // Header and footer of the slides
  let slide-header = { ... }
  let slide-footer = { ... }
  set page(header: slide-header, footer: slide-footer)

  // Other show and set rules defining the style of the document (headings, footnotes, references, #sym.dots)

  body
}

// Title slide
#let my-theme-title = context {
  // Define the style of the title slide
  ...
}

// Outline slide
#let my-theme-outline = context {
  // Define the style of the outline slide
  ...
}

// Focus slide
#let my-theme-focus-slide = context {
  // Define the style of the focus slide
  ...
}

// Link box
#let my-theme-link-box = context {
  // Define the style of the link box
  ...
}

// Box equation
#let my-theme-boxeq = context {
  // Define the style of the box equation
  ...
}

// Theme dictionary
#let my-theme = (
  theme: my-theme,
  title: my-theme-title,
  outline: my-theme-outline,
  focus-slide: my-theme-focus-slide,
  link-box: my-theme-link-box,
  boxeq: my-theme-boxeq,
)
```

Once the theme is defined, you can use it in your presentation by specifying it in the `#slydekit` function:
```typ
#import "@preview/slydekit:0.1.0": *
#import "my-theme.typ": *

#show: slydekit.with(
  theme: my-theme,
  colors: my-theme-colors,
  fonts: my-theme-fonts,
)
```

#calepin.elements.callout(kind: "note")[
  If you want to avoid setting the colors and fonts arguments in the `#slydekit` function, you can define your theme function to use the default colors and fonts of the theme, as follows:
  ```typ
  // my-theme.typ

  // Define the colors and fonts of the theme
  #let my-theme-colors = (...)
  #let my-theme-fonts = (...)

  #let my-theme(body) = context {
    // Update the shared states with the colors and fonts of the theme for further use
    sk-states.colors.update(colors-theme)
    sk-states.fonts.update(fonts-theme)

  // The rest of the theme definition goes here...
  }
  ```

  You can also explore the source code of the #link("https://github.com/maucejo/slydekit/tree/main/src/themes", "built-in themes") to see how they are defined and how they rely on shared states to manage colors, fonts, and other theming elements.
]

= Theme composition

Themes can be composed by combining functions from different themes, allowing specific components to be reused or replaced without having to duplicate an entire theme. This is possible because the theme contract is defined as a dictionary of functions, which can be easily combined and overridden.

The functions of a theme are accessible using the following pattern `theme-name.function-name`, where `themename` is the name of the theme and `function-name` is the name of the function defined in the theme dictionary. For example, you can compose a custom theme by combining the `theme` function from one theme with the `title` function from another theme, as follows:
```typ
#import "@preview/slydekit:0.1.0": *

#let my-theme = (
  theme: metropolis.theme,
  title: cambfurt.title,
  toc: simple-toc,
  focus-slide: fancy-slide,
  link-box: simple-link-box,
  boxeq: fancy-boxeq,
)

#show: slydekit.with(
  theme: my-theme,
)
```

= Partial theme definition

A custom theme does not need to implement the complete theme contract. Functions that are not defined in the custom theme fall back to those provided by the default theme, which is `simple` in Slydekit. This makes it straightforward to customize individual elements without redefining the entire theme.

For instance, if you want to create a custom theme that only changes the title slide and the table of contents slide, you can define your custom theme as follows:
```typ
#import "@preview/slydekit:0.1.0": *
#let my-theme = (
  theme: fancy.theme,
  toc: fancy-toc,
)

#show: slydekit.with(
  theme: my-theme,
)
```








