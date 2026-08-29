#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element

#let _calepin-expected-generation = "d3420a4f509e227a-1349cde127705c16"
#let _calepin-verify-generation() = {
  let path = sys.inputs.at("calepin-results", default: none)
  if path != none and path != "" {
    let actual = json(path).at("generation", default: "")
    if actual != _calepin-expected-generation {
      panic("Calepin results changed while this render was starting; Typst will retry with the completed build")
    }
  }
}
#_calepin-verify-generation()



#show raw.where(block: true, lang: "typ", theme: auto): it => _without-raw-chunk-transforms(() => _html-themed-raw-block(it))
#show raw.where(block: true, lang: "typst", theme: auto): it => _without-raw-chunk-transforms(() => _html-themed-raw-block(it))
#show raw.where(block: true, lang: "python", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("python", it) }
#show raw.where(block: true, lang: "r", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("r", it) }
#show raw.where(block: true, lang: "mermaid", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("mermaid", it) }
#show raw.where(block: true, lang: "dot", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("dot", it) }
#show raw.where(block: true, lang: "tikz", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("tikz", it) }
#show raw.where(block: true, lang: "d2", theme: auto): it => if _disable-raw-chunk-transforms.get() { _html-themed-raw-block(it) } else { _fenced-chunk("d2", it) }

#show raw.where(block: true, theme: auto): it => {
  if _is-query() {
    it
  } else if _disable-raw-chunk-transforms.get() {
    _html-themed-raw-block(it)
  } else if it.has("lang") and it.lang != none and _raw-chunk-langs.contains(it.lang) and _fenced-chunks-runs(
    it.lang,
    _resolve-options(it.lang, _call-defaults).at("fenced-chunks"),
  ) {
    _fenced-chunk(it.lang, it)
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

#show: _default-chunk-chrome

// Notebook theme
#import "/.calepin/calepin.typ" as calepin
#import "../doc-utils.typ": *

#set document(title: [Outlines])
#metadata((tags: ("outline", "toc", "progressive outline"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Outlines]

= Table of contents

In Slydekit, you can create an outline using the `tableofcontents` command.

```typ
#import "@preview/slydekit:0.4.0": *

#show: slydekit.with(...)

// Title slide
#title-slide

// Insert a table of contents
#tableofcontents
```

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

If you want to create a custom theme, Slydekit provides the `toc` command to create a simple table of contents with the current theme primary color. The `toc` function has the following signature:
```typ
#let toc(
  fill: (:),
  display-appendix: "auto",
)
```

#argument-callout("fill", [dictionary], default: [(:)])[
The color used to fill the outline number and entries. The dictionary keys are:
- `"number"`: The color used to fill the outline number.
- `"entry"`: The color used to fill the outline entries.

By default the outline number is filled with the theme primary color, and the outline entries are filled with black.
]

#argument-callout("display-appendix", [string], default: ["auto"])[
Whether to display the appendix in the table of contents. The default value is `"auto"`, which means that the appendix outline will be displayed on a dedicated slide. If set to `true`, the appendix will always be displayed in the main outline. If set to `false`, the appendix outline will never be displayed.
]

Actually, `tableofcontents` is just a wrapper around `toc`, that includes the title slide and the table of contents in a single slide.

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
  active-color: (:),
  inactive-color,
  entry-size: 0.8575em,
  gutter: 4%,
  display-subsection: false,
  display-appendix: "auto",
)
```

#argument-callout("it", [content])[
The content of the slide.]

#argument-callout("active-color", [dictionary], default: [(:)])[
The color used to fill the active slide indicator. The dictionary keys are:
- `"number"`: The color used to fill the outline number.
- `"entry"`: The color used to fill the outline entries.

By default the outline number is filled with the theme primary color, and the outline entries are filled with black.]

#argument-callout("inactive-color", [color])[
The color used to fill the inactive slide indicators.]

#argument-callout("entry-size", [number], default: [0.8575em])[
The size of the text used for the outline entries. The default value is `0.8575em`, which is a good size for most presentations.]

#argument-callout("gutter", [number], default: [4%])[
The space between the outline entries. The default value is `4%`.]

#argument-callout("display-subsection", [boolean], default: [false])[
Whether to display subsections in the progressive outline. The default value is `false`. If set to `true`, the progressive outline will display subsections as well.]

#argument-callout("display-appendix", [string], default: ["auto"])[
Whether to display the appendix in the progressive outline. The default value is `"auto"`, which means that the appendix outline will be displayed on a dedicated slide. If set to `true`, the appendix will always be displayed in the main outline. If set to `false`, the appendix will never be displayed.]

A typical implementation of the `progressive-outline` command when creating a theme is as follows:
```typ
#show heading.where(level: 1): it => {
  // Formatting the content
  ...

  // Creating the progressive outline
  progressive-outline(it, active-color, inactive-color)
}
```

= Hide sections

Slydekit provides the `hide-new-section-slide` function to hide the slide that introduces a new section, while keeping the section in the outline. This is useful when you want to keep the outline clean and concise, but still want to have the section in the outline. To use this function, simply add the following line to your presentation:
```typ
#show: hide-new-section-slide
```

#calepin.elements.callout(kind: "warning")[
This function can't be used in conjunction with `progressive-outline`, since `hide-new-section-slide` hides level 1 heading slides. However, the section will still be present in the `tableofcontents`.
]

If you need fine-grained control over which sections appear in the outline, you can use the `<hide-toc>` label to hide specific sections. This is particularly useful for sections such as bibliographies, but it can be applied to any section you want to exclude from the outline. Simply add the label to the section title as follows:
```typ
= Bibliography <hide-toc>
```

// == Without `<hide-toc>`

// #calepin.elements.gallery(
//   (
//     ("../assets/navigation/no-hide-toc1.png", "No hide-toc - Outline slide", [No hide-toc - Outline slide]),
//     ("../assets/navigation/no-hide-toc2.png", "No hide-toc - Progressive outline - Step 1", [No hide-toc - Progressive outline]),
//     ("../assets/navigation/no-hide-toc3.png", "No hide-toc - Progressive outline - Step 2", [No hide-toc - Progressive outline]),
//   ),
//   columns: 3,
//   max-width: 100%,
// )

// == With `<hide-toc>`

// #calepin.elements.gallery(
//   (
//     ("../assets/navigation/with-hide-toc1.png", "Hide-toc - Outline slide", [Hide-toc - Outline slide]),
//     ("../assets/navigation/with-hide-toc2.png", "Hide-toc - Progressive outline - Step 1", [Hide-toc - Progressive outline]),
//     ("../assets/navigation/with-hide-toc3.png", "Hide-toc - Progressive outline - Step 2", [Hide-toc - Progressive outline]),
//   ),
//   columns: 3,
//   max-width: 100%,
// )

#calepin.elements.callout[
  The `<hide-toc>` label can also be used to hide a slide, defined with `#slide(..., label: <hide-toc>)` or `== Title <hide-toc>`, from the outlines (`tableofcontents`, `progressive-outline` and `mini-slides`). This can be useful for a bibliography slide for instance.
]
