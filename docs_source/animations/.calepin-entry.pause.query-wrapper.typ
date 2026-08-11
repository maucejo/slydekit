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

#set document(title: [Pause, uncover and only])
#metadata((tags: ("animations", "pause", "uncover", "only"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Pause, uncover and only]

This page describes the pause, uncover and only animations available in Slydekit. These animations are used to control the visibility of content on slides, allowing for dynamic presentations.

= Pause

`pause` is an animation that allows you to pause the presentation at a specific point, waiting for user interaction before proceeding. This is useful for emphasizing a point or allowing the audience to absorb information before moving on.

```typ
#slide[`#pause` example][
  I am #pause an important point that requires attention.

  #pause

  I am not as important as the previous point.
]
```

#calepin.elements.gallery(
  (
    ("../assets/animations/pause1.png", "Step 1"),
    ("../assets/animations/pause2.png", "Step 2"),
    ("../assets/animations/pause3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)

= Uncover / Only

`uncover` and `only` are animations that control the visibility of content on slides. `uncover` reveals content gradually by reserving space, while `only` displays content only on specific subslides.

These functions are simply two variants of the same internal function, `_reveal`, which is not exported and has the following signature:
```typ
#let _reveal(
  from: 1,
  to: none,
  hide-color: none,
  reserved: true,
  hide-fn: none,
  int-or-range
  body
)

#let uncover = _reveal
#let only = _reveal(reserved: false)
```

#argument-callout("from", [int], default: [1])[
The subslide number from which the content will be revealed. The default value is 1, meaning that the content will be visible from the first subslide.
]

#argument-callout("to", [int | none], default: [none])[
The subslide number until which the content will be revealed. If set to `none`, the content will be visible until the last subslide. The default value is `none`.
]

#argument-callout("hide-color", [color | none], default: [none])[
The color used to hide the content when it is not visible. If set to `none`, the content will be hidden without any color. The default value is `none`.
]

#argument-callout("reserved", [bool], default: [true])[
A boolean value that determines whether the space for the content is reserved when it is not visible. If set to `true`, the space for the content will be reserved, preventing other content from shifting. If set to `false`, the space will not be reserved, allowing other content to shift into the space. The default value is `true`.
]

#argument-callout("hide-fn", [function | none], default: [none])[
A function that can be used to provide a custom masking for the content when it is not visible. If set to `none`, the default masking behavior will be used. The default value is `none`.
]

#argument-callout("int-or-range", [int | list of int])[
An array of subslide numbers on which the content will be visible. If this argument is provided, the `from` and `to` arguments will be ignored. The default value is an empty array, meaning that the content will be visible on all subslides.

Some examples:
```typ
#only(1, 3)[I am only visible on the first and third subslides]
#uncover(2, 4)[I am only visible on the second and fourth subslides, but my space is reserved on the first and third subslides]
```
]

```typ
#slide[`#uncover/#only` example][
  #only(1)[I am only visible on the first subslide.]

  #uncover(2)[I am only visible on the second subslide]

  #only(1, 3)[I am only visible on the first and third subslides]
]
```

#calepin.elements.gallery(
  (
    ("../assets/animations/uncover-only1.png", "Step 1"),
    ("../assets/animations/uncover-only2.png", "Step 2"),
    ("../assets/animations/uncover-only3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)

#calepin.elements.callout(kind: "Warning")[
  `uncover` and `only` are not compatible with packages like CeTZ or Fletcher, which use their own visibility logic and own `context`. In such cases, it is recommended to use the `reveal` function described in #link("animations/reveal.html", "CeTZ/Fletcher integration").
]
