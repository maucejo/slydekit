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

#set document(title: [Meanwhile and track])
#metadata((tags: ("animations", "meanwhile", "track"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Meanwhile and track]

Sometimes, you want to show multiple things at the same time, but not necessarily all of them. For example, you might want to show a list of items, and then reveal them one by one, but also have some items that are always visible. This is where the `#meanwhile` and `#track` commands come in handy.

= Meanwhile

`#meanwhile` splits a slide's top-level content into parallel tracks at the point it appears, each carrying its own local `#pause` sequence instead of one long chain. All tracks advance together on the same subslide clock, so content before and after `#meanwhile` can reveal independently while staying in sync. For example, `First #pause Second #meanwhile Third #pause Fourth` shows *First* and *Third* on the first step, then all four on the second. This mirrors Touying's `#meanwhile` directly and requires no wrapper function, `#pause` and `#meanwhile` are the only markers needed.

```typ
#slide[`#meanwhile` example][
  First

  #pause

  Second

  #meanwhile

  Third

  #pause

  Fourth
]
```

#calepin.elements.gallery(
  (
    ("../assets/animations/meanwhile1.png", "Step 1"),
    ("../assets/animations/meanwhile2.png", "Step 2"),
  ),
  columns: 2,
  max-width: 100%,
)

= Track

`track` provides the same parallel-track behavior as `#meanwhile`, exposed as a function rather than a flow marker, for the one case `#meanwhile` can't reach on its own: content nested inside a `#grid(..)` or `#columns(..)`. Since `#meanwhile`, like `#pause`, only sees a slide's direct top-level children, wrapping each column's content in `track(..)` lets every column carry its own independent `#pause` sequence while still advancing on the same subslide clock as the rest of the slide. Use `#meanwhile` for a linear flow with parallel timing, and `track(..)` when that parallel content needs to live side by side in a layout container.

```typ
#slide[`#track` example][
  #grid(
    columns: (1fr, 1fr),
    align: top,
    column-gutter: 1em,
    track[
      First point #pause

      Second point #pause

      Third point
    ],
    track[
      First parallel #pause

      Second parallel
    ]
  )
]
```

#calepin.elements.gallery(
  (
    ("../assets/animations/track1.png", "Step 1"),
    ("../assets/animations/track2.png", "Step 2"),
    ("../assets/animations/track3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)
