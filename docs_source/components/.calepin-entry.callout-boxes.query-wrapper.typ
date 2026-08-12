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

#set document(title: [Callout boxes])
#metadata((tags: ("callouts", "boxes"))) <website-metadata>


#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Callout boxes]

Callout boxes are a way to highlight important information in your presentation. They can be used to draw attention to key points, provide additional context, or emphasize warnings and tips.

= Types of callout boxes

Slydekit provides several types of callout boxes, each with its own purpose and style. The available types are:
- `info-box`: Used for general information or notes.
- `warning-box`: Used to highlight warnings or important cautions.
- `tip-box`: Used to provide helpful tips or suggestions.
- `important-box`: Used to emphasize critical information that should not be overlooked.
- `proof-box`: Used to present proofs or logical arguments.
- ``question-box``: Used to pose questions or prompts for the audience.
-`code-box`: Used to display code snippets or programming-related content.

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
    ("../assets/components/callout-simple1.png", "Title slide", [Callout boxes - Simple theme, Part 1]),
    ("../assets/components/callout-simple2.png", "Progressive outline 1", [Callout boxes - Simple theme, Part 2]),
    ("../assets/components/callout-simple3.png", "First slide", [Callout boxes - Simple theme, Part 3]),
  ),
  columns: 3,
  max-width: 100%,
)

= Metropolis

#calepin.elements.gallery(
  (
    ("../assets/components/callout-metropolis1.png", "Title slide", [Callout boxes - Metropolis theme, Part 1]),
    ("../assets/components/callout-metropolis2.png", "Progressive outline 1", [Callout boxes - Metropolis theme, Part 2]),
    ("../assets/components/callout-metropolis3.png", "First slide", [Callout boxes - Metropolis theme, Part 3]),
  ),
  columns: 3,
  max-width: 100%,
)

= Fancy

#calepin.elements.gallery(
  (
    ("../assets/components/callout-fancy1.png", "Title slide", [Callout boxes - Fancy theme, Part 1]),
    ("../assets/components/callout-fancy2.png", "Progressive outline 1", [Callout boxes - Fancy theme, Part 2]),
    ("../assets/components/callout-fancy3.png", "First slide", [Callout boxes - Fancy theme, Part 3]),
  ),
  columns: 3,
  max-width: 100%,
)
