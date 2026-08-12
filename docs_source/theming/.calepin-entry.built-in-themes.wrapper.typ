#let _calepin-document-element = document
#import "/.calepin/calepin.typ": *
#let document = _calepin-document-element

#let _calepin-expected-generation = "078dbbee46fe86ef-1349cde127705c16"
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

#set document(title: [Built-in themes])
#metadata((tags: ("theming", "built-in themes"))) <website-metadata>

#html.elem("p", attrs: (style: "color: var(--calepin-color-link); font-size: 2em; font-weight: bold;"))[Built-in themes]

Slydekit provides a set of built-in themes that you can use to customize the appearance of your presentations. Each theme defines a unique combination of colors, fonts, and layout styles, allowing you to create visually appealing slides with minimal effort.

Currently, Slydekit includes the following built-in themes:

- `simple`
- `metropolis`
- `fancy`
- `cambfurt`
- `chalkboard`

Each theme comes with its own default color palette and font settings, which can be further customized to suit your preferences. They also include two navigation styles: `topbar` and `minislide`, which can be selected using the `navigation` argument in the `#slydekit.with` function.

To apply a built-in theme to your presentation, simply set the `theme` argument in the `#slydekit.with` function to the desired theme name. For example, to use the `simple` theme, you would write:
```typ
#show: slydekit.with(
  theme: simple,
  navigation: "topbar",
)
```

= Simple

The `simple` theme is a clean and minimalistic design that focuses on readability and clarity. It uses a light background with dark text, making it suitable for professional presentations.

The default color palette and font settings for the `simple` theme are:
```typ
#let simple-colors = (
  primary: rgb("#014682"),
  secondary: rgb("#637382"),
  focus: rgb("#014682"),
  background: none,
  header: rgb("#014682"),
  footer: rgb("#014682"),
)

#let simple-fonts = (
  body: "Fira Sans",
  math: "Fira Math",
  raw: "Fira Code",
)
```

== Topbar navigation style

#calepin.elements.gallery(
  (
    ("../assets/theming/simple/SimpleTheme_Page1.png", "Title slide", [Title slide]),
    ("../assets/theming/simple/SimpleTheme_Page2.png", "Progressive outline 1", [Progressive outline 1]),
    ("../assets/theming/simple/SimpleTheme_Page3.png", "First slide", [First slide]),
    ("../assets/theming/simple/SimpleTheme_Page4.png", "Focus slide", [Focus slide]),
    ("../assets/theming/simple/SimpleTheme_Page5.png", "Progressive outline 2", [Progressive outline 2]),
    ("../assets/theming/simple/SimpleTheme_Page6.png", "Second slide", [Second slide]),
  ),
  columns: 3,
  max-width: 100%,
)

== Minislide navigation style

#calepin.elements.gallery(
  (
    ("../assets/theming/simple/SimpleTheme_minislide_Page1.png", "Title slide", [Title slide]),
    ("../assets/theming/simple/SimpleTheme_minislide_Page2.png", "Progressive outline 1", [Progressive outline 1]),
    ("../assets/theming/simple/SimpleTheme_minislide_Page3.png", "First slide", [First slide]),
    ("../assets/theming/simple/SimpleTheme_minislide_Page4.png", "Focus slide", [Focus slide]),
    ("../assets/theming/simple/SimpleTheme_minislide_Page5.png", "Progressive outline 2", [Progressive outline 2]),
    ("../assets/theming/simple/SimpleTheme_minislide_Page6.png", "Second slide", [Second slide]),
  ),
  columns: 3,
  max-width: 100%,
)

= Metropolis

The `metropolis` theme is inspired by the popular Metropolis Beamer theme. It features a modern design with a light gray background and vibrant accent colors, making it ideal for tech-oriented presentations.

The default color palette and font settings for the `metropolis` theme are:
```typ
#let metropolis-colors = (
  primary: rgb("#eb811b"),
  secondary: rgb("#d6c6b7"),
  focus: rgb("#23373b"),
  background: rgb("#fafafa"),
  header: rgb("#23373b"),
  footer: rgb("#23373b").lighten(20%),
)

#let metropolis-fonts = (
  body: "Fira Sans",
  math: "Fira Math",
  raw: "Fira Code",
)
```

== Topbar navigation style

