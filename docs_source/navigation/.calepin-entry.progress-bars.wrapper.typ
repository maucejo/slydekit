#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element

#let _calepin-expected-generation = "3f8514186ff4893d-1349cde127705c16"
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
