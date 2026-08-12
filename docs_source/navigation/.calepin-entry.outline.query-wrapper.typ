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

#set document(title: [Outlines])
#metadata((tags: ("outline", "toc", "progressive outline"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Outlines]

= Table of contents

In Slydekit, you can create an outline using the `tableofcontents` command.

```typ
#import "@preview/slydekit:0.1.0": *

#show: slydekit.with(...)

// Title slide
#title-slide

// Insert a table of contents
#tableofcontents
```

If you want to create a custom theme, Slydekit provides the `toc` command to create a simple table of contents with the current theme primary color. Actually, `tableofcontents` is just a wrapper around `toc`, that includes the title slide and the table of contents in a single slide.

#calepin.elements.gallery(
  (
    ("../assets/navigation/toc-progress-simple1.png", "Table of contents - Simple theme", [Table of contents - Simple theme]),
    ("../assets/navigation/toc-progress-metropolis1.png", "Table of contents - Metropolis theme", [Table of contents - Metropolis theme]),
    ("../assets/navigation/toc-progress-fancy1.png", "Table of contents - Fancy theme", [Table of contents - Fancy theme]),
    ("../assets/navigation/toc-progress-cambfurt1.png", "Table of contents - Cambfurt theme", [Table of contents - Cambfurt theme]),
    ("../assets/navigation/toc-progress-chalkboard1.png", "Table of contents - Chalkboard theme", [Table of contents - Chalkboard theme]),
  ),
  columns: 3,
  max-width: 100%,
)

You can see the #link("https://github.com/maucejo/slydekit/blob/main/src/slydekit-outline.typ#L29-L37", "source code") of the `toc` command to see implementation details.

= Progressive outline

Slydekit provides a `progressive-outline` command that creates a progressive outline, where each section is revealed one by one. This function is inspired by #link("https://typst.app/universe/package/touying/", "Touying") but is implemented in a different way. Only the `simple` and `cambfurt` built-in themes support progressive outlines.

#calepin.elements.gallery(
  (
    ("../assets/navigation/toc-progress-simple2.png", "Progressive outline - Simple theme", [Progressive outline - Simple theme]),
    ("../assets/theming/cambfurt/CambfurtTheme_Page2.png", "Progressive outline - Metropolis theme", [Progressive outline - Metropolis theme]),
  ),
  columns: 2,
  max-width: 100%,
)

```typ
#let progressive-outline(
  it,
  active-color,
  inactive-color,
  entry-size: 0.8575em,
  gutter: 4%,
  section-numbering: "1.1.",
  appendix-numbering: "A.1.",
)
```

#argument-callout("it", [content])[
The content of the slide.]

#argument-callout("active-color", [color])[
The color used to fill the active slide indicator.]

#argument-callout("inactive-color", [color])[
The color used to fill the inactive slide indicators.]

#argument-callout("entry-size", [number], default: [0.8575em])[
The size of the text used for the outline entries. The default value is `0.8575em`, which is a good size for most presentations.]

#argument-callout("gutter", [number], default: [4%])[
The space between the outline entries. The default value is `4%`.]

#argument-callout("section-numbering", [string], default: ["1.1."])[
The numbering format for sections. The default value is `"1.1."`.]

#argument-callout("appendix-numbering", [string], default: ["A.1."])[
The numbering format for appendices. The default value is `"A.1."`.]

A typical implementation of the `progressive-outline` command when creating a theme is as follows:
```typ
#show heading.where(level: 1): it => {
  // Formatting the content
  ...

  // Creating the progressive outline
  progressive-outline(it, active-color, inactive-color)
}
```

= Hide sections

Slydekit provides the `hide-new-section-slide` function to hide the slide that introduces a new section, while keeping the section in the outline. This is useful when you want to keep the outline clean and concise, but still want to have the section in the outline. To use this function, simply add the following line to your presentation:
```typ
#show: hide-new-section-slide
```

#calepin.elements.callout(kind: "warning")[
This function can't be used in conjunction with `progressive-outline`, since `hide-new-section-slide` hides level 1 heading slides. However, the section will still be present in the `tableofcontents`.
]

If you want to have a fine-grained control over which sections are hidden, you can use the label `hide-toc` command to hide specific sections.

== Without `<hide-toc>`

#calepin.elements.gallery(
  (
    ("../assets/navigation/no-hide-toc1.png", "No hide-toc - Outline slide", [No hide-toc - Outline slide]),
    ("../assets/navigation/no-hide-toc2.png", "No hide-toc - Progressive outline - Step 1", [No hide-toc - Progressive outline]),
    ("../assets/navigation/no-hide-toc3.png", "No hide-toc - Progressive outline - Step 2", [No hide-toc - Progressive outline]),
  ),
  columns: 3,
  max-width: 100%,
)

== With `<hide-toc>`

#calepin.elements.gallery(
  (
    ("../assets/navigation/with-hide-toc1.png", "Hide-toc - Outline slide", [Hide-toc - Outline slide]),
    ("../assets/navigation/with-hide-toc2.png", "Hide-toc - Progressive outline - Step 1", [Hide-toc - Progressive outline]),
    ("../assets/navigation/with-hide-toc3.png", "Hide-toc - Progressive outline - Step 2", [Hide-toc - Progressive outline]),
  ),
  columns: 3,
  max-width: 100%,
)
