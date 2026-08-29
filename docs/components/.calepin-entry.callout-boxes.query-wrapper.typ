#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element



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

#set document(title: [Callout boxes])
#metadata((tags: ("callouts", "boxes"))) <website-metadata>


#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Callout boxes]

Callout boxes are a way to highlight important information in your presentation. They can be used to draw attention to key points, provide additional context, or emphasize warnings and tips.

#calepin.elements.callout[
  Slydekit directly depends on `showybox: 2.0.4` to build the callout boxes used by its built-in themes.
]

= Types of callout boxes

Slydekit provides several types of callout boxes, each with its own purpose and style. The available types are:
- `info-box`: Used for general information or notes.
- `warning-box`: Used to highlight warnings or important cautions.
- `tip-box`: Used to provide helpful tips or suggestions.
- `important-box`: Used to emphasize critical information that should not be overlooked.
- `proof-box`: Used to present proofs or logical arguments.
- `question-box`: Used to pose questions or prompts for the audience.
- `code-box`: Used to display code snippets or programming-related content.

All of these callout boxes are variations of the `custom-box` function, which can be defined in the theme with the following signature:
```typ
#let custom-box(
  title: none,
  icon: "info",
  color: rgb(29, 144, 208),
  body
)
```

#argument-callout("title", "string | none", default: [none])[The title of the callout box. If set to `none`, no title will be displayed.]

#argument-callout("icon", "string", default: ["info"])[The icon to display in the callout box. This can be any valid icon name from the Slydekit icon set.

The available icons are: `info`, `warning`, `tip`, `important`, `proof`, `question`, and `code`.
]

#argument-callout("color", "color", default: [rgb(29, 144, 208)])[The color of the callout box. This can be any valid color value.]

#argument-callout("body", "content")[The content of the callout box. This can be any valid Typst content, including text, images, and other elements.]

You can use the `custom-box` function to create your own callout boxes with custom titles, icons, and colors or use it directly in your presentation.

= Example usage

Each built-in theme has its own visual style for the callout boxes, but they all share the same interface through the fixed theme contract.

```typ
== Callout boxes

#info-box[#lorem(10)]

#tip-box[#lorem(10)]

#warning-box[#lorem(10)]

==

#important-box[#lorem(10)]

#proof-box[#lorem(10)]

==

#question-box[#lorem(10)]

#code-box[#lorem(10)]
```

== Simple

#calepin.elements.gallery(
  (
    ("../assets/components/callout-simple1.png", "Callout boxes - Simple theme, Part 1", [Callout boxes - Simple theme, Part 1]),
    ("../assets/components/callout-simple2.png", "Callout boxes - Simple theme, Part 2", [Callout boxes - Simple theme, Part 2]),
    ("../assets/components/callout-simple3.png", "Callout boxes - Simple theme, Part 3", [Callout boxes - Simple theme, Part 3]),
  ),
  columns: 3,
  max-width: 100%,
)

== Metropolis

#calepin.elements.gallery(
  (
    ("../assets/components/callout-metropolis1.png", "Callout boxes - Metropolis theme, Part 1", [Callout boxes - Metropolis theme, Part 1]),
    ("../assets/components/callout-metropolis2.png", "Callout boxes - Metropolis theme, Part 2", [Callout boxes - Metropolis theme, Part 2]),
    ("../assets/components/callout-metropolis3.png", "Callout boxes - Metropolis theme, Part 3", [Callout boxes - Metropolis theme, Part 3]),
  ),
  columns: 3,
  max-width: 100%,
)

== Fancy

#calepin.elements.gallery(
  (
    ("../assets/components/callout-fancy1.png", "Callout boxes - Fancy theme, Part 1", [Callout boxes - Fancy theme, Part 1]),
    ("../assets/components/callout-fancy2.png", "Callout boxes - Fancy theme, Part 2", [Callout boxes - Fancy theme, Part 2]),
    ("../assets/components/callout-fancy3.png", "Callout boxes - Fancy theme, Part 3", [Callout boxes - Fancy theme, Part 3]),
  ),
  columns: 3,
  max-width: 100%,
)

== Cambfurt

#calepin.elements.gallery(
  (
    ("../assets/components/callout-cambfurt1.png", "Callout boxes - Cambfurt theme, Part 1", [Callout boxes - Cambfurt theme, Part 1]),
    ("../assets/components/callout-cambfurt2.png", "Callout boxes - Cambfurt theme, Part 2", [Callout boxes - Cambfurt theme, Part 2]),
    ("../assets/components/callout-cambfurt3.png", "Callout boxes - Cambfurt theme, Part 3", [Callout boxes - Cambfurt theme, Part 3]),
  ),
  columns: 3,
  max-width: 100%,
)

== Chalkboard

#calepin.elements.gallery(
  (
    ("../assets/components/callout-chalkboard1.png", "Callout boxes - Chalkboard theme, Part 1", [Callout boxes - Chalkboard theme, Part 1]),
    ("../assets/components/callout-chalkboard2.png", "Callout boxes - Chalkboard theme, Part 2", [Callout boxes - Chalkboard theme, Part 2]),
    ("../assets/components/callout-chalkboard3.png", "Callout boxes - Chalkboard theme, Part 3", [Callout boxes - Chalkboard theme, Part 3]),
  ),
  columns: 3,
  max-width: 100%,
)