#calepin.elements.gallery(
  (
    ("../assets/theming/metropolis/MetropolisTheme_Page1.png", "Title slide", [Title slide]),
    ("../assets/theming/metropolis/MetropolisTheme_Page2.png", "Progressive outline 1", [Progressive outline 1]),
    ("../assets/theming/metropolis/MetropolisTheme_Page3.png", "First slide", [First slide]),
    ("../assets/theming/metropolis/MetropolisTheme_Page4.png", "Focus slide", [Focus slide]),
    ("../assets/theming/metropolis/MetropolisTheme_Page5.png", "Progressive outline 2", [Progressive outline 2]),
    ("../assets/theming/metropolis/MetropolisTheme_Page6.png", "Second slide", [Second slide]),
  ),
  columns: 3,
  max-width: 100%,
)

== Minislide navigation style

#calepin.elements.gallery(
  (
    ("../assets/theming/metropolis/MetropolisTheme_minislide_Page1.png", "Title slide", [Title slide]),
    ("../assets/theming/metropolis/MetropolisTheme_minislide_Page2.png", "Progressive outline 1", [Progressive outline 1]),
    ("../assets/theming/metropolis/MetropolisTheme_minislide_Page3.png", "First slide", [First slide]),
    ("../assets/theming/metropolis/MetropolisTheme_minislide_Page4.png", "Focus slide", [Focus slide]),
    ("../assets/theming/metropolis/MetropolisTheme_minislide_Page5.png", "Progressive outline 2", [Progressive outline 2]),
    ("../assets/theming/metropolis/MetropolisTheme_minislide_Page6.png", "Second slide", [Second slide]),
  ),
  columns: 3,
  max-width: 100%,
)

= Fancy

The `fancy` theme is a variant of the `metropolis` theme with a more vibrant color palette and additional styling options. It is designed to create visually striking presentations that stand out.

The default color palette and font settings for the `fancy` theme are:
```typ
#let fancy-colors = (
  primary: rgb("#c1002a"),
  secondary: rgb("#405a68").lighten(50%),
  background: rgb("#405a68").lighten(95%),
  focus: rgb("#c1002a"),
  header: rgb("#c1002a"),
  footer: rgb("#c1002a"),
)

#let fancy-fonts = (
  body: "Lato",
  math: "Lete Sans Math",
  raw: "Cascadia Code",
)
```

== Topbar navigation style

#calepin.elements.gallery(
  (
    ("../assets/theming/fancy/FancyTheme_Page1.png", "Title slide", [Title slide]),
    ("../assets/theming/fancy/FancyTheme_Page2.png", "Progressive outline 1", [Progressive outline 1]),
    ("../assets/theming/fancy/FancyTheme_Page3.png", "First slide", [First slide]),
    ("../assets/theming/fancy/FancyTheme_Page4.png", "Focus slide", [Focus slide]),
    ("../assets/theming/fancy/FancyTheme_Page5.png", "Progressive outline 2", [Progressive outline 2]),
    ("../assets/theming/fancy/FancyTheme_Page6.png", "Second slide", [Second slide]),
  ),
  columns: 3,
  max-width: 100%,
)

== Minislide navigation style

#calepin.elements.gallery(
  (
    ("../assets/theming/fancy/FancyTheme_minislide_Page1.png", "Title slide", [Title slide]),
    ("../assets/theming/fancy/FancyTheme_minislide_Page2.png", "Progressive outline 1", [Progressive outline 1]),
    ("../assets/theming/fancy/FancyTheme_minislide_Page3.png", "First slide", [First slide]),
    ("../assets/theming/fancy/FancyTheme_minislide_Page4.png", "Focus slide", [Focus slide]),
    ("../assets/theming/fancy/FancyTheme_minislide_Page5.png", "Progressive outline 2", [Progressive outline 2]),
    ("../assets/theming/fancy/FancyTheme_minislide_Page6.png", "Second slide", [Second slide]),
  ),
  columns: 3,
  max-width: 100%,
)

= Cambfurt

The `cambfurt` theme is an adaptation of the `cambridge` and `frankfurt` themes. If `navigation` is set to `topbar`, it will use the `cambridge` theme, and if it is set to `minislide`, it will use the `frankfurt` theme. This theme provides a classic and elegant look for your presentations.

The default color palette and font settings for the `cambfurt` theme are:
```typ
#let cambfurt-colors = (
  primary: rgb("#a30100"),
  secondary: rgb("#d9d9d9"),
  focus: rgb("#a30100"),
  background: none,
  header: rgb("#a30100"),
  footer: rgb("#a30100"),
)

#let cambfurt-fonts = (
  body: "Lato",
  math: "Lete Sans Math",
  raw: "Cascadia Code",
)
```

