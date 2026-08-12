#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element

#let _calepin-expected-generation = "e08882a44262f6a6-1349cde127705c16"
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

#set document(title: [Topbar/Minislide])
#metadata((tags: ("topbar", "minislide"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Topbar and minislide]

Slydekit provides optional navigation elements to help structure and navigate presentations. The **topbar** displays the presentation’s content as a persistent navigation bar, highlighting the current section to provide a clear overview of the presentation structure. The **minislide** complements the topbar by displaying a compact visual representation of the slides within the current section, allowing the audience to quickly identify the current slide and its position in the presentation. Together, these components provide a lightweight navigation system that improves orientation without taking significant space away from the main slide content.

To activate a given navigation style, you can set the `navigation-style` argument in the `slydekit` command.
```typ
// For the topbar navigation style
#show: slydekit.with(
  navigation-style: topbar,
)

// For the minislide navigation style
#show: slydekit.with(
  navigation-style: minislide,
)
```

= Topbar

#calepin.elements.gallery(
  (
    ("../assets/theming/simple/SimpleTheme_Page3.png", "Topbar navigation style - Simple theme", [Topbar navigation style - Simple theme]),
    ("../assets/theming/metropolis/MetropolisTheme_Page3.png", "Topbar navigation style - Metropolis theme", [Topbar navigation style - Metropolis theme]),
    ("../assets/theming/fancy/FancyTheme_Page3.png", "Topbar navigation style - Fancy theme", [Topbar navigation style - Fancy theme]),
    ("../assets/theming/cambfurt/CambfurtTheme_Page3.png", "Topbar navigation style - Cambfurt theme", [Topbar navigation style - Cambfurt theme]),
    ("../assets/theming/chalkboard/ChalkboardTheme_Page3.png", "Topbar navigation style - Chalkboard theme", [Topbar navigation style - Chalkboard theme]),
  ),
  columns: 3,
  max-width: 100%,
)

= Minislide

#calepin.elements.gallery(
  (
    ("../assets/theming/simple/SimpleTheme_minislide_Page3.png", "Minislide navigation style - Simple theme", [Minislide navigation style - Simple theme]),
    ("../assets/theming/metropolis/MetropolisTheme_minislide_Page3.png", "Minislide navigation style - Metropolis theme", [Minislide navigation style - Metropolis theme]),
    ("../assets/theming/fancy/FancyTheme_minislide_Page3.png", "Minislide navigation style - Fancy theme", [Minislide navigation style - Fancy theme]),
    ("../assets/theming/cambfurt/CambfurtTheme_minislide_Page3.png", "Minislide navigation style - Cambfurt theme", [Minislide navigation style - Cambfurt theme]),
    ("../assets/theming/chalkboard/ChalkboardTheme_minislide_Page3.png", "Minislide navigation style - Chalkboard theme", [Minislide navigation style - Chalkboard theme]),
  ),
  columns: 3,
  max-width: 100%,
)

To implement the minislide navigation style, Slydekit provides the mini-slides helper function, adapted from the corresponding implementation in #link("https://github.com/touying-typ/touying/blob/main/src/components.typ#L806C1-L936C1","Touying") to work seamlessly with Slydekit.

```typ
#let mini-slides(
  fill: none,
  alpha: 50%,
  display-subsection: true,
  linebreaks: true,
  display-appendix: "auto",
)
```

#argument-callout("fill", [color | none], default: [none])[
The color used to fill the active slide indicator. If set to `none`, the indicator uses the `header` entry defined `color` dictionary instead.]

#argument-callout("alpha", [number], default: [50%])[
The transparency applied to inactive slides. A value of `0%` makes them fully transparent, while `100%` makes them fully opaque. The default value is `50%`, which provides a balanced visibility for inactive slides.]

#argument-callout("display-subsection", [boolean], default: [true])[
A boolean value that determines whether to display bullets for each slide under the sections. If set to `true`, bullets will be displayed for each slide under the sections. If set to `false`, bullets will not be displayed.]

#argument-callout("linebreaks", [boolean], default: [true])[
A boolean value that determines whether to place the bullets on a new line under the section title. If set to `true`, bullets will be placed horizontally on a new line under the section title. If set to `false`, bullets will be placed vertically on the same line as the section title.]

#argument-callout("display-appendix", [boolean | "auto"], default: ["auto"])[
A boolean value that determines whether to display appendix sections. If set to "auto", the main sections are displayed during the main presentation and switches to appendix during the appendix. If set to `true`, it always displays everything (main + appendix). If set to `false`, it never displays appendix sections.]

= Usage in custom themes

If you create a presentation using the topbar or minislide navigation style, you only need to implement the navigation element in the `header` of your theme. For examples of how to implement these navigation styles, refer to the #link("https://github.com/maucejo/slydekit/tree/main/src/themes", "Slydekit GitHub repository"), which contains implementations of the topbar and minislide navigation styles for the built-in themes.
