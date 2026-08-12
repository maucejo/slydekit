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

#set document(title: [Slides])
#metadata((tags: ("slides"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Slides]

= Generic slides

The main building block of the Slydekit framework is the `slide` function, which is used to create individual slides in a presentation.

```typ
#let slide(
  title,
  steps: none
  label: none,
  body
)
```

#argument-callout("title", [string | content])[
  The title of the slide.
]

#argument-callout("steps", [int | none], default: [none])[
  The number of steps in the slide. This is used to create incremental slides, where content is revealed step by step.
  This is required to animate slides using CeTZ or Fletcher, but optional for other animations.
]

#argument-callout("label", [label | none], default: [none])[
  An optional label for the slide. This can be used to reference the slide later in the presentation.
]

#argument-callout("body", [content])[
  The content of the slide.]

Practically, a slide can be defined in various ways:
```typ
// Markup-based slide + label
== Title <label>

Content of the slide

// Slide function + label
#slide("Title", label: <label>)[
  Content of the slide
]

// Slide function
#slide[
  Content of the slide
]
```

#calepin.elements.callout[
  `slide("Title")[...]` creates a slide with the specified title. When a slide is defined as `slide[...]`, its title is automatically inherited from the previous slide.
]

= Custom slides

There are several ways to define custom slides, which can be used to create slides with different layouts and styles. For instance, the `focus-slide` function used for capturing the audience's attention is defined as follows in the built-in themes:
```typ
// Focus slide of the simple theme
#let simple-focus-slide(body) = context {
  set page(header:none, footer: none, fill: sk-states.colors.get().focus)
  set align(center + horizon)
  text(size: 2em, fill: white)[*#body*]

  // Decrement the page counter to avoid counting the focus slide as a regular slide
  counter(page).update(n => n - 1)
}
```

If you want to create your own custom focus slide, that can use animations and other features, you can use the `slide` function to define it. For example:
```typ
#let my-focus-slide(..args) = {
  set align(center + horizon)
  set text(fill: white, size: 5em)
  set page(header: none, footer: none, fill: rgb("#5E8B65"))

  slide(..args)

  // Freeze the slide number to avoid incrementing it for focus slides
  sk-states.slide-number.update(n => n - 1)
}

```

Then, you can use it in your presentation like this:
```typ
#my-focus-slide[
  *Hey* #pause *ho!*
]
```

#calepin.elements.gallery(
  (
    ("../assets/components/my-focus-slide1.png", "Focus slide - Simple theme", [Custom Focus slide - Step 1]),
    ("../assets/components/my-focus-slide2.png", "Focus slide - Metropolis theme", [Custom Focus slide - Step 2]),
  ),
  columns: 2,
  max-width: 100%,
)
