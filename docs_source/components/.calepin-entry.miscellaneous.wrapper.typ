#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element

#let _calepin-expected-generation = "b7e5dacda0d9f223-1349cde127705c16"
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

The `full-width` function allows you to create a block that spans the entire width of the page. This can be useful for creating sections with a distinct background color or for highlighting important content.

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

= Adaptive column layout

The `adaptive-columns` function allows you to create a column layout that adapts to the available space. This function is borrowed from the #link("https://touying-typ.github.io/docs/reference/components/adaptive-columns", "Touying")

```typ
#let adaptive-columns(
  gutter: 4%,
  max-count: 3,
  start: none,
  end: none,
  body,
)
```

#argument-callout("gutter", "length", default: [4%])[The space between columns.]

#argument-callout("max-count", "integer", default: [3])[The maximum number of columns.]

#argument-callout("start", "content", default: [none])[Content to be displayed before the columns.]

#argument-callout("end", "content", default: [none])[Content to be displayed after the columns.]

#argument-callout("body", "content")[The content to be displayed in the columns.]

```typ
#set align(horizon)
#adaptive-columns(text(size: 1.2em, strong(outline(title:none, indent: 1em, depth: 1))))
```
