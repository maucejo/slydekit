#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element

#let _calepin-expected-generation = "7d81d1caf8d99acc-1349cde127705c16"
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

#set document(title: [Fonts and colors])
#metadata((tags: ("theming", "fonts", "colors"))) <website-metadata>


#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Fonts and colors customization]

Sometimes, you may want to use a built-in theme, but customize the fonts and colors used in your presentation to match your branding or personal preferences. Slydekit allows you to easily override the default fonts and colors by providing your own definitions.

= Fonts

To use a custom font set, you have to provide to `slydekit` a `fonts` argument with a dictionary containing the following keys:
#argument-callout(kind: "Key", "size", "string", default: ["20pt"])[
Size of the main text in the presentation.
]

#argument-callout(kind: "Key", "body", "string | array", default: ["New Computer Modern"])[
Font family for the main text in the presentation.
]

#argument-callout(kind: "Key", "math", "string | array", default: ["New Computer Modern Math"])[
Font family for mathematical symbols and equations in the presentation.
]

#argument-callout(kind: "Key", "raw", "string | array", default: ["DejaVu Sans Mono"])[
Font family for raw text, such as code snippets or monospaced text.
]

Let's say you want to use the "Lete Sans Math" font for mathematical symbols and equations, and "Roboto" or "Cascadia Code" (depending on the font availability) for raw text, with a font size of 25pt. You can define your custom fonts as follows:
```typ
#let my-fonts = (
  size: 25pt,
  math: "Lete Sans Math",
  raw: ("Roboto", "Cascadia Code")
)
```

Then, you can apply these custom fonts to your presentation by passing the `my-fonts` dictionary to the `slydekit` function:
```typ
#show: slydekit.with(
  fonts: my-fonts,
)
```

#calepin.elements.callout(kind: "Note")[
  It is not necessary to provide all the keys in the `fonts` dictionary. If you only want to change the font for mathematical symbols, you can just provide the `math` key, and the other fonts will remain as their default values.

  You can extend the fonts dictionary with additional keys, but they will not be used by the `slydekit` function. The only keys that are recognized are `size`, `body`, `math`, and `raw`. However, you can use the `sk-states.fonts` state to store additional font information and use it in your custom themes or styles.
]

= Colors

The colors cusotmization works similarly to the fonts customization. You can provide a `colors` argument to the `slydekit` function with a dictionary containing the following keys:
#argument-callout(kind: "Key", "primary", "color")[
Primary color of the presentation.
]

#argument-callout(kind: "Key", "secondary", "color")[
Secondary color.
]

#argument-callout(kind: "Key", "focus", "color")[
Background color of the focus slide.
]

#argument-callout(kind: "Key", "background", "color")[
Background color of the slides.
]

#argument-callout(kind: "Key", "header", "color")[
Color of the header.
]

#argument-callout(kind: "Key", "footer", "color")[
Color of the footer.
]

Let's say you want to use a different primary color, a light gray background, and a dark gray footer. You can define your custom colors as follows:
```typ
#let my-colors = (
  primary: rgb("#FF5733"),
  background: rgb("#F0F0F0"),
  footer: rgb("#333333")
)
```

Then, you can apply these custom colors to your presentation by passing the `my-colors` dictionary to the `slydekit` function:
```typ
#show: slydekit.with(
  colors: my-colors,
)
```

#calepin.elements.callout(kind: "Note")[
  While the `fonts` dictionary has a default set of fonts, that are applied during the slidekit initialization, the `colors` dictionary does not have a default set of colors. If you do not provide a `colors` argument to the `slydekit` function, no colors will be applied.

  This is a deliberate design choice, as it allows you to have a clean slate for your color customization. You can define your own color scheme without being constrained by a predefined set of colors.
]

