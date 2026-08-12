#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element

#let _calepin-expected-generation = "a2777c35fa8e70a3-1349cde127705c16"
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

#set document(title: [CeTZ/Fletcher integration])
#metadata((tags: ("animations", "reveal", "cetz", "fletcher"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[CeTZ/Fletcher integration]

As mentioned in #link("animations/pause.html", "Pause, uncover and only"), `uncover` and `only` are not compatible with packages like CeTZ or Fletcher. The reason is that CeTZ and Fletcher have their own rendering mechanisms and context. Therefore, Slydekit cannot simply wrap the content with `hide()` as it does for regular Typst content.

To integrate with these packages, you can use the `reveal` function, which reproduces the visibility logic of `uncover` and `only`, without opening a new `context`. This allows third-party packages to provide their own masking via the `hide-fn` argument.

```typ
#let reveal(
  int-or-range,
  from: 1,
  to: none,
  hide-fn: none,
  body
)
```

#argument-callout("int-or-range", [int | range])[
The subslide number or range of subslide numbers on which the content will be revealed. If an integer is provided, the content will be visible only on that specific subslide. If a range is provided, the content will be visible on all subslides within that range.
]

#argument-callout("from", [int], default: [1])[
The subslide number from which the content will be revealed. The default value is 1, meaning the content will be revealed starting from the first subslide.
]

#argument-callout("to", [int | none], default: [none])[
The subslide number until which the content will be revealed. If set to `none`, the content will be revealed until the last subslide. If an integer is provided, the content will be revealed only up to that specific subslide.
]

#argument-callout("hide-fn", [function | none], default: [none])[
A function that defines how the content should be hidden when it is not visible. If set to `none`, the content will be hidden using the default behavior. If a function is provided, it will be called with the content as an argument, allowing for custom hiding behavior.
]

#argument-callout("body", [content])[
The content to be revealed.]

Contrary to the other animations commands, using the `reveal` function requires to open a new `context` that includes the CeTZ/Fletcher content to be revealed, as well as to provide the number of steps for th slide. This is because the `reveal` function needs to know the current subslide step in order to determine whether the content should be visible or hidden.

#calepin.elements.callout[
  The current implementation of the Slydekit framework does not allow to compute the number of steps for a slide automatically, so you need to provide it manually. This is a known limitation that could be addressed in future versions of the framework.
]

= CeTZ integration

```typ
#import "@preview/cetz:0.5.2"

// Slydekit initialization
...

// Slide with CeTZ content
#slide("CeTZ integration", steps: 3)[
  #context {
    align(center)[
      #cetz.canvas({
        import cetz.draw: *

        scale(400%)
        grid((-1.5, -1.5), (1.5, 1.5), step: 0.5, stroke: gray + 0.2pt)

        reveal(from: 2, {
          line((-1.5, 0), (1.5, 0))
          line((0, -1.5), (0, 1.5))
        })

        reveal(3, circle((0, 0)))
      })
    ]
  }
]
```

#calepin.elements.gallery(
  (
    ("../assets/animations/cetz1.png", "Step 1"),
    ("../assets/animations/cetz2.png", "Step 2"),
    ("../assets/animations/cetz3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)

= Fletcher integration

```typ
#slide("Fletcher integration", steps: 3)[
  #show raw: set text(size: 0.7em)

  // Use the hide-fn from Fletcher
  #let reveal-fletcher = reveal.with(hide-fn: fletcher.hide.with(bounds: true))

  #context {
    align(center)[
    #diagram(
      node-stroke: .1em,
      node-fill: gradient.radial(blue.lighten(80%), blue, center: (30%, 20%), radius: 80%),
      spacing: 4em,
      edge((-1,0), "r", "-|>", `open(path)`, label-pos: 0, label-side: center),
      node((0,0), `reading`, radius: 2em),
      edge((0,0), (0,0), `read()`, "--|>", bend: 130deg),

      reveal-fletcher(from: 2, edge(`read()`, "-|>")),

      node((1,0), `eof`, radius: 2em),
      reveal-fletcher(3, edge(`close()`, "-|>")),
      node((2,0), `closed`, radius: 2em, extrude: (-2.5, 0)),
      reveal-fletcher(3, edge((0,0), (2,0), `close()`, "-|>", bend: -40deg)),
    )]
  }
]
```

#calepin.elements.gallery(
  (
    ("../assets/animations/fletcher1.png", "Step 1"),
    ("../assets/animations/fletcher2.png", "Step 2"),
    ("../assets/animations/fletcher3.png", "Step 3"),
  ),
  columns: 3,
  max-width: 100%,
)