#calepin.elements.gallery(
  (
    ("../assets/theming/cambfurt/CambfurtTheme_Page1.png", "Title slide", [Title slide]),
    ("../assets/theming/cambfurt/CambfurtTheme_Page2.png", "Progressive outline 1", [Progressive outline 1]),
    ("../assets/theming/cambfurt/CambfurtTheme_Page3.png", "First slide", [First slide]),
    ("../assets/theming/cambfurt/CambfurtTheme_Page4.png", "Focus slide", [Focus slide]),
    ("../assets/theming/cambfurt/CambfurtTheme_Page5.png", "Progressive outline 2", [Progressive outline 2]),
    ("../assets/theming/cambfurt/CambfurtTheme_Page6.png", "Second slide", [Second slide]),
  ),
  columns: 3,
  max-width: 100%,
)

== Minislide navigation style

#calepin.elements.gallery(
  (
    ("../assets/theming/cambfurt/CambfurtTheme_minislide_Page1.png", "Title slide", [Title slide]),
    ("../assets/theming/cambfurt/CambfurtTheme_minislide_Page2.png", "Progressive outline 1", [Progressive outline 1]),
    ("../assets/theming/cambfurt/CambfurtTheme_minislide_Page3.png", "First slide", [First slide]),
    ("../assets/theming/cambfurt/CambfurtTheme_minislide_Page4.png", "Focus slide", [Focus slide]),
    ("../assets/theming/cambfurt/CambfurtTheme_minislide_Page5.png", "Progressive outline 2", [Progressive outline 2]),
    ("../assets/theming/cambfurt/CambfurtTheme_minislide_Page6.png", "Second slide", [Second slide]),
  ),
  columns: 3,
  max-width: 100%,
)

= Chalkboard

The `chalkboard` theme is a unique and creative theme that simulates the appearance of a chalkboard. It features a dark background with light-colored text, giving your presentation a distinctive and engaging look.

The default color palette and font settings for the `chalkboard` theme are:
```typ
#let chalkboard-colors = (
  primary: rgb("#8fd3ff"),
  secondary: rgb("#a9aaa3"),
  focus: none,
  background: none,
  header: rgb("#8fd3ff"),
  footer: rgb("#8fd3ff"),
)

#let chalkboard-colors-variant = (
  primary: rgb("#e57373"),
  secondary: rgb("#a9aaa3"),
  focus: none,
  background: none,
  header: rgb("#e57373"),
  footer: rgb("#e57373"),
)

#let chalkboard-fonts = (
  body: "Pennstander",
  math: "Pennstander Math",
  raw: "Fantasque Sans Mono",
)
```

This theme has two variants: the default `chalkboard` variant and the `chalkboard-variant`, which uses a different primary color. You can activate the variant color scheme by setting the `colors` argument in the `#slydekit.with` function to `chalkboard-colors-variant`.
```typ
#show: slydekit.with(
  theme: chalkboard,
  colors: chalkboard-colors-variant,
)
```

== Topbar navigation style

#calepin.elements.gallery(
  (
    ("../assets/theming/chalkboard/ChalkboardTheme_Page1.png", "Title slide", [Title slide]),
    ("../assets/theming/chalkboard/ChalkboardTheme_Page2.png", "Progressive outline 1", [Progressive outline 1]),
    ("../assets/theming/chalkboard/ChalkboardTheme_Page3.png", "First slide", [First slide]),
    ("../assets/theming/chalkboard/ChalkboardTheme_Page4.png", "Focus slide", [Focus slide]),
    ("../assets/theming/chalkboard/ChalkboardTheme_Page5.png", "Progressive outline 2", [Progressive outline 2]),
    ("../assets/theming/chalkboard/ChalkboardTheme_Page6.png", "Second slide", [Second slide]),
  ),
  columns: 3,
  max-width: 100%,
)

== Minislide navigation style + Variant color scheme

#calepin.elements.gallery(
  (
    ("../assets/theming/chalkboard/ChalkboardTheme_minislide_Page1.png", "Title slide", [Title slide]),
    ("../assets/theming/chalkboard/ChalkboardTheme_minislide_Page2.png", "Progressive outline 1", [Progressive outline 1]),
    ("../assets/theming/chalkboard/ChalkboardTheme_minislide_Page3.png", "First slide", [First slide]),
    ("../assets/theming/chalkboard/ChalkboardTheme_minislide_Page4.png", "Focus slide", [Focus slide]),
    ("../assets/theming/chalkboard/ChalkboardTheme_minislide_Page5.png", "Progressive outline 2", [Progressive outline 2]),
    ("../assets/theming/chalkboard/ChalkboardTheme_minislide_Page6.png", "Second slide", [Second slide]),
  ),
  columns: 3,
  max-width: 100%,
)
