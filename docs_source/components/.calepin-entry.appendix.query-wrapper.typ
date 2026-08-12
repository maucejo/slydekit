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

#set document(title: [Appendix])
#metadata((tags: ("appendix"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Appendix]

If you want to add additional content to your presentation, you can use the `appendix` function. This function allows you to create an appendix section in your presentation, which can be used to include supplementary information, references, or any other content that is not part of the main presentation.

For the built-in themes, the appendix slides are automatically numbered with a prefix "A." to distinguish them from the main slides. For example, the first appendix slide will be numbered as "A.1", the second as "A.2", and so on.

= Appendix declaration

To include an appendix in your presentation, you can use the `appendix` function as follows:
```typ
#show: appendix
```

Practically, a presentation including an appendix looks like this:
```typ
#import "@preview/slydekit:0.1.0": *

#show: slydekit.with(...)

= Main section

== A subsection

#lorem(10)

#show: appendix

= Appendix

== A subsection in the appendix

#lorem(10)
```

#calepin.elements.gallery(
  (
    ("../assets/components/basic-appendix1.png", "Topbar navigation style - Simple theme", [Appendix example - Slide 1]),
    ("../assets/components/basic-appendix2.png", "Topbar navigation style - Metropolis theme", [Appendix example - Slide 2]),
    ("../assets/components/basic-appendix3.png", "Topbar navigation style - Fancy theme", [Appendix example - Slide 3]),
    ("../assets/components/basic-appendix4.png", "Topbar navigation style - Cambfurt theme", [Appendix example - Slide 4]),
  ),
  columns: 2,
  max-width: 100%,
)

= Outline/Navigation styles

For the built-in themes, the appendix slides are automatically excluded from the minislide navigation style. Similarly, when the label `hide-toc` is used in the appendix declaration, the appendix slides are excluded from the main outlines built by `tableofcontents` and `progressive-outline` and a separate outline is created for the appendix slides. This allows you to keep the main presentation structure separate from the appendix content, while still providing a clear overview of the entire presentation.

== Without `hide-toc`

```typ
#import "@preview/slydekit:0.1.0": *

#show: slydekit.with(...)

#tableofcontents

= First section

== A subsection

#lorem(10)

= Second section

== Another subsection

#lorem(10)

#show: appendix

= Appendix

== A subsection in the appendix

#lorem(10)
```

#calepin.elements.gallery(
  (
    ("../assets/components/appendix-nohide1.png", "Topbar navigation style - Simple theme", [Outline example - Without hide-toc - Slide 1]),
    ("../assets/components/appendix-nohide2.png", "Topbar navigation style - Metropolis theme", [Outline example - Without hide-toc - Slide 2]),
    ("../assets/components/appendix-nohide3.png", "Topbar navigation style - Fancy theme", [Outline example - Without hide-toc - Slide 3]),
    ("../assets/components/appendix-nohide4.png", "Topbar navigation style - Cambfurt theme", [Outline example - Without hide-toc - Slide 4]),
    ("../assets/components/appendix-nohide5.png", "Topbar navigation style - Metropolis theme", [Outline example - Without hide-toc - Slide 5]),
    ("../assets/components/appendix-nohide6.png", "Topbar navigation style - Fancy theme", [Outline example - Without hide-toc - Slide 6]),
    ("../assets/components/appendix-nohide7.png", "Topbar navigation style - Cambfurt theme", [Outline example - Without hide-toc - Slide 7]),
  ),
  columns: 3,
  max-width: 100%,
)

== With `hide-toc`

```typ
#import "@preview/slydekit:0.1.0": *

#show: slydekit.with(...)

#tableofcontents

= First section

== A subsection

#lorem(10)

= Second section

== Another subsection

#lorem(10)

#show: appendix

= Appendix <hide-toc>

== A subsection in the appendix

#lorem(10)
```

#calepin.elements.gallery(
  (
    ("../assets/components/appendix-hide1.png", "Topbar navigation style - Simple theme", [Outline example - With hide-toc - Slide 1]),
    ("../assets/components/appendix-hide2.png", "Topbar navigation style - Metropolis theme", [Outline example - With hide-toc - Slide 2]),
    ("../assets/components/appendix-hide3.png", "Topbar navigation style - Fancy theme", [Outline example - With hide-toc - Slide 3]),
    ("../assets/components/appendix-hide4.png", "Topbar navigation style - Cambfurt theme", [Outline example - With hide-toc - Slide 4]),
    ("../assets/components/appendix-hide5.png", "Topbar navigation style - Metropolis theme", [Outline example - With hide-toc - Slide 5]),
    ("../assets/components/appendix-hide6.png", "Topbar navigation style - Fancy theme", [Outline example - With hide-toc - Slide 6]),
    ("../assets/components/appendix-hide7.png", "Topbar navigation style - Cambfurt theme", [Outline example - With hide-toc - Slide 7]),
  ),
  columns: 3,
  max-width: 100%,
)
