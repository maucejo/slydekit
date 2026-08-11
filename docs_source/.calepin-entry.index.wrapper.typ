#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element

#let _calepin-expected-generation = "2a4e5532305146dc-1349cde127705c16"
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

#set document(title: [Slydekit Documentation])

#metadata((
  layout: "layouts/site-landing.html",
  tags: ("overview", "getting started"),
)) <website-metadata>

#html.elem("section", attrs: (class: "landing-hero"))[
  #html.elem("img", attrs: (
    src: "assets/slydekit-full.svg",
    alt: "Slydekit",
    class: "landing-hero-wordmark",
    style: "display: block; margin-inline: auto; color: currentColor;",
    "data-inline-svg": "1",
  ))
  #html.elem("h2", attrs: (style: "font-size: 1.3em; font-weight: 700;"))[
    Simple yet powerful presentation framework for Typst
  ]
  #html.elem("div", attrs: (class: "landing-cta-row", style: "color: white;"))[
    #html.elem("a", attrs: (
      class: "landing-button",
      href: "getting-started.html",
      style: "background: #654ca3",
    ))[Documentation]
  ]
]

Slydekit is a Typst presentation template designed to make slide creation simple and flexible. Its theme system, inspired by Bookly, makes it straightforward to design and integrate new themes.

// features
#let composable-card() = [
  #calepin.elements.card(
    class: "landing-feature-card",
    style: "height: 100%; width: 100%; flex: 1;",
  )[
    = #emoji.jigsaw Composable

    *Build with reusable components*

    Create presentations by assembling modular building blocks instead of duplicating slide layouts. Reuse, combine and customize components to keep your presentations clean and maintainable.
  ]
]

#let native-card() = [
  #calepin.elements.card(
    class: "landing-feature-card",
    style: "height: 100%; width: 100%; flex: 1;",
  )[
    = #emoji.sparkles Native

    *Feels like Typst*

    Slydekit follows Typst's philosophy and syntax, making slide creation feel natural. Spend less time learning a framework and more time writing your presentation.
  ]
]

#let extensible-card() = [
  #calepin.elements.card(
    class: "landing-feature-card",
    style: "height: 100%; width: 100%; flex: 1;",
  )[
    = #emoji.wrench Extensible

    *Made for customization*

    From themes and layouts to entirely new slide types, every part of Slydekit is designed to be extended without modifying the core package.
  ]
]

#let efficient-card() = [
  #calepin.elements.card(
    class: "landing-feature-card",
    style: "height: 100%; width: 100%; flex: 1;",
  )[
    = #emoji.lightning Efficient

    *Less boilerplate, more content*

    With sensible defaults and reusable abstractions, Slydekit reduces repetitive code so you can produce professional presentations faster.
  ]
]

#calepin.elements.columns(
  html-attrs: (style: "align-items: stretch;"),
  columns: 2,
  wrap: false,
  composable-card(),
  native-card(),
  extensible-card(),
  efficient-card()
)

= Why Slydekit?

Slydekit is a complete presentation framework for Typst that combines a simple authoring experience with a flexible architecture. Rather than introducing a custom programming model, it embraces Typst's native features to keep presentations readable, composable, and easy to extend.

= Built on Typst, not around it

Unlike frameworks that rely on a dedicated configuration object, Slydekit builds directly on Typst's native mechanisms such as context, state, counter, and query.

Presentation state, including colors, fonts, overlays, and slide metadata, is managed using the language itself. As a result, slide components and animation primitives behave like ordinary Typst functions, without wrapper objects or special calling conventions.

= Designed for extension

Slydekit does not restrict how packages or themes manage their own state. Authors are free to introduce additional `state()` or `counter()` values whenever needed, while the framework itself only synchronizes the information that is essential to the presentation lifecycle.

This decentralized approach keeps the core lightweight while making it straightforward to build custom themes, layouts, and reusable components.

= Familiar overlay system

If you are coming from Touying, you'll feel right at home.

Slydekit provides the same core incremental presentation model through commands such as `#pause`, `#meanwhile`, `#uncover`, `#only`, `#item-by-item`, `#alternatives`, `#track`, and `#reveal`. From bullet lists to mathematical derivations, complex reveal sequences can be expressed naturally using standard Typst code.

= How does Slydekit compare to Touying and Polylux?

#let table = table(
  columns: 4,
  inset: 0.6em,
  align: left,
  table.header(
    [],
    [Polylux],
    [Touying],
    [Slydekit],
  ),
  [Philosophy],
  [Presentation toolkit],
  [Complete presentation framework],
  [Complete presentation framework],

  [Programming model],
  [Native Typst state],
  [Shared `self` object],
  [Native Typst state],

  [Built-in themes],
  [Minimal],
  [Yes],
  [Yes],

  [Overlay system],
  [✓],
  [✓],
  [✓],

  [Themes],
  [External],
  [Integrated],
  [Integrated],

  [Extensible],
  [✓],
  [✓],
  [✓],

  [PDF output],
  [✓],
  [✓],
  [✓],

  [HTML / PPTX export],
  [External],
  [✓],
  [External],

  [Speaker notes],
  [✓],
  [✓],
  [External],
)

#html.elem("div", attrs: (align: "center"))[
  #table
]

= Why choose Slydekit?

#emoji.rocket Native Typst experience — Write presentations using standard Typst constructs.

#emoji.jigsaw Composable architecture — Build reusable layouts and slide components.

#emoji.wrench Easy to extend — Create your own themes without modifying the framework.

#emoji.lightning Minimal boilerplate — Focus on your content instead of presentation mechanics.
